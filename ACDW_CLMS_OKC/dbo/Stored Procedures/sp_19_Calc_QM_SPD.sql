CREATE PROCEDURE [sp_19_Calc_QM_SPD] @years INT, 
                                     @LOB   VARCHAR(20)
AS
     DECLARE @year INT= @years;
     DECLARE @QM1 VARCHAR(10)= 'SPD';
     DECLARE @QM2 VARCHAR(10)= 'SPD_80';
     DECLARE @RUNDATE DATE= GETDATE();
     DECLARE @RUNTIME DATETIME= GETDATE();
     DECLARE @table1 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @table2 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tableexc AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tableden AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tableden2 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt2 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum2 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop2 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     INSERT INTO @table1
            SELECT SUBSCRIBER_ID
            FROM adw.[tvf_get_active_members2](concat('12/31/', @year))
            WHERE AGE BETWEEN 18 AND 75;
     INSERT INTO @table2
            SELECT DISTINCT 
                   subscriber_id --, count(distinct seq_claim_id), count(distinct primary_svc_date)
            FROM
            (
                SELECT A.*
                FROM
                (
                    SELECT subscriber_id, 
                           SEQ_CLAIM_ID, 
                           PRIMARY_SVC_DATE
                    FROM adw.[tvf_get_claims_w_dates]('Outpatient', 'ED', 'Nonacute Inpatient', concat('1/1/', @year - 1), concat('12/31/', @year))
                    UNION
                    SELECT subscriber_id, 
                           SEQ_CLAIM_ID, 
                           PRIMARY_SVC_DATE
                    FROM adw.[tvf_get_claims_w_dates]('Observation', '', '', concat('1/1/', @year - 1), concat('12/31/', @year))
                ) A
                INNER JOIN
                (
                    SELECT subscriber_id, 
                           SEQ_CLAIM_ID, 
                           PRIMARY_SVC_DATE
                    FROM adw.[tvf_get_claims_w_dates]('Diabetes', '', '', concat('1/1/', @year - 1), concat('12/31/', @year))
                ) B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
            ) C
            GROUP BY subscriber_id
            HAVING(COUNT(DISTINCT seq_claim_id) >= 2)
                  AND (COUNT(DISTINCT primary_svc_date) >= 2);
     INSERT INTO @table2
            SELECT DISTINCT 
                   A.subscriber_id--, A.seq_claim_id
            FROM adw.[tvf_get_claims_w_dates]('Acute Inpatient', '', '', concat('1/1/', @year - 1), concat('12/31/', @year)) A
                 JOIN adw.[tvf_get_claims_w_dates]('Diabetes', '', '', concat('1/1/', @year - 1), concat('12/31/', @year)) B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID;
     INSERT INTO @table2
            SELECT DISTINCT 
                   subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Diabetes Medications', '', '', concat('1/1/', @year - 1), concat('12/31/', @year));
     INSERT INTO @tableexc
            SELECT DISTINCT 
                   A.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('MI', 'CABG', 'PCI', concat('1/1/', @year - 1), concat('12/31/', @year - 1)) A
            UNION
            SELECT DISTINCT 
                   A.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Other Revascularization', '', '', concat('1/1/', @year - 1), concat('12/31/', @year - 1)) A
            UNION
(
    SELECT DISTINCT 
           A.subscriber_id
    FROM adw.[tvf_get_claims_w_dates]('IVD', '', '', concat('1/1/', @year - 1), concat('12/31/', @year - 1)) A
    INTERSECT
    SELECT DISTINCT 
           A.subscriber_id
    FROM adw.[tvf_get_claims_w_dates]('IVD', '', '', concat('1/1/', @year), concat('12/31/', @year)) A
)
UNION
SELECT DISTINCT 
       a.subscriber_id
FROM adw.[tvf_get_claims_w_dates]('Pregnancy', 'IVF', 'Estrogen Agonists Medications', concat('1/1/', @year - 1), concat('12/31/', @year)) A
UNION
SELECT DISTINCT 
       a.subscriber_id
FROM adw.[tvf_get_claims_w_dates]('ESRD', 'Cirrhosis', 'Advanced Illness', concat('1/1/', @year - 1), concat('12/31/', @year)) A
UNION
SELECT DISTINCT 
       a.subscriber_id
