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
using System.Data.SqlClient;

namespace yaf.pages
{
    public partial class Events : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string Aname, PName;
            int Days, rowcounter = 0;
            bool actionset = false;
            DataTable results = new DataTable();
            SqlCommand Search = new SqlCommand();
            PName = "";

            s.Items.Add(new ListItem("S5.Travian.com", "5"));
            s.Items.Add(new ListItem("S2.Travian.com", "2"));
            s.Items.Add(new ListItem("S3.Travian.com", "3"));

            Trace.Write("Put stuff in dropdown...");
            if (Request.QueryString["AFilter"] != null && Request.QueryString["AFilter"] != "")
            {
                Trace.Write("Getting Alliance Filter");
                Aname = Request.QueryString["AFilter"].ToString();
                AFilter.Text = Aname;
            }
            if (Request.QueryString["PFilter"] != null && Request.QueryString["PFilter"] != "")
            {
                Trace.Write("Getting Player Filter");
                PName = Request.QueryString["PFilter"].ToString();
                PFilter.Text = PName;
            }

            if (Request.QueryString["DaysBack"] != null && Request.QueryString["DaysBack"] != "")
            {
                Trace.Write("Getting Date Filter");
                Days = int.Parse(Request.QueryString["DaysBack"].ToString());
                DaysBack.Text = Days.ToString();
            }


            if (Request.QueryString["s"] == null)
            {
                Search.CommandText = "USE S5 ";
            }
            else
            {
                Trace.Write("Taking server variable input");
                Search.CommandText = "USE S"+Request.QueryString["s"].ToString()+ " ";
            }
            //Build the appropriate query based on input:
            Search.CommandText += "SELECT * FROM Events ";

            if (Attack.Checked)
            {
                actionset = true;
                if(!Search.CommandText.Contains("WHERE"))
                {Search.CommandText += "WHERE (";}

                if(Search.CommandText.EndsWith("WHERE ("))
                {Search.CommandText += "EventType = 'Attacked' ";}
                else
                {Search.CommandText += "OR EventType = 'Attacked' ";                }
                Trace.Write("Added qualifier for attacks");
            }

            if (NewTown.Checked)
            {
                actionset = true;
                if(!Search.CommandText.Contains("WHERE"))
                {Search.CommandText += "WHERE (";}

                if(Search.CommandText.EndsWith("WHERE ("))
                {Search.CommandText += "EventType = 'Founded' ";}
                else
                {Search.CommandText += "OR EventType = 'Founded' ";                }
                Trace.Write("Added qualifier for new town");
            }

            if (Destroyed.Checked)
            {
                actionset = true;
                if(!Search.CommandText.Contains("WHERE"))
                {Search.CommandText += "WHERE (";}

                if(Search.CommandText.EndsWith("WHERE ("))
                {Search.CommandText += "EventType = 'Destroyed' ";}
                else
                {Search.CommandText += "OR EventType = 'Destroyed' ";                }
                Trace.Write("Added qualifier for destroyed");
            }

            if (Conquered.Checked)
            {
                actionset = true;
                if(!Search.CommandText.Contains("WHERE"))
                {Search.CommandText += "WHERE (";}

                if(Search.CommandText.EndsWith("WHERE ("))
                {Search.CommandText += "EventType = 'Conquered' ";}
                else
                {Search.CommandText += "OR EventType = 'Conquered' ";                }
                Trace.Write("Added qualifier for conquerings");
            }

            if (AChange.Checked)
            {
                actionset = true;
                if(!Search.CommandText.Contains("WHERE"))
                {Search.CommandText += "WHERE (";}

                if(Search.CommandText.EndsWith("WHERE ("))
                {Search.CommandText += "EventType = 'AllianceSwitch' ";}
                else
                {Search.CommandText += "OR EventType = 'AllianceSwitch' ";                }
                Trace.Write("Added qualifier for alliance switches");
            }

            if (Gold.Checked)
            {
                actionset = true;
                if(!Search.CommandText.Contains("WHERE"))
                {Search.CommandText += "WHERE (";}

                if(Search.CommandText.EndsWith("WHERE ("))
                {Search.CommandText += "EventType = 'Gold' ";}
                else
                {Search.CommandText += "OR EventType = 'Gold' ";
                Trace.Write("Added qualifier for gold users");
            }
            }

            if (Rename.Checked)
            {
                actionset = true;
                if(!Search.CommandText.Contains("WHERE"))
                {Search.CommandText += "WHERE (";}

                if(Search.CommandText.EndsWith("WHERE ("))
                {Search.CommandText += "EventType = 'RenameTown' ";}
                else
                {Search.CommandText += "OR EventType = 'RenameTown' ";                }
                Trace.Write("Added qualifier for rename town");
            }

