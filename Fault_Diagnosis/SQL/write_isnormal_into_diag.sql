-- ��ÿ�����ִ����֮��ִ�д˽ű�������Ͻ����ISNORMAL����
-- ���ڴ����в�̫����˽�����ó���ִ��

UPDATE "YJ_WARNING_DIAGNOSIS"
SET ISNORMAL = CASE
WHEN PROBABLITY>='0.8' THEN '0' ELSE '1'
END
WHERE
	ISNORMAL IS NULL
;

-- exit;