using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Web.UI;

public partial class Shopping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //if (Session["LoginUserID"] == null)
        //{
        //    Response.Redirect("Session_Expired.aspx");
        //}
        lblMsg.Text = "";
        if (!Page.IsPostBack)
        {
            Session["ShoppingLoginCount"] = 0;
            grdDetail.DataSource = Create_EmptyDataSet();
            grdDetail.DataBind();
            grdDetail.Rows[0].Visible = false;
            fill_combo();
        }
    }
    protected void fill_combo()
    {
        SqlCommand SQL_MyCommand = new SqlCommand();
        SQL_MyCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlDataReader SQL_MyDataReader;
        SQL_MyCommand.CommandText = "usp_list_Product";
        SQL_MyCommand.CommandType = CommandType.StoredProcedure;
        SQL_MyCommand.Parameters.AddWithValue("@DisplayAll", false);
        SQL_MyCommand.Parameters.AddWithValue("@DisplayBlank", true);
        if (SQL_MyCommand.Connection.State == ConnectionState.Closed)
        {
            SQL_MyCommand.Connection.Open();
        }
        SQL_MyDataReader = SQL_MyCommand.ExecuteReader();
        ddlProduct.DataSource = SQL_MyDataReader;
        ddlProduct.DataValueField = "ProductID";
        ddlProduct.DataTextField = "ProductName";
        ddlProduct.DataBind();
    }
    private DataSet Create_EmptyDataSet()
    {
        DataSet ds = new DataSet();
        DataTable dt = new DataTable();

        DataColumn dc = new DataColumn();
        dc.ColumnName = "Product";
        dc.DataType = Type.GetType("System.String");
        dt.Columns.Add(dc);
        
        DataColumn dc1 = new DataColumn();
        dc1.ColumnName = "Quantity";
        dc1.DataType = Type.GetType("System.Decimal");
        dt.Columns.Add(dc1);

        DataColumn dc2 = new DataColumn();
        dc2.ColumnName = "Rate";
        dc2.DataType = Type.GetType("System.Decimal");
        dt.Columns.Add(dc2);

        DataColumn dc3 = new DataColumn();
        dc3.ColumnName = "Amount";
        dc3.DataType = Type.GetType("System.Decimal");
        dt.Columns.Add(dc3);

        DataColumn dc4 = new DataColumn();
        dc4.ColumnName = "Remark";
        dc4.DataType = Type.GetType("System.String");
        dt.Columns.Add(dc4);
        
        ds.Tables.Add(dt);
        DataRow dr;
        dr = ds.Tables[0].NewRow();
        dr["Product"] = "";
        dr["Quantity"] = 0;
        dr["Rate"] = 0;
        dr["Amount"] = 0;
        dr["Remark"] = "";

        ds.Tables[0].Rows.Add(dr);
        ds.AcceptChanges();

        Session["ProductList"] = ds;
        return ds;

    }
    public void Show_Message(string varErrorMessage)
    {
        //ClientScript.RegisterClientScriptBlock(this.GetType(), "alter", "javascript:alert('" + varErrorMessage + "');", true);
        lblMsg.Text = varErrorMessage;
    }
    private bool saving_validation()
    {
        if (ddlProduct.SelectedValue == "0")
        {
            Show_Message("Please select product");
            ddlProduct.Focus();
            return false;
        }
        else if (txtQuantity.Text == "")
        {
            Show_Message("Please select product");
            txtQuantity.Focus();
            return false;
        }
        return true;
    }
    protected double getproductrate(int varProductid)
    {
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        try
        {
            da.SelectCommand = new SqlCommand();
            da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            da.SelectCommand.CommandText = "select * from [product] where productid = " + ddlProduct.SelectedValue.Trim();
            da.Fill(ds);
            if (ds.Tables[0].Rows.Count == 0)
            {
                return 0;
            }
            else
            {
                return Convert.ToDouble(ds.Tables[0].Rows[0]["rate"]);
            }
        }
        catch
        {
            return 0;
        }
    }
    protected void btnAddList_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (saving_validation() == false)
            {
                return;
            }
            DataRow dr;
            DataSet ds = (Session["ProductList"] as DataSet);

            dr = ds.Tables[0].NewRow();
            dr["Product"] = ddlProduct.SelectedValue;
            dr["Quantity"] = Convert.ToDouble(txtQuantity.Text);
            dr["Rate"] = Convert.ToDouble(lblRate.Text);
            dr["Amount"] = (Convert.ToDouble(lblRate.Text) * Convert.ToDouble(txtQuantity.Text));
            dr["Remark"] = txtRemark.Text;

            ds.Tables[0].Rows.Add(dr);
            ds.AcceptChanges();

            Session["ProductList"] = ds;
            grdDetail.DataSource = ds;
            grdDetail.DataBind();
            grdDetail.Rows[0].Visible = false;

            ddlProduct.SelectedValue = "0";
            lblRate.Text = "";
            txtQuantity.Text = "";
            txtRemark.Text = "";
        }
        catch(Exception ex)
        {
            Show_Message("Error Found");
        }
    }
    protected void ddlProduct_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblRate.Text = getproductrate(Convert.ToInt32(ddlProduct.SelectedValue)).ToString();
    }
    protected double gettotalamount()
    {
        double totalamount = 0;
        DataSet ds = (Session["ProductList"] as DataSet);
        for (int i = 1; i <= (ds.Tables[0].Rows.Count - 1); i++)
        {
            totalamount += Convert.ToDouble(ds.Tables[0].Rows[i]["amount"]);
        }
        return totalamount;
    }
    protected double getlasttransactionamount(bool ToleranceLimit)
    {
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        try
        {
            da.SelectCommand = new SqlCommand();
            da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            da.SelectCommand.CommandText = "getavaragetransactionamount";
            da.SelectCommand.CommandType = CommandType.StoredProcedure;
            da.SelectCommand.Parameters.AddWithValue("@cardid", Session["LoginUserID"]);
            da.Fill(ds);
            if (ds.Tables[0].Rows.Count == 0)
            {
                return 0;
            }
            else
            {
                if (ToleranceLimit)
                {
                    double val = Convert.ToDouble(ds.Tables[0].Rows[0]["maxtotalamount"]);
                    return Convert.ToDouble(ds.Tables[0].Rows[0]["maxtotalamount"]);
                }
                else
                {
                    double val = Convert.ToDouble(ds.Tables[0].Rows[0]["maxtotalamount"]);
                    return Convert.ToDouble(ds.Tables[0].Rows[0]["mintotalamount"]);
                }
            }
        }
        catch
        {
            return 0;
        }
    }
    protected double getmaxid()
    {
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        try
        {
            da.SelectCommand = new SqlCommand();
            da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            da.SelectCommand.CommandText = "select MAX(id) +1 as [id]  from sale";
            da.SelectCommand.CommandType = CommandType.Text;
            da.Fill(ds);
            if (ds.Tables[0].Rows.Count == 0)
            {
                return 0;
            }
            else
            {
                return Convert.ToDouble(ds.Tables[0].Rows[0]["id"]);
            }
        }
        catch
        {
            return 0;
        }
    }
    protected double getcreditlimit()
    {
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        try
        {
            da.SelectCommand = new SqlCommand();
            da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            da.SelectCommand.CommandText = "select creditlimit  from creditcard where cardid = " + Session["LoginUserID"];
            da.SelectCommand.CommandType = CommandType.Text;
            da.Fill(ds);
            if (ds.Tables[0].Rows.Count == 0)
            {
                return 0;
            }
            else
            {
                return Convert.ToDouble(ds.Tables[0].Rows[0]["creditlimit"]);
            }
        }
        catch
        {
            return 0;
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        grdDetail.DataSource = Create_EmptyDataSet();
        grdDetail.DataBind();
        grdDetail.Rows[0].Visible = false;
        txtOneTimePassword.Visible = false;
        lblOneTimePassword.Visible = false;
        lblSecurityQuestion.Text = "";
        txtSecurityAnswer.Text = "";  
        txtSecurityAnswer.Visible = false;

        txtCVVNo.Text = "";
        txtCreditCardNumber.Text = "";
        txtPassword.Text = "";
        mpePop.Enabled = false;
        pnlCreditCardInformation.Visible = false;
        mpePop.Hide();
    }
    protected void btnSavePopUp_Click(object sender, EventArgs e)
    {
        string varonetimepassword = "";
        string varEmailid = "";

        //Check For Valid Credit Card
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet ds = new DataSet();

        da.SelectCommand = new SqlCommand();
        da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        da.SelectCommand.CommandText = "select * from [creditcard] where cardnumber = '" + txtCreditCardNumber.Text.Trim() + "'";
        da.Fill(ds);
        if (ds.Tables[0].Rows.Count == 0)
        {
            Show_Message("Credit Card Number Is Not Valid.");
            txtCreditCardNumber.Focus();
            mpePop.Enabled = true;
            pnlCreditCardInformation.Visible = true;
            mpePop.Show();
            return;
        }
        else
        {
            if (Convert.ToInt32(Session["ShoppingLoginCount"]) >= 3)
            {
                SqlCommand My_Command = new SqlCommand();
                My_Command.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                if (My_Command.Connection.State == ConnectionState.Closed)
                {
                    My_Command.Connection.Open();
                }
                My_Command.CommandText = "update creditcard set deactivate = 1 where cardnumber = '" + txtCreditCardNumber.Text.Trim() + "'";
                My_Command.CommandType = CommandType.Text;
                My_Command.ExecuteNonQuery();

                Save_Data("Blocked");
                btnCancel_Click(sender, e);
                Show_Message("Your Account has been Deactivated, Please Contact Administrator");
                return;
            }
            if (ds.Tables[0].Rows[0]["cvvno"].ToString() != txtCVVNo.Text.Trim())
            {
                Show_Message("CVV No. Is Not Valid");
                txtCVVNo.Focus();
                mpePop.Enabled = true;
                pnlCreditCardInformation.Visible = true;
                mpePop.Show();
                Session["ShoppingLoginCount"] = Convert.ToInt32(Session["ShoppingLoginCount"]) + 1;
                return;
            }
            else if (ds.Tables[0].Rows[0]["password"].ToString() != txtPassword.Text.Trim())
            {
                Show_Message("Password is incorrect.");
                txtPassword.Focus();
                mpePop.Enabled = true;
                pnlCreditCardInformation.Visible = true;
                mpePop.Show();
                Session["ShoppingLoginCount"] = Convert.ToInt32(Session["ShoppingLoginCount"]) + 1;
                return;
            }
            Session["LoginUserID"] = ds.Tables[0].Rows[0]["cardid"].ToString();
            Session["Expirymonth"] = ds.Tables[0].Rows[0]["expirymonth"].ToString();
            Session["Expiryyear"] = ds.Tables[0].Rows[0]["expiryyear"].ToString();
            Session["Emailid"]  = ds.Tables[0].Rows[0]["email"].ToString();
            //Check For Valid Credit Card
        }

        if (DateTime.Now.Date.Year > Convert.ToInt32(Session["expiryyear"]))
        {
            Show_Message("Your Credit Card has expired.");
            mpePop.Enabled = true;
            pnlCreditCardInformation.Visible = true;
            mpePop.Show();
            return;
        }
        if ((DateTime.Now.Date.Year == Convert.ToInt32(Session["expiryyear"])) && (DateTime.Now.Date.Month > Convert.ToInt32(Session["Expirymonth"])))
        {
            Show_Message("Your Credit Card has expired.");
            mpePop.Enabled = true;
            pnlCreditCardInformation.Visible = true;
            mpePop.Show();
            return;
        }
        if (getcreditlimit() < gettotalamount())
        {
            Show_Message("You have Exceeded your Credit limit.");
            Save_Data("Fail");
            btnCancel_Click(sender, e);
            return;
        }
        if (getlasttransactionamount(true) != 0)
        {
            if (txtOneTimePassword.Visible == false)
            {
                if ((gettotalamount() > getlasttransactionamount(true)) || (gettotalamount() < getlasttransactionamount(false)))
                {
                    da = new SqlDataAdapter();
                    ds = new DataSet();

                    try
                    {
                        da.SelectCommand = new SqlCommand();
                        da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                        da.SelectCommand.CommandText = "generaterandomnumber";
                        da.SelectCommand.CommandType = CommandType.StoredProcedure;
                        da.SelectCommand.Parameters.AddWithValue("@cardid", Session["LoginUserID"]);
                        da.Fill(ds);
                        if (ds.Tables[0].Rows.Count == 0)
                        {
                            varonetimepassword = "";
                            varEmailid = "";
                        }
                        else
                        {
                            varonetimepassword = ds.Tables[0].Rows[0]["password"].ToString();
                            varEmailid = ds.Tables[0].Rows[0]["email"].ToString();
                            lblSecurityQuestion.Text = ds.Tables[0].Rows[0]["description"].ToString();
                            ViewState["Answer"] = ds.Tables[0].Rows[0]["answer"].ToString();
                            txtSecurityAnswer.Visible = true;
                            txtOneTimePassword.Visible = true;
                            lblOneTimePassword.Visible = true;
                            SendEmail(varEmailid, "One time password", "password : " + varonetimepassword);
                            Show_Message("Sorry!! There are some issues in your transactions, Please enter the one time password which is sent to your email address");
                            mpePop.Enabled = true;
                            pnlCreditCardInformation.Visible = true;
                            mpePop.Show();
                            return;
                        }
                    }
                    catch (Exception ex)
                    {
                        return;
                    }
                    return;
                }
            }
            else
            {
                if (txtOneTimePassword.Text == "")
                {
                    Show_Message("please provide one time password");
                    txtOneTimePassword.Focus();
                    mpePop.Enabled = true;
                    pnlCreditCardInformation.Visible = true;
                    mpePop.Show();
                    return;
                }
                if (txtSecurityAnswer.Text != ViewState["Answer"].ToString())
                {
                    Show_Message("Security answer is wrong");
                    txtSecurityAnswer.Focus();
                    Session["ShoppingLoginCount"] = Convert.ToInt32(Session["ShoppingLoginCount"]) + 1;
                    mpePop.Enabled = true;
                    pnlCreditCardInformation.Visible = true;
                    mpePop.Show();
                    return;
                }
                da = new SqlDataAdapter();
                ds = new DataSet();

                try
                {
                    da.SelectCommand = new SqlCommand();
                    da.SelectCommand.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                    da.SelectCommand.CommandText = "select 1 from onetimepassword where cardid = " + Session["LoginUserID"] + " and password = '" + txtOneTimePassword.Text.Trim() + "'";
                    da.SelectCommand.CommandType = CommandType.Text;
                    da.SelectCommand.Parameters.AddWithValue("@cardid", Session["LoginUserID"]);
                    da.Fill(ds);
                    if (ds.Tables[0].Rows.Count == 0)
                    {
                        Show_Message("Invalid one time password");
                        txtOneTimePassword.Text = "";
                        Session["ShoppingLoginCount"] = Convert.ToInt32(Session["ShoppingLoginCount"]) + 1;
                        mpePop.Enabled = true;
                        pnlCreditCardInformation.Visible = true;
                        mpePop.Show();
                        return;
                    }
                }
                catch
                {
                    return;
                }
                txtOneTimePassword.Visible = false;
                lblOneTimePassword.Visible = false;
                txtSecurityAnswer.Visible = false;
                lblSecurityQuestion.Text = "";
            }
        }

        Save_Data("Sucess");
        Show_Message("Your Transaction is Sucessful");
        SendEmail(Session["Emailid"].ToString(), "Transaction Sucess", "Your Transaction is Sucessful. Total amount of your transaction is: " + gettotalamount());
        btnCancel_Click(sender, e);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        DataSet ds_pro = (Session["ProductList"] as DataSet);
        if (ds_pro.Tables[0].Rows.Count > 1)
        {
            mpePop.Enabled = true;
            pnlCreditCardInformation.Visible = true;
            mpePop.Show();
        }
        else
        {
            Show_Message("Please select product");
            return;
        }
    }
    protected void Save_Data(string varStatus)
    {
        double id = getmaxid();
        DataSet ds_pro = (Session["ProductList"] as DataSet);
        SqlTransaction objTrans;
        SqlCommand cm = new SqlCommand();
        cm.Connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        if (cm.Connection.State == ConnectionState.Closed)
        {
            cm.Connection.Open();
        }
        objTrans = cm.Connection.BeginTransaction();
        cm.Transaction = objTrans;

        for (int i = 1; i < (ds_pro.Tables[0].Rows.Count); i++)
        {
            string strSQL;
            strSQL = "insert into sale (cardid, productid, quantity, rate, amount, remark, id, status) values ('" +
                     Session["LoginUserID"] + "','" + ds_pro.Tables[0].Rows[i]["product"] + "','" + ds_pro.Tables[0].Rows[i]["quantity"] + "','" +
                    ds_pro.Tables[0].Rows[i]["rate"] + "','" + ds_pro.Tables[0].Rows[i]["amount"] + "','" + ds_pro.Tables[0].Rows[i]["remark"] + "'," + id + ",'" + varStatus + "')";

            cm.CommandText = strSQL;
            cm.CommandType = CommandType.Text;
            try
            {
                cm.ExecuteNonQuery();
            }
            catch
            {
                cm.Transaction.Rollback();
                return;
            }
        }
        cm.Transaction.Commit();
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
    protected void btnLogOut_Click(object sender, EventArgs e)
    {
        Response.Redirect("CustomerLogin.aspx");
    }

    protected void grdDetail_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}
