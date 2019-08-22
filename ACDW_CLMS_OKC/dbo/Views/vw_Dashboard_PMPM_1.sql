
CREATE VIEW [dbo].[vw_Dashboard_PMPM]
as 
SELECT * 
FROM 
(
    SELECT DISTINCT 
           YEAR, 
           QUARTER, 
           HICN AS HICN_ACT
    FROM [ADI].[z_MEMBERELIGIBLITYBYQUARTER]
) ACT 
LEFT JOIN (

SELECT CATEGORY_OF_SVC, 
       CAST(CAST(YEAR(A.PRIMARY_SVC_DATE) AS VARCHAR(4))+'-'+CAST(MONTH(A.PRIMARY_SVC_DATE) AS VARCHAR(2))+'-01' AS DATE) AS DATE, 
       SUBSCRIBER_ID AS HICN, 
       TOTAL_BILLED_AMT, 
	   paid_amt,
       SEQ_CLAIM_ID
FROM (select a.category_of_svc, a.subscriber_id, a.total_billed_amt, a.primary_svc_date, a.seq_claim_id, b.paid_amt from [ADW].[CLAIMS_HEADERS] A  
join (select seq_claim_id , sum(b.paid_amt) as paid_amt from adw.claims_details b group by seq_claim_id ) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID) a 


     JOIN
(
    SELECT DISTINCT 
           YEAR, 
           QUARTER, 
           HICN
    FROM [ADI].[z_MEMBERELIGIBLITYBYQUARTER]
) B ON A.SUBSCRIBER_ID = B.HICN
       AND YEAR(A.PRIMARY_SVC_DATE) = B.YEAR
       AND CASE
               WHEN MONTH(A.PRIMARY_SVC_DATE) IN(1, 2, 3)
               THEN 1
               WHEN MONTH(A.PRIMARY_SVC_DATE) IN(4, 5, 6)
               THEN 2
               WHEN MONTH(A.PRIMARY_SVC_DATE) IN(7, 8, 9)
               THEN 3
               WHEN MONTH(A.PRIMARY_SVC_DATE) IN(10, 11, 12)
               THEN 4
               ELSE NULL
           END = B.QUARTER
) ACTCLM 
ON ACT.HICN_ACT = ACTCLM.HICN
       AND ACT.YEAR = YEAR(ACTCLM.DATE)
       AND CASE
               WHEN MONTH(ACTCLM.DATE) IN(1, 2, 3)
               THEN 1
               WHEN MONTH(ACTCLM.DATE) IN(4, 5, 6)
               THEN 2
               WHEN MONTH(ACTCLM.DATE) IN(7, 8, 9)
               THEN 3
               WHEN MONTH(ACTCLM.DATE) IN(10, 11, 12)
               THEN 4
               ELSE NULL
           END = ACT.QUARTER
