using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Net;
using System.Text;
using System.IO;

namespace yaf.pages
{
    class PostVar
    {
        public string Name;
        public string Value;
    }

    public partial class WebForm3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            HttpWebRequest TReq = (HttpWebRequest)WebRequest.Create("http://s2.travian.com/login.php");
            string parms;
            Trace.Write("Created WebRequest object.");
            TReq.Method = "POST";
            //TReq.UserAgent = "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_4_11; en) AppleWebKit/525.18 (KHTML, like Gecko) Version/3.1.1 Safari/525.18";

            TReq.Timeout = 10000;
            //TReq.ContentType = "text/plain";

            ArrayList parmcol;

            PostVar user, pass;
            user = new PostVar();
            pass = new PostVar();
            user.Name = "e24bef7";
            user.Value = "leftleg";
            pass.Name = "ef1cd58";
            pass.Value = "homer80";

            parmcol = new ArrayList();
            parmcol.Add(user);
            parmcol.Add(pass);

            parms = EncodePostData(parmcol);
            //char[] send = Encoding.Default.GetChars(parms);
            TReq.ContentLength = parms.Length;

            Trace.Write("Created WebResponse object....");
            HttpWebResponse loWebResponse = (HttpWebResponse)TReq.GetResponse();



            StreamWriter stOut = new StreamWriter(TReq.GetRequestStream(), System.Text.Encoding.ASCII);

            Trace.Write("Writing to RequestStream");
            stOut.Write(parms, 0, parms.Length);
            stOut.Flush();
            stOut.Close(); 

            Encoding enc = Encoding.GetEncoding(1252);  // Windows default Code Page

            Trace.Write("ReadingResponseStream...");
            StreamReader loResponseStream = new StreamReader(loWebResponse.GetResponseStream(), enc);


            string lcHtml = loResponseStream.ReadToEnd();

            loResponseStream.Close();
            loWebResponse.Close();

            
            Response.Write(Server.HtmlEncode(lcHtml));

        }

        private string EncodePostData(ArrayList PostVars)
        {
            string boundary = "--AaB03x";
            
            int arrReqs = PostVars.Count * 5;
            string[] auxReqBody = new string[arrReqs];
            int count = 0;
            foreach (PostVar par in PostVars)
            {
                auxReqBody[count] = boundary;
                count++;

                auxReqBody[count] = "Content-Disposition: form-data; name=\"" + par.Name + "\"";
                count++;
                auxReqBody[count] = "";
                count++;
                auxReqBody[count] = par.Value;
                count++;
            
            }
            auxReqBody[count] = boundary;
            count++;
            string requestBody = String.Join("\r\n", auxReqBody);
            return requestBody;
        } 
    }
}
