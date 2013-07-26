/* Yet Another Forum.net
 * Copyright (C) 2003 Bjørnar Henden
 * http://www.yetanotherforum.net/
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

using System;
using System.Collections;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Globalization;

namespace yaf.install
{
	/// <summary>
	/// Summary description for install.
	/// </summary>
	public partial class _default : System.Web.UI.Page
	{
		private string m_loadMessage = "";
		enum Step
		{
			Welcome = 0,
			Config,
			Connect,
			Database,
			Forum,
			Finished
		};

		private int InstalledVersion = 0;
		private Step CurStep = Step.Welcome;
		// Forum
		private string [] m_scripts = new string []
		{
			"tables.sql",
			"indexes.sql",
			"constraints.sql",
			"triggers.sql",
			"views.sql",
			"procedures.sql"
		};

		void AddLoadMessage( string msg )
		{
			msg = msg.Replace( "\\", "\\\\" );
			msg = msg.Replace( "'", "\\'" );
			msg = msg.Replace( "\r\n", "\\r\\n" );
			msg = msg.Replace( "\n", "\\n" );
			msg = msg.Replace( "\"", "\\\"" );
			m_loadMessage += msg + "\\n\\n";
		}

		public _default()
		{
			InstalledVersion = GetCurrentVersion();
		}

		protected void Page_Load( object sender, System.EventArgs e )
		{
			if ( !IsPostBack )
			{
				if ( InstalledVersion >= Data.AppVersion )
				{
					LeaveStep( CurStep );
					// see if a forced upgrade was requested
					if ( Request.QueryString ["forceupgrade"] != null )
					{
						// user is forcing a database update -- just move to that step
						CurStep = Step.Database;
					}
					else
					{
						CurStep = Step.Finished;
					}
					EnterStep( CurStep );
				}

				cursteplabel.Text = ( ( int ) CurStep ).ToString();
				TimeZones.DataSource = Data.TimeZones();
				DataBind();
				TimeZones.Items.FindByValue( "0" ).Selected = true;
			}
			else
			{
				CurStep = ( Step ) int.Parse( cursteplabel.Text );
			}
		}

		private void back_Click( object sender, System.EventArgs e )
		{
			LeaveStep( CurStep );
			EnterStep( --CurStep );
			cursteplabel.Text = ( ( int ) CurStep ).ToString();
		}

		public static int GetCurrentVersion()
		{
			try
			{
				// get newer version from registry
				using ( DataTable dt = DB.registry_list( "Version" ) )
					foreach ( DataRow row in dt.Rows )
						return Convert.ToInt32( row ["Value"] );
			}
			catch ( Exception )
			{
			}

			// attempt to get older version information
			try
			{
				using ( DataTable dt = DB.system_list() )
					foreach ( DataRow row in dt.Rows )
						return Convert.ToInt32( row ["Version"] );
			}
			catch ( Exception )
			{
			}
			return 0;
		}

		private void finish_Click( object sender, System.EventArgs e )
		{
			if ( Config.IsDotNetNuke )
			{
				//Redirect back to the portal main page.
				string rPath = Data.ForumRoot;
				int pos = rPath.IndexOf( "/", 2 );
				rPath = rPath.Substring( 0, pos );
				Response.Redirect( rPath );
			}
			else
			{
				Response.Redirect( Data.ForumRoot );
			}
		}

		private void next_Click( object sender, System.EventArgs e )
		{
			if ( CurStep == Step.Config )
			{
				ConfigSample.Visible = true;
				if ( Config.yafSection == null )
				{
					AddLoadMessage( "Web.config is missing the configuration/yafnet section." );
					return;
				}
				if ( Config.ConnectionString == null )
				{
					AddLoadMessage( "Web.config is missing configuration/yafnet/connstr" );
					return;
				}

				ConfigSample.Visible = false;
			}
			else if ( CurStep == Step.Connect )
			{
				try
				{
					using ( SqlConnection conn = DB.GetConnection() )
					{
						conn.Close();
					}
				}
				catch ( Exception x )
				{
					AddLoadMessage( String.Format( "Connection failed. Modify Web.config and try again.\n\nThe error message was:\n\n{0}", x.Message ) );
					return;
				}
			}
			else if ( CurStep == Step.Database )
			{
				UpgradeDatabase();
			}
			else if ( CurStep == Step.Forum )
			{
				if ( TheForumName.Text.Length == 0 )
				{
					AddLoadMessage( "You must enter a forum name." );
					return;
				}
				if ( ForumEmailAddress.Text.Length == 0 )
				{
					AddLoadMessage( "You must enter a forum email address." );
					return;
				}
				if ( SmptServerAddress.Text.Length == 0 )
				{
					AddLoadMessage( "You must enter a smtp server." );
					return;
				}
				if ( UserName.Text.Length == 0 )
				{
					AddLoadMessage( "You must enter the admin user name," );
					return;
				}
				if ( AdminEmail.Text.Length == 0 )
				{
					AddLoadMessage( "You must enter the administrators email address." );
					return;
				}
				if ( Password1.Text.Length == 0 )
				{
					AddLoadMessage( "You must enter a password." );
					return;
				}
				if ( Password1.Text != Password2.Text )
				{
					AddLoadMessage( "The passwords must match." );
					return;
				}
				try
				{
					using ( SqlCommand cmd = new SqlCommand( "yaf_system_initialize" ) )
					{
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.Parameters.AddWithValue( "@Name", TheForumName.Text );
						cmd.Parameters.AddWithValue( "@TimeZone", TimeZones.SelectedItem.Value );
						cmd.Parameters.AddWithValue( "@ForumEmail", ForumEmailAddress.Text );
						cmd.Parameters.AddWithValue( "@SmtpServer", SmptServerAddress.Text );
						cmd.Parameters.AddWithValue( "@User", UserName.Text );
						cmd.Parameters.AddWithValue( "@UserEmail", AdminEmail.Text );
						cmd.Parameters.AddWithValue( "@Password", System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile( Password1.Text, "md5" ) );
						DB.ExecuteNonQuery( cmd );
					}

					using ( SqlCommand cmd = new SqlCommand( "yaf_system_updateversion" ) )
					{
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.Parameters.AddWithValue( "@Version", Data.AppVersion );
						cmd.Parameters.AddWithValue( "@VersionName", Data.AppVersionName );
						DB.ExecuteNonQuery( cmd );
					}
				}
				catch ( Exception x )
				{
					AddLoadMessage( x.Message );
					return;
				}
			}
			LeaveStep( CurStep );
			if ( CurStep == Step.Database && InstalledVersion > 0 )
				CurStep = Step.Finished;
			else
				++CurStep;

			EnterStep( CurStep );
			cursteplabel.Text = ( ( int ) CurStep ).ToString();
		}

		private void LeaveStep( Step step )
		{
			switch ( step )
			{
				case Step.Welcome:
					stepWelcome.Visible = false;
					break;
				case Step.Config:
					stepConfig.Visible = false;
					break;
				case Step.Connect:
					stepConnect.Visible = false;
					break;
				case Step.Database:
					stepDatabase.Visible = false;
					break;
				case Step.Forum:
					stepForum.Visible = false;
					break;
			}
		}

		private void EnterStep( Step step )
		{
			switch ( step )
			{
				case Step.Welcome:
					stepWelcome.Visible = true;
					back.Enabled = false;
					next.Enabled = true;
					break;
				case Step.Config:
					stepConfig.Visible = true;
					back.Enabled = true;
					next.Enabled = true;
					break;
				case Step.Connect:
					stepConnect.Visible = true;
					back.Enabled = true;
					next.Enabled = true;
					break;
				case Step.Database:
					stepDatabase.Visible = true;
					back.Enabled = true;
					next.Enabled = true;
					break;
				case Step.Forum:
					stepForum.Visible = true;
					back.Enabled = false;
					next.Enabled = true;
					break;
				case Step.Finished:
					stepFinished.Visible = true;
					back.Enabled = false;
					next.Enabled = false;
					finish.Enabled = true;
					break;
			}
		}

		#region method UpgradeDatabase
		bool UpgradeDatabase()
		{
			try
			{
				FixAccess( false );

				foreach ( string script in m_scripts )
					ExecuteScript( script );

				FixAccess( true );

				using ( SqlCommand cmd = new SqlCommand( "yaf_system_updateversion" ) )
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue( "@Version", Data.AppVersion );
					cmd.Parameters.AddWithValue( "@VersionName", Data.AppVersionName );
					DB.ExecuteNonQuery( cmd );
				}
			}
			catch ( Exception x )
			{
				AddLoadMessage( x.Message );
				return false;
			}
			return true;
		}
		#endregion


		override protected void OnInit( EventArgs e )
		{
			this.Load += new System.EventHandler( this.Page_Load );
			back.Click += new System.EventHandler( back_Click );
			next.Click += new System.EventHandler( next_Click );
			finish.Click += new System.EventHandler( finish_Click );
			base.OnInit( e );
		}

		protected override void Render( System.Web.UI.HtmlTextWriter writer )
		{
			base.Render( writer );
			if ( m_loadMessage != "" )
			{
				writer.WriteLine( "<script language='javascript'>" );
				writer.WriteLine( "onload = function() {" );
				writer.WriteLine( "	alert('{0}');", m_loadMessage );
				writer.WriteLine( "}" );
				writer.WriteLine( "</script>" );
			}
		}

		private void ExecuteScript( string sScriptFile )
		{
			string sScript = null;
			try
			{
				using ( System.IO.StreamReader file = new System.IO.StreamReader( Request.MapPath( sScriptFile ) ) )
				{
					sScript = file.ReadToEnd() + "\r\n";
					file.Close();
				}
			}
			catch ( System.IO.FileNotFoundException )
			{
				return;
			}
			catch ( Exception x )
			{
				throw new Exception( "Failed to read " + sScriptFile, x );
			}

			string [] statements = System.Text.RegularExpressions.Regex.Split( sScript, "\\sGO\\s", System.Text.RegularExpressions.RegexOptions.IgnoreCase );

			using ( SqlConnection conn = DB.GetConnection() )
			{
				using ( SqlTransaction trans = conn.BeginTransaction( DB.IsolationLevel ) )
				{
					foreach ( string sql0 in statements )
					{
						string sql = sql0.Trim();

						try
						{
							if ( sql.ToLower().IndexOf( "setuser" ) >= 0 )
								continue;

							if ( sql.Length > 0 )
							{
								using ( SqlCommand cmd = new SqlCommand() )
								{
									cmd.Transaction = trans;
									cmd.Connection = conn;
									cmd.CommandType = CommandType.Text;
									cmd.CommandText = sql.Trim();
									cmd.ExecuteNonQuery();
								}
							}
						}
						catch ( Exception x )
						{
							trans.Rollback();
							throw new Exception( String.Format( "FILE:\n{0}\n\nERROR:\n{2}\n\nSTATEMENT:\n{1}", sScriptFile, sql, x.Message ) );
						}
					}
					trans.Commit();
				}
			}
		}


		private void FixAccess( bool bGrant )
		{
			using ( SqlConnection conn = DB.GetConnection() )
			{
				using ( SqlTransaction trans = conn.BeginTransaction( DB.IsolationLevel ) )
				{
					using ( SqlDataAdapter da = new SqlDataAdapter( "select Name,IsUserTable = OBJECTPROPERTY(id, N'IsUserTable'),IsScalarFunction = OBJECTPROPERTY(id, N'IsScalarFunction'),IsProcedure = OBJECTPROPERTY(id, N'IsProcedure'),IsView = OBJECTPROPERTY(id, N'IsView') from dbo.sysobjects where Name like 'yaf_%'", conn ) )
					{
						da.SelectCommand.Transaction = trans;
						using ( DataTable dt = new DataTable( "sysobjects" ) )
						{
							da.Fill( dt );
							using ( SqlCommand cmd = conn.CreateCommand() )
							{
								cmd.Transaction = trans;
								cmd.CommandType = CommandType.Text;
								cmd.CommandText = "select current_user";
								string userName = ( string ) cmd.ExecuteScalar();

								if ( bGrant )
								{
									cmd.CommandType = CommandType.Text;
									foreach ( DataRow row in dt.Select( "IsProcedure=1 or IsScalarFunction=1" ) )
									{
										cmd.CommandText = string.Format( "grant execute on \"{0}\" to \"{1}\"", row ["Name"], userName );
										cmd.ExecuteNonQuery();
									}
									foreach ( DataRow row in dt.Select( "IsUserTable=1 or IsView=1" ) )
									{
										cmd.CommandText = string.Format( "grant select,update on \"{0}\" to \"{1}\"", row ["Name"], userName );
										cmd.ExecuteNonQuery();
									}
								}
								else
								{
									cmd.CommandText = "sp_changeobjectowner";
									cmd.CommandType = CommandType.StoredProcedure;
									foreach ( DataRow row in dt.Select( "IsUserTable=1" ) )
									{
										cmd.Parameters.Clear();
										cmd.Parameters.AddWithValue( "@objname", row ["Name"] );
										cmd.Parameters.AddWithValue( "@newowner", "dbo" );
										try
										{
											cmd.ExecuteNonQuery();
										}
										catch ( SqlException )
										{
										}
									}
									foreach ( DataRow row in dt.Select( "IsView=1" ) )
									{
										cmd.Parameters.Clear();
										cmd.Parameters.AddWithValue( "@objname", row ["Name"] );
										cmd.Parameters.AddWithValue( "@newowner", "dbo" );
										try
										{
											cmd.ExecuteNonQuery();
										}
										catch ( SqlException )
										{
										}
									}
								}
							}
						}
					}
					trans.Commit();
				}
			}
		}
	}
}
