CREATE VIEW adw.[vw_AllMbrDetail_MissingCodes]
AS
     SELECT a.SUBSCRIBER_ID, 
            a.diagCode AS DXCODE, 
            b.[ICD10_DESCRIPTION] AS DESCRIPTION, 
            b.HCCV22
     FROM
     (
         SELECT a.subscriber_id, 
                diagCode--, b.primary_svc_date 
         FROM adw.claims_diags a
              JOIN adw.claims_headers b ON a.SEQ_CLAIM_ID = b.seq_claim_id
         WHERE YEAR(b.primary_svc_date) = YEAR(GETDATE()) - 1
         EXCEPT
         SELECT a.subscriber_id, 
                diagCode--, b.primary_svc_date 
         FROM adw.claims_diags a
              JOIN adw.claims_headers b ON a.SEQ_CLAIM_ID = b.seq_claim_id
         WHERE YEAR(b.primary_svc_date) = YEAR(GETDATE())
     ) a
     LEFT JOIN
     (
         SELECT b.[ICD10], 
                b.[ICD10_DESCRIPTION], 
                b.HCCV22
         FROM lst.[LIST_ICD10CMwHCC] b
         WHERE b.PY = YEAR(GETDATE())
     ) AS b ON replace(a.diagCode, '.', '') = b.[ICD10];
