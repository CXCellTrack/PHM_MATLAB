-- ��ÿ�����ִ����֮��ִ�д˽ű�������Ͻ����FAULTDESC����
-- ���ڴ����в�̫����˽�����ó���ִ��
UPDATE "YJ_WARNING_FORECAST"
SET FAULTDESC = CASE 
WHEN ISNORMAL = '1' THEN
	'Ԥ����:����'
WHEN FAULTTYPE = '��ʴ' AND PROBABLITY>='0.8' AND ISNORMAL = '0' THEN
	'Ԥ����:���п��ܸ�ʴ'
WHEN FAULTTYPE = '��ʴ' AND PROBABLITY<'0.8' AND ISNORMAL = '0' THEN
	'Ԥ����:���ܸ�ʴ'
WHEN FAULTTYPE = '����' AND PROBABLITY>='0.8' AND ISNORMAL = '0' THEN
	'Ԥ����:���п�������'
WHEN FAULTTYPE = '����' AND PROBABLITY<'0.8' AND ISNORMAL = '0' THEN
	'Ԥ����:��������'
WHEN FAULTTYPE = '��©' AND PROBABLITY>='0.8' AND ISNORMAL = '0' THEN
	'Ԥ����:���п�����©'
WHEN FAULTTYPE = '��©' AND PROBABLITY<'0.8' AND ISNORMAL = '0' THEN
	'Ԥ����:������©'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY<'0.8' AND ISNORMAL = '0' THEN
	'Ԥ����:������ˮ����'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY>='0.8' AND ISNORMAL = '0' THEN
	'Ԥ����:���п�����ˮ����'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY<'0.8' AND ISNORMAL = '0' THEN
	'Ԥ����:������ˮ����'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY>='0.8' AND ISNORMAL = '0' THEN
	'Ԥ����:���п�����ˮ����'
END
WHERE 
	FAULTDESC IS NULL
;
