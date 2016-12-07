using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace WindowsServicePHM
{
    class ServiceLog
    {
        // 服务启动时间
        private static DateTime start;


        /// <summary>
        /// 往服务日志中写入服务运行状态
        /// </summary>
        /// <param name="PHMevent">要记录的服务事件</param>
        /// <param name="newlogpath">PHM执行失败的日志地址，只有服务事件为“failed”的时候才有</param>
        public static void WriteLog(string PHMevent, string newlogpath)
        {
            //输入的字符串startorStop只能为"start"或"stop"
            //Append the text to the sample file.
            string logPath = CallUserExe.getFullFilePath("phm_home", @"\Csharp代码\ServicePHM.log");
            StreamWriter writer = File.AppendText(logPath);

            switch (PHMevent)
            {
                case "start":
                    start = DateTime.Now;
                    writer.WriteLine("ServicePHM Start！\t" + DateTime.Now.ToString());
                    writer.WriteLine("----------------------------------------------------------");
                    break;

                case "stop":
                    TimeSpan runtime = DateTime.Now.Subtract(start);
                    writer.WriteLine("");
                    writer.WriteLine("<此次服务共运行{0}天{1}小时{2}分钟{3}秒，累计诊断{4}次，诊断失败{5}次；累计预警{6}次，预警失败{7}次>",
                        runtime.Days, runtime.Hours, runtime.Minutes, runtime.Seconds,
                        ServicePHM.n_diag, ServicePHM.n_failed_diag, ServicePHM.n_predict, ServicePHM.n_failed_predict);

                    writer.WriteLine("----------------------------------------------------------");
                    writer.WriteLine("ServicePHM Stop！\t" + DateTime.Now.ToString());
                    writer.WriteLine("");
                    writer.WriteLine("");
                    break;

                case "diag":
                    writer.WriteLine("启动PHM系统...进行一次故障诊断\t\t" + DateTime.Now.ToString());
                    break;

                case "predict":
                    writer.WriteLine("启动一次故障预警...\t\t\t" + DateTime.Now.ToString());
                    break;

                case "success":
                    string ev = ServicePHM.hasPredicted ? "预警" : "诊断";
                    writer.WriteLine("执行" + ev + "成功！\t\t\t\t" + DateTime.Now.ToString());
                    break;

                case "alarm":
                    writer.WriteLine("故障警报已发送！\t\t\t" + DateTime.Now.ToString());
                    writer.WriteLine("");
                    break;

                case "failed":
                    // 事件为failed时,若没给出新日志地址，说明原日志没找到
                    if (newlogpath == null)
                    {
                        writer.WriteLine("找不到诊断日志文件 {0}\n", ServicePHM.logpath);
                        break;
                    }
                    writer.WriteLine("执行过程出错！\t\t\t\t" + DateTime.Now.ToString());
                    writer.WriteLine("\n请查看日志文件 " + newlogpath);
                    writer.WriteLine("");
                    break;

            }
            writer.Close();
        }

        //// 检查诊断日志，进行异常处理（逐行读入并判断）（不采用这种方法）
        //private string checkPHMlog()
        //{
        //    string logpath = @"C:\Users\Administrator\Desktop\PHM.log";
        //    if (!File.Exists(logpath))
        //        return "log文件不存在";

        //    FileStream fs = new FileStream(logpath, FileMode.Open);
        //    StreamReader reader = new StreamReader(fs, Encoding.Default);

        //    string line = null;
        //    while (!reader.EndOfStream)
        //    {
        //        line = reader.ReadLine();
        //        if (line.StartsWith("<出现异常>")) // 由matlab中errorlog返回的异常
        //        {
        //            fs.Close();
        //            reader.Close();
        //            return line;
        //        }
        //        if (line == "数据库连接关闭！") // 说明exe成功运行到了最后
        //        {
        //            fs.Close();
        //            reader.Close();
        //            return "success";
        //        }

        //    }
        //    fs.Close();
        //    reader.Close();
        //    return "internal error!"; // 说明了出现无法捕获的异常，多半是matlab内部函数错误
        //}

        /// <summary>
        /// 检查此次诊断的日志，从而判断诊断是否成功
        /// </summary>
        /// <param name="logpath">诊断日志的地址</param>
        /// <returns></returns>
        public static string checkPHMlog(string logpath)
        {

            if (!File.Exists(logpath))
                return "PHM日志不存在！";
			
            string[] log = File.ReadAllLines(logpath, Encoding.Default);

            if (log[log.Length - 1] == "数据库连接关闭！") // 说明exe成功运行到了最后
                return "success";
            else if (log[log.Length - 2].StartsWith("<出现异常>")) // 由matlab中errorlog返回的异常
                return log[log.Length - 2];
            else
                return "日志检查失败！"; // 说明了出现无法捕获的异常，多半是matlab内部函数错误
        }

        /// <summary>
        /// 捕捉到异常以后，将错误日志备份到以日期命名的log中
        /// </summary>
        /// <param name="logpath">诊断日志地址</param>
        /// <param name="isDiag">如果为true，此备份是一次诊断；否则为一次预警</param>
        /// <returns></returns>诊断失败日志的备份地址
        public static string backupPHMlog(string logpath, bool isDiag)
        {
            string dt = File.GetLastWriteTime(logpath).ToString();
            dt = dt.Replace(' ', '-');
            dt = dt.Replace('/', '-');
            dt = dt.Replace(':', '-'); // 原来的时间格式xx/xx/xx x:x:x无法作为文件名使用，因此要换掉字符

            string newlogpath = null;
            if (isDiag)
                newlogpath = logpath.Replace("PHM.log", "PHM运行失败日志\\PHM诊断-") + dt + ".log";
            else
                newlogpath = logpath.Replace("PHM.log", "PHM运行失败日志\\PHM预警-") + dt + ".log";

            //Console.WriteLine("将错误日志备份到" + newlogpath);
            File.Copy(logpath, newlogpath, true);

            return newlogpath; // 返回错误日志名
        }

    }
}