FROM adw.[tvf_get_claims_w_dates]('', '', 'Dementia Medications', concat('1/1/', @year - 1), concat('12/31/', @year)) A
UNION
SELECT DISTINCT 
       a.subscriber_id
FROM adw.[tvf_get_claims_w_dates]('', 'Frailty', 'Muscular Pain and Disease', concat('1/1/', @year), concat('12/31/', @year)) A;
     INSERT INTO @tableden
            SELECT a.*
            FROM @table1 a
                 JOIN @table2 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            EXCEPT
            SELECT *
            FROM @tableexc;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT DISTINCT 
                   A.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('High and Moderate-Intensity Statin Medications', '', '', concat('1/1/', @year), concat('12/31/', @year)) A;
     INSERT INTO @tablenumt
            SELECT *
            FROM @table1;
     INSERT INTO @tablenum
            SELECT a.*
            FROM @tablenumt a
            INTERSECT
            SELECT b.*
            FROM @tableden b;
     INSERT INTO @tablecareop
            SELECT a.*
            FROM @tableden a
                 LEFT JOIN @tablenum b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.[QM_ResultByMember_History]
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM1, 
                   'DEN', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tableden;
     INSERT INTO adw.[QM_ResultByMember_History]
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM1, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum;
     INSERT INTO adw.[QM_ResultByMember_History]
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM1, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop;

     --------------------------------------------

     INSERT INTO @tableden2
            SELECT *
            FROM @tablenum;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT DISTINCT 
                   SUBSCRIBER_ID
            FROM
            (
                SELECT subscriber_id, 
                       SUM(rx_supply_dayyys) AS total_supply_days, 
                       DATEDIFF(day, MIN(a.primary_svc_date), concat(CONVERT(VARCHAR(4), @year), '-12-31')) AS total_days_in_treatment
                FROM
                (
                    SELECT *,
                           CASE
                               WHEN DATEADD(day, rx_supply_days, a.PRIMARY_SVC_DATE) > concat(CONVERT(VARCHAR(4), @year), '-12-31')
                               THEN DATEDIFF(day, a.primary_svc_date, concat(CONVERT(VARCHAR(4), @year), '-12-31'))
                               ELSE rx_supply_days
                           END AS rx_supply_dayyys
                    FROM
                    (
                        SELECT subscriber_id, 
                               b.seq_claim_id, 
                               primary_svc_date, 
                               SUM(CAST(b.rx_supply_days AS FLOAT)) AS rx_supply_days
                        FROM adw.[tvf_get_claims_w_dates]('High and Moderate-Intensity Statin Medications', 'Low-Intensity Statin Medications', '', concat('1/1/', @year), concat('12/31/', @year)) A
                             JOIN
                        (
                            SELECT DISTINCT 
                                   claim_number, 
                                   seq_claim_id, 
                                   line_number, 
                                   rx_supply_days
                            FROM adw.claims_details
                        ) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                        GROUP BY subscriber_id, 
                                 b.seq_claim_id, 
                                 primary_svc_date
                    ) a
                ) a
                GROUP BY subscriber_id
                HAVING(CAST(SUM(rx_supply_dayyys) AS FLOAT) / DATEDIFF(day, MIN(a.primary_svc_date), concat(CONVERT(VARCHAR(4), @year), '-12-31'))) >= .8
            ) a;
     INSERT INTO @tablenumt2
            SELECT *
            FROM @table1;
     INSERT INTO @tablenum2
            SELECT a.*
            FROM @tablenumt2 a
            INTERSECT
            SELECT b.*
            FROM @tableden2 b;
     INSERT INTO @tablecareop2
            SELECT a.*
            FROM @tableden2 a
                 LEFT JOIN @tablenum2 b ON a.SUBSCRIBER_ID = b.SUBSCRIBER_ID
            WHERE b.SUBSCRIBER_ID IS NULL;
     INSERT INTO adw.[QM_ResultByMember_History]
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM2, 
                   'DEN', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tableden;
     INSERT INTO adw.[QM_ResultByMember_History]
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM2, 
                   'NUM', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablenum2;
     INSERT INTO adw.[QM_ResultByMember_History]
     ([ClientMemberKey], 
      [QmMsrId], 
      [QmCntCat], 
      [QMDate], 
      [CreateDate]
     )
            SELECT *, 
                   @QM2, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop2;
