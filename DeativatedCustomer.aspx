<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DeativatedCustomer.aspx.cs" Inherits="DeativatedCustomer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="StyleSheet.css" />
    <script language="javascript" type="text/javascript">
        function ActivateConfirm() {
            return confirm('Are You Sure? You Want To Activate The Customer?');
        }
        function DeactivateConfirm() {
            return confirm('Are You Sure? You Want To Deactivate The Customer?');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <table cellpadding="0" cellspacing="0" style="width: 100%" id="tblPageTitle">
        <tr>
            <td align="center" style="width: 95%">
                <asp:Label ID="lblPageTitle" runat="server" Text="Manage Customer" CssClass="PageTitle"></asp:Label>
            </td>
        </tr>
    </table>
    <div id="divLine">
        <asp:Label ID="lblError" runat="server" CssClass="ErrorMessage"></asp:Label>
    </div>
    <asp:Panel ID="pnlState" runat="server">
        <div id="Div1">
            <asp:GridView runat="server" ID="grdListing" GridLines="None" CellSpacing="1" rowspecing="2" AutoGenerateColumns="false"
                TabIndex="11" Width="98%" Height="100px" AllowPaging="true" PageSize="10" OnRowDataBound="grdListing_RowDataBound" 
                AllowSorting="false" 
                OnPageIndexChanging="grdListing_PageIndexChanging" OnPageIndexChanged="grdListing_PageIndexChanged"
                ShowHeader="true">
                <PagerStyle Width="100%" HorizontalAlign="left"></PagerStyle>
                <PagerSettings NextPageText="Next" PreviousPageText="Previous" Mode="Numeric" Position="Bottom" />
                <HeaderStyle Wrap="false" HorizontalAlign="Center" CssClass="grid_header" />
                <RowStyle Wrap="false" BorderStyle="Solid" BorderColor="Gray"  CssClass="grid_rows"/>
                <Columns>               
                    <asp:TemplateField HeaderText="Action" HeaderStyle-Width = "5%" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnActivate" runat="server" Text="Activate" OnClick="btnActivate_Click" OnClientClick="return ActivateConfirm()"></asp:LinkButton>
                            <asp:LinkButton ID="btnDeactivate" runat="server" Text="Deactivate" OnClick="btnDeactivate_Click" OnClientClick="return DeactivateConfirm()" Visible="false" ></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>         
                    <asp:BoundField HeaderText="Customer" ItemStyle-HorizontalAlign="Left" DataField="Customer" ItemStyle-Width="700px"  />
                    <asp:BoundField HeaderText="Customer" ItemStyle-HorizontalAlign="Left" DataField="cardid"/>
                </Columns>
            </asp:GridView>
            <asp:Label ID="lblTotalField" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblPageName" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblSortKey" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblDirection" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblTitle1" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblIsDataLoaded" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblDeleteQuery" runat="server" Visible="false"></asp:Label>
        </div>
    </asp:Panel>
    </form>
</body>
</html>
