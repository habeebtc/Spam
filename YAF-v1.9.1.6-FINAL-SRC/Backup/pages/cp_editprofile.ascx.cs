/* Yet Another Forum.net
 * Copyright (C) 2003 Bj�rnar Henden
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
using System.Globalization;
using System.Collections.Specialized;

namespace yaf.pages
{
	/// <summary>
	/// Summary description for cp_editprofile.
	/// </summary>
	public partial class cp_editprofile : ForumPage
	{

		public cp_editprofile()
			: base( "CP_EDITPROFILE" )
		{
		}

		protected void Page_Load( object sender, System.EventArgs e )
		{
			if ( !User.IsAuthenticated )
			{
				if ( User.CanLogin )
					Forum.Redirect( Pages.login, "ReturnUrl={0}", Utils.GetSafeRawUrl() );
				else
					Forum.Redirect( Pages.forum );
			}

			if ( !IsPostBack )
			{
				PageLinks.AddLink( BoardSettings.Name, Forum.GetLink( Pages.forum ) );
				PageLinks.AddLink( PageUserName, Forum.GetLink( Pages.cp_profile ) );
				PageLinks.AddLink( GetText( "TITLE" ), "" );
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
	}
}
