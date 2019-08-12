/****** Script for SelectTopNRows command from SSMS  ******/

CREATE view VW_Dashboard_Comorbidity
as
SELECT distinct  a.seq_claim_id, a.subscriber_id, a.diagCode, a.diagNumber, b.CCS_CATEGORY--, b.CCS_CATEGORY_DESCRIPTION, b.MULTI_CCS_LVL1, b.MULTI_CCS_LVL1_LABEL , b.MULTI_CCS_LVL2, b.MULTI_CCS_LVL2_LABEL 
  FROM [ACDW_CLMS_OKC].[adw].[Claims_Diags] a inner join [lst].[LIST_ICDCCS] b on replace(a.diagCode,'.','') = b.[ICD-10-CM_CODE]
join (
  select distinct seq_claim_id from 
  [ACDW_CLMS_OKC].[adw].[Claims_Diags] a join (
  select distinct [ICD-10-CM_CODE] from lst.LIST_ICDCCS where ccs_category in (98)) b on replace(a.diagCode,'.','') = b.[ICD-10-CM_CODE]
  ) c on a.seq_claim_id = c.seq_claim_id