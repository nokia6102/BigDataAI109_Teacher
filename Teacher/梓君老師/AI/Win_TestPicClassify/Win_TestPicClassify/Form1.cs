using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win_TestPicClassify
{
    public partial class Form1 : Form
    {
        SqlConnection cnn;


        public Form1()
        {
            InitializeComponent();

            PickPicPath_Label.Text = "";
            Result_Label.Text = "";
            Probability_Label.Text = "";
        }

        private void CreateSqlConnection()
        {

            SqlConnectionStringBuilder scsb = new SqlConnectionStringBuilder();
            scsb.DataSource = ServerName_Text.Text;
            scsb.InitialCatalog = DBName_Text.Text;

            if (this.WinValid_Radio.Checked)
            {
                scsb.IntegratedSecurity = true;
            }
            else
            {
                scsb.IntegratedSecurity = false;
                scsb.UserID = UserName_Text.Text;
                scsb.Password = Pass_Text.Text;
            }

            this.cnn = null;
            this.cnn = new SqlConnection();
            this.cnn.ConnectionString = scsb.ConnectionString;

        }

        private void PickPic_Btn_Click(object sender, EventArgs e)
        {
            OFD.InitialDirectory = Environment.SpecialFolder.MyComputer.ToString();
            OFD.Title = "請選擇圖片";
            OFD.Filter = "JPEG(*.jpg)|*.jpg|PNG(*.png)|*.png";
            OFD.Multiselect = false;

            if (OFD.ShowDialog() == DialogResult.OK)
            {
                this.PickPicPath_Label.Text = OFD.FileName;
                PB1.Image=Image.FromFile(OFD.FileName);
            }
        }

        private void SQLValid_Radio_CheckedChanged(object sender, EventArgs e)
        {
            if (SQLValid_Radio.Checked)
            {
                UserName_Text.Enabled = true;
                Pass_Text.Enabled = true;
            }
            else
            {
                UserName_Text.Enabled = false;
                Pass_Text.Enabled = false;
            }
        }

        private void TestConnect_Btn_Click(object sender, EventArgs e)
        {
            this.CreateSqlConnection();

            try
            {
                cnn.Open();
                MessageBox.Show("連線成功！", "成功", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show("連線出問題！", "失敗", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                this.cnn.Close();
            }
        }

        private void RunClassify_Btn_Click(object sender, EventArgs e)
        {            
            if (string.IsNullOrEmpty(PickPicPath_Label.Text))
            {
                MessageBox.Show("請選擇愈辨識的影像圖片！", "錯誤", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            if (string.IsNullOrEmpty(StoredProcedure_Text.Text))
            {
                MessageBox.Show("請輸入欲呼叫的預存程序！", "錯誤", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }


            Result_Label.Text = "";
            Probability_Label.Text = "";

            try
            {
                this.CreateSqlConnection();
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = this.cnn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = StoredProcedure_Text.Text;
                    cmd.Parameters.Add("@PathInfo", SqlDbType.NVarChar);
                    cmd.Parameters["@PathInfo"].Value = PickPicPath_Label.Text;

                    DataTable tt = null;
                    cnn.Open();
                    SqlDataReader rr = cmd.ExecuteReader();
                    if (rr.HasRows)
                    {
                        tt = new DataTable();
                        tt.Load(rr);
                    }
                    rr.Close();
                    cmd.Dispose();

                    if (tt != null)
                    {
                        Result_Label.Text = tt.Rows[0][0].ToString();

                        List<double> pp = new List<double>();
                        for (int i = 2; i < tt.Columns.Count; i++)
                            pp.Add(Convert.ToDouble(tt.Rows[0][i]));
                                                pp.Sort();

                        Probability_Label.Text = pp[pp.Count - 1].ToString("#0.0000");
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            finally
            {
                cnn.Close();
            }

        }
    }
}
