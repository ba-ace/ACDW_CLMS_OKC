
CREATE View [dbo].[vw_Dashboard_MbrPCPMapOverlay]
AS 
SELECT a.HICN,
CONVERT(INT,a.MEMB_ZIP) as MBR_ZIP,
a.MBR_YEAR,
b.PCP_NPI,
CONVERT(INT,b.PCP_ZIP) as PCP_ZIP,
b.PROV_TYPE

  FROM [ACDW_CLMS_OKC].[dbo].[vw_Dashboard_MemberDemographics] a
FULL JOIN   [ACDW_CLMS_OKC].[lst].[LIST_PCP] b ON a.NPI=b.PCP_NPI

