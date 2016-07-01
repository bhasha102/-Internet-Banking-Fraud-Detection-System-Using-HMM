using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class AdminLogin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            txtUserName.Focus();
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
        da.SelectCommand.CommandText = "select * from [user] where username = '" + txtUserName.Text.Trim() + "' and password = '" + txtPassword.Text.Trim() + "'";
        da.Fill(ds);
        if (ds.Tables[0].Rows.Count == 0)
        {
            Show_Message("User Name or Password is incorrect.");
            txtUserName.Focus();
            return;
        }
        else
        {
            Session["LoginUserID"] = ds.Tables[0].Rows[0]["userid"].ToString();
            Response.Redirect("Welcome.aspx");
        }
    }
}
