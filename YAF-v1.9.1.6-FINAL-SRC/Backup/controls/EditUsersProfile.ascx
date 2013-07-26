<%@ Control Language="C#" AutoEventWireup="true" Codebehind="EditUsersProfile.ascx.cs" Inherits="yaf.controls.EditUsersProfile" %>
<%@ Register TagPrefix="yaf" Namespace="yaf.controls" Assembly="yaf" %>
<%@ Register TagPrefix="editor" Namespace="yaf.editor" Assembly="yaf" %>
<table width="100%" class="content" cellspacing="1" cellpadding="4">
    <tr>
        <td class="header1" colspan="2">
            <%= ForumPage.GetText("CP_EDITPROFILE","title") %>
        </td>
    </tr>
    <tr>
        <td colspan="2" class="header2">
            <b>
                <%= ForumPage.GetText("CP_EDITPROFILE","aboutyou") %>
            </b>
        </td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","realname2") %>
        </td>
        <td class="post">
            <asp:TextBox ID="Realname" runat="server" CssClass="edit" /></td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","occupation") %>
        </td>
        <td class="post">
            <asp:TextBox ID="Occupation" runat="server" CssClass="edit" /></td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","interests") %>
        </td>
        <td class="post">
            <asp:TextBox ID="Interests" runat="server" CssClass="edit" /></td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","gender") %>
        </td>
        <td class="post">
            <asp:DropDownList ID="Gender" runat="server" CssClass="edit" /></td>
    </tr>
    <tr>
        <td colspan="2" class="header2">
            <b>
                <%= ForumPage.GetText("CP_EDITPROFILE","location") %>
            </b>
        </td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","where") %>
        </td>
        <td class="post">
            <asp:TextBox ID="Location" runat="server" CssClass="edit" /></td>
    </tr>
    <tr>
        <td colspan="2" class="header2">
            <b>
                <%= ForumPage.GetText("CP_EDITPROFILE","homepage") %>
            </b>
        </td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","homepage2") %>
        </td>
        <td class="post">
            <asp:TextBox runat="server" ID="HomePage" CssClass="edit" /></td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","weblog2") %>
        </td>
        <td class="post">
            <asp:TextBox runat="server" ID="Weblog" CssClass="edit" /></td>
    </tr>
    <tr>
        <td colspan="2" class="header2">
            <b>
                <%= ForumPage.GetText("CP_EDITPROFILE","messenger") %>
            </b>
        </td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","msn") %>
        </td>
        <td class="post">
            <asp:TextBox runat="server" ID="MSN" CssClass="edit" /></td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","yim") %>
        </td>
        <td class="post">
            <asp:TextBox runat="server" ID="YIM" CssClass="edit" /></td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","aim") %>
        </td>
        <td class="post">
            <asp:TextBox runat="server" ID="AIM" CssClass="edit" /></td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","icq") %>
        </td>
        <td class="post">
            <asp:TextBox runat="server" ID="ICQ" CssClass="edit" /></td>
    </tr>
    <tr>
        <td colspan="2" class="header2">
            <b>
                <%= ForumPage.GetText("CP_EDITPROFILE","timezone") %>
            </b>
        </td>
    </tr>
    <tr>
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","timezone2") %>
        </td>
        <td class="post">
            <asp:DropDownList runat="server" ID="TimeZones" DataTextField="Name" DataValueField="Value" /></td>
    </tr>
    <tr runat="server" id="ForumSettingsRows">
        <td colspan="2" class="header2">
            <b>
                <%= ForumPage.GetText("CP_EDITPROFILE","FORUM_SETTINGS") %>
            </b>
        </td>
    </tr>
    <tr runat="server" id="UserThemeRow">
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","SELECT_THEME") %>
        </td>
        <td class="post">
            <asp:DropDownList runat="server" ID="Theme" /></td>
    </tr>
    <tr runat="server" id="UserLanguageRow">
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","SELECT_LANGUAGE") %>
        </td>
        <td class="post">
            <asp:DropDownList runat="server" ID="Language" /></td>
    </tr>
    <tr runat="server" id="PMNotificationRow">
        <td class="postheader">
            <%= ForumPage.GetText("CP_EDITPROFILE","PM_EMAIL_NOTIFICATION") %>
        </td>
        <td class="post">
            <asp:CheckBox ID="PMNotificationEnabled" runat="server" /></td>
    </tr>
    <asp:PlaceHolder runat="server" ID="LoginInfo" Visible="false">
        <tr>
            <td class="header2" colspan="2">
                <%= ForumPage.GetText("CP_EDITPROFILE","change_password") %>
            </td>
        </tr>
        <asp:PlaceHolder runat="server" ID="ShowOldPassword" Visible="true">
            <tr>
                <td class="postheader" width="50%">
                    <%= ForumPage.GetText("CP_EDITPROFILE","oldpassword") %>
                </td>
                <td class="post" width="50%">
                    <asp:TextBox CssClass="edit" ID="OldPassword" runat="server" TextMode="Password" /></td>
            </tr>
        </asp:PlaceHolder>
        <tr>
            <td class="postheader">
                <%= ForumPage.GetText("CP_EDITPROFILE","newpassword") %>
            </td>
            <td class="post">
                <asp:TextBox CssClass="edit" ID="NewPassword1" runat="server" TextMode="Password" /></td>
        </tr>
        <tr>
            <td class="postheader">
                <%= ForumPage.GetText("CP_EDITPROFILE","confirmpassword") %>
            </td>
            <td class="post">
                <asp:TextBox CssClass="edit" ID="NewPassword2" runat="server" TextMode="Password" /></td>
        </tr>
        <tr>
            <td colspan="2" class="header2">
                <%= ForumPage.GetText("CP_EDITPROFILE","change_email") %>
            </td>
        </tr>
        <tr>
            <td class="postheader">
                <%= ForumPage.GetText("CP_EDITPROFILE","email") %>
            </td>
            <td class="post">
                <asp:TextBox ID="Email" CssClass="edit" runat="server" OnTextChanged="Email_TextChanged" /></td>
        </tr>
    </asp:PlaceHolder>
    <tr>
        <td class="footer1" colspan="2" align="center">
            <asp:Button ID="UpdateProfile" CssClass="pbutton" runat="server" OnClick="UpdateProfile_Click" />
            |
            <asp:Button ID="Cancel" CssClass="pbutton" runat="server" OnClick="Cancel_Click" />            
        </td>
    </tr>
</table>
