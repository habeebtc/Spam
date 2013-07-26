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

namespace yaf.pages
{
	/// <summary>
	/// Summary description for topics.
	/// </summary>
	public partial class topics : ForumPage
	{
		/// <summary>
		/// FIXME: I have no clue what this is.
		/// </summary>
		protected PlaceHolder SubForums;
		private DataRow forum;
		protected int ShowTopicListSelected;
		private bool m_bIgnoreQueryString = false;

		/// <summary>
		/// Overloads the topics page.
		/// </summary>
		public topics()
			: base( "TOPICS" )
		{
		}

		private void topics_Unload( object sender, System.EventArgs e )
		{
			if ( Mession.UnreadTopics == 0 )
				SetForumRead( PageForumID, DateTime.Now );
		}

		protected void Page_Load( object sender, System.EventArgs e )
		{
			Mession.UnreadTopics = 0;
			RssFeed.NavigateUrl = Forum.GetLink( Pages.rsstopic, "pg=topics&f={0}", Request.QueryString ["f"] );
			RssFeed.Text = GetText( "RSSFEED" );
			RssFeed.Visible = BoardSettings.ShowRSSLink;
			RSSLinkSpacer.Visible = BoardSettings.ShowRSSLink;
			ForumJumpLine.Visible = BoardSettings.ShowForumJump && ForumControl.LockedForum == 0;

			if ( !IsPostBack )
			{
				//PageLinks.Clear();

				if ( ForumControl.LockedForum == 0 )
				{
					PageLinks.AddLink( BoardSettings.Name, Forum.GetLink( Pages.forum ) );
					PageLinks.AddLink( PageCategoryName, Forum.GetLink( Pages.forum, "c={0}", PageCategoryID ) );
				}

				PageLinks.AddForumLinks( PageForumID, true );

				moderate1.Text = GetThemeContents( "BUTTONS", "MODERATE" );
				moderate1.ToolTip = "Moderate this forum";
				moderate2.Text = moderate1.Text;
				moderate2.ToolTip = moderate1.ToolTip;
				MarkRead.Text = GetText( "MARKREAD" );

				NewTopic1.Text = GetThemeContents( "BUTTONS", "NEWTOPIC" );
				NewTopic1.ToolTip = "Post new topic";
				NewTopic2.Text = NewTopic1.Text;
				NewTopic2.ToolTip = NewTopic1.ToolTip;

				ShowList.DataSource = Data.TopicTimes( this );
				ShowList.DataTextField = "TopicText";
				ShowList.DataValueField = "TopicValue";
				ShowTopicListSelected = ( Mession.ShowList == -1 ) ? BoardSettings.ShowTopicsDefault : Mession.ShowList;

				HandleWatchForum();
			}

			if ( Request.QueryString ["f"] == null )
				Data.AccessDenied();

			if ( !ForumReadAccess )
				Data.AccessDenied();

			using ( DataTable dt = DB.forum_list( PageBoardID, PageForumID ) )
				forum = dt.Rows [0];

			if ( forum ["RemoteURL"] != DBNull.Value )
			{
				Response.Clear();
				Response.Redirect( ( string ) forum ["RemoteURL"] );
			}

			PageTitle.Text = ( string ) forum ["Name"];

			BindData();	// Always because of yaf:TopicLine

			if ( !ForumPostAccess )
			{
				NewTopic1.Visible = false;
				NewTopic2.Visible = false;
			}

			if ( !ForumModeratorAccess )
			{
				moderate1.Visible = false;
				moderate2.Visible = false;
			}
		}

		#region Web Form Designer generated code
		/// <summary>
		/// The initialization script for the topics page.
		/// </summary>
		/// <param name="e">The EventArgs object for the topics page.</param>
		override protected void OnInit( System.EventArgs e )
		{
			this.Unload += new System.EventHandler( this.topics_Unload );
			moderate1.Click += new System.EventHandler( this.moderate_Click );
			moderate2.Click += new System.EventHandler( this.moderate_Click );
			ShowList.SelectedIndexChanged += new System.EventHandler( this.ShowList_SelectedIndexChanged );
			MarkRead.Click += new System.EventHandler( this.MarkRead_Click );
			Pager.PageChange += new System.EventHandler( this.Pager_PageChange );
			this.NewTopic1.Click += new System.EventHandler( this.NewTopic_Click );
			this.NewTopic2.Click += new System.EventHandler( this.NewTopic_Click );
			this.WatchForum.Click += new System.EventHandler( this.WatchForum_Click );
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			base.OnInit( e );
		}
		#endregion

		private void HandleWatchForum()
		{
			if ( IsGuest || !ForumReadAccess ) return;
			// check if this forum is being watched by this user
			using ( DataTable dt = DB.watchforum_check( PageUserID, PageForumID ) )
			{
				if ( dt.Rows.Count > 0 )
				{
					// subscribed to this forum
					WatchForum.Text = GetText( "unwatchforum" );
					foreach ( DataRow row in dt.Rows )
					{
						WatchForumID.InnerText = row ["WatchForumID"].ToString();
						break;
					}
				}
				else
				{
					// not subscribed
					WatchForumID.InnerText = "";
					WatchForum.Text = GetText( "watchforum" );
				}
			}
		}

