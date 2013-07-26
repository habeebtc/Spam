<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Events.aspx.cs" Inherits="yaf.pages.Events" EnableViewState="false" Trace="true"%>

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

<img src="http://habeebtc.servegame.org/spam/images/yaflogo.jpg" runat="server" id="imgBanner" alt="" enableviewstate="false" />&nbsp;<br />

<form id="Form1" runat="server" enctype="multipart/form-data" method="get">
    <br />

    <br />
    International Server #:
    <asp:DropDownList ID="s" runat="server" Width="150px" EnableViewState="false">
    </asp:DropDownList>
    &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
    <input id="Button1" style="width: 81px" type="submit" value="submit" title="submit" EnableViewState="false"/><br />
    Player Filter&nbsp;
    <asp:TextBox ID="PFilter" runat="server" EnableViewState="False"></asp:TextBox>&nbsp; Alliance Filter:&nbsp;
    <asp:TextBox ID="AFilter" runat="server" EnableViewState="False"></asp:TextBox><br />
    How many days back to search?
    <asp:TextBox ID="DaysBack" runat="server" Width="59px" EnableViewState="False"></asp:TextBox><br />
    <br />
    <asp:CheckBox ID="NewTown" runat="server" Text="New Towns" EnableViewState="False" />
    <asp:CheckBox ID="Destroyed" runat="server" Text="Destroyed Towns" EnableViewState="False" />
    <asp:CheckBox ID="Conquered" runat="server" Text="Conquered Towns" EnableViewState="False" />
    <asp:CheckBox ID="AChange" runat="server" Text="Alliance Changes" EnableViewState="False" /><br />
    <asp:CheckBox ID="Gold" runat="server" Text="Gold Use" EnableViewState="False" />
    <asp:CheckBox ID="Attack" runat="server" Text="Big Attacks" EnableViewState="False" />
    <asp:CheckBox ID="Rename" runat="server" Text="Renamed Town" EnableViewState="False" />
    <asp:Table ID="Table1" runat="server" EnableViewState="False">
    </asp:Table>
	 


</form>

</body>
</html>
