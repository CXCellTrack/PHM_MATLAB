using System;
using System.IO;
using System.ServiceProcess;

namespace WindowsService1
{
    public partial class Service1 : ServiceBase
    {
        public Service1()
        {
            InitializeComponent();

            System.Timers.Timer t = new System.Timers.Timer(1000);//实例化Timer类，设置间隔时间为10000毫秒；      
            t.Elapsed += new System.Timers.ElapsedEventHandler(TimeElapse);//到达时间的时候执行事件；      
            t.AutoReset = true;//设置是执行一次（false）还是一直执行(true)；      
            t.Enabled = true;//是否执行System.Timers.Timer.Elapsed事件；    
        }

        public void TimeElapse(object source, System.Timers.ElapsedEventArgs e)
        {
            //EventLog log = new EventLog();     
            //log.Source = "我的应用程序";     
            //log.WriteEntry("1秒调用一次", EventLogEntryType.Information);     
            FileStream fs = new FileStream(@"C:\Users\Administrator\Desktop\timetick.txt", FileMode.OpenOrCreate, FileAccess.Write);
            StreamWriter m_streamWriter = new StreamWriter(fs);
            m_streamWriter.BaseStream.Seek(0, SeekOrigin.End);
            m_streamWriter.WriteLine("过了一秒 " + DateTime.Now.ToString() + "\n");
            m_streamWriter.Flush();
            m_streamWriter.Close();
            fs.Close();

        }    

        protected override void OnStart(string[] args)
        {
        }

        protected override void OnStop()
        {
        }
    }
}
