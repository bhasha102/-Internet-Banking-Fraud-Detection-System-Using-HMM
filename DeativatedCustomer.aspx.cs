using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DeativatedCustomer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginUserID"] == null)
        {
            Response.Redirect("Session_Expired.aspx");
        }
        if (!(Page.IsPostBack))
        {
            grdListing.DataSource = getdata();
            grdListing.DataBind();
        }
    }
    private DataSet getdata()
    {
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        try
        {
            da.SelectCommand = new SqlCommand();
            da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            da.SelectCommand.CommandText = "select DesiredLoginName as [Customer], CardID from [creditcard] where deactivate = 1 union select '', 0 order by CardID ";
            da.Fill(ds);
        }
        catch
        {
        }
        return ds;
    }
    public void Show_Message(string varErrorMessage)
    {
        ClientScript.RegisterClientScriptBlock(this.GetType(), "alter", "javascript:alert('" + varErrorMessage + "');", true);
        //lblError.Text = varErrorMessage;
    }
    protected void btnActivate_Click(object sender, EventArgs e)
    {
        int id = Convert.ToInt32(((sender as LinkButton).Parent.Parent as GridViewRow).Cells[2].Text);

        SqlCommand My_Command = new SqlCommand();
        try
        {
            My_Command.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            if (My_Command.Connection.State == ConnectionState.Closed)
            {
                My_Command.Connection.Open();
            }
            My_Command.CommandText = "update creditcard set deactivate = 0 where cardid = " + id;
            My_Command.CommandType = CommandType.Text;
            My_Command.ExecuteNonQuery();

            Show_Message("Activated Sucessfully");

            grdListing.DataSource = getdata();
            grdListing.DataBind();
            grdListing.Rows[0].Visible = false;

            SqlDataAdapter da = new SqlDataAdapter();
            DataSet ds = new DataSet();

            try
            {
                da.SelectCommand = new SqlCommand();
                da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                da.SelectCommand.CommandText = "select * from [creditcard] where cardid = " + id;
                da.Fill(ds);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    SendEmail(ds.Tables[0].Rows[0]["Email"].ToString(), "Activate", "user activated. password is : " + ds.Tables[0].Rows[0]["Password"].ToString());
                }
            }
            catch
            {
            }
            
        }
        catch (SqlException ex)
        {
            
        }
    }
    protected void SendEmail(string varToEmailID, string varSubject, string varBodyText)
    {
        try
        {
            MailMessage mail = new MailMessage();
            var client = new SmtpClient(ConfigurationManager.AppSettings["SMTPServerName"].ToString(), Convert.ToInt32(ConfigurationManager.AppSettings["SMTPPort"]))
            {
                Credentials = new NetworkCredential(ConfigurationManager.AppSettings["UserName"].ToString(), ConfigurationManager.AppSettings["Password"].ToString()),
                EnableSsl = true,
            };
            mail.From = new MailAddress(ConfigurationManager.AppSettings["FromEmailID"].ToString());
            mail.IsBodyHtml = true;
            mail.To.Add(varToEmailID);
            mail.Subject = varSubject;
            mail.Body = varBodyText;
            client.Send(mail);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    protected void btnDeactivate_Click(object sender, EventArgs e)
    {
        int id = Convert.ToInt32(((sender as LinkButton).Parent.Parent as GridViewRow).Cells[2].Text);

        SqlCommand My_Command = new SqlCommand();
        try
        {
            My_Command.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            if (My_Command.Connection.State == ConnectionState.Closed)
            {
                My_Command.Connection.Open();
            }
            My_Command.CommandText = "update creditcard set deactivate = 1 where cardid = " + id;
            My_Command.CommandType = CommandType.Text;
            My_Command.ExecuteNonQuery();

            Show_Message("Deactivated Sucessfully");

            grdListing.DataSource = getdata();
            grdListing.DataBind();
            grdListing.Rows[0].Visible = false;
        }
        catch (SqlException ex)
        {

        }
    }
    protected void grdListing_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.Pager)
        {
            e.Row.Cells[2].Visible = false;
            if (e.Row.Cells[2].Text == "0")
            {
                e.Row.FindControl("btnActivate").Visible = false;
            }
        }
    }
    protected void grdListing_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
    {
        grdListing.PageIndex = e.NewPageIndex;
    }
    protected void grdListing_PageIndexChanged(object sender, System.EventArgs e)
    {
        grdListing.DataSource = getdata();
        grdListing.DataBind();
        grdListing.Rows[0].Visible = false;
    }
}
