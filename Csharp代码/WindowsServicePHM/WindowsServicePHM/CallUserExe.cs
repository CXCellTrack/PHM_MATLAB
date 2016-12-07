using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WindowsServicePHM
{
    class CallUserExe
    {
        // This thread function would launch a child process 
        // in the interactive session of the logged-on user.

        /// <summary>
        /// 调用外部的exe
        /// </summary>
        /// <param name="sysname"></param> exe所在的系统变量目录
        /// <param name="exeSubPath"></param> exe相对目录
        public static void call(string sysname, string exeSubPath, string arg)
        {
            string exeFullPath = getFullFilePath(sysname, exeSubPath);
            CreateProcessAsUserWrapper.LaunchChildProcess(exeFullPath, arg);
        }

        /// <summary>
        /// 获取系统变量PHM_HOME内文件的完整地址
        /// </summary>
        /// <param name="subPath">文件在PHM_HOME下的相对路径</param>
        /// <returns></returns>完整路径
        public static string getFullFilePath(string sysname, string subPath)
        {
            // 注意这个GetEnvironmentVariable只能得到系统环境变量的值！而非用户环境变量！
            // 应该是因为在服务环境下无法连接用户
            string home = Environment.GetEnvironmentVariable(sysname);
            //Console.Write(PHM_HOME);
            return (home + subPath);

        }
    }
}
