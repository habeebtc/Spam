<%@ Register TagPrefix="yaf" Namespace="yaf.controls" Assembly="yaf" %>
<%@ Control Language="c#" Codebehind="hostsettings.ascx.cs" AutoEventWireup="True" Inherits="yaf.pages.admin.hostsettings" %>
<yaf:PageLinks runat="server" ID="PageLinks" />
<yaf:AdminMenu runat="server" ID="Adminmenu1">
    <table class="content" cellspacing="1" cellpadding="0" align="center">
        <tr>
            <td class="header1" colspan="2">
                Forum Settings</td>
        </tr>
        <tr>
            <td class="header2" align="center" colspan="2">
                Forum Setup</td>
        </tr>
        <tr>
            <td class="postheader" width="50%">
                <b>MS SQL Server Version:</b><br>
                What version of MS SQL Server is running.</td>
            <td class="post" width="50%">
                <asp:Label ID="SQLVersion" runat="server" CssClass="smallfont"></asp:Label></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Time Zone:</b><br>
                The time zone of the web server.</td>
            <td class="post">
                <asp:DropDownList ID="TimeZones" runat="server" DataValueField="Value" DataTextField="Name">
                </asp:DropDownList></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Forum Email:</b><br>
                The from address when sending emails to users.</td>
            <td class="post">
                <asp:TextBox ID="ForumEmailEdit" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Require Email Verification:</b><br>
                If unchecked users will not need to verify their email address.</td>
            <td class="post">
                <asp:CheckBox ID="EmailVerification" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Show Moved Topics:</b><br>
                If this is checked, topics that are moved will leave behind a pointer to the new topic.</td>
            <td class="post">
                <asp:CheckBox ID="ShowMoved" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Links in New Window:</b><br>
                If this is checked, links in messages will open in a new window.</td>
            <td class="post">
                <asp:CheckBox ID="BlankLinks" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Show Groups:</b><br>
                Should the groups a user is part of be visible on the posts page.</td>
            <td class="post">
                <asp:CheckBox ID="ShowGroupsX" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Show Groups in profile:</b><br>
                Should the groups a user is part of be visible on the users profile page.</td>
            <td class="post">
                <asp:CheckBox ID="ShowGroupsProfile" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Use File Table:</b><br>
                Uploaded files will be saved in the database instead of the file system.</td>
            <td class="post">
                <asp:CheckBox ID="UseFileTableX" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Show RSS Links:</b><br>
                Enable or disable display of RSS links throughout the forum.</td>
            <td class="post">
                <asp:CheckBox ID="ShowRSSLinkX" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Show Page Generated Time:</b><br>
                Enable or disable display of page generation text at the bottom of the page.</td>
            <td class="post">
                <asp:CheckBox ID="ShowPageGenerationTime" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Show Forum Jump Box:</b><br>
                Enable or disable display of the Forum Jump Box throughout the forum.</td>
            <td class="post">
                <asp:CheckBox ID="ShowForumJumpX" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Display Points System:</b><br>
                If checked, points for posting will be displayed for each user.</td>
            <td class="post">
                <asp:CheckBox ID="DisplayPoints" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Remove Nested Quotes:</b><br>
                Automatically remove nested [quote] tags from replies.</td>
            <td class="post">
                <asp:CheckBox ID="RemoveNestedQuotesX" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Show Member Stats:</b><br>
                Show the total members statistics on the front page.</td>
            <td class="post">
                <asp:CheckBox ID="ShowMemberStatsX" runat="server"></asp:CheckBox></td>
        </tr>        
        <tr>
            <td class="postheader">
                <b>Poll Votes Dependant on IP:</b><br>
                By default, poll voting is tracked via username and client-side cookie. (One vote per username. Cookies are used if guest voting
                is allowed.) If this option is enabled, votes also use IP as a reference providing the most security against voter fraud.
            </td>
            <td class="post">
                <asp:CheckBox ID="PollVoteTiedToIPX" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Max File Size:</b><br>
                Maximum size of uploaded files. Leave empty for no limit.</td>
            <td class="post">
                <asp:TextBox ID="MaxFileSize" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Smilies Display Grid Size:</b><br>
                Number of smilies to show by number of rows and columns.</td>
            <td class="post">
                <asp:TextBox ID="SmiliesPerRow" runat="server"></asp:TextBox><b>x</b>
                <asp:TextBox ID="SmiliesColumns" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Posts Per Page:</b><br>
                Number of posts to show per page.</td>
            <td class="post">
                <asp:TextBox ID="PostsPerPage" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Topics Per Page:</b><br>
                Number of topics to show per page.</td>
            <td class="post">
                <asp:TextBox ID="TopicsPerPage" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Days before posts are locked:</b><br>
                Number of days until posts are locked and not possible to edit or delete. Set to 0 for no limit.</td>
            <td class="post">
                <asp:TextBox ID="LockPosts" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Post Flood Delay:</b><br>
                Number of seconds before another post can be entered. (Does not apply to admins or mods.)</td>
            <td class="post">
                <asp:TextBox ID="PostFloodDelay" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Date and time format from language file:</b><br>
                If this is checked, the date and time format will use settings from the language file. Otherwise the browser settings will be
                used.</td>
            <td class="post">
                <asp:CheckBox ID="DateFormatFromLanguage" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Create NNTP user names:</b><br>
                Check to allow users to automatically be created when downloading usenet messages. Only enable this in a test environment, and
                <em>NEVER</em> in a production environment. The main purpose of this option is for performance testing.</td>
            <td class="post">
                <asp:CheckBox ID="CreateNntpUsers" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="header2" align="center" colspan="2">
                Forum Ads</td>
        </tr>
        <tr>
            <td class="postheader">
                <b>2nd post ad:</b><br />
                Place the code that you wish to be displayed in each thread after the 1st post. If you do not want an ad to be displayed, don't
                put anything in the box.
            </td>
            <td class="post">
                <asp:TextBox TextMode="MultiLine" runat="server" ID="AdPost" Columns="75" Rows="10"/>
            </td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Show ad from above to signed in users:</b><br />
                If checked, signed in users will see ads.
            </td>
            <td class="post">
                <asp:CheckBox runat="server" ID="ShowAdsToSignedInUsers" />
            </td>
        </tr>
        <tr>
            <td class="header2" align="center" colspan="2">
                Editing/Formatting Settings</td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Forum Editor:</b><br>
                Select global editor type for your forum. To use the HTML editors (FCK and FreeTextBox) the .bin file must be in the \bin directory
                and the proper support files must be put in \editors.
            </td>
            <td class="post">
                <asp:DropDownList ID="ForumEditorList" runat="server" DataValueField="Value" DataTextField="Name">
                </asp:DropDownList></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Accepted HTML Tags:</b><br>
                Comma seperated list (no spaces) of HTML tags that are allowed in posts using HTML editors.</td>
            <td class="post">
                <asp:TextBox ID="AcceptedHTML" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="header2" align="center" colspan="2">
                Permissions Settings</td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Allow User Change Theme:</b><br>
                Should users be able to choose what theme they want to use?</td>
            <td class="post">
                <asp:CheckBox ID="AllowUserThemeX" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Allow User Change Language:</b><br>
                Should users be able to choose what language they want to use?</td>
            <td class="post">
                <asp:CheckBox ID="AllowUserLanguageX" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Allow Private Messages:</b><br>
                Allow users to access and send private messages.</td>
            <td class="post">
                <asp:CheckBox ID="AllowPrivateMessagesX" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Allow Private Message Notifications:</b><br>
                Allow users email notifications when new private messages arrive.</td>
            <td class="post">
                <asp:CheckBox ID="AllowPMNotifications" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Allow Email Sending:</b><br>
                Allow users to send emails to each other.</td>
            <td class="post">
                <asp:CheckBox ID="AllowEmailSendingX" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Allow Signatures:</b><br>
                Allow users to create signatures.</td>
            <td class="post">
                <asp:CheckBox ID="AllowSignaturesX" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Disable New Registrations:</b><br>
                New users won't be able to register.</td>
            <td class="post">
                <asp:CheckBox ID="DisableRegistrations" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="header2" align="center" colspan="2">
                SMTP Server Settings</td>
        </tr>
        <tr>
            <td class="postheader">
                <b>SMTP Server:</b><br>
                To be able to send posts you need to enter the name of a valid smtp server.</td>
            <td class="post">
                <asp:TextBox ID="ForumSmtpServer" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>SMTP User Name:</b><br>
                If you need to be authorized to send email.</td>
            <td class="post">
                <asp:TextBox ID="ForumSmtpUserName" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>SMTP Password:</b><br>
                If you need to be authorized to send email.</td>
            <td class="post">
                <asp:TextBox ID="ForumSmtpUserPass" runat="server" TextMode="Password"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="header2" align="center" colspan="2">
                Avatar Settings</td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Allow remote avatars:</b><br>
                Can users use avatars from other websites.</td>
            <td class="post">
                <asp:CheckBox ID="AvatarRemote" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Allow avatar uploading:</b><br>
                Can users upload avatars to their profile.</td>
            <td class="post">
                <asp:CheckBox ID="AvatarUpload" runat="server"></asp:CheckBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Avatar Width:</b><br>
                Maximum width for avatars.</td>
            <td class="post">
                <asp:TextBox ID="AvatarWidth" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Avatar Height:</b><br>
                Maximum height for avatars.</td>
            <td class="post">
                <asp:TextBox ID="AvatarHeight" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td class="postheader">
                <b>Avatar Size:</b><br>
                Maximum size for avatars in bytes.</td>
            <td class="post">
                <asp:TextBox ID="AvatarSize" runat="server"></asp:TextBox></td>
        </tr>
        <!--tr>
		<td class="header2" colspan="2">Forum Moderator Access</td>
	</tr>
	<tr>
		<td class="postheader"><b>Groups and Users:</b><br/>Forum moderators can access groups and users administration.</td>
		<td class="post">...</td>
	</tr>
	<tr>
		<td class="postheader"><b>Forum:</b><br/>Forum moderators can access forum management.</td>
		<td class="post">...</td>
	</tr>
	<tr>
		<td class="postheader"><b>...</b><br/>...</td>
		<td class="post">...</td>
	</tr-->
        <tr>
            <td class="postfooter" align="center" colspan="2">
                <asp:Button ID="Save" runat="server" Text="Save" OnClick="Save_Click"></asp:Button></td>
        </tr>
    </table>
</yaf:AdminMenu>
<yaf:SmartScroller ID="SmartScroller1" runat="server" />
