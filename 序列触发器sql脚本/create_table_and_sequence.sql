-------------------------------------------------------------------------------
--  ����Ԥ����
--  PIPETYPE  Ϊ�������ͣ�STREET   Ϊ������·���������ֶο��Բ�д���ݣ�Ϊ�˷���ǰ̨��ѯչ�ֵ������ԣ��������������
-------------------------------------------------------------------------------
create table YJ_WARNING_ALARMPIPE
(
  DBID      NUMBER(19) primary key not null,
  ACTIVE    NUMBER(1),
  ALARMTIME TIMESTAMP(6),
  FAULTDESC VARCHAR2(255 CHAR),
  FAULTTYPE VARCHAR2(255 CHAR),
  PROBABLITY VARCHAR2(255 CHAR),--���ϸ���
  MEMO      VARCHAR2(255 CHAR),
  PIPEID    VARCHAR2(255 CHAR),
  PIPETYPE  VARCHAR2(255 CHAR),
  STRATEGY  VARCHAR2(255 CHAR),
  STREET    VARCHAR2(255 CHAR)
);
-------------------------------------------------------------------------------
--  ����Ԥ��������
-------------------------------------------------------------------------------
drop sequence SEQ_YJ_WARNING_ALARMPIPE;
create sequence SEQ_YJ_WARNING_ALARMPIPE
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;
-------------------------------------------------------------------------------
--  ������ϱ�
--  PIPETYPE  Ϊ�������ͣ�STREET   Ϊ������·���������ֶο��Բ�д���ݣ�Ϊ�˷���ǰ̨��ѯչ�ֵ������ԣ��������������
-------------------------------------------------------------------------------
create table YJ_WARNING_DIAGNOSIS
(
  DBID      NUMBER(19) primary key not null,
  RECORDID  VARCHAR2(255 CHAR),--��¼���
  CHECKTIME TIMESTAMP(6),--���ʱ��
  FAULTDESC VARCHAR2(255 CHAR),--��������
  FAULTTYPE VARCHAR2(255 CHAR),--��������
  PROBABLITY VARCHAR2(255 CHAR),--���ϸ���
  ISNORMAL  NUMBER(1),--�Ƿ�����
  MEMO      VARCHAR2(255 CHAR),--��ע
  PIPEID    VARCHAR2(255 CHAR),--���߱��
  PIPETYPE  VARCHAR2(255 CHAR),--��������
  STRATEGY  VARCHAR2(255 CHAR),--������ϲ���
  STREET    VARCHAR2(255 CHAR)��--������·

  ISACTUALOCCUR  VARCHAR2(255 CHAR),--�Ƿ���
  ISCORRECT  VARCHAR2(255 CHAR),--�Ƿ���ȷ
  PRECISION    VARCHAR2(255 CHAR)--����
);

-------------------------------------------------------------------------------
--  ������ϱ�����
-------------------------------------------------------------------------------
drop sequence SEQ_YJ_WARNING_DIAGNOSIS;
create sequence SEQ_YJ_WARNING_DIAGNOSIS
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;
-------------------------------------------------------------------------------
--  ����Ԥ���
-------------------------------------------------------------------------------
create table YJ_WARNING_FORECAST
(
  DBID      NUMBER(19) primary key not null,
  RECORDID  VARCHAR2(255 CHAR),--��¼���
  CHECKTIME TIMESTAMP(6),--���ʱ��
  FAULTDESC VARCHAR2(255 CHAR),--��������
  FAULTTYPE VARCHAR2(255 CHAR),--��������
  PROBABLITY VARCHAR2(255 CHAR),--����Ԥ�ⷢ���ĸ���
  PROBBIAS   VARCHAR2(255 CHAR),--����ֵ�����¸�����Χ
  ISNORMAL  NUMBER(1),--�Ƿ�����
  MEMO      VARCHAR2(255 CHAR),--��ע
  PIPEID    VARCHAR2(255 CHAR),--���߱��
  PIPETYPE  VARCHAR2(255 CHAR),--��������
  STRATEGY  VARCHAR2(255 CHAR),--������ϲ���
  STREET    VARCHAR2(255 CHAR)��--������·

  DIAGPROB  VARCHAR2(255 CHAR),
  DIAGTIME  TIMESTAMP(6),
  DIAGRECORDID  VARCHAR2(255 CHAR),
  ISCORRECT  VARCHAR2(255 CHAR),--�Ƿ���ȷ
  PRECISION    VARCHAR2(255 CHAR)--����
);
-------------------------------------------------------------------------------
--  ����Ԥ�������
-------------------------------------------------------------------------------
drop sequence SEQ_YJ_WARNING_FORECAST;
create sequence SEQ_YJ_WARNING_FORECAST
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;
-------------------------------------------------------------------------------
--  �����ȱ�
-------------------------------------------------------------------------------
create table YJ_WARNING_HEALTH
(
  DBID       NUMBER(19) primary key not null,
  EVALTIME   TIMESTAMP(6),
  RANK       VARCHAR2(255 CHAR),--�ȼ�
  MEMO       VARCHAR2(255 CHAR),--��ע
  PIPEID     VARCHAR2(255 CHAR),
  PIPETYPE   VARCHAR2(255 CHAR),
  RESULT     VARCHAR2(255 CHAR),--�������
  STREET     VARCHAR2(255 CHAR),
  SUGGESTION VARCHAR2(255 CHAR)��--����

  EVALRECORDID VARCHAR2(255 CHAR)
);
-------------------------------------------------------------------------------
--  �����ȱ�����
-------------------------------------------------------------------------------
drop sequence SEQ_YJ_WARNING_HEALTH;
create sequence SEQ_YJ_WARNING_HEALTH
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

