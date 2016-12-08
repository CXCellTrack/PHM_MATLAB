LOAD DATA
INFILE
"%predictpath%\Water\data\backup_Water.txt"
append
into TABLE "YJ_WARNING_FORECAST"
FIELDS TERMINATED BY ","
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS 
(
"PIPEID",
"FAULTTYPE",
"PROBABLITY",
"PROBBIAS",
-- "ISNORMAL",
"CHECKTIME"	TIMESTAMP 'YYYY-MM-DD HH24:MI:SS',
-- "FAULTDESC",
"RECORDID"
)
