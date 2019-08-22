
CREATE VIEW [dbo].[vw_Dashboard_ChronicConditions]
AS
SELECT z.*
	,zz.hicn AS ACT_MBR_ID
	,(
		SELECT count(DISTINCT ChronicCategory)
		FROM [dbo].[tmp_CC_ResultsByMember] c
		WHERE zz.hicn = c.Subscriber_id
		) AS BIN
FROM (
	SELECT *
		,stuff((
				SELECT ';' + b.code_desc
				FROM (
					SELECT *
					FROM [dbo].[tmp_CC_ResultsByMember]
					) b
				WHERE a.subscriber_id = b.subscriber_id
					AND a.category_num = b.category_num
				ORDER BY code_desc
				FOR XML PATH('')
				), 1, 1, '') AS codes_desc
		,stuff((
				SELECT ';' + b.code
				FROM (
					SELECT *
					FROM [dbo].[tmp_CC_ResultsByMember]
					) b
				WHERE a.subscriber_id = b.subscriber_id
					AND a.category_num = b.category_num
				ORDER BY code
				FOR XML PATH('')
				), 1, 1, '') AS codes
	FROM (
		SELECT DISTINCT subscriber_id
			,chronicCategory
			,category_num
			,level1
		FROM [ACDW_CLMS_OKC].[dbo].[tmp_CC_ResultsByMember]
		) a
	) z
RIGHT JOIN (
	SELECT DISTINCT hicn
	FROM adw.tmp_active_members a
	WHERE Exclusion = 'N'
	) zz
	ON z.subscriber_id = zz.hicn
		--where codes_desc like '%diab%'
