using System;
using System.Net;
using System.Net.Mail;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class CreditCardDetails : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginUserID"] == null)
        {
            Response.Redirect("Session_Expired.aspx");
        }
        lblError.Text = "";
        if (!(Page.IsPostBack))
        {
            set_security_question();
        }
    }
    private void set_security_question()
    {
         SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        da.SelectCommand = new SqlCommand();
        da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        da.SelectCommand.CommandText = "select * from [securityquestion]";
        da.Fill(ds);
        if (ds.Tables[0].Rows.Count > 0)
        {
            lblSecQue1.Text = ds.Tables[0].Rows[0]["Description"].ToString();
            lblSecQue2.Text = ds.Tables[0].Rows[1]["Description"].ToString();
            lblSecQue3.Text = ds.Tables[0].Rows[2]["Description"].ToString();
            lblSecQue4.Text = ds.Tables[0].Rows[3]["Description"].ToString();
            lblSecQue5.Text = ds.Tables[0].Rows[4]["Description"].ToString();
        }
    }
    public void Show_Message(string varErrorMessage)
    {
        //ClientScript.RegisterClientScriptBlock(this.GetType(), "alter", "javascript:alert('" + varErrorMessage + "');", true);
        lblError.Text = varErrorMessage;
    }
    private bool Saving_Validation()
    {
        if (checkusernameavailability() == false)
        {
            Show_Message("User name not available");
            return false;
        }
        else if (checkcreditcardavailability() == true)
        {
            Show_Message("Card number already exists");
            return false;
        }
        return true;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        SqlTransaction objTrans;
        SqlCommand cm = new SqlCommand();
        try
        {
            if (Saving_Validation() == false)
            {
                return;
            }
            
            string strSQL;
            strSQL = "insert into creditcard (CardNumber, FirstName, " +
                        "LastName, DesiredLoginName, Password, Email, Gender, PhoneNo, dateofbirth, " + 
                        "AddressLine1, AddressLine2, City, state, country, pin, accountnumber, bankname, CreditLimit, Deactivate, cvvno, expirymonth, expiryyear, secque1, secque2, secque3, secque4, secque5, secans1, secans2, secans3, secans4, secans5) values ('" +
                    txtCardNumber.Text.Trim() + "','" + txtFirstName.Text.Trim() + "','" + txtLastName.Text.Trim() + "','" +
                    txtLoginName.Text.Trim() + "','" + txtPass.Text.Trim() + "','" + txtEmail.Text.Trim() + "','" +
                    ddlGender.SelectedItem.Text + "','" + txtPhone.Text.Trim() + "','" +
                    txtDate.Text.Trim() + "','" + txtAdd1.Text.Trim() + "','" + txtAdd2.Text.Trim() + "','" +
                    txtCity.Text.Trim() + "','" + txtState.Text.Trim() + "','" + txtCountry.Text.Trim() + "','" +
                    txtPin.Text.Trim() + "','" + txtAccountNumber.Text.Trim() + "','" + txtBankName.Text.Trim() + "','" +
                    txtCreditLimit.Text + "',0,'" + txtCVVNo.Text + "','" + ddlMonth.SelectedValue + "','" + ddlYear.SelectedValue + "',1,2,3,4,5,'" + txtSecAns1.Text + "','" + txtSecAns2.Text + "','" + txtSecAns3.Text + "','" + txtSecAns4.Text + "','" + txtSecAns5.Text + "')";

            cm.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            if (cm.Connection.State == ConnectionState.Closed)
            {
                cm.Connection.Open();
            }
            objTrans = cm.Connection.BeginTransaction(); 
            cm.CommandText = strSQL;
            cm.Transaction = objTrans;
            cm.CommandType = CommandType.Text;
            cm.ExecuteNonQuery();
            String mailmsg = "Registration Successful. Credit Card no: " + txtCardNumber.Text.Trim() + "  CVV no: " + txtCVVNo.Text.Trim() + "  Username: " + txtLoginName.Text.Trim() + " Password: " + txtPass.Text.Trim();
            SendEmail(txtEmail.Text.Trim(), "User Registration", mailmsg);
            
            cm.Transaction.Commit();
            Show_Message("You have been Successfully Registered.");
            Page_Clear_Screen();
        }
        catch (Exception ex)
        {
            Show_Message("Saving Fail.");
            cm.Transaction.Rollback();
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
        catch(Exception ex)
        {
            throw ex;
        }
    }
    protected void Page_Clear_Screen()
    {
        txtCardNumber.Text = "";
        txtFirstName.Text = "";
        txtLastName.Text = "";
        txtLoginName.Text = "";
        txtPass.Text = "";
        txtEmail.Text = "";
        txtPhone.Text = "";
        txtDate.Text = "";
        txtAdd1.Text = "";
        txtAdd2.Text = "";
        txtCity.Text = "";
        txtState.Text = "";
        txtCountry.Text = "";
        txtPin.Text = "";
        txtAccountNumber.Text = "";
        txtBankName.Text = "";
        txtCreditLimit.Text = "";
        txtCVVNo.Text = "";
        txtSecAns1.Text = "";
        txtSecAns2.Text = "";
        txtSecAns3.Text = "";
        txtSecAns4.Text = "";
        txtSecAns5.Text = "";
    }
    protected void btnCancel_Click(object sender, System.EventArgs e)
    {
        Page_Clear_Screen();
    }

    protected bool checkusernameavailability()
    {
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        da.SelectCommand = new SqlCommand();
        da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        da.SelectCommand.CommandText = "select 1 from [creditcard] where desiredloginname = '" + txtLoginName.Text.Trim() + "'";
        da.Fill(ds);
        if (ds.Tables[0].Rows.Count == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }


    protected bool checkcreditcardavailability()
    {
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        da.SelectCommand = new SqlCommand();
        da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        da.SelectCommand.CommandText = "select 1 from [creditcard] where cardnumber = '" + txtCardNumber.Text.Trim() + "'";
        da.Fill(ds);
        if (ds.Tables[0].Rows.Count == 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    
    
    protected void btnAvail_Click(object sender, EventArgs e)
    {
        if (checkusernameavailability())
        {
            lblAvail.Text = "Available";
        }
        else
        {
            lblAvail.Text = "Not Available";
        }
    }
}
