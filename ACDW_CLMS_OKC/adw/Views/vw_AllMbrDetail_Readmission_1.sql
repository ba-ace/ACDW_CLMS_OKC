CREATE VIEW adw.[vw_AllMbrDetail_Readmission]
AS
     SELECT a.*, 
            b.VENDOR_ID, 
            b.SVC_PROV_NPI
     FROM
     (
         SELECT b.*
         FROM adw.[tvf_get_claims_w_dates]('Inpatient Stay', '', '', '01/01/2001', '01/01/2099') a
              JOIN adw.[tvf_get_claims_w_dates]('Inpatient Stay', '', '', '01/01/2001', '01/01/2099') b ON a.seq_claim_id <> b.seq_claim_id
                                                                                                           AND a.subscriber_id = b.subscriber_id
                                                                                                           AND ABS(DATEDIFF(day, a.svc_to_date, b.admission_date)) <= 30
                                                                                                           AND a.svc_to_date <= b.admission_date
     ) a
     JOIN adw.Claims_Headers b ON a.seq_claim_id = b.seq_claim_id;
