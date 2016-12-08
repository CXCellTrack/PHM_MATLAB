function Val_Pre_Result()

% 将诊断结果写入预测表，以此来验证预测结果是否准确
% 操作全在sqlplus上进行，使用脚本
% 操作诊断数据-->预测表，并计算精度
% 选择管线进行预测
predict_path = getphmpath('predict');

sqladdr = [predict_path,'\update_PR.sql'];

% 执行sql脚本更新预测中的诊断验证部分
try
	execute_sql_script(sqladdr);
catch
    errorlog(['使用sqlplus执行sql脚本', alterPath(sqladdr), '失败！']);
end
    
    
    
    
    
    

