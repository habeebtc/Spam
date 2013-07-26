<%@ Control Language="c#" Codebehind="posts.ascx.cs" AutoEventWireup="True" Inherits="yaf.pages.posts" %>
<%@ Register TagPrefix="yaf" Namespace="yaf.controls" Assembly="yaf" %>
<%@ Register TagPrefix="yaf" TagName="displaypost" Src="../controls/DisplayPost.ascx" %>
<yaf:PageLinks runat="server" ID="PageLinksTop" />
<a name="top"></a>
<asp:Repeater ID="Poll" runat="server" Visible="false">
    <HeaderTemplate>
        <table class="content" cellspacing="1" cellpadding="0" width="100%">
            <tr>
                <td class="header1" colspan="3">
                    <%= GetText("question") %>
                    :
                    <%# GetPollQuestion() %>
                    <%# GetPollIsClosed() %>
                </td>
            </tr>
            <tr>
                <td class="header2">
                    <%= GetText("choice") %>
                </td>
                <td class="header2" align="center" width="10%">
                    <%= GetText("votes") %>
                </td>
                <td class="header2" width="40%">
                    <%= GetText("statistics") %>
                </td>
            </tr>
    </HeaderTemplate>
    <ItemTemplate>
        <tr>
            <td class="post">
                <yaf:MyLinkButton runat="server" Enabled="<%#CanVote%>" CommandName="vote" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ChoiceID") %>'
                    Text='<%# HtmlEncode(yaf.Utils.BadWordReplace(Convert.ToString(DataBinder.Eval(Container.DataItem, "Choice")))) %>' /></td>
            <td class="post" align="center">
                <%# DataBinder.Eval(Container.DataItem, "Votes") %>
            </td>
            <td class="post">
                <nobr><img src="<%# GetThemeContents("VOTE","LCAP") %>" alt=""><img src='<%# GetThemeContents("VOTE","BAR") %>' height="12" width='<%# VoteWidth(Container.DataItem) %>%'><img src='<%# GetThemeContents("VOTE","RCAP") %>'></nobr>
                <%# DataBinder.Eval(Container.DataItem,"Stats") %>
                %</td>
        </tr>
    </ItemTemplate>
    <FooterTemplate>
        </table><br />
    </FooterTemplate>
</asp:Repeater>
<table class='command' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td align="left" class="navlinks">
            <yaf:Pager runat="server" ID="Pager" UsePostBack="false" />
        </td>
        <td align="right">
            <asp:LinkButton ID="PostReplyLink1" runat="server" CssClass="imagelink" ToolTip="Post Reply"
                OnClick="PostReplyLink_Click" />
            <asp:LinkButton ID="NewTopic1" runat="server" CssClass="imagelink" OnClick="NewTopic_Click" />
            <asp:LinkButton ID="DeleteTopic1" runat="server" OnLoad="DeleteTopic_Load" CssClass="imagelink"
                OnClick="DeleteTopic_Click" />
            <asp:LinkButton ID="LockTopic1" runat="server" CssClass="imagelink" OnClick="LockTopic_Click" />
            <asp:LinkButton ID="UnlockTopic1" runat="server" CssClass="imagelink" OnClick="UnlockTopic_Click" />
            <asp:LinkButton ID="MoveTopic1" runat="server" CssClass="imagelink" OnClick="MoveTopic_Click" />
        </td>
    </tr>
