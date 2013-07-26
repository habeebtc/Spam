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
using System.Data;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Security;

namespace yaf.pages
{
	/// <summary>
	/// Summary description for login.
	/// </summary>
	public partial class login : ForumPage
	{
		public login()
			: base( "LOGIN" )
		{
		}

		protected void Page_Load( object sender, System.EventArgs e )
		{
			if ( !User.CanLogin )
				Forum.Redirect( Pages.forum );

			LostPassword.Click += new System.EventHandler( LostPassword_Click );
			Recover.Click += new System.EventHandler( Recover_Click );

			if ( !IsPostBack )
			{
				PageLinks.AddLink( BoardSettings.Name, Forum.GetLink( Pages.forum ) );
				ForumLogin.Text = GetText( "forum_login" );
				LostPassword.Text = GetText( "lostpassword" );
				Recover.Text = GetText( "sendpassword" );

				// set the focus using Damien McGivern client-side focus class
				ClientSideFocus.setFocus( UserName );

				if ( !String.IsNullOrEmpty( Request.QueryString ["ReturnUrl"] ) )
				{
					ViewState[ "ReturnUrl" ] = Server.UrlDecode( Request.QueryString ["ReturnUrl"] );
				}
			}
		}

		private void LostPassword_Click( object sender, EventArgs e )
		{
			LoginView.Visible = false;
			RecoverView.Visible = true;
		}

		private void Recover_Click( object sender, EventArgs e )
		{
			try
			{
				if ( LostEmail.Text.Length == 0 || LostUserName.Text.Length == 0 )
				{
					AddLoadMessage( GetText( "both_username_email" ) );
					return;
				}

				/// Generate the new password
				string newpw = pages.register.CreatePassword( 8 );

				/// Update password in db
				object userID = DB.user_recoverpassword( PageBoardID, LostUserName.Text, LostEmail.Text );
				if ( userID == DBNull.Value )
				{
					AddLoadMessage( GetText( "wrong_username_email" ) );
				}
				else
				{
					/// Email generated password to user
					System.Text.StringBuilder msg = new System.Text.StringBuilder();
					msg.AppendFormat( "Hello {0}.\r\n\r\n", LostUserName.Text );
					msg.AppendFormat( "Here is your new password: {0}\r\n\r\n", newpw );
					msg.AppendFormat( "Visit {0} at {1}", BoardSettings.Name, ForumURL );

					Utils.SendMail( this, BoardSettings.ForumEmail, LostEmail.Text, "New password", msg.ToString() );

					DB.user_savepassword( userID, newpw );

					LoginView.Visible = true;
					RecoverView.Visible = false;
					AddLoadMessage( GetText( "email_sent_password" ) );
				}
			}
			catch ( Exception x )
			{
				DB.eventlog_create( PageUserID, this, x );
				Utils.LogToMail( x );
				AddLoadMessage( GetText( "RECOVER_ERROR" ) );
			}
		}

		#region Web Form Designer generated code
		override protected void OnInit( EventArgs e )
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit( e );
		}

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{

		}
		#endregion

		protected void ForumLogin_Click( object sender, System.EventArgs e )
		{
			string sPassword = FormsAuthentication.HashPasswordForStoringInConfigFile( Password.Text, "md5" );
			object userID = DB.user_login( PageBoardID, UserName.Text, sPassword );

			if ( userID != DBNull.Value )
			{
				string idName = string.Format( "{0};{1};{2}", userID, PageBoardID, UserName.Text );

				FormsAuthentication.SetAuthCookie( idName, AutoLogin.Checked );

				if ( ViewState ["ReturnUrl"] != null )
				{
					Response.Redirect( ViewState ["ReturnUrl"].ToString() );
				}
				else
				{
					
					Forum.Redirect( Pages.forum );
				}
			}
			else
			{
				AddLoadMessage( GetText( "password_error" ) );
			}
		}
	}
}
