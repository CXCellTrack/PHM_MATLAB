-- ����ϱ���ɸ���������ϵĵ��͵���������
INSERT INTO "YJ_WARNING_ALARMPIPE" (
	"DBID",
	"ACTIVE",
	"ALARMTIME",
	"FAULTDESC",
	"FAULTTYPE",
	"PROBABLITY",
	"PIPEID"
) SELECT
	SEQ_YJ_WARNING_ALARMPIPE.nextval,
	'1',
	"CHECKTIME",
	"FAULTDESC",
	"FAULTTYPE",
	"PROBABLITY",
	"PIPEID"
FROM
	"YJ_WARNING_DIAGNOSIS"
WHERE
	-- ����ϱ�������recordid���ģ�Ҳ�������һ����ϵĽ����
	RECORDID = ( SELECT MAX (RECORDID) FROM "YJ_WARNING_DIAGNOSIS" )
	-- ����recordid������Ŀ������ͬ����ֹ�ظ�д��
-- AND CHECKTIME != ( SELECT MAX (ALARMTIME) FROM "YJ_WARNING_ALARMPIPE" )
-- �������Ĳ�д��Ԥ��
AND ISNORMAL = '0'; 
-- exit;

