<%@ Page Language="C#" AutoEventWireup="true"  Inherits="yaf.pages.WebForm2" EnableViewState="false"%>
<%@ Register TagPrefix="yaf" Namespace="yaf" Assembly="yaf" %>
<%@ Register TagPrefix="yc" Namespace="yaf.controls" Assembly="yaf" %>

<html>
<head runat="Server" id="YafHead">
<meta name="Description" content="A bulletin board system written in ASP.NET" />
<meta name="Keywords" content="Yet Another Forum.net, Forum, ASP.NET, BB, Bulletin Board, opensource" />
<!-- If you don't want the forum to set the page title, you can remove runat and id -->
<title>Cary's Travian Tools - Daily Spam</title>
</head>
<body>

<img src="http://habeebtc.servegame.org/spam/images/yaflogo.jpg" runat="server" id="imgBanner" alt="" />&nbsp;<br />

<form id="Form1" runat="server" enctype="multipart/form-data" method="get">
    <br />
    <table>
        <tr>
            <td id="mytable" colspan="3" rowspan="3" style="width: 239px; height: 157px">
            </td>
        </tr>
        <tr>
        </tr>
        <tr>
        </tr>
    </table>

    <br />
    International Server #:
    <asp:DropDownList ID="s" runat="server" Width="150px" EnableViewState="false">
    </asp:DropDownList>
    &nbsp; &nbsp;&nbsp; X:
    <asp:TextBox ID="x" EnableViewState="false" runat="server" Width="32px"></asp:TextBox>
    &nbsp; Y:
    <asp:TextBox ID="y" runat="server" Width="32px" EnableViewState="false"></asp:TextBox>
    &nbsp; Search Radius:
    <asp:TextBox ID="dist" runat="server" Width="32px" EnableViewState="false"></asp:TextBox>
    &nbsp;
    <input id="Button1" style="width: 81px" type="submit" value="submit" title="submit" EnableViewState="false"/><br />


    <asp:Table ID="Table1" runat="server" GridLines="Both" EnableViewState="false">
    </asp:Table>
    &nbsp;
	 


</form>

</body>
</html>

