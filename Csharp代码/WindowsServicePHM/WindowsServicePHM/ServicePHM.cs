using System;
using System.IO;
using System.ServiceProcess;
using System.Text;
using System.Collections.Generic;

namespace WindowsServicePHM
{
    public partial class ServicePHM : ServiceBase
    {
        // -------------------- 全局变量 ---------------------- //
        public static int n_diag = 0; // 记录诊断的次数
        public static int n_predict = 0; // 记录预测的次数
        public static int n_failed_diag = 0; // 记录诊断失败的次数
        public static int n_failed_predict = 0; // 记录预测失败的次数

        /// <summary>
        /// 计时器启动时间
        /// </summary>
        public DateTime clock;

        /// <summary>
        /// exe产生的日志文件的位置（诊断和预警为同一log，每次写入都overwrite）
        /// 各种exe的位置
        /// </summary>
        public static string txtpath = CallUserExe.getFullFilePath("predictpath", @"\predict_config.ini");
        public static string logpath = CallUserExe.getFullFilePath("phm_home", @"\Csharp代码\PHM.log");
        public const string exeDiagPath = @"\Precompiled_EXE\PHMdiag\distrib\PHMdiag.exe";
        public const string exePredictPath = @"\Precompiled_EXE\PHMpredict\distrib\PHMpredict.exe";
        // 诊断完成后/预测完成后 应该做的事
        public const string exePostPath = @"\Csharp代码\WindowsServicePHM\runbat\bin\Debug\runbat.exe";


        /// <summary>
        /// 用来标识诊断/预测是否已经完成
        /// </summary>
        public static bool hasDiaged = false;
        public static bool hasPredicted = false;
        public static bool hasChecked = true;
        public static string done_flag_path = CallUserExe.getFullFilePath("phm_home", @"\Csharp代码\done.flag");
        private static readonly object syn = new object(); // 同步锁

        // 从txt中读入diag_trigger_time：dtt 和 predict_trigger_time：ptt
        public static Dictionary<string, int> result = read_diag_trigger_time(txtpath);
        public static int dtt = result["diag_trigger_time"];
        public static int ptt = result["n_predict"];
        public static int predict_time = result["max_diag_time"]; // 诊断多少分钟后开始预测(predict_time 即为 max_diag_time)


        // -------------------- 服务主方法 -------------------- //
        /// <summary>
        /// 服务主方法
        /// </summary>
        public ServicePHM()
        {
            InitializeComponent();
            // 运行计时器
            MyTimer();
        }

        // ------------------ 开始结束触发事件 --------------------- //
        protected override void OnStart(string[] args)
        {
            File.Delete(done_flag_path);
            string failed_dir = CallUserExe.getFullFilePath("phm_home", @"\Csharp代码\PHM运行失败日志");
            if (!Directory.Exists(failed_dir))
                Directory.CreateDirectory(failed_dir);

            ServiceLog.WriteLog("start", null);
        }
        protected override void OnStop()
        {
            ServiceLog.WriteLog("stop", null);
        }

        // ------------------- 定时器事件 --------------------- //
        // 设定定时器
        private void MyTimer()
        {
            // 创建timer，需要加上namespace，因为timer有2个
            System.Timers.Timer time = new System.Timers.Timer();
            // 设置时间间隔
            time.Interval = 1000 * 1;
            // 设置触发事件为timeEvent
            time.Elapsed += new System.Timers.ElapsedEventHandler(timeEvent);
            // 启动
            time.Enabled = true;
            // 记录下定时器启动的时间
            clock = DateTime.Now;
           
        }

        #region 封装各个定点触发事件

        private void runDiag()
        {
            ServiceLog.WriteLog("diag", null);
            n_diag++;
            // 定时器默认会新开一个线程，无需手动写
            CallUserExe.call("phm_home", exeDiagPath, null);
            hasDiaged = true;
            hasPredicted = false;
        }

        private void runPredict()
        {
            ServiceLog.WriteLog("predict", null);
            n_predict++;
            CallUserExe.call("phm_home", exePredictPath, null);
            hasDiaged = false;
            hasPredicted = true;
        }