		private void MarkRead_Click( object sender, System.EventArgs e )
		{
			SetForumRead( PageForumID, DateTime.Now );
			BindData();
		}

		private void Pager_PageChange( object sender, EventArgs e )
		{
			m_bIgnoreQueryString = true;
			SmartScroller1.Reset();
			BindData();
		}

		private void moderate_Click( object sender, EventArgs e )
		{

			if ( ForumModeratorAccess )
				Forum.Redirect( Pages.moderate, "f={0}", PageForumID );
		}

		private void ShowList_SelectedIndexChanged( object sender, System.EventArgs e )
		{
			ShowTopicListSelected = ShowList.SelectedIndex;
			BindData();
		}

		private void BindData()
		{
			DataSet ds = DB.board_layout( PageBoardID, PageUserID, PageCategoryID, PageForumID );
			if ( ds.Tables ["yaf_Forum"].Rows.Count > 0 )
			{
				ForumList.DataSource = ds.Tables ["yaf_Forum"].Rows;
				SubForums.Visible = true;
			}

			Pager.PageSize = BoardSettings.TopicsPerPage;

			DataTable dt = DB.topic_list( PageForumID, 1, null, 0, 10 );
			int nPageSize = System.Math.Max( 5, Pager.PageSize - dt.Rows.Count );
			Announcements.DataSource = dt;
			
			if ( !m_bIgnoreQueryString && Request.QueryString ["p"] != null )
			{
				// show specific page (p is 1 based)
				int tPage = Convert.ToInt32( Request.QueryString ["p"] );
				
				if ( tPage > 0 )
				{
					Pager.CurrentPageIndex = tPage - 1;
				}
			}

			int nCurrentPageIndex = Pager.CurrentPageIndex;

			DataTable dtTopics;
			if ( ShowTopicListSelected == 0 )
			{
				dtTopics = DB.topic_list( PageForumID, 0, null, nCurrentPageIndex * nPageSize, nPageSize );
			}
			else
			{
				DateTime date = DateTime.Now;
				switch ( ShowTopicListSelected )
				{
					case 1:
						date -= TimeSpan.FromDays( 1 );
						break;
					case 2:
						date -= TimeSpan.FromDays( 2 );
						break;
					case 3:
						date -= TimeSpan.FromDays( 7 );
						break;
					case 4:
						date -= TimeSpan.FromDays( 14 );
						break;
					case 5:
						date -= TimeSpan.FromDays( 31 );
						break;
					case 6:
						date -= TimeSpan.FromDays( 2 * 31 );
						break;
					case 7:
						date -= TimeSpan.FromDays( 6 * 31 );
						break;
					case 8:
						date -= TimeSpan.FromDays( 365 );
						break;
				}
				dtTopics = DB.topic_list( PageForumID, 0, date, nCurrentPageIndex * nPageSize, nPageSize );
			}
			int nRowCount = 0;
			if ( dtTopics.Rows.Count > 0 ) nRowCount = ( int ) dtTopics.Rows [0] ["RowCount"];
			int nPageCount = ( nRowCount + nPageSize - 1 ) / nPageSize;

			TopicList.DataSource = dtTopics;

			DataBind();

			// setup the show topic list selection after data binding
			ShowList.SelectedIndex = ShowTopicListSelected;
			Mession.ShowList = ShowTopicListSelected;

			Pager.Count = nRowCount;
		}

		private void NewTopic_Click( object sender, System.EventArgs e )
		{
			if ( ( ( int ) forum ["Flags"] & ( int ) ForumFlags.Locked ) == ( int ) ForumFlags.Locked )
			{
				AddLoadMessage( GetText( "WARN_FORUM_LOCKED" ) );
				return;
			}

			if ( !ForumPostAccess )
				Data.AccessDenied(/*"You don't have access to post new topics in this forum."*/);

			Forum.Redirect( Pages.postmessage, "f={0}", PageForumID );
		}

		private void WatchForum_Click( object sender, System.EventArgs e )
		{
			if ( !ForumReadAccess )
				return;

			if ( IsGuest )
			{
				AddLoadMessage( GetText( "WARN_LOGIN_FORUMWATCH" ) );
				return;
			}

			if ( WatchForumID.InnerText == "" )
			{
				DB.watchforum_add( PageUserID, PageForumID );
				AddLoadMessage( GetText( "INFO_WATCH_FORUM" ) );
			}
			else
			{
				int tmpID = Convert.ToInt32( WatchForumID.InnerText );
				DB.watchforum_delete( tmpID );
				AddLoadMessage( GetText( "INFO_UNWATCH_FORUM" ) );
			}

			HandleWatchForum();
		}

		protected string GetSubForumTitle()
		{
			return string.Format( GetText( "SUBFORUMS" ), PageForumName );
		}
	}
}
