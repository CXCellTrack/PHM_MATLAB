using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace 配置界面
{
    public partial class Form1 : Form
    {

        public string[] Dlines; // D矩阵richbox内容
        public string[] Clines; // CPD richbox内容

        public static string diagpath = Environment.GetEnvironmentVariable("diagpath");
        // d矩阵地址表
        public static string[] d_path = 
        {
            diagpath + @"\Water\data\udf\Dmatrix_Water_test.txt",
            diagpath + @"\Sewage\data\udf\Dmatrix_Sewage_test.txt",
            diagpath + @"\Rain\data\udf\Dmatrix_Rain_test.txt",
            diagpath + @"\Heat\data\udf\Dmatrix_Heat_test.txt",
            diagpath + @"\Gas\data\udf\Dmatrix_Gas_test.txt"
        };
        // cpd地址表
        public static string[] c_path = 
        {
            diagpath + @"\Water\data\udf\CPD_Water_test.txt",
            diagpath + @"\Sewage\data\udf\CPD_Sewage_test.txt",
            diagpath + @"\Rain\data\udf\CPD_Rain_test.txt",
            diagpath + @"\Heat\data\udf\CPD_Heat_test.txt",
            diagpath + @"\Gas\data\udf\CPD_Gas_test.txt"
        };

        public Form1()
        {
            InitializeComponent();
        }

        /// <summary>
        /// button1是编辑按键，按下后将对应管子d矩阵中的内容显示在richtextbox上
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button1_Click(object sender, EventArgs e)
        {

            string dmatrix_path = getPath(true);
            string cpd_path = getPath(false);

            if (dmatrix_path!= null)
            {
                // 打开d矩阵txt并显示到richtextbox1上
                if (!File.Exists(dmatrix_path))
                {
                    MessageBox.Show("找不到管线地址: " + dmatrix_path,
                        "文件不存在", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                Dlines = File.ReadAllLines(dmatrix_path, Encoding.Default);
                richTextBox1.Lines = Dlines;
                int nd = getrealLines(Dlines);
                MessageBox.Show(Convert.ToString(nd));

                // 打开cpdtxt并显示到richtextbox2上
                if (!File.Exists(cpd_path))
                {
                    MessageBox.Show("找不到管线地址: " + cpd_path,
                        "文件不存在", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                Clines = File.ReadAllLines(cpd_path, Encoding.Default);
                richTextBox2.Lines = Clines;
                int nc = getrealLines(Clines);
                MessageBox.Show(Convert.ToString(nc));
                // 一种全体读写的方法
                //byte[] cpd = File.ReadAllBytes(cpd_path);
                //richTextBox2.Text = Encoding.Default.GetString(cpd);
            }

        }


        /// <summary>
        /// 保存D矩阵txt
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button2_Click(object sender, EventArgs e)
        {
            string dmatrix_path = getPath(true);
            if (dmatrix_path == null)
                return;
            string dmatrix_backup_path = dmatrix_path.Replace(".", "_old.");

            // 弹框确认是否保存
            DialogResult dr = MessageBox.Show("确认修改并保存?", "保存文件", 
                MessageBoxButtons.OKCancel, MessageBoxIcon.Question);

            if (dr == DialogResult.OK)
            {
                // 将原d矩阵备份
                File.Copy(dmatrix_path, dmatrix_backup_path, true);
                richTextBox1.SaveFile(dmatrix_path, RichTextBoxStreamType.PlainText);
                MessageBox.Show("新D矩阵已保存，原D矩阵备份在\n" + dmatrix_backup_path, "信息",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            
        }

        /// <summary>
        /// 保存CPD文件txt
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button3_Click(object sender, EventArgs e)
        {
            string cpd_path = getPath(false);
            if (cpd_path == null)
                return;
            string cpd_backup_path = cpd_path.Replace(".", "_old.");

            // 弹框确认是否保存
            DialogResult dr = MessageBox.Show("确认修改并保存?", "保存文件",
                MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
            if (dr == DialogResult.OK)
            {
                // 将原d矩阵备份
                File.Copy(cpd_path, cpd_backup_path, true);
                richTextBox2.SaveFile(cpd_path, RichTextBoxStreamType.PlainText);
                MessageBox.Show("新CPD表已保存，原CPD表备份在\n" + cpd_backup_path, "信息",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }



        // 返回不同管线D矩阵路径
        private string getPath( bool useDmatrix )
        {
            string[] thispath = null;
            if (useDmatrix)
                thispath = d_path;
            else
                thispath = c_path;

            string dmatrix_path = null;
            switch (comboBox1.Text)
            {
                case "给水管线":
                    dmatrix_path = thispath[0];
                    break;
                case "污水管线":
                    dmatrix_path = thispath[1];
                    break;
                default:
                    //MessageBox.Show("请先选择一种管线！");
                    break;
            }
            return dmatrix_path;
        }


        /// <summary>
        /// 清空输入表格
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button5_Click(object sender, EventArgs e)
        {
            textBox1.Text = null;
            textBox2.Text = null;
            textBox3.Text = null;
            textBox4.Text = null;
            textBox5.Text = null;
            textBox6.Text = null;
        }

        /// <summary>
        /// 确认添加一条记录进入D矩阵txt中
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button4_Click(object sender, EventArgs e)
        {
            string[] tb = new string[6];
            string record = null;
            int n = 0;
            tb[0] = textBox1.Text;
            tb[1] = textBox2.Text;
            tb[2] = textBox3.Text;
            tb[3] = textBox4.Text;
            tb[4] = textBox5.Text;
            tb[5] = textBox6.Text;
            for(n=0;n<tb.Length;n++)
                if(tb[n]=="")
                    break;
            if (n <= 1)
                MessageBox.Show("至少需要一个传感器和一个管线!", "错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
            else
            {
                record = textBox1.Text + "\t\t";
                for (int ii = 1; ii < n; ii++)
                    record += (": " + tb[ii]);

                if(Dlines==null)
                    Dlines = new string[2]; // 为null时无法引用
                else
                    Array.Resize(ref Dlines, Dlines.Length+2);

                Dlines[Dlines.Length-2] = "";
                Dlines[Dlines.Length-1] = record;
                
                richTextBox1.Lines = Dlines;
                MessageBox.Show("添加成功!");
            }



        }

        /// <summary>
        /// 撤销上一次添加的记录
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button6_Click(object sender, EventArgs e)
        {
            if (Dlines == null)
                return;
            Array.Resize(ref Dlines, Dlines.Length-2);
            richTextBox1.Lines = Dlines;
            MessageBox.Show("撤销成功!");
        }

        private int getrealLines(string[] Lines)
        {
            int nl = 0;
            for (int h = 0; h < Lines.Length; h++)
            {
                if (Lines[h].StartsWith("#") || Lines[h].Trim() == "")
                    continue;
                nl += 1;
            }
            return nl;
        }

    }
}
