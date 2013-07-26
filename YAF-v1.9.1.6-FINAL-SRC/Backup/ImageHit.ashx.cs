using System;
using System.Data;
using System.Web;
using System.Collections;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Net;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging; 


namespace yaf
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ImageHit : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string newRec;
            SqlCommand query;


            context.Response.ContentType = "image/GIF";
            context.Response.AppendHeader("content-disposition", "attachment; filename=" + "dummy.gif");
            Image oImg = Image.FromFile("C:\\wmpub\\YAF-v1.9.1.6-FINAL-BIN\\spam\\dummy.gif", true);
            oImg.Save(context.Response.OutputStream, ImageFormat.Gif);
            oImg.Dispose(); 
            //what on earth do I want to get for params?
            //I suppose I should devise my evil first, yes?
            //uid=Request.QueryString["uid"];

            query = new SqlCommand();
            query.CommandText = "INSERT INTO MSPHITS (IP, UserAgent, RefURL, TimeStamp,RemoteUser)" +
                    "VALUES ('" + System.Web.HttpContext.Current.Request.UserHostAddress + "','" +
                    System.Web.HttpContext.Current.Request.UserAgent + "','" +
                    System.Web.HttpContext.Current.Request.UrlReferrer + "'," +
                    "GetDate(),'" + System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_USER"] + "') " +
                    "SELECT @@IDENTITY";

            newRec = DB.ExecuteScalar(query).ToString();



            string ConsoleOutput;


            System.Diagnostics.Process p = new System.Diagnostics.Process();
            p.StartInfo.FileName = "c:\\Windows\\System32\\cmd.exe";
            p.StartInfo.Arguments = "/c tracert " + System.Web.HttpContext.Current.Request.UserHostAddress;
            p.StartInfo.CreateNoWindow = true;
            p.StartInfo.UseShellExecute = false;
            p.StartInfo.RedirectStandardOutput = true;

            p.Start();

            ConsoleOutput = p.StandardOutput.ReadToEnd();


            p.WaitForExit();

            ConsoleOutput.Trim();
            string[] lines = null;
            int lasthopid;
            string lasthop;
            lasthopid = 0;
            lines = ConsoleOutput.Split('\r');

            for (int l = 0; l == lines.Length; l++)
            {
                if (lines[l].Contains("Trace complete."))
                {
                    lasthopid = (l -= 3);
                }
            }

            //lasthop = lines[lasthopid];
            lasthop = ConsoleOutput.ToString();

            //put consoleoutput into database



            //next, do an ARIN lookup: http://ws.arin.net/whois/?queryinput=
            //parse the result, checking for other registrars.  
            //If it returns a reference, resolve the record on another registrar

            //Our getVars, to test the get of our php. We can get a page without any of these vars too though.
            string getVars = "?queryinput=" + System.Web.HttpContext.Current.Request.UserHostAddress;
            //Initialisation, we use localhost, change if appliable
            HttpWebRequest WebReq = (HttpWebRequest)WebRequest.Create(string.Format("http://ws.arin.net/whois/{0}", getVars));
            //This time, our method is GET.
            WebReq.Method = "GET";
            //From here on, it's all the same as above.
            HttpWebResponse WebResp = (HttpWebResponse)WebReq.GetResponse();

            //Now, we read the response (the string), and output it.
            Stream Answer = WebResp.GetResponseStream();
            StreamReader _Answer = new StreamReader(Answer);


            string strXML = _Answer.ReadToEnd();

            //parse the webpage output
            int start, end;
            string ArinRecord;
            start = strXML.IndexOf("<pre>") + 5;
            end = strXML.IndexOf("</pre>");

            ArinRecord = strXML.Substring(start, (end - start));

            //Response.Write(ArinRecord);
            //so now, parse the ARIN record and see if there's a reference to RIPE or APNIC, etc.:
            //OrgID:      <a href="/whois/?queryinput=O%20!%20RIPE">RIPE</a>

            /*RIPE:
             * http://www.db.ripe.net/whois?form_type=simple&full_query_string=&searchtext=+99.141.207.210&submit.x=14&submit.y=11&submit=Search
             * 
             * APNIC:
             * http://wq.apnic.net/apnic-bin/whois.pl
             * this one is a POST it looks like.  Dang.
             * 
             * LacNIC
             * http://lacnic.net/cgi-bin/lacnic/whois?lg=EN
             * Another POST
             * 
             * InterNIC
             * http://reports.internic.net/cgi/whois?whois_nic=64.94.33.1&type=nameserver
             * 
             * AfriNIC
             * http://www.afrinic.net/cgi-bin/whois
             * Another POST
             */
            //OK, we need to replace the dangerous characters with escape sequences:
            //ArinRecord = ArinRecord.Replace("\"", "%34");
            ArinRecord = ArinRecord.Replace("'", "\"");
            
            
           query.CommandText = "UPDATE MSPHITS" +
                " SET IPLookupText ='" + ArinRecord + "'" +
                " WHERE HitID ='" + newRec + "'";
            //Insert ARIN lookup into database

            DB.ExecuteNonQuery(query);
            
            //insert last hop host
            query.CommandText = "UPDATE MSPHITS" +
            " SET LastHopHost='" + lasthop.ToString() + "'" +
            " WHERE HitID ='" + newRec + "'";

            DB.ExecuteNonQuery(query);


            
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
