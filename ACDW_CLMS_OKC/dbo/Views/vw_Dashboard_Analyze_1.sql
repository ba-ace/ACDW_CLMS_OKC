CREATE view vw_Dashboard_Analyze
  as
  select distinct 
  CATEGORY_OF_SVC, prov_spec, prov_type, PRIMARY_SVC_DATE,year(primary_svc_date) as YEARS,
  a.SUBSCRIBER_ID,PLACE_OF_SVC_CODE1,
  a.SVC_PROV_NPI,a.VEND_FULL_NAME, a.SVC_PROV_FULL_NAME,  
  a.SEQ_CLAIM_ID, ICD_PRIM_DIAG, TOTAL_BILLED_AMT ,c.*,[ChronicIndicator]
      ,[BodySystem],  b.BILLED_AMT, b.PROCEDURE_CODE, b.label,e.*
  from (select * from [adw].[Claims_Headers] )a 
  join (
    select  a.SEQ_CLAIM_ID, a.PROCEDURE_CODE, a.BILLED_AMT , a.PLACE_OF_SVC_CODE1,b.[label] from 
	(select a.SEQ_CLAIM_ID, a.PROCEDURE_CODE, a.BILLED_AMT , a.PLACE_OF_SVC_CODE1 from adw.[Claims_Details] a where year(DETAIL_SVC_DATE) in (2017,2018) ) a
  left join
   
  (SELECT [Code]
      ,[Class]
      ,[Label]
  FROM [ACECAREDW_TEST].[dbo].[tmp_CCSCPT]) b on a.PROCEDURE_CODE = b.code 
  ) b   on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID 

  left join (
  SELECT [ICD-10-CM_CODE]
      ,[CCS_CATEGORY]
      ,[ICD-10-CM_CODE_DESCRIPTION]
      ,[CCS_CATEGORY_DESCRIPTION]
      ,[MULTI_CCS_LVL1]
      ,[MULTI_CCS_LVL1_LABEL]
      ,[MULTI_CCS_LVL2]
      ,[MULTI_CCS_LVL2_LABEL]
      ,[MULTI_CCS_LVL3]
      ,[MULTI_CCS_LVL3_LABEL]
      ,[MULTI_CCS_LVL4]
      ,[MULTI_CCS_LVL4_LABEL]
      ,[Version]
  FROM [ACDW_CLMS_OKC].[lst].[LIST_ICDCCS]
  ) c on a.ICD_PRIM_DIAG = c.[ICD-10-CM_CODE]
  left join (
  SELECT [Icd10CmCode]
      
      ,[ChronicIndicator]
      ,[BodySystem]
    
  FROM [ACDW_CLMS_OKC].[lst].[lstChronicConditionIndicator]
  ) d on a.ICD_PRIM_DIAG = d.Icd10CmCode
  
 left join 
( SELECT  [NPI] as [NPIEXTRA]
      
      ,[PracticeZip]
     
      ,[Taxonomy1]
      ,[Taxonomy2]
      ,[Taxonomy3]
	  ,Latitude
	  ,longitude
	  ,Pod
	  ,avgest as[AvgCareAccess]
  FROM [ACDW_CLMS_OKC].[lst].[LIST_NPPES] aa
  left join (SELECT  [Pod]
      ,[ZipCode]
      
      ,[AvgEst]
      ,[Latitude]
      ,[Longitude]
      ,[CreatedDate]
      ,[CreatedBy]
  FROM [ACDW_CLMS_OKC].[lst].[lstZipCodes]) bb on aa.practicezip = bb.zipcode )e on a.SVC_PROV_NPI = e.[NPIEXTRA]