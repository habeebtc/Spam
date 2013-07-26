<%@ Control Language="c#" Codebehind="cp_inbox.ascx.cs" AutoEventWireup="True" Inherits="yaf.pages.cp_inbox" %>
<%@ Register TagPrefix="yaf" Namespace="yaf.controls" Assembly="yaf" %>
<yaf:PageLinks runat="server" ID="PageLinks" />
<table class="content" cellspacing="1" cellpadding="0" width="100%">
    <tr>
        <td class="header1" colspan="6">
            <%# GetText(IsSentItems ? "sentitems" : "title") %>
        </td>
    </tr>
    <tr class="header2">
        <td>
            &nbsp;</td>
        <td>
            <img runat="server" id="SortSubject" align="absmiddle" />
            <asp:LinkButton runat="server" ID="SubjectLink" /></td>
        <td>
            <img runat="server" id="SortFrom" align="absmiddle" />
            <asp:LinkButton runat="server" ID="FromLink" /></td>
        <td>
            <img runat="server" id="SortDate" align="absmiddle" />
            <asp:LinkButton runat="server" ID="DateLink" /></td>
        <td>
            &nbsp;</td>
    </tr>
    <asp:Repeater ID="Inbox" runat="server">
        <FooterTemplate>
            <tr class="footer1">
                <td colspan="6" align="right">
                    <asp:Button runat="server" OnLoad="DeleteSelected_Load" CommandName="delete" Text='<%# GetText("deleteselected") %>' /></td>
            </tr>
            </table>
        </FooterTemplate>
        <ItemTemplate>
            <tr class="post">
                <td align="center">
                    <img src="<%# GetImage(Container.DataItem) %>" /></td>
                <td>
                    <a href='<%# yaf.Forum.GetLink(yaf.Pages.cp_message,"pm={0}",DataBinder.Eval(Container.DataItem,"UserPMessageID")) %>'>
                        <%# HtmlEncode(DataBinder.Eval(Container.DataItem,"Subject")) %>
                    </a>
                </td>
                <td>
                    <%# HtmlEncode(DataBinder.Eval(Container.DataItem,IsSentItems ? "ToUser" : "FromUser")) %>
                </td>
                <td>
                    <%# FormatDateTime((System.DateTime)((System.Data.DataRowView)Container.DataItem)["Created"]) %>
                </td>
                <td align="center">
                    <asp:CheckBox runat="server" ID="ItemCheck" /></td>
                <asp:Label runat="server" ID="UserPMessageID" Visible="false" Text='<%# DataBinder.Eval(Container.DataItem,"UserPMessageID") %>' />
            </tr>
        </ItemTemplate>
    </asp:Repeater>
    <yaf:SmartScroller ID="SmartScroller1" runat="server" />
