
CREATE VIEW [adw].[vw_AllMbrDetail_IPVisit]
AS
     SELECT a.*, 
            b.VENDOR_ID, 
            b.SVC_PROV_NPI, 
            b.TOTAL_BILLED_AMT
			--c.SVC_TO_DATE as ER_DISCHARGE,
			--case when c.svc_to_date is not null then 1 else 0 end as ER_TRANSFER,
           -- c.PRIMARY_SVC_DATE as ER_START_DATE

     FROM [adw].[tvf_get_claims_w_dates]('Inpatient Stay', '', '', '01/01/2001', '01/01/2099') a
          JOIN adw.Claims_Headers b ON a.seq_claim_id = b.seq_claim_id
		 -- left JOIN (select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE, SVC_TO_DATE from adw.vw_AllMbrDetail_ERVisit) c 
		--  on (datediff(day,c.svc_to_date, a.ADMISSION_DATE) in (0,1,2) or datediff(day,c.PRIMARY_SVC_DATE, a.ADMISSION_DATE) in (0,1,2)) and a.SUBSCRIBER_ID = c.SUBSCRIBER_ID 
		  
		 -- ;
