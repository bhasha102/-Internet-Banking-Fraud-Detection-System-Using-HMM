using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class CustomerLogin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            Session.Abandon();
            txtUserName.Focus();
            Session["LoginCount"] = 0;
        }
    }
    public void Show_Message(string varErrorMessage)
    {
        ClientScript.RegisterStartupScript(this.GetType(), "alter", "javascript:alert('" + varErrorMessage + "');", true);
    }
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (txtUserName.Text.Trim() == "")
        {
            Show_Message("Please provide user name.");
            txtUserName.Focus();
            return;
        }
        if (txtPassword.Text.Trim() == "")
        {
            Show_Message("Please provide password.");
            txtPassword.Focus();
            return;
        }

        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        da.SelectCommand = new SqlCommand();
        da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        da.SelectCommand.CommandText = "select * from [creditcard] where desiredloginname = '" + txtUserName.Text.Trim() + "'";
        da.Fill(ds);
        if (ds.Tables[0].Rows.Count == 0)
        {
            Show_Message("User Name or Password is incorrect.");
            txtUserName.Focus();
            return;
        }
        else
        {

            if (Convert.ToInt32(Session["LoginCount"]) >= 3)
            {
                SqlCommand My_Command = new SqlCommand();
                My_Command.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                if (My_Command.Connection.State == ConnectionState.Closed)
                {
                    My_Command.Connection.Open();
                }
                My_Command.CommandText = "update creditcard set deactivate = 1 where cardid = " + ds.Tables[0].Rows[0]["cardid"].ToString();
                My_Command.CommandType = CommandType.Text;
                My_Command.ExecuteNonQuery();

                Show_Message("User is deactivated. Contact administrator");
                return;
            }
            if (ds.Tables[0].Rows[0]["password"].ToString() != txtPassword.Text.Trim())
            {
                Show_Message("User Name or Password is incorrect.");
                txtUserName.Focus();
                Session["LoginCount"] = Convert.ToInt32(Session["LoginCount"]) + 1;
                return;
            }
            else if (Convert.ToBoolean(ds.Tables[0].Rows[0]["deactivate"]) == true)
            {
                Show_Message("User is deactivated. Contact administrator");
                txtUserName.Focus();
                return;
            }
            Session["LoginUserID"] = ds.Tables[0].Rows[0]["cardid"].ToString();
            Session["Expirymonth"] = ds.Tables[0].Rows[0]["expirymonth"].ToString();
            Session["Expiryyear"] = ds.Tables[0].Rows[0]["expiryyear"].ToString();
            Response.Redirect("Shopping.aspx");
        }
    }
}
