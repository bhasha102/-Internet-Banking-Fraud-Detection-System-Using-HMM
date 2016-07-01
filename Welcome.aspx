<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Welcome.aspx.cs" Inherits="Welcome" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Welcome</title>
    <link rel="stylesheet" type="text/css" href="StyleSheet.css" />
    <script>
        
        function func(linker) {
            //top.frames['ifMain'].location.href = linker;
            document.getElementById('ifMain').setAttribute('src',linker);
        }
</script>
</head>
<body>
    <form id="frmWelcome" runat="server">
    <div id="mainwrapper">
        <!--header tag start-->
        <header>
            <div id="headerdiv"> 
                <a href="welcome.aspx" class="logo">Fraud Detaction</a>
                <div class="formdiv">
                    <div class="toplinksdiv">              
                        <asp:Button ID="btnLogOut" runat="server" CssClass="login_out" />
                        <br /><br />                 
                        <asp:Label ID="lblWelcome" runat="server" Text="Welcome " Font-Bold="True" 
                            Font-Size="Medium"></asp:Label>
                        <asp:Label ID="lblLoginUser" runat="server" Text="Admin" Font-Bold="True" 
                            Font-Size="Medium"></asp:Label>
                    </div>
                </div>
                <div class="clear"></div>
            </div>
        </header>
        <!--header tag end-->
        <!--menudiv start-->
        <div style="background-color: #1d74b9;">
        </div>
        <table cellpadding="0" cellspacing="0" style="width: 100%" >
            <tr>
                <td>
                    <ul>
                    <li><a onclick="func('CreditCardDetails.aspx')">Credit Card</a></li>
                    <li><a onclick="func('DeativatedCustomer.aspx')">Manage Customer</a></li>
                    <li><a onclick="func('AboutUs.aspx')">About Us</a></li>
                    </ul>
                </td>
            </tr>
        </table>
        <div class="clear">
        </div>
        <!--mainbodydiv start-->
        <div id="mainbodydiv">
            <!--accordion container div start-->
            <!--accordion container div end-->
            <!--rightfaqlistdiv start-->
            <div id="rightfaqlistdiv">
                <iframe id="ifMain" runat="server" width="100%" frameborder="0" name="test" scrolling="auto"
                    height="480px"></iframe>
            </div>
            <!--rightfaqlistdiv end-->
            <div class="clear">
            </div>
        </div>
        <div id="shadowdiv">
        </div>
    </div>
    </form>
</body>
</html>
