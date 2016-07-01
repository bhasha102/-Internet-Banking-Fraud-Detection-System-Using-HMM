<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Shopping.aspx.cs" Inherits="Shopping" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="StyleSheet.css" />
</head>
<body>
    <form id="frmShopping" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <table cellpadding="0" cellspacing="0" style="width:100%" id="tblPageTitle">
            <tr>
                <td align="center" style="width:95%">
                    <asp:Label ID="lblPageTitle" runat="server" Text="Shopping" CssClass="PageTitle"></asp:Label>
                </td>
                <td style="width:5%">
                    <asp:ImageButton ID="btnLogOut" runat="server" ImageUrl="~/Images/login_out.jpg"  OnClick="btnLogOut_Click" Visible="false"/>    
                </td>                
            </tr>
        </table>
        <div id="divLine">
            <asp:Label id="lblMsg" runat="server" CssClass="ErrorMessage"></asp:Label>
        </div>
        <asp:Panel ID="pnlState" runat="server">
        <table cellpadding="0" cellspacing="1" style="width:100%;">
            <tr>
                <td style="width:25%">&nbsp;</td>
                <td style="width:20%" align="center">
                    Product
                </td>
                <td style="width:30%">
                    <asp:DropDownList ID="ddlProduct" runat="server" Width="90%" AutoPostBack="true"
                        onselectedindexchanged="ddlProduct_SelectedIndexChanged" ></asp:DropDownList>
                </td>
                <td style="width:25%">&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td align="center">
                    Rate
                </td>
                <td>
                    <asp:Label ID="lblRate" runat="server"></asp:Label>
                </td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td align="center">
                    Quantity
                </td>
                <td>
                    <asp:TextBox ID="txtQuantity" runat="server" Width="40%"></asp:TextBox>
                    <asp:RangeValidator ID="RangeValidator2" runat="server" ControlToValidate="txtQuantity"
                    MaximumValue="99999999999999999999" MinimumValue="1" Font-Bold="True" Type="Double">*</asp:RangeValidator>
                </td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td align="center">
                    <asp:Label ID="lblRemark" runat="server" Text="Remark"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtRemark" runat="server" Width="90%"></asp:TextBox>
                </td>
                <td>&nbsp;</td>
            </tr>
        </table>
        <br />
        <div id="divLine">
        <table cellpadding="0" cellspacing="1" style="width:100%;">
            <%--<tr>
                <td style="width:25%">&nbsp;</td>
                <td style="width:20%">
                    Password
                </td>
                <td style="width:30%">
                    <asp:TextBox ID="txtPassword" runat="server" Width="90%" Enabled="false" TextMode="Password" ></asp:TextBox>
                </td>
                <td style="width:25%">&nbsp;</td>
            </tr>--%>
            <%--<tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Label ID="lblSecurityQuestion" runat="server"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtSecurityAnswer" runat="server" Width="90%" Visible="false"></asp:TextBox>
                </td>
                <td>&nbsp;</td>
            </tr>--%>
        </table>
        </div>
        <br />
        <div id="divLine"></div>
        <br />
        <table cellpadding="0" cellspacing="0" style="width:100%">
            <tr>
                <td align="center" style="width:100%">
                    <asp:ImageButton ID="btnAddList" runat="server" 
                        ImageUrl="~/Images/shoppingCart.jpg" onclick="btnAddList_Click"/>    
                </td>                
            </tr>
        </table>
        <table cellpadding="0" cellspacing="1" style="width:100%">
            <tr>
                <td>
                    <asp:GridView ID="grdDetail" runat="server" Width="100%" ShowFooter="false" ShowHeader="true"
                        AutoGenerateColumns="false" AllowSorting="false" HorizontalAlign="Center" 
                        onselectedindexchanged="grdDetail_SelectedIndexChanged">
                        <PagerStyle Width="100%" HorizontalAlign="Center"></PagerStyle>
                        <AlternatingRowStyle Wrap="false" BackColor="LightCyan" />
                        <RowStyle Wrap="false" CssClass="grid_rows"/>
                        <HeaderStyle Wrap="false" HorizontalAlign="Center" CssClass="grid_header" />
                        <Columns>                        
                            <asp:BoundField HeaderText="Productid" ItemStyle-HorizontalAlign="Center" DataField="Product" ItemStyle-Width="300px"  HeaderStyle-HorizontalAlign="Center" />
                            <asp:BoundField HeaderText="Quantity" ItemStyle-HorizontalAlign="Center" DataField="Quantity" ItemStyle-Width="150px"  HeaderStyle-HorizontalAlign="Center"/>
                            <asp:BoundField HeaderText="Rate" ItemStyle-HorizontalAlign="Center" DataField="Rate" ItemStyle-Width="150px"  HeaderStyle-HorizontalAlign="Center"/>
                            <asp:BoundField HeaderText="Amount" ItemStyle-HorizontalAlign="Center" DataField="Amount" ItemStyle-Width="150px"  HeaderStyle-HorizontalAlign="Center"/>
                            <asp:BoundField HeaderText="Remark" ItemStyle-HorizontalAlign="Center" DataField="Remark" ItemStyle-Width="500px"  HeaderStyle-HorizontalAlign="Center"/>                                
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
        </table>
        </asp:Panel>
        <table cellpadding="0" cellspacing="1" style="width:100%" id="tblButton">
            <tr>
                <td align="right">
                    <asp:Button ID="btnSave" runat="server" Text="Submit" CssClass="button" 
                        Width="50px" onclick="btnSave_Click"/>
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="button" Width="50px" OnClick="btnCancel_Click"/>
                </td>
            </tr>
        </table>
        <cc1:ModalPopupExtender id="mpePop" runat="server" PopupControlID="pnlCreditCardInformation" TargetControlID="btnSave" CancelControlID="btnCancelPopUp" Enabled="false"
        ></cc1:ModalPopupExtender>
        <asp:Panel ID="pnlCreditCardInformation" runat="server" Visible="false" style="border:solid 1px black;background-color:White;" >
            <table cellpadding="0" cellspacing="1" style="width:100%;">
                <tr>
                    <td style="width:15%">
                        &nbsp;
                    </td>
                    <td style="width:25%" align="center">
                        Credit Card Number
                    </td>
                    <td style="width:35%">
                        <asp:TextBox ID="txtCreditCardNumber" runat="server" Width="80%"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ControlToValidate="txtCreditCardNumber"
                    ErrorMessage="Card Number Is Required" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidator1" runat="server" ControlToValidate="txtCreditCardNumber"
                    MaximumValue="9999999999999999" MinimumValue="1111111111111111" Font-Bold="True" Type="Double" ValidationGroup="savevalidation">*</asp:RangeValidator>
                    </td>
                    <td style="width:25%">
                        &nbsp;
                    </td>
                </tr>
                <%--<tr>
                    <td >
                        &nbsp;
                    </td>
                    <td >
                        &nbsp;
                    </td>
                    <td colspan="2">
                            Expiry Month <asp:DropDownList ID="ddlMonth" runat="server" Width="30%">
                        <asp:ListItem Text="1" Value="1"></asp:ListItem>
                        <asp:ListItem Text="2" Value="2"></asp:ListItem>
                        <asp:ListItem Text="3" Value="3"></asp:ListItem>
                        <asp:ListItem Text="4" Value="4"></asp:ListItem>
                        <asp:ListItem Text="5" Value="5"></asp:ListItem>
                        <asp:ListItem Text="6" Value="6"></asp:ListItem>
                        <asp:ListItem Text="7" Value="7"></asp:ListItem>
                        <asp:ListItem Text="8" Value="8"></asp:ListItem>
                        <asp:ListItem Text="9" Value="9"></asp:ListItem>
                        <asp:ListItem Text="10" Value="10"></asp:ListItem>
                        <asp:ListItem Text="11" Value="11"></asp:ListItem>
                        <asp:ListItem Text="12" Value="12"></asp:ListItem>
                    </asp:DropDownList>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            Expiry Year <asp:DropDownList ID="ddlYear" runat="server" Width="30%">
                        <asp:ListItem Text="2001" Value="2001"></asp:ListItem>
                        <asp:ListItem Text="2002" Value="2002"></asp:ListItem>
                        <asp:ListItem Text="2003" Value="2003"></asp:ListItem>
                        <asp:ListItem Text="2004" Value="2004"></asp:ListItem>
                        <asp:ListItem Text="2005" Value="2005"></asp:ListItem>
                        <asp:ListItem Text="2006" Value="2006"></asp:ListItem>
                        <asp:ListItem Text="2007" Value="2007"></asp:ListItem>
                        <asp:ListItem Text="2008" Value="2008"></asp:ListItem>
                        <asp:ListItem Text="2009" Value="2009"></asp:ListItem>
                        <asp:ListItem Text="2010" Value="2010"></asp:ListItem>
                        <asp:ListItem Text="2011" Value="2011"></asp:ListItem>
                        <asp:ListItem Text="2012" Value="2012"></asp:ListItem>
                        <asp:ListItem Text="2013" Value="2013"></asp:ListItem>
                        <asp:ListItem Text="2014" Value="2014"></asp:ListItem>
                        <asp:ListItem Text="2015" Value="2015"></asp:ListItem>
                        <asp:ListItem Text="2016" Value="2016"></asp:ListItem>
                        <asp:ListItem Text="2017" Value="2017"></asp:ListItem>
                        <asp:ListItem Text="2018" Value="2018"></asp:ListItem>
                        <asp:ListItem Text="2019" Value="2019"></asp:ListItem>
                        <asp:ListItem Text="2020" Value="2020"></asp:ListItem>
                    </asp:DropDownList>
                    </td>
                </tr>--%>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                    <td align="center">
                        CVV No
                    </td>
                    <td>
                        <asp:TextBox ID="txtCVVNo" runat="server" Width="80%"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" ControlToValidate="txtCVVNo"
                    ErrorMessage="RequiredFieldValidator" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidator5" runat="server" ControlToValidate="txtCVVNo"
                        ErrorMessage="*" MaximumValue="999" MinimumValue="100" Type="Double" ValidationGroup="savevalidation"></asp:RangeValidator>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                    <td align="center">
                        Password
                    </td>
                    <td>
                        <asp:TextBox ID="txtPassword" runat="server" Width="80%" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password Rrequired" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td align="center">
                        <asp:Label ID="lblOneTimePassword" runat="server" Text="One Time Password" Visible="false" ></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtOneTimePassword" runat="server" Width="80%" Visible="false"></asp:TextBox>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td align="center">
                        <asp:Label ID="lblSecurityQuestion" runat="server"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtSecurityAnswer" runat="server" Width="80%" Visible="false"></asp:TextBox>
                    </td>
                    <td>&nbsp;</td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="1" style="width:100%" id="Table1">
                <tr>
                    <td align="right">
                        <asp:Button ID="btnSavePopUp" runat="server" Text="Submit" CssClass="button" OnClick="btnSavePopUp_Click" ValidationGroup="savevalidation"
                            Width="50px"/>
                        <asp:Button ID="btnCancelPopUp" runat="server" Text="Cancel" CssClass="button" Width="50px" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </form>
</body>
</html>
