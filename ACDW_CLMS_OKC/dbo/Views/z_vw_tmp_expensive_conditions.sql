CREATE view z_vw_tmp_expensive_conditions
as
select   a.SUBSCRIBER_ID,a.PRIMARY_SVC_DATE, a.seq_claim_id
,b.line_number
, total_billed_amt , PAID_AMT 
,replace(diagCode,'.','')  as diagCode
,d.[ICD-10-CM_CODE_DESCRIPTION] as icd_desc
,d.CCS_CATEGORY as ccs_cat
,d.CCS_CATEGORY_DESCRIPTION as ccs_desc
,d.MULTI_CCS_LVL1 as ccs_lvl1_num
,d.MULTI_CCS_LVL1_LABEL as ccs_lvl1_lab

,replace(ICD_PRIM_DIAG,'.','')  as  ICD_PRIM_DIAG
,e.[ICD-10-CM_CODE_DESCRIPTION] as prim_icd_desc
,e.CCS_CATEGORY as prim_ccs_cat
,e.CCS_CATEGORY_DESCRIPTION as prim_ccs_desc
,e.MULTI_CCS_LVL1 as prim_ccs_lvl1_num
,e.MULTI_CCS_LVL1_LABEL as prim_ccs_lvl1_lab
from adw.Claims_Headers a join adw.Claims_Details b  on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID join adw.Claims_Diags c on a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID 
left join lst.LIST_ICDCCS d on replace(c.diagCode,'.','')  = d.[ICD-10-CM_CODE]
left join lst.LIST_ICDCCS e on replace(a.ICD_PRIM_DIAG,'.','') = e.[ICD-10-CM_CODE]
where year(a.PRIMARY_SVC_DATE) = 2018