-------------------------------------------------------------------------------
--  故障预警表
--  PIPETYPE  为管线类型，STREET   为所属道路，这两个字段可以不写数据，为了方便前台查询展现的完整性，表里加上这两列
-------------------------------------------------------------------------------
create table YJ_WARNING_ALARMPIPE
(
  DBID      NUMBER(19) primary key not null,
  ACTIVE    NUMBER(1),
  ALARMTIME TIMESTAMP(6),
  FAULTDESC VARCHAR2(255 CHAR),
  FAULTTYPE VARCHAR2(255 CHAR),
  PROBABLITY VARCHAR2(255 CHAR),--故障概率
  MEMO      VARCHAR2(255 CHAR),
  PIPEID    VARCHAR2(255 CHAR),
  PIPETYPE  VARCHAR2(255 CHAR),
  STRATEGY  VARCHAR2(255 CHAR),
  STREET    VARCHAR2(255 CHAR)
);
-------------------------------------------------------------------------------
--  故障预警表序列
-------------------------------------------------------------------------------
drop sequence SEQ_YJ_WARNING_ALARMPIPE;
create sequence SEQ_YJ_WARNING_ALARMPIPE
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;
-------------------------------------------------------------------------------
--  故障诊断表
--  PIPETYPE  为管线类型，STREET   为所属道路，这两个字段可以不写数据，为了方便前台查询展现的完整性，表里加上这两列
-------------------------------------------------------------------------------
create table YJ_WARNING_DIAGNOSIS
(
  DBID      NUMBER(19) primary key not null,
  RECORDID  VARCHAR2(255 CHAR),--记录编号
  CHECKTIME TIMESTAMP(6),--检测时间
  FAULTDESC VARCHAR2(255 CHAR),--故障描述
  FAULTTYPE VARCHAR2(255 CHAR),--故障类型
  PROBABLITY VARCHAR2(255 CHAR),--故障概率
  ISNORMAL  NUMBER(1),--是否正常
  MEMO      VARCHAR2(255 CHAR),--备注
  PIPEID    VARCHAR2(255 CHAR),--管线编号
  PIPETYPE  VARCHAR2(255 CHAR),--管线类型
  STRATEGY  VARCHAR2(255 CHAR),--解决故障策略
  STREET    VARCHAR2(255 CHAR)，--所属道路

  ISACTUALOCCUR  VARCHAR2(255 CHAR),--是否发生
  ISCORRECT  VARCHAR2(255 CHAR),--是否正确
  PRECISION    VARCHAR2(255 CHAR)--精度
);

-------------------------------------------------------------------------------
--  故障诊断表序列
-------------------------------------------------------------------------------
drop sequence SEQ_YJ_WARNING_DIAGNOSIS;
create sequence SEQ_YJ_WARNING_DIAGNOSIS
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;
-------------------------------------------------------------------------------
--  故障预测表
-------------------------------------------------------------------------------
create table YJ_WARNING_FORECAST
(
  DBID      NUMBER(19) primary key not null,
  RECORDID  VARCHAR2(255 CHAR),--记录编号
  CHECKTIME TIMESTAMP(6),--检测时间
  FAULTDESC VARCHAR2(255 CHAR),--故障描述
  FAULTTYPE VARCHAR2(255 CHAR),--故障类型
  PROBABLITY VARCHAR2(255 CHAR),--故障预测发生的概率
  PROBBIAS   VARCHAR2(255 CHAR),--概率值的上下浮动范围
  ISNORMAL  NUMBER(1),--是否正常
  MEMO      VARCHAR2(255 CHAR),--备注
  PIPEID    VARCHAR2(255 CHAR),--管线编号
  PIPETYPE  VARCHAR2(255 CHAR),--管线类型
  STRATEGY  VARCHAR2(255 CHAR),--解决故障策略
  STREET    VARCHAR2(255 CHAR)，--所属道路

  DIAGPROB  VARCHAR2(255 CHAR),
  DIAGTIME  TIMESTAMP(6),
  DIAGRECORDID  VARCHAR2(255 CHAR),
  ISCORRECT  VARCHAR2(255 CHAR),--是否正确
  PRECISION    VARCHAR2(255 CHAR)--精度
);
-------------------------------------------------------------------------------
--  故障预测表序列
-------------------------------------------------------------------------------
drop sequence SEQ_YJ_WARNING_FORECAST;
create sequence SEQ_YJ_WARNING_FORECAST
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;
-------------------------------------------------------------------------------
--  健康度表
-------------------------------------------------------------------------------
create table YJ_WARNING_HEALTH
(
  DBID       NUMBER(19) primary key not null,
  EVALTIME   TIMESTAMP(6),
  RANK       VARCHAR2(255 CHAR),--等级
  MEMO       VARCHAR2(255 CHAR),--备注
  PIPEID     VARCHAR2(255 CHAR),
  PIPETYPE   VARCHAR2(255 CHAR),
  RESULT     VARCHAR2(255 CHAR),--评估结果
  STREET     VARCHAR2(255 CHAR),
  SUGGESTION VARCHAR2(255 CHAR)，--建议

  EVALRECORDID VARCHAR2(255 CHAR)
);
-------------------------------------------------------------------------------
--  健康度表序列
-------------------------------------------------------------------------------
drop sequence SEQ_YJ_WARNING_HEALTH;
create sequence SEQ_YJ_WARNING_HEALTH
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20;

