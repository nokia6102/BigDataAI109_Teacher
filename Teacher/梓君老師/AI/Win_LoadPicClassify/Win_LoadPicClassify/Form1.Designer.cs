﻿namespace Win_LoadPicClassify
{
    partial class Form1
    {
        /// <summary>
        /// 設計工具所需的變數。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清除任何使用中的資源。
        /// </summary>
        /// <param name="disposing">如果應該處置 Managed 資源則為 true，否則為 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form 設計工具產生的程式碼

        /// <summary>
        /// 此為設計工具支援所需的方法 - 請勿使用程式碼編輯器修改
        /// 這個方法的內容。
        /// </summary>
        private void InitializeComponent()
        {
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.TestConnect_Btn = new System.Windows.Forms.Button();
            this.Pass_Text = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.UserName_Text = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.SQLValid_Radio = new System.Windows.Forms.RadioButton();
            this.WinValid_Radio = new System.Windows.Forms.RadioButton();
            this.DBName_Text = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.ServerName_Text = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.PicFolderPath_Label = new System.Windows.Forms.Label();
            this.FBD1 = new System.Windows.Forms.FolderBrowserDialog();
            this.PickFolder_Btn = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.ViewFileStatus_Btn = new System.Windows.Forms.Button();
            this.Upload_Btn = new System.Windows.Forms.Button();
            this.label6 = new System.Windows.Forms.Label();
            this.TableName_Text = new System.Windows.Forms.TextBox();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.TestConnect_Btn);
            this.groupBox1.Controls.Add(this.Pass_Text);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.UserName_Text);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.SQLValid_Radio);
            this.groupBox1.Controls.Add(this.WinValid_Radio);
            this.groupBox1.Controls.Add(this.DBName_Text);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.ServerName_Text);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Location = new System.Drawing.Point(12, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(382, 248);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "資料庫連接";
            // 
            // TestConnect_Btn
            // 
            this.TestConnect_Btn.Location = new System.Drawing.Point(278, 178);
            this.TestConnect_Btn.Name = "TestConnect_Btn";
            this.TestConnect_Btn.Size = new System.Drawing.Size(75, 23);
            this.TestConnect_Btn.TabIndex = 10;
            this.TestConnect_Btn.Text = "測試連接";
            this.TestConnect_Btn.UseVisualStyleBackColor = true;
            this.TestConnect_Btn.Click += new System.EventHandler(this.TestConnect_Btn_Click);
            // 
            // Pass_Text
            // 
            this.Pass_Text.Enabled = false;
            this.Pass_Text.Location = new System.Drawing.Point(109, 178);
            this.Pass_Text.Name = "Pass_Text";
            this.Pass_Text.Size = new System.Drawing.Size(132, 22);
            this.Pass_Text.TabIndex = 9;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(64, 183);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(41, 12);
            this.label4.TabIndex = 8;
            this.label4.Text = "密碼：";
            // 
            // UserName_Text
            // 
            this.UserName_Text.Enabled = false;
            this.UserName_Text.Location = new System.Drawing.Point(109, 150);
            this.UserName_Text.Name = "UserName_Text";
            this.UserName_Text.Size = new System.Drawing.Size(132, 22);
            this.UserName_Text.TabIndex = 7;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(64, 155);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(41, 12);
            this.label3.TabIndex = 6;
            this.label3.Text = "帳號：";
            // 
            // SQLValid_Radio
            // 
            this.SQLValid_Radio.AutoSize = true;
            this.SQLValid_Radio.Location = new System.Drawing.Point(35, 125);
            this.SQLValid_Radio.Name = "SQLValid_Radio";
            this.SQLValid_Radio.Size = new System.Drawing.Size(68, 16);
            this.SQLValid_Radio.TabIndex = 5;
            this.SQLValid_Radio.Text = "SQL驗證";
            this.SQLValid_Radio.UseVisualStyleBackColor = true;
            this.SQLValid_Radio.CheckedChanged += new System.EventHandler(this.SQLValid_Radio_CheckedChanged);
            // 
            // WinValid_Radio
            // 
            this.WinValid_Radio.AutoSize = true;
            this.WinValid_Radio.Checked = true;
            this.WinValid_Radio.Location = new System.Drawing.Point(35, 102);
            this.WinValid_Radio.Name = "WinValid_Radio";
            this.WinValid_Radio.Size = new System.Drawing.Size(91, 16);
            this.WinValid_Radio.TabIndex = 4;
            this.WinValid_Radio.TabStop = true;
            this.WinValid_Radio.Text = "Windows驗證";
            this.WinValid_Radio.UseVisualStyleBackColor = true;
            // 
            // DBName_Text
            // 
            this.DBName_Text.Location = new System.Drawing.Point(79, 53);
            this.DBName_Text.Name = "DBName_Text";
            this.DBName_Text.Size = new System.Drawing.Size(152, 22);
            this.DBName_Text.TabIndex = 3;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(20, 58);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(53, 12);
            this.label2.TabIndex = 2;
            this.label2.Text = "資料庫：";
            // 
            // ServerName_Text
            // 
            this.ServerName_Text.Location = new System.Drawing.Point(79, 25);
            this.ServerName_Text.Name = "ServerName_Text";
            this.ServerName_Text.Size = new System.Drawing.Size(152, 22);
            this.ServerName_Text.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(20, 31);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(53, 12);
            this.label1.TabIndex = 0;
            this.label1.Text = "伺服器：";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(574, 31);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(89, 12);
            this.label5.TabIndex = 1;
            this.label5.Text = "影像檔案位置：";
            // 
            // PicFolderPath_Label
            // 
            this.PicFolderPath_Label.AutoSize = true;
            this.PicFolderPath_Label.Location = new System.Drawing.Point(669, 31);
            this.PicFolderPath_Label.Name = "PicFolderPath_Label";
            this.PicFolderPath_Label.Size = new System.Drawing.Size(33, 12);
            this.PicFolderPath_Label.TabIndex = 2;
            this.PicFolderPath_Label.Text = "label6";
            // 
            // PickFolder_Btn
            // 
            this.PickFolder_Btn.Location = new System.Drawing.Point(417, 22);
            this.PickFolder_Btn.Name = "PickFolder_Btn";
            this.PickFolder_Btn.Size = new System.Drawing.Size(133, 36);
            this.PickFolder_Btn.TabIndex = 3;
            this.PickFolder_Btn.Text = "選擇影像檔案資料夾";
            this.PickFolder_Btn.UseVisualStyleBackColor = true;
            this.PickFolder_Btn.Click += new System.EventHandler(this.PickFolder_Btn_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(417, 70);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBox1.Size = new System.Drawing.Size(555, 190);
            this.textBox1.TabIndex = 4;
            // 
            // ViewFileStatus_Btn
            // 
            this.ViewFileStatus_Btn.Location = new System.Drawing.Point(839, 22);
            this.ViewFileStatus_Btn.Name = "ViewFileStatus_Btn";
            this.ViewFileStatus_Btn.Size = new System.Drawing.Size(133, 33);
            this.ViewFileStatus_Btn.TabIndex = 5;
            this.ViewFileStatus_Btn.Text = "檢視檔案";
            this.ViewFileStatus_Btn.UseVisualStyleBackColor = true;
            this.ViewFileStatus_Btn.Click += new System.EventHandler(this.ViewFileStatus_Btn_Click);
            // 
            // Upload_Btn
            // 
            this.Upload_Btn.Location = new System.Drawing.Point(839, 280);
            this.Upload_Btn.Name = "Upload_Btn";
            this.Upload_Btn.Size = new System.Drawing.Size(133, 41);
            this.Upload_Btn.TabIndex = 6;
            this.Upload_Btn.Text = "確定上傳";
            this.Upload_Btn.UseVisualStyleBackColor = true;
            this.Upload_Btn.Click += new System.EventHandler(this.Upload_Btn_Click);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(598, 294);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(65, 12);
            this.label6.TabIndex = 7;
            this.label6.Text = "資料表名：";
            // 
            // TableName_Text
            // 
            this.TableName_Text.Location = new System.Drawing.Point(669, 291);
            this.TableName_Text.Name = "TableName_Text";
            this.TableName_Text.Size = new System.Drawing.Size(145, 22);
            this.TableName_Text.TabIndex = 8;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1009, 357);
            this.Controls.Add(this.TableName_Text);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.Upload_Btn);
            this.Controls.Add(this.ViewFileStatus_Btn);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.PickFolder_Btn);
            this.Controls.Add(this.PicFolderPath_Label);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.groupBox1);
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "影像辨識  上傳影像";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TextBox Pass_Text;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox UserName_Text;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.RadioButton SQLValid_Radio;
        private System.Windows.Forms.RadioButton WinValid_Radio;
        private System.Windows.Forms.TextBox DBName_Text;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox ServerName_Text;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button TestConnect_Btn;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label PicFolderPath_Label;
        private System.Windows.Forms.FolderBrowserDialog FBD1;
        private System.Windows.Forms.Button PickFolder_Btn;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Button ViewFileStatus_Btn;
        private System.Windows.Forms.Button Upload_Btn;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox TableName_Text;
    }
}

