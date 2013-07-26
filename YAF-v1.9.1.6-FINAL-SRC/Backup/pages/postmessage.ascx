<%@ Control language="c#" Codebehind="postmessage.ascx.cs" AutoEventWireup="True" Inherits="yaf.pages.postmessage" %>
<%@ Register TagPrefix="uc1" TagName="smileys" Src="../controls/smileys.ascx" %>
<%@ Register TagPrefix="yaf" Namespace="yaf.controls" Assembly="yaf" %>
<%@ Register TagPrefix="editor" Namespace="yaf.editor" Assembly="yaf" %>

<yaf:PageLinks runat="server" id="PageLinks"/>

<table class="content" cellspacing="1" cellpadding="4" width="100%" align="center">
	<tr>
		<td class="header1" align="center" colspan="2"><asp:label id="Title" runat="server"/></td>
	</tr>

	<tr id="PreviewRow" runat="server" visible="false">
		<td class="postformheader" valign="top"><%= GetText("previewtitle") %></td>
		<td class="post" valign="top" id="PreviewCell" runat="server"></td>
	</tr>

	<tr id="SubjectRow" runat="server">
		<td class="postformheader" width="20%"><%= GetText("subject") %></td>
		<td class="post" width="80%"><asp:textbox id="Subject" runat="server" cssclass="edit"/></td>
	</tr>
	<tr id="FromRow" runat="server">
		<td class="postformheader" width="20%"><%= GetText("from") %></td>
		<td class="post" width="80%"><asp:textbox id="From" runat="server" cssclass="edit"/></td>
	</tr>
	<tr id="PriorityRow" runat="server">
		<td class="postformheader" width="20%"><%= GetText("priority") %></td>
		<td class="post" width="80%">
			<asp:dropdownlist id="Priority" runat="server"/>
		</td>
	</tr>
	<tr id=CreatePollRow runat="server">
		<td class="postformheader" width="20%"><asp:linkbutton id=CreatePoll runat="server" onclick="CreatePoll_Click" /></td>
		<td class="post" width="80%">&nbsp;</td>
	</tr>
	<tr id=PollRow1 runat="server" visible="false">
		<td class="postformheader" width="20%"><em><%= GetText("pollquestion") %></em></td>
		<td class="post" width="80%"><asp:textbox maxlength="50" id=Question runat="server" cssclass="edit"/></td>
	</tr>
	<tr id=PollRow2 runat="server" visible="false">
		<td class="postformheader" width="20%"><em><%= GetText("choice1") %></em></td>
		<td class="post" width="80%"><asp:TextBox maxlength="50" id=PollChoice1 runat="server" cssclass="edit"/></td>
	</tr>
	<tr id="PollRow3" runat="server" visible=false>
		<td class="postformheader" width="20%"><em><%= GetText("choice2") %></em></td>
		<td class="post" width="80%"><asp:TextBox maxlength="50" id=PollChoice2 runat="server" cssclass="edit"/></td>
	</tr>
	<tr id="PollRow4" runat="server" visible=false>
		<td class="postformheader" width="20%"><em><%= GetText("choice3") %></em></td>
		<td class="post" width="80%"><asp:TextBox maxlength="50" id=PollChoice3 runat="server" cssclass="edit"/></td>
	</tr>
	<tr id="PollRow5" runat="server" visible=false>
		<td class="postformheader" width="20%"><em><%= GetText("choice4") %></em></td>
		<td class="post" width="80%"><asp:TextBox maxlength="50" id=PollChoice4 runat="server" cssclass="edit"/></td>
	</tr>
	<tr id="PollRow6" runat="server" visible=false>
		<td class="postformheader" width="20%"><em><%= GetText("choice5") %></em></td>
		<td class="post" width="80%"><asp:TextBox maxlength="50" id=PollChoice5 runat="server" cssclass="edit"/></td>
	</tr>
	<tr id="PollRow7" runat="server" visible=false>
		<td class="postformheader" width="20%"><em><%= GetText("choice6") %></em></td>
		<td class="post" width="80%"><asp:TextBox maxlength="50" id=PollChoice6 runat="server" cssclass="edit"/></td>
	</tr>
	<tr id="PollRow8" runat="server" visible=false>
		<td class="postformheader" width="20%"><em><%= GetText("choice7") %></em></td>
		<td class="post" width="80%"><asp:TextBox maxlength="50" id=PollChoice7 runat="server" cssclass="edit"/></td>
	</tr>
	<tr id="PollRow9" runat="server" visible=false>
		<td class="postformheader" width="20%"><em><%= GetText("choice8") %></em></td>
		<td class="post" width="80%"><asp:TextBox maxlength="50" id=PollChoice8 runat="server" cssclass="edit"/></td>
	</tr>
	<tr id="PollRow10" runat="server" visible=false>
		<td class="postformheader" width="20%"><em><%= GetText("choice9") %></em></td>
		<td class="post" width="80%"><asp:TextBox maxlength="50" id=PollChoice9 runat="server" cssclass="edit"/></td>
	</tr>
	<tr id="PollRowExpire" runat="server" visible=false>
		<td class="postformheader" width="20%"><em><%= GetText("poll_expire") %></em></td>
		<td class="post" width="80%"><asp:TextBox maxlength="10" id="PollExpire" runat="server" cssclass="edit"/> <%= GetText("poll_expire_explain") %></td>
	</tr>	
	<tr>
		<td class="postformheader" width="20%" valign="top"><%= GetText("message") %>
			<br/>
			<uc1:smileys runat="server" onclick="insertsmiley"/>
		</td>
		<td class="post" id="EditorLine" width="80%" runat="server">
			<!-- editor goes here -->
		</td>
	</tr>
  <tr id="NewTopicOptionsRow" runat="server" visible="false">
      <td class="postformheader" valign="top">
        <%= GetText("NEWPOSTOPTIONS") %>
      </td>
      <td class="post">
	    <asp:CheckBox ID="TopicWatch" runat="server" /><asp:Label runat="server" ID="TopicWatchLabel"><%= GetText("TOPICWATCH") %></asp:Label><br />
		<asp:CheckBox ID="TopicAttach" runat="server" visible="false" /><asp:Label runat="server" ID="TopicAttachLabel" visible="false"><%= GetText("TOPICATTACH") %></asp:Label>
      </td>
  </tr>  	
	<tr>
		<td align="center" colspan="2" class="footer1">
			<asp:Button id=Preview cssclass="pbutton" runat="server" onclick="Preview_Click" />
			<asp:button id=PostReply cssclass="pbutton" runat="server" onclick="PostReply_Click" />
			<asp:Button id=Cancel cssclass="pbutton" runat="server" onclick="Cancel_Click" />
		</td>
	</tr>
