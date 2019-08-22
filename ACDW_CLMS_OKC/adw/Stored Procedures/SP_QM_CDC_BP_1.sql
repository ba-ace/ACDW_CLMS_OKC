CREATE PROCEDURE adw.[SP_QM_CDC_BP]
AS

     ---- NUMERATOR CALC

     IF OBJECT_ID('tmp_QM_CDC_BP_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_BP_NUM_T;
     CREATE TABLE tmp_QM_CDC_BP_NUM_T(member VARCHAR(50));

     --exampl
     --meas year conditions 
     INSERT INTO tmp_QM_CDC_BP_NUM_T
            SELECT DISTINCT 
                   subscriber_id
            FROM
            (
                --readings that are compliant
                SELECT DISTINCT 
                       subscriber_id, 
                       seq_claim_id
                FROM adw.[tvf_get_claims_w_dates]('Diastolic Less Than 80', 'Diastolic 80–89', '', '1/1/2018', '12/31/2018')
                INTERSECT
                SELECT DISTINCT 
                       subscriber_id, 
                       seq_claim_id
                FROM adw.[tvf_get_claims_w_dates]('Systolic Less Than 140', '', '', '1/1/2018', '12/31/2018')
            ) firsts
            JOIN
            (
                --most recent bp reading
                SELECT DISTINCT 
                       SEQ_CLAIM_ID
                FROM
                (
                    SELECT DISTINCT 
                           subscriber_id, 
                           seq_claim_id, 
                           DENSE_RANK() OVER(PARTITION BY subscriber_id
                           ORDER BY primary_svc_date DESC) AS rank
                    FROM
                    (
                        SELECT DISTINCT 
                               subscriber_id, 
                               seq_claim_id, 
                               primary_svc_date
                        FROM adw.[tvf_get_claims_w_dates]('Diastolic Less Than 80', 'Diastolic 80–89', 'Diastolic Greater Than/Equal To 90', '1/1/2018', '12/31/2018')
                        UNION
                        SELECT DISTINCT 
                               subscriber_id, 
                               seq_claim_id, 
                               primary_svc_date
                        FROM adw.[tvf_get_claims_w_dates]('Systolic Less Than 140', 'Systolic Greater Than/Equal To 140', '', '1/1/2018', '12/31/2018')
                    ) b
                ) c
                WHERE c.rank = 1
            ) seconds ON firsts.SEQ_CLAIM_ID = seconds.SEQ_CLAIM_ID
     --has to be outpatient or nonacute 
            JOIN
            (
                SELECT DISTINCT 
                       seq_claim_id
                FROM adw.[tvf_get_claims_w_dates]('Outpatient', 'Nonacute Inpatient', '', '1/1/2018', '12/31/2018')
            ) thirds ON firsts.SEQ_CLAIM_ID = thirds.SEQ_CLAIM_ID;
     IF OBJECT_ID('tmp_QM_CDC_BP_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_BP_NUM;
     CREATE TABLE tmp_QM_CDC_BP_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_CDC_BP_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_BP_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_8_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('CDC_BP', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_8_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_BP_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
