--Done
CREATE VIEW [dbo].[vw_Dashboard_MemberDemographics]
AS
SELECT  x.HICN
       , x.MBR_QTR
	   ,x.MBR_YEAR
      ,a.[Plan]
      ,a.[FirstName]
      ,a.[LastName]
      ,a.[Sex]
      ,a.[DOB]
      ,a.[DOD]
      ,a.[Exclusion]
      ,a.[Mbr_Type]
      ,a.[TIN]
      ,a.[TIN_NAME]
      ,a.[NPI]
      ,a.[NPI_NAME]
	  ,c.[MEMB_ZIP]
	  ,d.[pod]
    ,case when a.hicn is not null then 1 else 0 end as ACTIVE 
	,case when x.mbr_QTR = a.mbr_QTR and x.mbr_year =a.mbr_year then 1 else 0 end as CURR_DATE
FROM 
(select distinct hicn, mbr_year, mbr_qtr from [adw].[Member_History]) x
left join 
(
	SELECT *
	FROM adw.tmp_active_members
	WHERE Exclusion = 'N'
		AND [plan] <> ''
	) a on x.hicn = a.hicn
LEFT JOIN [adw].[Claims_Member] c
	ON a.hicn = c.SUBSCRIBER_ID
left join [lst].[lstZipCodes] d on c.memb_zip = d.ZipCode

