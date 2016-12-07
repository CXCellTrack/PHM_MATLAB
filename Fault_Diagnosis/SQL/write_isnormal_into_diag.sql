-- 在每次诊断执行完之后，执行此脚本更新诊断结果的ISNORMAL部分
-- 放在代码中不太灵活，因此将这个拿出来执行

UPDATE "YJ_WARNING_DIAGNOSIS"
SET ISNORMAL = CASE
WHEN PROBABLITY>='0.8' THEN '0' ELSE '1'
END
WHERE
	ISNORMAL IS NULL
;

-- exit;