
CREATE VIEW [adw].[vw_AllMbrDetail_IPVisit_ER_TRANS]
AS
     SELECT a.SEQ_CLAIM_ID, a.SUBSCRIBER_ID
	 , a.PRIMARY_SVC_DATE
     FROM [adw].[tvf_get_claims_w_dates]('Inpatient Stay', '', '', '01/01/2001', '01/01/2099') a
JOIN (select distinct SUBSCRIBER_ID, SEQ_CLAIM_ID, PRIMARY_SVC_DATE, SVC_TO_DATE from adw.vw_AllMbrDetail_ERVisit) c 
		  on datediff(day,c.svc_to_date, a.ADMISSION_DATE) in (0,1,2) and a.SUBSCRIBER_ID = c.SUBSCRIBER_ID 
		  
		  
