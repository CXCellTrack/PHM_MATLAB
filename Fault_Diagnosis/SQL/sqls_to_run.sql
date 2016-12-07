-- 1、调用 write_isnormal_into_diag.sql 将ISNORMAL写入diag表
-- 2、调用 write_faultdesc_into_diag.sql 将故障描述写入diag表
-- 3、调用 select_diag_into_alarm.sql 将故障写入alarm表

@@write_isnormal_into_diag.sql

@@write_faultdesc_into_diag.sql

@@select_diag_into_alarm.sql


exit;