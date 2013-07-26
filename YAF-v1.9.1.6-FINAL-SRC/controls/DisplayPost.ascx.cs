namespace yaf.controls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
    using System.Text;

	/// <summary>
	///		Summary description for DisplayPost.
	/// </summary>
	public partial class DisplayPost : BaseUserControl
	{

		protected void Page_Load( object sender, System.EventArgs e )
		{
            object obj1 = this.DataRow["MessageID"];
            object obj2 = this.DataRow["ForumID"];
            object obj3 = this.DataRow["TopicID"];
            object obj4 = this.DataRow["UserID"];
			PopMenu1.Visible = ForumPage.IsAdmin;
			if ( PopMenu1.Visible )
			{
				PopMenu1.ItemClick += new PopEventHandler( PopMenu1_ItemClick );
				PopMenu1.AddItem( "userprofile", "User Profile" );
				PopMenu1.AddItem( "edituser", "Edit User (Admin)" );
				PopMenu1.Attach( UserName );
			}

			Page.ClientScript.RegisterClientScriptBlock( this.GetType(), "yafjs", string.Format( "<script language='javascript' src='{0}'></script>", ForumPage.GetURLToResource( "yaf.js" ) ) );
			NameCell.ColSpan = int.Parse( GetIndentSpan() );

            if (DB.hasRated(this.ForumPage.PageUserID.ToString(), obj1.ToString()))
            {
                extraPoints.Visible = false;
                AwardPoints.Visible = false;
            }
            else
            {
                extraPoints.Visible = true;
                AwardPoints.Visible = true;
                AwardPoints.Click += new EventHandler(this.btnAwardPoints_Click);
            }

            
		}


        private void btnAwardPoints_Click(object sender, EventArgs e)
        {
            object obj1 = this.DataRow["MessageID"];
            object obj2 = this.DataRow["ForumID"];
            object obj3 = this.DataRow["TopicID"];
            object userID = this.DataRow["UserID"];
            string UserID = this.ForumPage.PageUserID.ToString();
            switch (((object)extraPoints.SelectedValue).ToString())
            {
                case "-100":
                    DB.user_removepoints(userID, (object)100);
                    break;
                case "-50":
                    DB.user_removepoints(userID, (object)50);
                    break;
                case "-10":
                    DB.user_removepoints(userID, (object)10);
                    break;
                case "-5":
                    DB.user_removepoints(userID, (object)5);
                    break;
                case "-1":
                    DB.user_removepoints(userID, (object)1);
                    break;
                case "1":
                    DB.user_addpoints(userID, (object)1);
                    break;
                case "5":
                    DB.user_addpoints(userID, (object)5);
                    break;
                case "10":
                    DB.user_addpoints(userID, (object)10);
                    break;
                case "50":
                    DB.user_addpoints(userID, (object)50);
                    break;
                case "100":
                    DB.user_addpoints(userID, (object)100);
                    break;
            }
            DB.RatePost(UserID, obj1.ToString(), ((object)extraPoints.SelectedValue).ToString());
            Forum.Redirect(Pages.posts, "m={0}&#{0}", new object[1]
      {
        (object) obj1.ToString()
      });
        }

		private void DisplayPost_PreRender( object sender, EventArgs e )
		{
			// TODO localize tooltips

			Attach.Visible = CanAttach;
			Attach.Text = ForumPage.GetThemeContents( "BUTTONS", "ATTACHMENTS" );
			Attach.ToolTip = "Attachments";
			Attach.NavigateUrl = Forum.GetLink( Pages.attachments, "m={0}", DataRow ["MessageID"] );
			Edit.Visible = CanEditPost;
			Edit.Text = ForumPage.GetThemeContents( "BUTTONS", "EDITPOST" );
			Edit.ToolTip = "Edit this post";
			Edit.NavigateUrl = Forum.GetLink( Pages.postmessage, "m={0}", DataRow ["MessageID"] );
			Delete.Visible = CanDeletePost;
			Delete.Text = ForumPage.GetThemeContents( "BUTTONS", "DELETEPOST" );
			Delete.ToolTip = "Delete this post";
			Delete.Attributes ["onclick"] = string.Format( "return confirm('{0}')", ForumPage.GetText( "confirm_deletemessage" ) );
			Quote.Visible = CanReply;
			Quote.Text = ForumPage.GetThemeContents( "BUTTONS", "QUOTEPOST" );
			Quote.ToolTip = "Reply with quote";
			Quote.NavigateUrl = Forum.GetLink( Pages.postmessage, "t={0}&f={1}&q={2}", ForumPage.PageTopicID, ForumPage.PageForumID, DataRow ["MessageID"] );

			// private messages
			Pm.Visible = ForumPage.User.IsAuthenticated && ForumPage.BoardSettings.AllowPrivateMessages && !IsSponserMessage;
			Pm.Text = ForumPage.GetThemeContents( "BUTTONS", "PM" );
			Pm.NavigateUrl = Forum.GetLink( Pages.pmessage, "u={0}", DataRow ["UserID"] );
			// emailing
			Email.Visible = ForumPage.User.IsAuthenticated && ForumPage.BoardSettings.AllowEmailSending && !IsSponserMessage;
			Email.NavigateUrl = Forum.GetLink( Pages.im_email, "u={0}", DataRow ["UserID"] );
			Email.Text = ForumPage.GetThemeContents( "BUTTONS", "EMAIL" );

			Home.Visible = DataRow ["HomePage"] != DBNull.Value;
			Home.NavigateUrl = DataRow ["HomePage"].ToString();
			Home.Text = ForumPage.GetThemeContents( "BUTTONS", "WWW" );
			Blog.Visible = DataRow ["Weblog"] != DBNull.Value;
			Blog.NavigateUrl = DataRow ["Weblog"].ToString();
			Blog.Text = ForumPage.GetThemeContents( "BUTTONS", "WEBLOG" );
			Msn.Visible = ForumPage.User.IsAuthenticated && DataRow ["MSN"] != DBNull.Value;
			Msn.Text = ForumPage.GetThemeContents( "BUTTONS", "MSN" );
			Msn.NavigateUrl = Forum.GetLink( Pages.im_email, "u={0}", DataRow ["UserID"] );
			Yim.Visible = ForumPage.User.IsAuthenticated && DataRow ["YIM"] != DBNull.Value;
			Yim.NavigateUrl = Forum.GetLink( Pages.im_yim, "u={0}", DataRow ["UserID"] );
			Yim.Text = ForumPage.GetThemeContents( "BUTTONS", "YAHOO" );
			Aim.Visible = ForumPage.User.IsAuthenticated && DataRow ["AIM"] != DBNull.Value;
			Aim.Text = ForumPage.GetThemeContents( "BUTTONS", "AIM" );
			Aim.NavigateUrl = Forum.GetLink( Pages.im_aim, "u={0}", DataRow ["UserID"] );
			Icq.Visible = ForumPage.User.IsAuthenticated && DataRow ["ICQ"] != DBNull.Value;
			Icq.Text = ForumPage.GetThemeContents( "BUTTONS", "ICQ" );
			Icq.NavigateUrl = Forum.GetLink( Pages.im_icq, "u={0}", DataRow ["UserID"] );

			// display admin only info
			if ( ForumPage.IsAdmin )
			{
				AdminInfo.InnerHtml = @"<span class=""smallfont"">";
				if ( Convert.ToDateTime( DataRow ["Edited"] ) != Convert.ToDateTime( DataRow ["Posted"] ) )
				{
					// message has been edited
					AdminInfo.InnerHtml += String.Format( "<b>Edited:</b> {0}", ForumPage.FormatDateTimeShort( Convert.ToDateTime( DataRow ["Edited"] ) ) );
				}
				AdminInfo.InnerHtml += String.Format( " <b>IP:</b> {0}", DataRow ["IP"].ToString() );
				AdminInfo.InnerHtml += "</span>";
			}
		}


		override protected void OnInit( EventArgs e )
		{
			this.PreRender += new EventHandler( DisplayPost_PreRender );
			Delete.Click += new EventHandler( Delete_Click );
			base.OnInit( e );
		}

		private DataRowView m_row = null;
		public DataRowView DataRow
		{
			get
			{
				return m_row;
			}
			set
			{
				m_row = value;
			}
		}

		private yaf.MessageFlags PostMessageFlags
		{
			get
			{
				return new MessageFlags( Convert.ToInt32( DataRow ["Flags"] ) );
			}
		}

		protected bool IsSponserMessage
		{
			get
			{
				return (DataRow["IP"].ToString() == "none");
			}
		}

		protected bool CanEditPost
		{
			get
			{
				return !PostLocked && ( ( int ) DataRow ["ForumFlags"] & ( int ) ForumFlags.Locked ) != ( int ) ForumFlags.Locked && ( ( int ) DataRow ["TopicFlags"] & ( int ) TopicFlags.Locked ) != ( int ) TopicFlags.Locked && ( ( int ) DataRow ["UserID"] == ForumPage.PageUserID || ForumPage.ForumModeratorAccess ) && ForumPage.ForumEditAccess;
			}
		}

		private bool PostLocked
		{
			get
			{
				if ( PostMessageFlags.IsLocked ) return true;

				if ( !ForumPage.IsAdmin && ForumPage.BoardSettings.LockPosts > 0 )
				{
					DateTime edited = ( DateTime ) DataRow ["Edited"];
					if ( edited.AddDays( ForumPage.BoardSettings.LockPosts ) < DateTime.Now )
						return true;
				}
				return false;
			}
		}

		protected bool CanAttach
		{
			get
			{
				return !PostLocked && ( ( int ) DataRow ["ForumFlags"] & ( int ) ForumFlags.Locked ) != ( int ) ForumFlags.Locked && ( ( int ) DataRow ["TopicFlags"] & ( int ) TopicFlags.Locked ) != ( int ) TopicFlags.Locked && ( ( int ) DataRow ["UserID"] == ForumPage.PageUserID || ForumPage.ForumModeratorAccess ) && ForumPage.ForumUploadAccess;
			}
		}

		protected bool CanDeletePost
		{
			get
			{
				return !PostLocked && ( ( int ) DataRow ["ForumFlags"] & ( int ) ForumFlags.Locked ) != ( int ) ForumFlags.Locked && ( ( int ) DataRow ["TopicFlags"] & ( int ) TopicFlags.Locked ) != ( int ) TopicFlags.Locked && ( ( int ) DataRow ["UserID"] == ForumPage.PageUserID || ForumPage.ForumModeratorAccess ) && ForumPage.ForumDeleteAccess;
			}
		}
		protected bool CanReply
		{
			get
			{
				return !PostMessageFlags.IsLocked && ( ( int ) DataRow ["ForumFlags"] & ( int ) ForumFlags.Locked ) != ( int ) ForumFlags.Locked && ( ( int ) DataRow ["TopicFlags"] & ( int ) TopicFlags.Locked ) != ( int ) TopicFlags.Locked && ForumPage.ForumReplyAccess;
			}
		}

		private bool m_isAlt = false;
		public bool IsAlt
		{
			get { return this.m_isAlt; }
			set { this.m_isAlt = value; }
		}

		private bool m_isThreaded = false;
		public bool IsThreaded
		{
			get
			{
				return m_isThreaded;
			}
			set
			{
				m_isThreaded = value;
			}
		}

		protected string GetIndentCell()
		{
			if ( !IsThreaded )
				return "";

			int iIndent = ( int ) DataRow ["Indent"];
			if ( iIndent > 0 )
				return string.Format( "<td rowspan='3' width='1%'><img src='{1}images/spacer.gif' width='{0}' height='2'/></td>", iIndent * 32, Data.ForumRoot );
			else
				return "";
		}

		protected string GetIndentSpan()
		{
			if ( !IsThreaded || ( int ) DataRow ["Indent"] == 0 )
				return "2";
			else
				return "1";
		}

		protected string GetPostClass()
		{
			if ( this.IsAlt )
				return "post_alt";
			else
				return "post";
		}

		protected string FormatUserBox()
		{
			if ( IsSponserMessage ) return "";

			System.Text.StringBuilder userboxOutput = new System.Text.StringBuilder( 1000 );

			// Avatar
			if ( ForumPage.BoardSettings.AvatarUpload && DataRow ["HasAvatarImage"] != null && long.Parse( DataRow ["HasAvatarImage"].ToString() ) > 0 )
			{
				userboxOutput.AppendFormat( "<img src='{1}resource.ashx?u={0}' /><br clear=\"all\" />", DataRow ["UserID"], Data.ForumRoot );
			}
			else if ( DataRow ["Avatar"].ToString().Length > 0 ) // Took out ForumPage.BoardSettings.AvatarRemote
			{
				userboxOutput.AppendFormat( "<img src='{3}resource.ashx?url={0}&width={1}&height={2}'><br clear=\"all\" />",
					Server.UrlEncode( DataRow ["Avatar"].ToString() ),
					ForumPage.BoardSettings.AvatarWidth,
					ForumPage.BoardSettings.AvatarHeight,
					Data.ForumRoot
					);
			}

			// Rank Image
			if ( DataRow ["RankImage"].ToString().Length > 0 )
				userboxOutput.AppendFormat( "<img align=left src=\"{0}images/ranks/{1}\" /><br clear=\"all\" />", Data.ForumRoot, DataRow ["RankImage"] );

			// Rank
			userboxOutput.AppendFormat( "{0}: {1}<br clear=\"all\" />", ForumPage.GetText( "rank" ), DataRow ["RankName"] );

			// Groups
			if ( ForumPage.BoardSettings.ShowGroups )
			{
				using ( DataTable dt = DB.usergroup_list( DataRow ["UserID"] ) )
				{
					userboxOutput.AppendFormat( "{0}: ", ForumPage.GetText( "groups" ) );
					
					bool bFirst = true;

					foreach ( DataRow grp in dt.Rows )
					{
						if ( bFirst )
						{
							userboxOutput.AppendLine( grp ["Name"].ToString() );
							bFirst = false;
						}
						else
						{
							userboxOutput.AppendFormat( ", {0}", grp ["Name"] );
						}
					}
					userboxOutput.AppendLine( "<br/>" );
				}
			}

			// Extra row
			userboxOutput.AppendLine( "<br/>" );

			// Joined
			userboxOutput.AppendFormat( "{0}: {1}<br />", ForumPage.GetText( "joined" ), ForumPage.FormatDateShort( ( DateTime ) DataRow ["Joined"] ) );

			// Posts
			userboxOutput.AppendFormat( "{0}: {1:N0}<br />", ForumPage.GetText( "posts" ), DataRow ["Posts"] );


			// Points
			if ( ForumPage.BoardSettings.DisplayPoints )
			{
				userboxOutput.AppendFormat( "{0}: {1:N0}<br />", ForumPage.GetText( "points" ), DataRow ["Points"] );
			}

			// Location
			if ( DataRow ["Location"].ToString().Length > 0 )
				userboxOutput.AppendFormat( "{0}: {1}<br />", ForumPage.GetText( "location" ), FormatMsg.RepairHtml( ForumPage, DataRow ["Location"].ToString(), false ) );

			return userboxOutput.ToString();
		}

        protected string FormatBody()
        {
            StringBuilder messageOutput = new StringBuilder(2000);
            if (this.PostMessageFlags.NotFormatted)
                messageOutput.Append(this.DataRow["Message"].ToString());
            else
                messageOutput.Append(FormatMsg.FormatMessage(this.ForumPage, this.DataRow["Message"].ToString(), this.PostMessageFlags));
            this.AddAttachedFiles(ref messageOutput);
            if (this.ForumPage.BoardSettings.AllowSignatures && this.DataRow["Signature"] != DBNull.Value && (this.DataRow["Signature"].ToString().ToLower() != "<p>&nbsp;</p>" && this.DataRow["Signature"].ToString().Trim().Length > 0))
                messageOutput.Append("<br/><hr noshade />" + FormatMsg.FormatMessage(this.ForumPage, this.DataRow["Signature"].ToString(), new MessageFlags()
                {
                    IsHTML = false
                }));
            DataTable messageRatings = DB.GetMessageRatings(this.DataRow["MessageID"].ToString());
            if (messageRatings.Rows.Count > 0)
            {
                messageOutput.Append("<br><br><b>This message has been rated: </b><br><br>");
                messageOutput.Append("<table border=1>");
                foreach (DataRow dataRow in (InternalDataCollectionBase)messageRatings.Rows)
                {
                    messageOutput.Append("<tr><td>" + DB.GetUserName(dataRow["UserID"].ToString()) + "</td>");
                    messageOutput.Append("<td>" + dataRow["Rating"].ToString() + "</td></tr>");
                }
                messageOutput.Append("</td></table>");
            }
            return ((object)messageOutput).ToString();
        }

		private void AddAttachedFiles( ref System.Text.StringBuilder messageOutput )
		{
			// define valid image extensions
			string [] aImageExtensions = { "jpg", "gif", "png" };

			if ( long.Parse( DataRow ["HasAttachments"].ToString() ) > 0 )
			{
				string stats = ForumPage.GetText( "ATTACHMENTINFO" );
				string strFileIcon = ForumPage.GetThemeContents( "ICONS", "ATTACHED_FILE" );

				messageOutput.Append( "<p>" );

				using ( DataTable dt = DB.attachment_list( DataRow ["MessageID"], null, null ) )
				{
					// show file then image attachments...
					int tmpDisplaySort = 0;

					while ( tmpDisplaySort <= 1 )
					{
						bool bFirstItem = true;

						foreach ( DataRow dr in dt.Rows )
						{
							string strFilename = Convert.ToString( dr ["FileName"] ).ToLower();
							bool bShowImage = false;

							// verify it's not too large to display (might want to make this a board setting)
							if ( Convert.ToInt32( dr ["Bytes"] ) <= 262144 )
							{
								// is it an image file?
								for ( int i = 0; i < aImageExtensions.Length; i++ )
								{
									if ( strFilename.EndsWith( aImageExtensions [i] ) )
									{
										bShowImage = true;
										break;
									}
								}
							}

							if ( bShowImage && tmpDisplaySort == 1 )
							{
								if ( bFirstItem )
								{
									messageOutput.AppendLine( @"<i class=""smallfont"">" );
									messageOutput.AppendFormat( ForumPage.GetText( "IMAGE_ATTACHMENT_TEXT" ), Convert.ToString( DataRow ["UserName"] ) );
									messageOutput.AppendLine( @"</i><br />" );
									bFirstItem = false;
								}
								messageOutput.AppendFormat( @"<img src=""{0}resource.ashx?a={1}"" alt=""{2}"" /><br />", Data.ForumRoot, dr ["AttachmentID"], Server.HtmlEncode( Convert.ToString( dr ["FileName"] ) ) );
							}
							else if ( !bShowImage && tmpDisplaySort == 0 )
							{
								if ( bFirstItem )
								{
									messageOutput.AppendFormat( @"<b class=""smallfont"">{0}</b><br />", ForumPage.GetText( "ATTACHMENTS" ) );
									bFirstItem = false;
								}
								// regular file attachment
								int kb = ( 1023 + ( int ) dr ["Bytes"] ) / 1024;
								messageOutput.AppendFormat( @"<img border=""0"" alt="""" src=""{0}"" /> <b><a href=""{1}resource.ashx?a={2}"">{3}</a></b> <span class=""smallfont"">{4}</span><br />", strFileIcon, Data.ForumRoot, dr ["AttachmentID"], dr ["FileName"], String.Format( stats, kb, dr ["Downloads"] ) );
							}
						}
						// now show images
						tmpDisplaySort++;
						messageOutput.AppendLine( "<br />" );
					}
				}
			}
		}

		private void Delete_Click( object sender, EventArgs e )
		{
			if ( !CanDeletePost )
				return;

			//Create objects for easy access
			object tmpMessageID = DataRow ["MessageID"];
			object tmpForumID = DataRow ["ForumID"];
			object tmpTopicID = DataRow ["TopicID"];
			object tmpUserID = DataRow ["UserID"];

			// Take away 100 points once!
			DB.user_removepoints( tmpUserID, 100 );

			// Delete message. If it is the last message of the topic, the topic is also deleted
			DB.message_delete( tmpMessageID );

			//If topic has been deleted, redirect to topic list for active forum, else show remaining posts for topic
			if ( DB.topic_info( tmpTopicID ) == null )
				Forum.Redirect( Pages.topics, "f={0}", tmpForumID );
			else
				Forum.Redirect( Pages.posts, "t={0}", tmpTopicID );
		}

		private void PopMenu1_ItemClick( object sender, PopEventArgs e )
		{
			switch ( e.Item )
			{
				case "userprofile":
					Forum.Redirect( Pages.profile, "u={0}", DataRow ["UserID"] );
					break;
				case "edituser":
					Forum.Redirect( Pages.admin_edituser, "u={0}", DataRow ["UserID"] );
					break;
			}
		}
	}
}
