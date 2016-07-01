<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminLogin.aspx.cs" Inherits="AdminLogin" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="StyleSheet.css" />
</head>
<body>
    <form id="frmAdminLogin" runat="server">
        <table cellpadding="0" cellspacing="0" style="width:100%">
            <tr>
                <td style="height:100px;background-color:#1d74b9;">&nbsp;                
                </td>
            </tr>
        </table>
        <br />
        <table cellpadding="0" cellspacing="1" style="width:100%;text-align:center;" border="0" >
            <img src="Images/Admin.jpg" style="text-align:center"/>
            <tr>
                <td colspan="2">
                    <asp:Label id="lblMsg" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width:35%">&nbsp;
                </td>
                <td style="width:10%" align="left">
                    <asp:Label id="lblUserName" runat="server" Text="User Name"></asp:Label>
                </td>
                <td style="width:40%" align="left">
                    <asp:TextBox id="txtUserName" runat="server" Width="70%"></asp:TextBox>
                </td>
                <td style="width:15%">&nbsp;
                </td>
            </tr>            
            <tr>
                <td>&nbsp;</td>
                <td align="left">
                    <asp:Label id="lblPassword" runat="server" Text="Password"></asp:Label>
                </td>
                <td align="left">
                    <asp:TextBox id="txtPassword" runat="server" TextMode="Password" Width="70%" ></asp:TextBox>
                </td>
                <td>&nbsp;</td>
            </tr>            
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="left">
                    <asp:Button id="btnLogin" runat="server" Text="Login" onclick="btnLogin_Click" CssClass="button" Width="75px"></asp:Button>
                </td>
                <td></td>
            </tr>
            <tr>
                <td colspan="3" style="height:150px;"></td>
            </tr>
        </table>
        <table cellpadding="0" cellspacing="0" style="width:100%">
            <tr>
                <td style="height:100px;background-color:#1d74b9;">&nbsp;                
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
