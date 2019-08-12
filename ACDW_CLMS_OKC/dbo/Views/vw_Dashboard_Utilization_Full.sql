




CREATE VIEW [dbo].[vw_Dashboard_Utilization_Full]
as
SELECT A.[SEQ_CLAIM_ID], 
       A.[SUBSCRIBER_ID], 
	   I.ACE_ACTIVE,
	   I.year as [MBR_YEAR],
	   I.month as [MBR_MTH],
	   I.mbr_mth as [TOTAL_MBR_MTHS],
	   I.NPI as [MBR_NPI],
	   I.TIN as [MBR_TIN],
	   I.memb_zip [MBR_ZIP],
	   I.gender as [MBR_GENDER],
	   I.DOB as [MBR_DOB],
	   I.pod as [MBR_POD],
       A.[CATEGORY_OF_SVC], 
       A.[ICD_PRIM_DIAG], 
       A.[PRIMARY_SVC_DATE], 
       A.[ADMISSION_DATE], 
       A.[SVC_TO_DATE], 
       A.[SVC_PROV_ID], 
       A.[SVC_PROV_FULL_NAME], 
       A.[SVC_PROV_NPI], 
       A.[PROV_SPEC], 
       A.[PROV_TYPE], 
       A.[VENDOR_ID], 
    --   A.[VEND_FULL_NAME], 
	   J.LBN_NAME as [VEND_FULL_NAME], 
	   J.ZIP as [VEND_ZIP],
	   J.POD as [VEND_POD],
       A.[IRS_TAX_ID], 
       A.[DRG_CODE], 
       A.[CLAIM_STATUS], 
       A.[CLAIM_TYPE], 
       A.[TOTAL_BILLED_AMT], 
       B.[TOTAL_PAID_AMT],
	   case when c.STAY_DAYS= 0 then null else c.STAY_DAYS end as [IS_LOS], 
	   case when k.seq_claim_id is not null then 1 else 0 end as [IS_READMIT],
	   case when e.seq_claim_id is not null then 1 else 0 end as [IS_INPAT],
	   case when f.seq_claim_id is not null then 1 else 0 end as [IS_ER],
	   case when g.seq_claim_id is not null then 1 else 0 end as [IS_INPAT_ER_TRANS],
	   case when h.seq_claim_id is not null then 1 else 0 end as [IS_PCP]
FROM 
(
    SELECT Claims_Headers.SEQ_CLAIM_ID, 
           Claims_Headers.SUBSCRIBER_ID, 
           Claims_Headers.CATEGORY_OF_SVC, 
           Claims_Headers.ICD_PRIM_DIAG, 
           case when Claims_Headers.PRIMARY_SVC_DATE is null then b.DETAIL_SVC_DATE else Claims_Headers.PRIMARY_SVC_DATE end as PRIMARY_SVC_DATE, 
           Claims_Headers.SVC_PROV_ID, 
           Claims_Headers.SVC_PROV_FULL_NAME, 
           Claims_Headers.SVC_PROV_NPI, 
           Claims_Headers.PROV_SPEC, 
           Claims_Headers.PROV_TYPE, 
		   Claims_Headers.ADMISSION_DATE, 
	       Claims_Headers.SVC_TO_DATE, 
           Claims_Headers.VENDOR_ID,
           Claims_Headers.VEND_FULL_NAME, 
           Claims_Headers.IRS_TAX_ID, 
           Claims_Headers.DRG_CODE, 
           Claims_Headers.CLAIM_STATUS, 
           Claims_Headers.CLAIM_TYPE, 
           Claims_Headers.TOTAL_BILLED_AMT
     
    FROM [adw].[Claims_Headers] join (select distinct seq_claim_id, detail_svc_date from adw.Claims_Details) b on Claims_Headers.SEQ_CLAIM_ID  = b.SEQ_CLAIM_ID
) a
/*Claims Detail Paid amount total data*/
left join tmp_UTIL_TOTAL_PAID b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
/*Claims lenght of stay / bed days data*/
left join tmp_UTIL_LOS c on a.SEQ_CLAIM_ID = c.SEQ_CLAIM_ID 
/*Claims Readmission data*/ 
left join tmp_UTIL_READMIT k on a.SEQ_CLAIM_ID = k.SEQ_CLAIM_ID 
/*Claims IP and ER transfer IP  data*/
left join tmp_UTIL_IP e on a.SEQ_CLAIM_ID = e.SEQ_CLAIM_ID 
/*Claims ER data*/
left join tmp_UTIL_ER f on a.SEQ_CLAIM_ID = f.SEQ_CLAIM_ID 
/*Claims ER transfer to IP, IP visit data*/
left join tmp_UTIL_IP_FROM_ER g on a.SEQ_CLAIM_ID = g.SEQ_CLAIM_ID 
/*Claims ER transfer to IP, IP visit data*/
left join tmp_UTIL_PCP h on a.SEQ_CLAIM_ID = h.SEQ_CLAIM_ID 
/*member provider and practice data*/
right join 
(
SELECT distinct a.hicn, tin, npi , memb_zip, gender, d.DOB, pod, SUBSCRIBER_ID as ACE_ACTIVE, Mbr_mth, month, year
  FROM [tmp_UTIL_MBR_ACTIVE] a 
  left join [adw].[tmp_Active_Members] d on a.hicn = d.HICN
  left join [adw].[Claims_Member] b on a.hicn = b.subscriber_id 
  left join [lst].[lstZipCodes] c on b.memb_zip = c.ZipCode
  where a.hicn not in (select distinct hicn from adw.tmp_Active_Members where exclusion = 'Y' ) 
  ) i on a.subscriber_id = i.hicn and year(a.PRIMARY_SVC_DATE) = i.year and month(a.PRIMARY_SVC_DATE) = i.month 
LEFT JOIN
     (
         SELECT DISTINCT 
                npi, 
                lbn_name, 
                PracticeCity AS city, 
                PracticeState AS states, 
                LEFT(practiceZip, 5) AS zip,
				b.pod 
         FROM lst.LIST_NPPES a
		 left join [lst].[lstZipCodes] b on LEFT(a.practiceZip, 5) = b.ZipCode
     ) j ON a.VENDOR_ID = j.NPI
where i.ACE_ACTIVE is not null 


;
