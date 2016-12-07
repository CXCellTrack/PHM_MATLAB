----------------------------------------------------
-- 诊断序列-给水
drop sequence seq_DRwater; -- 删除序列
create sequence seq_DRwater
minvalue 1        --最小值
maxvalue	999999999999999999999999999 --不设置最大值
start with 1      --从1开始计数
increment by 1    --每次加1个
nocycle           --一直累加，不循环
cache 20;          --不建缓冲区

-- 健康评估序列-给水
drop sequence seq_HEwater; -- 删除序列
create sequence seq_HEwater
minvalue 1        --最小值
maxvalue	999999999999999999999999999 --不设置最大值
start with 1      --从1开始计数
increment by 1    --每次加1个
nocycle           --一直累加，不循环
cache 20;          --不建缓冲区

-- 故障预测序列-给水
drop sequence seq_PRwater; -- 删除序列
create sequence seq_PRwater
minvalue 1        --最小值
maxvalue	999999999999999999999999999 --不设置最大值
start with 1      --从1开始计数
increment by 1    --每次加1个
nocycle           --一直累加，不循环
cache 20;          --不建缓冲区

exit;