</table>

<br/>

<asp:repeater id="LastPosts" runat="server" visible="false">
<HeaderTemplate>
    <table class="content" cellspacing="1" cellpadding="0" width="100%" align="center">
        <tr>
            <td class="header2" align="center" colSpan="2">
                <%# GetText("last10") %>
            </td>
        </tr>
</HeaderTemplate>
<FooterTemplate>
	</table>
</FooterTemplate>
<ItemTemplate>
		<tr class="postheader">
			<td width="140"><b><a href="<%# yaf.Forum.GetLink(yaf.Pages.profile,"u={0}",DataBinder.Eval(Container.DataItem, "UserID")) %>"><%# DataBinder.Eval(Container.DataItem, "UserName") %></a></b>
			</td>
			<td width="80%" class="small" align="left"><b><%# GetText("posted") %></b> <%# FormatDateTime((System.DateTime)((System.Data.DataRowView)Container.DataItem)["Posted"]) %></td>
		</tr>
		<tr class="post">
			<td>&nbsp;</td>
			<td valign="top" class="message">
				<%# FormatBody(Container.DataItem) %>
			</td>
		</tr>
</ItemTemplate>
<AlternatingItemTemplate>
		<tr class="postheader">
			<td width="140"><b><a href="<%# yaf.Forum.GetLink(yaf.Pages.profile,"u={0}",DataBinder.Eval(Container.DataItem, "UserID")) %>"><%# DataBinder.Eval(Container.DataItem, "UserName") %></a></b>
			</td>
			<td width="80%" class="small" align="left"><b><%# GetText("posted") %></b> <%# FormatDateTime((System.DateTime)((System.Data.DataRowView)Container.DataItem)["Posted"]) %></td>
		</tr>
		<tr class="post_alt">
			<td>&nbsp;</td>
			<td valign="top" class="message">
				<%# FormatBody(Container.DataItem) %>
			</td>
		</tr>
</AlternatingItemTemplate>
</asp:repeater>

<iframe runat="server" visible="false" id="LastPostsIFrame" name="lastposts" width="100%" height="300" frameborder="0" marginheight="2" marginwidth="2" scrolling="yes"></iframe>

<yaf:SmartScroller id="SmartScroller1" runat = "server" />
