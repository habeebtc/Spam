using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.IO;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;


namespace yaf.pages
{
    public class PostInfo
    {
        public string host;
        public int distance;
        public string today;
        public int x;
        public int y;
        public int strx, stry;

        
        public PostInfo(string h)
        {
            host = h;
            SqlCommand getToday;
            getToday = new SqlCommand("USE S" + host + " SELECT TOP 1 NAME FROM SysObjects WHERE xtype = 'U' and Name <> 'Events' order by name desc");
            today = (string)DB.ExecuteScalar(getToday);



            //Trace.Write("PostInfo Constructor Completed");

        }

    }

    public class tTown
    {
        public string name;
        public string id;
        public int daysinactive;
        private string today;
        public int x;
        public int y;
        public string tname;
        public string tid;
        public string alliance;
        public int pop;
        public string host;

        public tTown(PostInfo pinfo,string pid, string pname, string ttid, string ttname, string xloc, string yloc, string allnce, int size, string host)
        {
            pop = size;
            alliance = allnce;
            tid = ttid;
            tname = ttname;

            x = int.Parse(xloc);
            y = int.Parse(yloc);
            id = pid;
            name = pname;
            today = pinfo.today;
            SqlCommand cmd = new SqlCommand("USE S" + host + " SELECT DISTINCT DaysInactive FROM [" + today + "] where player = '" + pname + "'order by daysinactive asc");
            daysinactive = (int)DB.ExecuteScalar(cmd);
        }
    }



    public partial class WebForm2 : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

            int TownSize, DaysInactive, radius, gridY, gridX;
            string TownName, Player, Alliance;
            PostInfo PageData;
            
            ArrayList towns = new ArrayList();

            s.Items.Add(new ListItem("S5.Travian.com", "5"));
            s.Items.Add(new ListItem("S2.Travian.com", "2"));
            s.Items.Add(new ListItem("S3.Travian.com", "3"));

            if (Request.QueryString["s"] == null)
            { PageData = new PostInfo("5");
            s.SelectedValue = "5";   
            }
            else
            { PageData = new PostInfo((string)Request.QueryString["s"]);
            s.SelectedValue = PageData.host;
            }
            

            if (Request.QueryString["x"] == null)
            { PageData.x = 0;
            x.Text = "0";
            }
            else
            { PageData.x = int.Parse(Request.QueryString["x"]);
            x.Text = PageData.x.ToString();
            }

            if (Request.QueryString["y"] == null)
            { PageData.y = 0;
            y.Text = "0";
            }
            else
            { PageData.y = int.Parse(Request.QueryString["y"]);
            y.Text = PageData.y.ToString();
            }

            if (Request.QueryString["dist"] == null)
            { PageData.distance = 7;
            dist.Text = "7";
            }
            else
            { PageData.distance = int.Parse(Request.QueryString["dist"]);
            dist.Text = PageData.distance.ToString();
            }


  
                s.Items.Add(new ListItem("S5.Travian.com", "5"));
                s.Items.Add(new ListItem("S2.Travian.com", "2"));
                s.Items.Add(new ListItem("S3.Travian.com", "3"));

               /* PageData.x = int.Parse(PageData.strx);
                PageData.y = int.Parse(PageData.stry);*/
               
               


                //getPageData.today = new SqlCommand("USE S" + PageData.host + " SELECT TOP 1 NAME FROM SysObjects WHERE xtype = 'U' and Name <> 'Events' order by name desc");

                Trace.Write("first if statement");
                if ((PageData.distance % 2) == 0)
                {
                    //just in case they picked an even number...we can only center on odd numbers
                    PageData.distance++;
                }
                radius = (PageData.distance - 1) / 2;

                //init table
                for (int xcell = 0; xcell < PageData.distance; xcell++)
                {
                    Table1.Rows.Add(new TableRow());
                    Trace.Write("Added Row " + Table1.Rows.Count.ToString());

                    for (int ycell = 0; ycell < PageData.distance; ycell++)
                    {

                        Table1.Rows[xcell].Cells.Add(new TableCell());
                        Table1.Rows[xcell].Cells[ycell].Width = (int)(500 / PageData.distance);
                        Table1.Rows[xcell].Cells[ycell].Height = (int)(500 / PageData.distance);
                        Table1.Rows[xcell].Cells[ycell].BorderWidth = 1;
                        //Trace.Write("Trying to populate Row " + xcell.ToString() + "Cell " + ycell.ToString());                           


                    }
                }