            if(Search.CommandText.Contains("WHERE (") && !Search.CommandText.EndsWith(")"))
            {
                Search.CommandText += ")";
            }

            if (PName!= "")
            {
                if(!Search.CommandText.Contains("WHERE"))
                {Search.CommandText += "WHERE ";}

                if(Search.CommandText.EndsWith("WHERE "))
                {Search.CommandText += "(player = '"+PName+"' or OldVal = '"+PName+"' or NewVal = '"+PName+"') ";}
                else if(Search.CommandText.Contains("WHERE (") && Search.CommandText.EndsWith(")"))
                {Search.CommandText += " AND (player = '"+PName+"' or OldVal = '"+PName+"' or NewVal = '"+PName+"') ";                }
                Trace.Write("Added qualifier for player filter");

            }

            //don't do this yet, since I forget to include alliance in the table schema
            /*if (AName!= "")
            {
                if(!Search.CommandText.Contains("WHERE")
                {Search.CommandText += "WHERE ";}

                if(Search.CommandText.EndsWith("WHERE ")
                {Search.CommandText += "(Alliance = '"+AName+"' or OldVal = '"+AName+"' or NewVal = '"+AName+"') ";}
                else
                {Search.CommandText += "AND (Alliance = '"+AName+"' or OldVal = '"+AName+"' or NewVal = '"+AName+"') ";                }
            }*/

            Search.CommandText += "ORDER BY EventDate ASC";

            if(actionset)
            {

            Trace.Write(Search.CommandText);
            results = yaf.DB.GetData(Search.CommandText);
            string rowtext= "";
            /*TableRow newrow = new TableRow();
            TableCell newcell1, newcell2;
            newcell1 = new TableCell();
            newcell2 = new TableCell();
            newrow.Cells.Add(newcell1);
            newrow.Cells.Add(newcell2);*/
                
            foreach (DataRow dr in results.Rows)
            {
                Trace.Write("parsing record: " + dr["EventType"].ToString());


                if (dr["EventType"].ToString().Trim() == "Attacked")
                    {
                        rowtext = dr["Player"].ToString();
                        rowtext += " was attacked. " + dr["TownName"].ToString() + " Lost ";
                        rowtext += dr["OldVal"].ToString() + " Pop.";

                        //Table1.Rows.Add(new TableRow().Cells[0].Text = rowtext);
                    }

                    if (dr["EventType"].ToString().Trim() == "RenameTown")
                    {
                        rowtext = dr["Player"].ToString();
                        rowtext += " Renamed " + dr["OldVal"].ToString() + " to ";
                        rowtext += dr["TownName"].ToString() + ".";
                        Trace.Write("RenameTown");
                    }

                    if (dr["EventType"].ToString().Trim() == "Conquered")
                    {
                        rowtext = dr["NewVal"].ToString() + " Stole " + dr["OldVal"].ToString() + "'s town: " + dr["TownName"].ToString();
                        //Table1.Rows.Add(new TableRow().Cells[0].Text = rowtext);
                        Trace.Write("Conquered");
                    }

                    if (dr["EventType"].ToString().Trim() == "Gold")
                    {
                        rowtext = dr["Player"].ToString() + " (probably) used gold to grow ";
                        rowtext += dr["OldVal"].ToString() + " pop.";
                    }

                    if (dr["EventType"].ToString().Trim() == "Destroyed")
                    {
                        rowtext = dr["Player"].ToString() + " had their city " + dr["TownName"].ToString() + " destroyed.";
                    }

                    if (dr["EventType"].ToString().Trim() == "AllianceSwitch")
                    {
                        rowtext = dr["Player"].ToString() + " switched from alliance " + dr["OldVal"].ToString() + " to " + dr["NewVal"].ToString();

                    }

                    if (dr["EventType"].ToString().Trim() == "Founded")
                    {
                        rowtext = dr["Player"].ToString() + " founded town " + dr["TownName"].ToString();
                    }
                
                //newrow.Cells[0].Text = rowtext;
                //newrow.Cells[1].Text = dr["EventDate"].ToString();

                Table1.Rows.Add(new TableRow());
                Table1.Rows[rowcounter].Cells.Add(new TableCell());
                Table1.Rows[rowcounter].Cells.Add(new TableCell());
                Table1.Rows[rowcounter].Cells[0].Text = rowtext;
                Table1.Rows[rowcounter].Cells[1].Text = dr["EventDate"].ToString(); 
                rowcounter++;
            }
                

            }
        }
    }
}
