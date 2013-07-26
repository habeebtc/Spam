<%@ Register TagPrefix="yaf" Namespace="yaf.controls" Assembly="yaf" %>
<%@ Control Language="c#" Codebehind="users.ascx.cs" AutoEventWireup="True" Inherits="yaf.pages.admin.users" %>
<yaf:PageLinks runat="server" ID="PageLinks" />
<yaf:AdminMenu runat="server" ID="Adminmenu1">
    <table class="content" cellspacing="0" cellpadding="0" width="100%">
        <tr>
            <td class="post" valign="top">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td class="header2" nowrap colspan="4">
                            <b>Filter</b></td>
                    </tr>
                    <tr class="post">
                        <td>
                            Group:</td>
                        <td>
                            Rank:</td>
                        <td>
                            Name Contains:</td>
                        <td width="99%">
                            &nbsp;</td>
                    </tr>
                    <tr class="post">
                        <td>
                            <asp:DropDownList ID="group" runat="server">
                            </asp:DropDownList></td>
                        <td>
                            <asp:DropDownList ID="rank" runat="server">
                            </asp:DropDownList></td>
                        <td>
                            <asp:TextBox ID="name" runat="server"></asp:TextBox></td>
                        <td align="right">
                            <asp:Button ID="search" runat="server" Text="Search"></asp:Button></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br>
    <table class="content" cellspacing="1" cellpadding="0" width="100%">
        <tr>
            <td class="header1" colspan="6">
                Users</td>
        </tr>
        <tr>
            <td class="header2">
                Name</td>
            <td class="header2">
                Rank</td>
            <td class="header2" align="center">
                Posts</td>
            <td class="header2" align="center">
                Approved</td>
            <td class="header2">
                Last Visit</td>
            <td class="header2">
                &nbsp;</td>
        </tr>
        <asp:Repeater ID="UserList" runat="server">
            <ItemTemplate>
                <tr>
                    <td class="post">
                        <asp:LinkButton ID="NameEdit" runat="server" CommandName="edit" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "UserID") %>' Text='<%# HtmlEncode(DataBinder.Eval(Container.DataItem, "Name")) %>' /></td>
                    <td class="post">
                        <%# DataBinder.Eval(Container.DataItem,"RankName") %>
                    </td>
                    <td class="post" align="center">
                        <%# DataBinder.Eval(Container.DataItem, "NumPosts") %>
                    </td>
                    <td class="post" align="center">
                        <%# BitSet(DataBinder.Eval(Container.DataItem, "Flags"),2) %>
                    </td>
                    <td class="post">
                        <%# FormatDateTime((System.DateTime)((System.Data.DataRowView)Container.DataItem)["LastVisit"]) %>
                    </td>
                    <td class="post" align="center">
                        <asp:LinkButton runat="server" CommandName="edit" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "UserID") %>'>Edit</asp:LinkButton>
                        |
                        <asp:LinkButton OnLoad="Delete_Load" runat="server" CommandName="delete" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "UserID") %>'>Delete</asp:LinkButton>
                    </td>
                </tr>
            </ItemTemplate>
        </asp:Repeater>
        <!--- Added BAI 07.01.2003 -->
        <tr>
            <td class="footer1" colspan="6">
                <asp:LinkButton ID="NewUser" runat="server">New User</asp:LinkButton></td>
        </tr>
        <!--- Added BAI 07.01.2003 -->
    </table>
</yaf:AdminMenu>
<yaf:SmartScroller ID="SmartScroller1" runat="server" />
