/****** Script for SelectTopNRows command from SSMS  ******/
create view dbo.vw_Dashboard_HospitalCost_Map
as 
SELECT [VENDOR_ID]
      
      ,[vendor_name_nppes]
	  ,year(primary_svc_date) as year 
	  ,count(distinct [SEQ_CLAIM_ID])  as num_clm
      ,count(distinct [SUBSCRIBER_ID]) as num_mbr
	  ,sum(TOTAL_BILLED_AMT) as total_billed
     
  FROM [ACDW_CLMS_OKC].[dbo].[vw_Dashboard_HospitalCost] 
  group by [VENDOR_ID],[vendor_name_nppes], year(primary_svc_date)