                Trace.Write("Table Init'd");
                //gets out stuff for the tables!
                DataTable results = new DataTable();
                //string Today = yaf.DB.ExecuteScalar(getPageData.today).ToString();
                System.Drawing.Color bcolor = System.Drawing.Color.White;
                Trace.Write("Host: " + PageData.host);
                Trace.Write("Today: " + PageData.today);
                Trace.Write("X: " + PageData.x.ToString());
                Trace.Write("Y: " + PageData.y.ToString());

                results = yaf.DB.GetData("USE S" + PageData.host + " SELECT * FROM [" + PageData.today + "] WHERE " +
                    "xcoord <= " + (PageData.x + radius).ToString() + " and xcoord >= " +
                    (PageData.x - radius).ToString() + " and ycoord >= " + (PageData.y - radius).ToString() +
                    " and ycoord <= " + (PageData.y + radius).ToString());


                Trace.Write("Connected OK to DB...");

                foreach (DataRow dr in results.Rows)
                {
                    towns.Add(new tTown(PageData, dr["playerid"].ToString(), (string)dr["player"], dr["TownID"].ToString(), (string)dr["townname"], dr["xcoord"].ToString(), dr["ycoord"].ToString(), (string)dr["Alliance"], int.Parse(dr["townsize"].ToString()), PageData.host.ToString()));
                    
                    Trace.Write("Parsing a record...");
                    //recX = (int)dr["xcoord"];
                    //recY = (int)dr["ycoord"];
                    
                    TownName = dr["townname"].ToString();
                    //Trace.Write("Town: " + TownName);
                    TownSize = int.Parse(dr["townsize"].ToString());
                    Player = (string)dr["player"];
                    DaysInactive = (int)dr["daysinactive"];
                    Alliance = (string)dr["Alliance"];
               

                }

            foreach(tTown trec in towns)
            {
                //we need some math to realign the grid coordinates 90 degrees
                    gridX = ((trec.x - PageData.x) + radius);
                    gridY = (PageData.distance - ((trec.y - PageData.y) + radius)) - 1;

                    Table1.Rows[gridY].Cells[gridX].Attributes["OnClick"] = "document.getElementById('mytable').innerHTML='" + "(" +
                    trec.x.ToString() + "," + trec.y.ToString() + ") <br/>Player: " +
                        trec.name + " <br/>Alliance: " + trec.alliance +
                        " <br/>Town  Name: " + trec.tname + " <br/>Town Size: " + trec.pop +
                        " <br/>Days Inactive: " + trec.daysinactive + "'"; 
                    /*Table1.Rows[gridY].Cells[gridX].ToolTip = */

                    if (trec.daysinactive == 0)
                    {
                        bcolor = System.Drawing.Color.Green;
                        Trace.Write("We're Green.");
                    }
                    if ((trec.daysinactive < 3) && (trec.daysinactive > 0))
                    {
                        bcolor = System.Drawing.Color.Yellow;
                        Trace.Write("We're Yellow.");
                    }
                    if ((trec.daysinactive >= 3) && (trec.daysinactive < 7))
                    {
                        bcolor = System.Drawing.Color.Red;
                        Trace.Write("We're Red.");
                    }
                    if (trec.daysinactive >= 7)
                    {
                        bcolor = System.Drawing.Color.Gray;
                        Trace.Write("We're Gray.");
                    }

                    


                    Trace.Write("XGrid: " + gridX.ToString());
                    Trace.Write("YGrid: " + gridY.ToString());
                    Table1.Rows[gridY].Cells[gridX].BackColor = bcolor;


                    Trace.Write("Record Parsed!");
                }
                Trace.Write("got through all the table records...");
                
            }
        
        }
    
}
