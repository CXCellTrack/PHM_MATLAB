-- ��ÿ�����ִ����֮��ִ�д˽ű�������Ͻ����ISNORMAL����
-- ���ڴ����в�̫����˽�����ó���ִ��

UPDATE "YJ_WARNING_FORECAST"
SET ISNORMAL = CASE
WHEN PROBABLITY>='0.5' THEN '0' ELSE '1'
END
WHERE
	ISNORMAL IS NULL
;

-- exit;