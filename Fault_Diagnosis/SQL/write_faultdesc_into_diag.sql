-- ��ÿ�����ִ����֮��ִ�д˽ű�������Ͻ����FAULTDESC����
-- ���ڴ����в�̫����˽�����ó���ִ��
UPDATE "YJ_WARNING_DIAGNOSIS"
SET FAULTDESC = CASE 
WHEN ISNORMAL = '1' THEN
	'��Ͻ��:����'
WHEN FAULTTYPE = '��ʴ' AND PROBABLITY>='0.8' THEN
	'��Ͻ��:���п��ܸ�ʴ'
WHEN FAULTTYPE = '��ʴ' AND PROBABLITY<'0.8' THEN
	'��Ͻ��:���ܸ�ʴ'
WHEN FAULTTYPE = '����' AND PROBABLITY>='0.8' THEN
	'��Ͻ��:���п�������'
WHEN FAULTTYPE = '����' AND PROBABLITY<'0.8' THEN
	'��Ͻ��:��������'
WHEN FAULTTYPE = '��©' AND PROBABLITY>='0.8' THEN
	'��Ͻ��:���п�����©'
WHEN FAULTTYPE = '��©' AND PROBABLITY<'0.8' THEN
	'��Ͻ��:������©'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY<'0.8' THEN
	'��Ͻ��:������ˮ����'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY>='0.8' THEN
	'��Ͻ��:���п�����ˮ����'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY<'0.8' THEN
	'��Ͻ��:������ˮ����'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY>='0.8' THEN
	'��Ͻ��:���п�����ˮ����'
END
WHERE
	FAULTDESC IS NULL
;
