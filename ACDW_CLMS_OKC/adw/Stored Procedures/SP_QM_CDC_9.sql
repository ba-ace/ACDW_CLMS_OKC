CREATE PROCEDURE adw.[SP_QM_CDC_9]
AS

     --intersect all numerator conditions
     --numerator condition: hba1c test with greater than 9

     IF OBJECT_ID('tmp_QM_CDC_9_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_9_NUM_T;
     CREATE TABLE tmp_QM_CDC_9_NUM_T(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_CDC_9_NUM_T
            SELECT DISTINCT 
                   A.subscriber_id
            FROM [tvf_get_claims_w_dates]('HbA1c Tests', '', '', '1/1/2017', '12/31/2018') a
                 JOIN
            (
                SELECT *
                FROM
                (
                    SELECT DISTINCT 
                           subscriber_id, 
                           seq_claim_id, 
                           primary_svc_date, 
                           DENSE_RANK() OVER(PARTITION BY subscriber_id
                           ORDER BY primary_svc_date DESC) AS rank, 
                           code
                    FROM
                    (
                        SELECT DISTINCT 
                               subscriber_id, 
                               seq_claim_id, 
                               primary_svc_date, 
                               'HbA1c Level Less Than 7.0' AS code
                        FROM [tvf_get_claims_w_dates]('HbA1c Level Less Than 7.0', '', '', '1/1/2018', '12/31/2018')
                        UNION
                        SELECT DISTINCT 
                               subscriber_id, 
                               seq_claim_id, 
                               primary_svc_date, 
                               'HbA1c Level Greater Than 9.0' AS code
                        FROM [tvf_get_claims_w_dates]('', 'HbA1c Level Greater Than 9.0', '', '1/1/2018', '12/31/2018')
                        UNION
                        SELECT DISTINCT 
                               subscriber_id, 
                               seq_claim_id, 
                               primary_svc_date, 
                               'HbA1c Level 7.0-9.0' AS code
                        FROM [tvf_get_claims_w_dates]('', '', 'HbA1c Level 7.0-9.0', '1/1/2018', '12/31/2018')
                    ) A
                ) C
                WHERE rank = 1
                      AND code = 'HbA1c Level Greater Than 9.0'
            ) B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
     --numerator condition union: members with hba1c test but with no results (the most recent one)
            UNION
            SELECT DISTINCT 
                   Subscriber_id
            FROM
            (
                SELECT DISTINCT 
                       subscriber_id, 
                       seq_claim_id
                FROM
                (
                    SELECT DISTINCT 
                           subscriber_id, 
                           SEQ_CLAIM_ID, 
                           DENSE_RANK() OVER(PARTITION BY subscriber_id
                           ORDER BY primary_svc_date DESC) AS rank
                    FROM [tvf_get_claims_w_dates]('HbA1c Tests', '', '', '1/1/2018', '12/31/2018')
                ) A
                WHERE A.rank = 1
                EXCEPT
                SELECT DISTINCT 
                       subscriber_id, 
                       seq_claim_id
                FROM [tvf_get_claims_w_dates]('HbA1c Level Less Than 7.0', 'HbA1c Level Greater Than 9.0', 'HbA1c Level 7.0-9.0', '1/1/2018', '12/31/2018')
            ) Z
--numerator condition union: members with no hba1c test 
            UNION
            (
                SELECT DISTINCT 
                       subscriber_id
                FROM M_MEMBER_ENR
                EXCEPT
                SELECT DISTINCT 
                       subscriber_id
                FROM [tvf_get_claims_w_dates]('HbA1c Tests', '', '', '1/1/2018', '12/31/2018')
            );
     IF OBJECT_ID('tmp_QM_CDC_9_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_9_NUM;
     CREATE TABLE tmp_QM_CDC_9_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_CDC_9_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_9_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_8_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('CDC_9', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_8_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_9_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
