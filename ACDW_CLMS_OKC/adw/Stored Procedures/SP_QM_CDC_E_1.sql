CREATE PROCEDURE adw.[SP_QM_CDC_E]
AS

     ---- NUMERATOR CALC

     IF OBJECT_ID('tmp_QM_CDC_E_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_E_NUM_T;
     CREATE TABLE tmp_QM_CDC_E_NUM_T(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_CDC_E_NUM_T
            SELECT DISTINCT 
                   a.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Diabetic Retinal Screening', '', '', '1/1/2018', '12/31/2018') a
            WHERE prov_spec IN('Optometry', 'Ophthalmology');

     --prior year negative result from screening by professional
     INSERT INTO tmp_QM_CDC_E_NUM_T
            SELECT DISTINCT 
                   a.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Diabetic Retinal Screening', '', '', '1/1/2017', '12/31/2017') a
                 JOIN
            (
                SELECT DISTINCT 
                       seq_claim_id
                FROM adw.[tvf_get_claims_w_dates]('', 'Diabetic Retinal Screening Negative', '', '1/1/2017', '12/31/2017')
            ) b ON a.seq_claim_id = b.seq_claim_id
            WHERE prov_spec IN('Optometry', 'Ophthalmology');

     --prior year diabetes mellitus without comp from screening by professional
     INSERT INTO tmp_QM_CDC_E_NUM_T
            SELECT DISTINCT 
                   a.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Diabetic Retinal Screening', '', '', '1/1/2017', '12/31/2017') a
                 JOIN
            (
                SELECT DISTINCT 
                       seq_claim_id
                FROM adw.[tvf_get_claims_w_dates]('', 'Diabetes Mellitus Without Complications', '', '1/1/2017', '12/31/2017')
            ) b ON a.seq_claim_id = b.seq_claim_id
            WHERE prov_spec IN('Optometry', 'Ophthalmology');

     --meas year diabetes ret screening with eye care professional value code
     INSERT INTO tmp_QM_CDC_E_NUM_T
            SELECT DISTINCT 
                   a.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Diabetic Retinal Screening With Eye Care Professional', '', '', '1/1/2018', '12/31/2018') a;

     --prior year diabetes ret screening with eye care professional value code with negative result
     INSERT INTO tmp_QM_CDC_E_NUM_T
            SELECT DISTINCT 
                   a.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Diabetic Retinal Screening With Eye Care Professional', '', '', '1/1/2017', '12/31/2017') a
                 JOIN
            (
                SELECT DISTINCT 
                       seq_claim_id
                FROM adw.[tvf_get_claims_w_dates]('', 'Diabetic Retinal Screening Negative', '', '1/1/2017', '12/31/2017')
            ) b ON a.seq_claim_id = b.seq_claim_id;

     --meas year screening negative result
     INSERT INTO tmp_QM_CDC_E_NUM_T
            SELECT DISTINCT 
                   a.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Diabetic Retinal Screening Negative', '', '', '1/1/2018', '12/31/2018') a;

     --unilateral eye enucleation with a bilateral modifier
     INSERT INTO tmp_QM_CDC_E_NUM_T
            SELECT DISTINCT 
                   a.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Unilateral Eye Enucleation', '', '', '1/1/1900', '12/31/2018') a
                 JOIN
            (
                SELECT DISTINCT 
                       seq_claim_id
                FROM adw.[tvf_get_claims_w_dates]('Bilateral', '', '', '1/1/1900', '12/31/2018')
            ) b ON a.seq_claim_id = b.seq_claim_id;

     --two unilateral eye enucleation 14 days or more apart
     INSERT INTO tmp_QM_CDC_E_NUM_T
            SELECT DISTINCT 
                   a.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Unilateral Eye Enucleation Left', '', '', '1/1/1900', '12/31/2018') a
                 JOIN
            (
                SELECT DISTINCT 
                       *
                FROM adw.[tvf_get_claims_w_dates]('Unilateral Eye Enucleation Left', '', '', '1/1/1900', '12/31/2018')
            ) b ON a.subscriber_id = b.subscriber_id
                   AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
                   AND ABS(DATEDIFF(day, a.PRIMARY_SVC_DATE, b.primary_svc_date)) >= 14;

     --left and right unilateral eye enucleation 
     INSERT INTO tmp_QM_CDC_E_NUM_T
            SELECT DISTINCT 
                   a.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Unilateral Eye Enucleation Left', '', '', '1/1/1900', '12/31/2018') a
                 JOIN
            (
                SELECT DISTINCT 
                       *
                FROM adw.[tvf_get_claims_w_dates]('Unilateral Eye Enucleation Right', '', '', '1/1/1900', '12/31/2018')
            ) b ON a.subscriber_id = b.subscriber_id;
     IF OBJECT_ID('tmp_QM_CDC_E_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_CDC_E_NUM;
     CREATE TABLE tmp_QM_CDC_E_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_CDC_E_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_E_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_CDC_8_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('CDC_E', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_8_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_CDC_E_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
