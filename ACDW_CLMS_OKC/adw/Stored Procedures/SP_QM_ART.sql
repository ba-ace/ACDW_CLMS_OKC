CREATE PROCEDURE adw.[SP_QM_ART]
AS
     IF OBJECT_ID('tmp_QM_ART_DEN', 'U') IS NOT NULL
         DROP TABLE tmp_QM_ART_DEN;
     CREATE TABLE tmp_QM_ART_DEN(member VARCHAR(50));
     --Denominator:
     INSERT INTO tmp_QM_ART_DEN
            SELECT DISTINCT 
                   subscriber_id
            FROM
            (
                SELECT SUBSCRIBER_ID, 
                       DOB
                FROM tvf_get_active_members(1)
            ) A
            WHERE DATEDIFF(year, DOB, CONVERT(DATE, '12/31/2018', 101)) BETWEEN 18 AND 120
            INTERSECT
            SELECT DISTINCT 
                   subscriber_id
            FROM
            (
                SELECT DISTINCT 
                       A.subscriber_id, 
                       A.SEQ_CLAIM_ID, 
                       A.PRIMARY_SVC_DATE
                FROM [tvf_get_claims_w_dates]('Outpatient', '', '', '1/1/2018', '11/30/2018') a
                     JOIN [tvf_get_claims_w_dates]('Rheumatoid Arthritis', '', '', '1/1/2018', '11/30/2018') B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
                UNION
                SELECT DISTINCT 
                       A.subscriber_id, 
                       A.SEQ_CLAIM_ID, 
                       A.PRIMARY_SVC_DATE
                FROM [tvf_get_claims_w_dates]('Inpatient Stay', '', '', '1/1/2018', '11/30/2018') a
                     JOIN [tvf_get_claims_w_dates]('Rheumatoid Arthritis', '', '', '1/1/2018', '11/30/2018') B ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
                     JOIN [tvf_get_claims_w_dates]('Nonacute Inpatient', '', '', '1/1/2018', '11/30/2018') C ON A.SEQ_CLAIM_ID = C.SEQ_CLAIM_ID
            ) X
            GROUP BY subscriber_id
            HAVING COUNT(DISTINCT SEQ_CLAIM_ID) >= 2
                   AND COUNT(DISTINCT PRIMARY_SVC_DATE) >= 2;

     -----------------numerator
     CREATE TABLE tmp_QM_ART_NUM_T
     (member VARCHAR(50)
     );
     IF OBJECT_ID('tmp_QM_ART_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_ART_NUM_T;
     CREATE TABLE tmp_QM_ART_NUM_T(member VARCHAR(50));
     --Numerator: wellcare visit with pcp measurement year
     INSERT INTO tmp_QM_ART_NUM_T
            SELECT DISTINCT 
                   A.subscriber_id
            FROM [tvf_get_claims_w_dates]('DMARD', 'DMARD Medications', '', '1/1/2018', '12/31/2018') a;
     IF OBJECT_ID('tmp_QM_ART_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_ART_NUM;
     CREATE TABLE tmp_QM_ART_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_ART_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_ART_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_ART_DEN;
     IF OBJECT_ID('tmp_QM_ART_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_ART_NUM;
     CREATE TABLE tmp_QM_ART_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_ART_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_ART_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_ART_DEN;
     IF OBJECT_ID('tmp_QM_ART_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_ART_NUM_T;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('ART', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_ART_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_ART_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
