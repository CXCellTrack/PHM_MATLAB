----------------------------------------------------
-- �������-��ˮ
drop sequence seq_DRwater; -- ɾ������
create sequence seq_DRwater
minvalue 1        --��Сֵ
maxvalue	999999999999999999999999999 --���������ֵ
start with 1      --��1��ʼ����
increment by 1    --ÿ�μ�1��
nocycle           --һֱ�ۼӣ���ѭ��
cache 20;          --����������

-- ������������-��ˮ
drop sequence seq_HEwater; -- ɾ������
create sequence seq_HEwater
minvalue 1        --��Сֵ
maxvalue	999999999999999999999999999 --���������ֵ
start with 1      --��1��ʼ����
increment by 1    --ÿ�μ�1��
nocycle           --һֱ�ۼӣ���ѭ��
cache 20;          --����������

-- ����Ԥ������-��ˮ
drop sequence seq_PRwater; -- ɾ������
create sequence seq_PRwater
minvalue 1        --��Сֵ
maxvalue	999999999999999999999999999 --���������ֵ
start with 1      --��1��ʼ����
increment by 1    --ÿ�μ�1��
nocycle           --һֱ�ۼӣ���ѭ��
cache 20;          --����������

exit;