        private void runChecklog() // 检查PHM.log是否有异常
        {
            string info = ServiceLog.checkPHMlog(logpath);
            if (info == "success")
            {
                ServiceLog.WriteLog(info, null);
                if (hasDiaged) // 执行完诊断才写入alarm
                {
                    // 执行完毕后运行 diag_post.bat 将诊断结果写入报警表、
                    CallUserExe.call("phm_home", exePostPath, " diag"); 
                    // 这里的参数需要加一个空格，猜测是采用system('exe arg1 arg2')这种形式
                    ServiceLog.WriteLog("alarm", null);
                }
                else
                {
                    // 执行完毕后运行 predict_post.bat 进行后处理
                    CallUserExe.call("phm_home", exePostPath, " predict");
                    ServiceLog.WriteLog("alarm", null);
                }
            }
            else // 出现异常
            {
                if (hasPredicted) // 记录异常出现次数
                    n_failed_predict++;
                if (hasDiaged)
                    n_failed_diag++;

                if (info == "PHM日志不存在！")
                {
                    ServiceLog.WriteLog("failed", null);
                }
                else
                {
                    string newlogpath = ServiceLog.backupPHMlog(logpath, hasDiaged); // 将出错的log文件备份
                    ServiceLog.WriteLog("failed", newlogpath);
                }
                //Interop.ShowMessageBox(info, "错误信息"); // 向桌面发送错误信息提示
            }
        }

        #endregion

        /// <summary>
        /// 从txt \predict_config.ini中读入预测与诊断触发时间信息
        /// </summary>
        /// <param name="txtpath"></param>
        /// <returns></returns>
        private static Dictionary<string, int> read_diag_trigger_time(string txtpath)
        {
            StreamReader rd = new StreamReader(txtpath);
            string firstline = rd.ReadLine();
            rd.Close();
            string[] arr = firstline.Split(); // 按空格划分
            // 使用字典存放这些变量
            Dictionary<string, int> dict = new Dictionary<string, int>();
            dict.Add("diag_trigger_time", int.Parse(arr[5]));
            dict.Add("predict_trigger_time", dict["diag_trigger_time"] * int.Parse(arr[3]));
            dict.Add("max_diag_time", int.Parse(arr[7])); // 将最后一个字符转换为int
            return dict;
        }


        private void timeEvent(object sender, EventArgs e)
        {
            //lock (syn) // 每次触发事件都是一个新线程，因此这里要加锁
            //{
                // As creating a child process might be a time consuming operation,
                // its better to do that in a separate thread than blocking the main thread.
                //每隔一秒检查下是否是x分钟0秒，如果是则执行代码，通过这种方式做到定点执行
                DateTime now = DateTime.Now;
                int time_elapse = now.Hour * 60 + now.Minute; // 以0点作为标准时间
                // dtt分钟触发一次诊断
                if (now.Second == 0 && time_elapse % dtt == 0) 
                {
                    hasChecked = false;
                    this.runDiag();
                    return;
                }
                // ptt分钟诊断结束后predict_time分，触发一次预测
                if (now.Second == 0 && time_elapse % ptt == predict_time)
                {
                    hasChecked = false;
                    this.runPredict();
                    return;
                }
                // 检查诊断日志中的内容，从开始诊断到predict_time分（有可能开始下一次预测），每5秒检查一次
                if (hasDiaged && !hasChecked && now.Second % 5 == 0 && time_elapse % dtt < predict_time)
                {
                    // 如果存在这个标记文件，说明诊断/预测已经完成，则可checklog，并删去文件
                    if (File.Exists(done_flag_path)) // 标记文件由matlab代码生成
                    {
                        hasChecked = true;
                        File.Delete(done_flag_path);
                        this.runChecklog();
                    }
                    else if (time_elapse % dtt == predict_time - 1 && now.Second == 55)
                    {
                        // 如果快到预测时间了还没发现done.flag，则直接check，此时必然会报错
                        this.runChecklog();
                    }
                    return;
                }
                // 检查预测日志中的内容，从开始预测到开始下一次诊断，每5秒检查一次
                if (hasPredicted && !hasChecked && now.Second % 5 == 0)
                {
                    // 如果存在这个标记文件，说明诊断/预测已经完成，则可checklog，并删去文件
                    if (File.Exists(done_flag_path)) // 标记文件由matlab代码生成
                    {
                        hasChecked = true;
                        File.Delete(done_flag_path);
                        this.runChecklog();
                    }
                    else if (now.Minute % dtt == dtt - 1 && now.Second == 55)
                    {
                        // 如果快到下次诊断时间了还没发现done.flag，则直接check，此时必然会报错
                        this.runChecklog();
                    }
                    return;
                }
            //} // endlock

        }
    }
}
