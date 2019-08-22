
/****** Script for SelectTopNRows command from SSMS  ******/

CREATE view [dbo].[VW_Dashboard_Comorbidity_Network]
as
SELECT distinct  a.seq_claim_id, a.diagCode, a.diagNumber, b.CCS_CATEGORY, b.[ICD-10-CM_CODE_DESCRIPTION], b.CCS_CATEGORY_DESCRIPTION, c.BodySystem, c.ChronicIndicator
  FROM [ACDW_CLMS_OKC].[adw].[Claims_Diags] a 
  join [ACDW_CLMS_OKC].[adw].[Claims_Headers] x on  a.seq_claim_id = x.seq_claim_id
  left join [lst].[LIST_ICDCCS] b on replace(a.diagCode,'.','') = b.[ICD-10-CM_CODE]
  left join lst.lstChronicConditionIndicator c on replace(a.diagCode,'.','') =  c.[Icd10CmCode]
  where year(x.primary_svc_date)= 2017


