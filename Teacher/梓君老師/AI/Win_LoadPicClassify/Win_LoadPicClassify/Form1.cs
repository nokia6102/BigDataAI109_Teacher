using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using System.Windows.Forms;

namespace Win_LoadPicClassify
{
    public partial class Form1 : Form
    {
        SqlConnection cnn;
        
        public Form1()
        {
            InitializeComponent();

            PicFolderPath_Label.Text = "";
        }

        private void CreateSqlConnection() {

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
            this.CreateSqlConnection() ;

            try
            {
                cnn.Open();
                MessageBox.Show("連線成功！","成功", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show("連線出問題！", "失敗", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally {
                this.cnn.Close();
            }
        }

        private void PickFolder_Btn_Click(object sender, EventArgs e)
        {
            FBD1.RootFolder = Environment.SpecialFolder.MyComputer;
            FBD1.ShowNewFolderButton = false;
            if (FBD1.ShowDialog() == DialogResult.OK)
            {
                this.PicFolderPath_Label.Text = FBD1.SelectedPath;
            }
        }

        private void ViewFileStatus_Btn_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(PicFolderPath_Label.Text))
            {
                MessageBox.Show("請選擇影像圖片的資料夾！", "錯誤", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            DirectoryInfo di = null;            
            di = new DirectoryInfo(PicFolderPath_Label.Text);

            StringBuilder sb = new StringBuilder();
            foreach (FileInfo fi in di.GetFiles("*.*", SearchOption.AllDirectories))
            {
                if (fi.Extension == ".jpg" || fi.Extension == ".png")
                    sb.Append(fi.FullName).Append("\r\n");
            }

            textBox1.Text = sb.ToString();
        }

        private void Upload_Btn_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(TableName_Text.Text))
            {
                MessageBox.Show("請填寫欲上傳儲存的資料表名稱！", "錯誤", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            else if (string.IsNullOrEmpty(PicFolderPath_Label.Text))
            {
                MessageBox.Show("請選擇影像圖片的資料夾！", "錯誤", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            DialogResult ans = MessageBox.Show("此動作將會建立資料表，\n若該資料表已存在，則將會予以刪除！"
                , "注意", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (ans == DialogResult.No) return;
            

            this.CreateSqlConnection();            
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = this.cnn;

                //若該資料表已存在，刪除
                string sqltext = string.Format("IF (SELECT COUNT(*) FROM sys.tables WHERE [name]='{0}')>0 DROP TABLE {0};",TableName_Text.Text);                
                cmd.CommandText = sqltext;
                //MessageBox.Show(sqltext);
                cnn.Open();
                cmd.ExecuteNonQuery();
                cnn.Close();

                //建立資料表
                sqltext = string.Format("CREATE TABLE {0}( [Pic] NVARCHAR(128),[Type] NVARCHAR(128),[Label] INT);", TableName_Text.Text);
                cmd.CommandText = sqltext;
                cnn.Open();
                cmd.ExecuteNonQuery();
                cnn.Close();                
            }
                       

            //建立DataTable
            DataTable tt = new DataTable();
            tt.Columns.Add(new DataColumn("Pic", Type.GetType("System.String")));
            tt.Columns.Add(new DataColumn("Type", Type.GetType("System.String")));
            tt.Columns.Add(new DataColumn("Label", Type.GetType("System.Int32")));
            
            DirectoryInfo di = null;
            di = new DirectoryInfo(PicFolderPath_Label.Text);
                        
            foreach (FileInfo fi in di.GetFiles("*.*", SearchOption.AllDirectories))
            {
                if (fi.Extension.ToLower() == ".jpg" || fi.Extension.ToLower() == ".png"
                    || fi.Extension.ToLower() == ".jpeg" || fi.Extension.ToLower() == ".gif")
                {
                    int p2 = fi.FullName.LastIndexOf("\\");
                    int p1 = fi.FullName.LastIndexOf("\\",p2-1)+1;
                    string picType = fi.FullName.Substring(p1, p2 - p1);
                    string picPath = fi.FullName.Replace(@"\", @"\\");

                    DataRow rr = tt.NewRow();
                    rr[0] = picPath;
                    rr[1] = picType;
                    tt.Rows.Add(rr);
                }                
            }

            SqlBulkCopy sbc = new SqlBulkCopy(this.cnn);
            sbc.DestinationTableName = TableName_Text.Text;
            this.cnn.Open();
            sbc.WriteToServer(tt);
            sbc.Close();
            this.cnn.Close();

            MessageBox.Show("檔案已上傳成功！", "成功", MessageBoxButtons.OK, MessageBoxIcon.Information);

        }
    }
}