</table>
<table class="content" cellspacing="1" cellpadding="0" width="100%" border="0">
    <tr>
        <td colspan="3" style="padding: 0px">
            <table border="0" cellpadding="0" cellspacing="0" width="100%" class="header1">
                <tr class="header1">
                    <td class="header1Title">
                        <asp:Label ID="TopicTitle" runat="server" /></td>
                    <td align="right">
                        <asp:HyperLink ID="MyTest" runat="server"><%= GetText("Options") %></asp:HyperLink>
                        <asp:PlaceHolder runat="server" ID="ViewOptions">&middot;
                            <asp:HyperLink ID="View" runat="server"><%= GetText("View") %></asp:HyperLink>
                        </asp:PlaceHolder>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr class="header2">
        <td colspan="3" align="right" class="header2links">
            <asp:LinkButton ID="PrevTopic" CssClass="header2link" runat="server" OnClick="PrevTopic_Click"><%# GetText("prevtopic") %></asp:LinkButton>
            &middot;
            <asp:LinkButton ID="NextTopic" CssClass="header2link" runat="server" OnClick="NextTopic_Click"><%# GetText("nexttopic") %></asp:LinkButton>
            <div runat="server" visible="false">
                <asp:LinkButton ID="TrackTopic" CssClass="header2link" runat="server" OnClick="TrackTopic_Click"><%# GetText("watchtopic") %></asp:LinkButton>
                &middot;
                <asp:LinkButton ID="EmailTopic" CssClass="header2link" runat="server" OnClick="EmailTopic_Click"><%# GetText("emailtopic") %></asp:LinkButton>
                &middot;
                <asp:LinkButton ID="PrintTopic" CssClass="header2link" runat="server" OnClick="PrintTopic_Click"><%# GetText("printtopic") %></asp:LinkButton>
                &middot;
                <asp:HyperLink ID="RssTopic" CssClass="header2link" runat="server"><%# GetText("rsstopic") %></asp:HyperLink>
            </div>
        </td>
    </tr>
    <asp:Repeater ID="MessageList" runat="server">
        <ItemTemplate>
            <%# GetThreadedRow(Container.DataItem) %>
            <yaf:DisplayPost runat="server" DataRow="<%# Container.DataItem %>" Visible="<%#IsCurrentMessage(Container.DataItem)%>"
                IsThreaded="<%#IsThreaded%>" />
        </ItemTemplate>
        <AlternatingItemTemplate>
            <%# GetThreadedRow(Container.DataItem) %>
            <yaf:DisplayPost runat="server" DataRow="<%# Container.DataItem %>" IsAlt="True"
                Visible="<%#IsCurrentMessage(Container.DataItem)%>" IsThreaded="<%#IsThreaded%>" />
        </AlternatingItemTemplate>
    </asp:Repeater>
    <asp:PlaceHolder ID="QuickReplyPlaceHolder" runat="server">
        <tr>
            <td colspan="3" class="post" style="padding: 0px;">
                <yaf:DataPanel runat="server" ID="DataPanel1" AllowTitleExpandCollapse="true" TitleStyle-CssClass="header2"
                    TitleStyle-Font-Bold="true" Collapsed="true">
                    <div class="post" id="QuickReplyLine" runat="server" style="margin-top: 10px; margin-left: 20px;
                        margin-right: 20px; padding: 2px; height: 100px">
                    </div>
                    <div align="center" style="margin: 7px;">
                        <asp:Button ID="QuickReply" CssClass="pbutton" runat="server" />
                    </div>
                </yaf:DataPanel>
            </td>
        </tr>
    </asp:PlaceHolder>
    <yaf:ForumUsers runat="server" />
</table>
<br />
<table class="command" cellspacing="0" cellpadding="0" width="100%">
    <tr>
        <td align="left" class="navlinks">
            <yaf:Pager runat="server" LinkedPager="Pager" UsePostBack="false" />
        </td>
        <td align="right">
            <asp:LinkButton ID="PostReplyLink2" runat="server" CssClass="imagelink" OnClick="PostReplyLink_Click" />
            <asp:LinkButton ID="NewTopic2" runat="server" CssClass="imagelink" OnClick="NewTopic_Click" />
            <asp:LinkButton ID="DeleteTopic2" runat="server" OnLoad="DeleteTopic_Load" CssClass="imagelink"
                OnClick="DeleteTopic_Click" />
            <asp:LinkButton ID="LockTopic2" runat="server" CssClass="imagelink" OnClick="LockTopic_Click" />
            <asp:LinkButton ID="UnlockTopic2" runat="server" CssClass="imagelink" OnClick="UnlockTopic_Click" />
            <asp:LinkButton ID="MoveTopic2" runat="server" CssClass="imagelink" OnClick="MoveTopic_Click" />
        </td>
    </tr>
</table>
<yaf:PageLinks runat="server" ID="PageLinksBottom" />
<br />
<table cellspacing="0" cellpadding="0" width="100%">
    <tr id="ForumJumpLine" runat="Server">
        <td align="right">
            <%= GetText("FORUM_JUMP") %>
            <yaf:ForumJump ID="ForumJump1" runat="server" />
        </td>
    </tr>
    <tr>
        <td align="right" valign="top" class="smallfont">
            <yaf:PageAccess ID="PageAccess1" runat="server" />
        </td>
    </tr>
</table>
<yaf:SmartScroller ID="SmartScroller1" runat="server" />
<yaf:PopMenu runat="server" ID="MyTestMenu" Control="MyTest" />
<yaf:PopMenu runat="server" ID="ViewMenu" Control="View" />
<span id="WatchTopicID" runat="server" visible="false"></span>