<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CreditCardDetails.aspx.cs"
    Inherits="CreditCardDetails" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="StyleSheet.css" />
</head>
<body>
    <form id="frmCreditCard" runat="server">
    <table cellpadding="0" cellspacing="0" style="width: 100%" id="tblPageTitle">
        <tr>
            <td align="center" style="width: 95%">
                <asp:Label ID="lblPageTitle" runat="server" Text="Credit Card" CssClass="PageTitle"></asp:Label>
            </td>
        </tr>
    </table>
    <div id="divLine">
        <asp:Label ID="lblError" runat="server" CssClass="ErrorMessage"></asp:Label>
    </div>
    <asp:Panel ID="pnlState" runat="server">
        <table cellpadding="0" cellspacing="1" style="width: 100%">
            <tr>
                <td>
                    Card Number
                </td>
                <td colspan="3">
                    <asp:TextBox ID="txtCardNumber" runat="server" Width="92.5%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ControlToValidate="txtCardNumber"
                    ErrorMessage="Card Number Is Required" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidator2" runat="server" ControlToValidate="txtCardNumber"
                    MaximumValue="9999999999999999" MinimumValue="1111111111111111" Font-Bold="True" Type="Double" ValidationGroup="savevalidation">*</asp:RangeValidator>
                </td>
            </tr>
            <tr>
                <td style="width: 20%">
                    First Name
                </td>
                <td style="width: 30%">
                    <asp:TextBox ID="txtFirstName" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtFirstName"
                    ErrorMessage="Name Is Required" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
                <td style="width: 20%">
                    Last Name
                </td>
                <td style="width: 30%">
                    <asp:TextBox ID="txtLastName" runat="server" Width="80%"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    Desired Login Name
                </td>
                <td>
                    <asp:TextBox ID="txtLoginName" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtLoginName"
                        ErrorMessage="Login Name Required" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
                <td colspan="2">
                    <asp:LinkButton ID="btnAvail" runat="server" CausesValidation="False" WFont-Bold="True"
                        Font-Size="Larger" ForeColor="Blue" onclick="btnAvail_Click">Check Availablility</asp:LinkButton>
                    <asp:Label ID="lblAvail" runat="server" ForeColor="Red" Text="Sorry The UserName Not Available"
                        Visible="False" Font-Bold="True" Font-Size="Larger"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    Password
                </td>
                <td>
                    <asp:TextBox ID="txtPass" runat="server" TextMode="Password" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtPass"
                        ErrorMessage="Password Rrequired" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
                <td>
                    Confirm Password
                </td>
                <td>
                    <asp:TextBox ID="txtConPass" runat="server" Width="80%" TextMode="Password"></asp:TextBox>
                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtPass"
                        ControlToValidate="txtConPass" ErrorMessage="Password Mismatch" Font-Bold="True" ValidationGroup="savevalidation">*</asp:CompareValidator>
                </td>
            </tr>
            <tr>
                <td>
                    Email
                </td>
                <td>
                    <asp:TextBox ID="txtEmail" runat="server" Width="80%"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Invalid Email" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        Font-Bold="True" ValidationGroup="savevalidation">*</asp:RegularExpressionValidator>
                </td>                
                <td>
                    Gender
                </td>
                <td>
                    <asp:DropDownList ID="ddlGender" runat="server" Width="79px">
                        <asp:ListItem Selected="True">Male</asp:ListItem>
                        <asp:ListItem>Female</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="ddlGender"
                        ErrorMessage="Gender Is Required" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>
                    Phone No
                </td>
                <td>
                    <asp:TextBox ID="txtPhone" runat="server" Width="80%"></asp:TextBox>
                    <asp:RangeValidator ID="RangeValidator1" runat="server" ControlToValidate="txtPhone"
                        ErrorMessage="*" MaximumValue="999999999999999" MinimumValue="111" Type="Double" ValidationGroup="savevalidation"></asp:RangeValidator>
                </td>
                <td>
                    Date Of Birth
                </td>
                <td>
                    <div>
                        <table cellpadding="0" style="margin:0">
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtDate" runat="server" Width="60%" MaxLength="10"></asp:TextBox>
                                    <asp:Label ID="Label18" runat="server" Text="(dd/mm/yyyy)" Font-Bold="True"></asp:Label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtDate"
                                        ErrorMessage="DOB Required" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    AddressLine 1
                </td>
                <td>
                    <asp:TextBox ID="txtAdd1" runat="server" TextMode="MultiLine" Height="50px" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtAdd1"
                        Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
                <td >
                    Addresss Line 2
                </td>
                <td >
                    <asp:TextBox ID="txtAdd2" runat="server" TextMode="MultiLine" Height="50px" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txtAdd2"
                        Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td >
                    City
                </td>
                <td >
                    <asp:TextBox ID="txtCity" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtCity"
                        Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
                <td >
                    State
                </td>
                <td >
                    <asp:TextBox ID="txtState" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="txtState"
                        Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td >
                    Country
                </td>
                <td >
                    <asp:TextBox ID="txtCountry" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="txtCountry"
                        Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
                <td >
                    Pin Code
                </td>
                <td >
                    <asp:TextBox ID="txtPin" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" ControlToValidate="txtPin"
                        Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidator3" runat="server" ControlToValidate="txtPin"
                        ErrorMessage="*" MaximumValue="9999999999" MinimumValue="11" Type="Double" ValidationGroup="savevalidation"></asp:RangeValidator>
                </td>
            </tr>
            <tr>
                <td>
                    Account Number
                </td>
                <td>
                    <asp:TextBox ID="txtAccountNumber" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtAccountNumber"
                    ErrorMessage="RequiredFieldValidator" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
                <td>
                    Bank Name
                </td>
                <td>
                    <asp:TextBox ID="txtBankName" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="txtBankName"
                    ErrorMessage="RequiredFieldValidator" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>
                    Credit Limit
                </td>
                <td>
                    <asp:TextBox ID="txtCreditLimit" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ControlToValidate="txtCreditLimit"
                    ErrorMessage="RequiredFieldValidator" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidator4" runat="server" ControlToValidate="txtCreditLimit"
                        ErrorMessage="*" MaximumValue="9999999999" MinimumValue="100" Type="Double" ValidationGroup="savevalidation"></asp:RangeValidator>
                </td>
                <td>
                    CVV No
                </td>
                <td>
                    <asp:TextBox ID="txtCVVNo" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" ControlToValidate="txtCVVNo"
                    ErrorMessage="RequiredFieldValidator" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidator5" runat="server" ControlToValidate="txtCVVNo"
                        ErrorMessage="*" MaximumValue="999" MinimumValue="100" Type="Double" ValidationGroup="savevalidation"></asp:RangeValidator>
                </td>
            </tr>
            <tr>
                <td>
                    Expiry Date
                </td>
                <td>
                    <asp:DropDownList ID="ddlMonth" runat="server" Width="30%">
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
                    </asp:DropDownList> Moth
                    <asp:DropDownList ID="ddlYear" runat="server" Width="30%">
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
                    </asp:DropDownList> Year
                </td>
                <td>
                    <asp:Label ID="lblSecQue1" runat="server">who is ur favourite actor?</asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtSecAns1" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator17" runat="server" ControlToValidate="txtSecAns1"
                    ErrorMessage="RequiredFieldValidator" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblSecQue2" runat="server">who is ur childhood friend?</asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtSecAns2" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server" ControlToValidate="txtSecAns2"
                    ErrorMessage="RequiredFieldValidator" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
                <td>
                    <asp:Label ID="lblSecQue3" runat="server">what is you petname?</asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtSecAns3" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator19" runat="server" ControlToValidate="txtSecAns3"
                    ErrorMessage="RequiredFieldValidator" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblSecQue4" runat="server">which is your birth place?</asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtSecAns4" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator20" runat="server" ControlToValidate="txtSecAns4"
                    ErrorMessage="RequiredFieldValidator" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
                <td>
                    <asp:Label ID="lblSecQue5" runat="server">who is your role model?</asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtSecAns5" runat="server" Width="80%"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator21" runat="server" ControlToValidate="txtSecAns5"
                    ErrorMessage="RequiredFieldValidator" Font-Bold="True" ValidationGroup="savevalidation">*</asp:RequiredFieldValidator>
                </td>
            </tr>
        </table>
        <br />
    </asp:Panel>
    <table cellpadding="0" cellspacing="1" style="width: 100%" id="tblButton">
        <tr>
            <td align="right">
                <asp:Button ID="btnSave" runat="server" Text="Submit" CssClass="button" Width="50px" OnClick="btnSave_Click" ValidationGroup="savevalidation" CausesValidation="true"  />
                <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="button" Visible="false"
                    Width="50px" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="button" Width="50px" CausesValidation="False" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
