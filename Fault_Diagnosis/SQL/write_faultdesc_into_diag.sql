-- ��ÿ�����ִ����֮��ִ�д˽ű�������Ͻ����FAULTDESC����
-- ���ڴ����в�̫����˽�����ó���ִ��
UPDATE "YJ_WARNING_DIAGNOSIS"
SET FAULTDESC = CASE 
WHEN FAULTTYPE = '��ʴ' AND PROBABLITY>='0.8' AND ISNORMAL = '0' THEN
	'��Ͻ��:���п��ܸ�ʴ'
WHEN FAULTTYPE = '��ʴ' AND PROBABLITY<'0.8' AND ISNORMAL = '0' THEN
	'��Ͻ��:���ܸ�ʴ'
WHEN FAULTTYPE = '����' AND PROBABLITY>='0.8' AND ISNORMAL = '0' THEN
	'��Ͻ��:���п�������'
WHEN FAULTTYPE = '����' AND PROBABLITY<'0.8' AND ISNORMAL = '0' THEN
	'��Ͻ��:��������'
WHEN FAULTTYPE = '��©' AND PROBABLITY>='0.8' AND ISNORMAL = '0' THEN
	'��Ͻ��:���п�����©'
WHEN FAULTTYPE = '��©' AND PROBABLITY<'0.8' AND ISNORMAL = '0' THEN
	'��Ͻ��:������©'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY<'0.8' AND ISNORMAL = '0' THEN
	'��Ͻ��:������ˮ����'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY>='0.8' AND ISNORMAL = '0' THEN
	'��Ͻ��:���п�����ˮ����'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY<'0.8' AND ISNORMAL = '0' THEN
	'��Ͻ��:������ˮ����'
WHEN FAULTTYPE = '��ˮ����' AND PROBABLITY>='0.8' AND ISNORMAL = '0' THEN
	'��Ͻ��:���п�����ˮ����'
ELSE '��Ͻ��:����'
END
WHERE
	FAULTDESC IS NULL;
-- AND ISNORMAL = '0';
-- exit;