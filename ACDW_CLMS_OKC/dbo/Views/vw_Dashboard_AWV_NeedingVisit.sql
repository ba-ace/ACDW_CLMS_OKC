CREATE VIEW [dbo].[vw_Dashboard_AWV_NeedingVisit]
AS
SELECT a.[HICN]
	,a.LastName
	,a.FirstName
	,a.[Sex]
	,a.[DOB]
	,a.[Mbr_Type]
	,c.SVC_PROV_NPI AS LastSvcNPI
	,c.LBN AS LastSvcName
	,c.SVC_DATE AS LastSvcDate
	,d.PCP_NPI AS ACO_NPI
	,CONCAT (
		d.PCP_LAST_NAME
		,', '
		,d.PCP_FIRST_NAME
		) AS ACO_NPI_NAME
FROM (
	SELECT *
	FROM adw.[tmp_Active_Members]
	WHERE exclusion = 'N' and [plan] <>''
	) a
JOIN  [adw].[vw_AllMbrDetail_LastAWVVisit] c
	ON a.HICN = c.SUBSCRIBER_ID
LEFT JOIN lst.LIST_PCP d
	ON c.SVC_PROV_NPI = d.PCP_NPI
where c.SVC_DATE < concat('01/01/',year(getdate()))



