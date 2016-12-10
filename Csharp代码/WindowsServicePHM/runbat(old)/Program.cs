using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.IO;

namespace runbat
{
    /// <summary>
    /// 已经放弃使用（2016.12.8改为在matlab中处理）
    /// </summary>
    class Program
    {

        static string home = Environment.GetEnvironmentVariable("phm_home");
        static string diag = Environment.GetEnvironmentVariable("diagpath");
        static string predict = Environment.GetEnvironmentVariable("predictpath");

        /// <summary>
        /// 使用c#封装一下bat，主要为了不显示黑框
        /// </summary>
        /// <param name="args"></param>
        static void Main(string[] args)
        {
            string DBinfo_path = home + @"\DBinfo.ini";
            string sql_path;
            string exename;
            if (args[0] == "diag"){
                sql_path = diag + @"\SQL\sqls_to_run.sql";
                exename = diag + @"\diag_post.bat";
            }else if (args[0] == "predict"){
                sql_path = predict + @"\SQL\sqls_to_run.sql";
                exename = predict + @"\predict_post.bat";
            }else
                return;

            // 读入数据库信息
            string[] DBinfo = readDBinfo( DBinfo_path );
            // 生成diag/predict _post.bat，其执行sqlnames脚本
            create_diag_or_predict_post(exename, sql_path, DBinfo);

            // 执行diag/predict _post.bat
            if (File.Exists(exename))
            {
                Process p = new Process();
                p.StartInfo.FileName = exename;
                p.StartInfo.CreateNoWindow = true;
                p.StartInfo.UseShellExecute = false;
                p.Start();
            }
        }


        /// <summary>
        /// 函数1、读入数据库的配置信息
        /// </summary>
        /// <returns></returns>
        static string[] readDBinfo(string DBinfo_path)
        {
            string[] lines = File.ReadAllLines(DBinfo_path, Encoding.Default);
            string [] DBinfo = new string[3];

            foreach (string line in lines)
            {
                if (line.Contains("service_name_oracle"))
                    DBinfo[2] = line.Split('=')[1].Trim();
                else if (line.Contains("username_oracle"))
                    DBinfo[0] = line.Split('=')[1].Trim();
                else if (line.Contains("password_oracle "))
                    DBinfo[1] = line.Split('=')[1].Trim();
            }
            return DBinfo;
        }


        /// <summary>
        /// 函数2、创建diag_post.bat，并动态写入执行sqlnames.sql的语句
        /// </summary>
        /// <param name="sql_path"></param>
        /// <param name="DBinfo"></param>
        static void create_diag_or_predict_post(string exename, string sql_path, string[] DBinfo)
        {
            //在diag_post.bat末尾添加上执行语句
            StreamWriter writer = new StreamWriter(exename);
            writer.WriteLine("sqlplus " + DBinfo[0] + "/" + DBinfo[1] + "@" + DBinfo[2] +
                            " @" + sql_path);
            writer.Close();
        }

    }
}
