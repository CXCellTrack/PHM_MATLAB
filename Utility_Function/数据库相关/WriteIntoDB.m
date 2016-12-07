function WriteIntoDB( conn, data2write, tablename )
% 将data2write这个cell写入到conn中数据库的tablename表格中
% 此函数可以为通用函数
% 但其中调用的 insert...方法需要针对每种管线每种表格

% 验证表格是否存在
validateTable(conn, tablename);
writelog(['将结果写入oracle数据库的',tablename,'中...\n']);
writelog(['<共',num2str(size(data2write,1)),'条数据>\n']);

tic;
switch tablename
    % -------------------- 诊断部分表格 ------------------- %
    case 'YJ_WARNING_DIAGNOSIS'
        insert_DR( conn, data2write, tablename );
        
    % -------------------- 健康度评估部分表格 ------------------- %
    case 'YJ_WARNING_HEALTH'
        insert_HE( conn, data2write, tablename );
        
    % -------------------- 故障预警部分表格 ------------------- %
    case 'predict_result_water'
        insert_PR( conn, data2write, tablename );
        
end

writelog('toc', toc);
writelog('数据写入成功！\n\n==========================================\n',1);


