CREATE PROCEDURE adw.[SP_QM_PCE_B]
AS
     IF OBJECT_ID('tmp_QM_PCE_B_DEN1', 'U') IS NOT NULL
         DROP TABLE tmp_QM_PCE_B_DEN1;
     CREATE TABLE tmp_QM_PCE_B_DEN1(member VARCHAR(50));
     INSERT INTO tmp_QM_PCE_B_DEN1(member)
            SELECT DISTINCT 
                   subscriber_id
            FROM
            (
                SELECT subscriber_id, 
                       dob, 
                       DATEDIFF(year, dob, CONVERT(DATE, '01/01/2018', 101)) AS years
                FROM
                (
                    SELECT *
                    FROM tvf_get_active_members(1)
                ) A
            ) a
            WHERE DATEDIFF(year, dob, CONVERT(DATE, '01/01/2018', 101)) BETWEEN 40 AND 120;
     IF OBJECT_ID('tmp_QM_PCE_B_TB1', 'U') IS NOT NULL
         DROP TABLE tmp_QM_PCE_B_TB1;
     CREATE TABLE tmp_QM_PCE_B_TB1
     (member       VARCHAR(50), 
      claim        VARCHAR(50), 
      episode_date DATE
     );
     INSERT INTO tmp_QM_PCE_B_TB1
            SELECT A.subscriber_id, 
                   A.SEQ_CLAIM_ID, 
                   A.PRIMARY_SVC_DATE AS episode_date
            FROM
            (
                SELECT DISTINCT 
                       A.subscriber_id, 
                       A.SEQ_CLAIM_ID, 
                       A.PRIMARY_SVC_DATE
                FROM [tvf_get_claims_w_dates]('ED', '', '', '1/1/2018', '11/30/2018') a
                     JOIN [tvf_get_claims_w_dates]('COPD', 'Emphysema', 'Chronic Bronchitis', '1/1/2018', '11/30/2018') b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
            --exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
                EXCEPT
                (
                    SELECT DISTINCT 
                           A.subscriber_id, 
                           A.SEQ_CLAIM_ID, 
                           A.PRIMARY_SVC_DATE
                    FROM [tvf_get_claims_w_dates]('ED', '', '', '1/1/2018', '11/30/2018') a
                         JOIN [tvf_get_claims_w_dates]('Inpatient Stay', '', '', '1/1/2018', '11/30/2018') b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                    UNION
                    SELECT DISTINCT 
                           A.subscriber_id, 
                           A.SEQ_CLAIM_ID, 
                           A.PRIMARY_SVC_DATE
                    FROM [tvf_get_claims_w_dates]('ED', '', '', '1/1/2018', '11/30/2018') a
                         JOIN [tvf_get_claims_w_dates]('Inpatient Stay', '', '', '1/1/2018', '11/30/2018') b ON(ABS(DATEDIFF(day, b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <= 1)
                                                                                                               AND A.SUBSCRIBER_ID = B.SUBSCRIBER_ID
                                                                                                               AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
                )
            ) A
            UNION
            --Den cond 2 and cond 3 direct transfer , a and b are used for acute inpatient stay with the where statement and a and c are used to account for direct transfers: Acute Inpatient Discharge with 3 related lung conditions
            (
                SELECT DISTINCT 
                       A.subscriber_id, 
                       A.SEQ_CLAIM_ID,
                       CASE
                           WHEN c.ADMISSION_DATE IS NULL
                           THEN a.SVC_TO_DATE
                           ELSE c.SVC_TO_DATE
                       END AS EpisodeDate
                FROM [tvf_get_claims_w_dates]('Inpatient Stay', '', '', '1/1/2018', '11/30/2018') a
                     JOIN [tvf_get_claims_w_dates]('COPD', 'Emphysema', 'Chronic Bronchitis', '1/1/2018', '11/30/2018') b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                     JOIN [tvf_get_claims_w_dates]('Inpatient Stay', '', '', '1/1/2018', '11/30/2018') c ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
                                                                                                            AND a.SEQ_CLAIM_ID <> c.SEQ_CLAIM_ID
                                                                                                            AND a.SVC_TO_DATE <= c.ADMISSION_DATE
                                                                                                            AND ABS(DATEDIFF(day, a.SVC_TO_DATE, c.ADMISSION_DATE)) <= 1
                WHERE A.SEQ_CLAIM_ID NOT IN
                (
                    SELECT SEQ_CLAIM_ID
                    FROM [tvf_get_claims_w_dates]('Nonacute Inpatient Stay', '', '', '1/1/2018', '11/30/2018')
                )
            );
     IF OBJECT_ID('tmp_QM_PCE_B_DEN2', 'U') IS NOT NULL
         DROP TABLE tmp_QM_PCE_B_DEN2;
     CREATE TABLE tmp_QM_PCE_B_DEN2(member VARCHAR(50));
     INSERT INTO tmp_QM_PCE_B_DEN2(member)
            SELECT DISTINCT 
                   member
            FROM tmp_QM_PCE_B_TB1;
     IF OBJECT_ID('tmp_QM_PCE_B_DEN', 'U') IS NOT NULL
         DROP TABLE tmp_QM_PCE_B_DEN;
     CREATE TABLE tmp_QM_PCE_B_DEN(member VARCHAR(50));
     --Denominator: 40 years or older on jan of meas year
     INSERT INTO tmp_QM_PCE_B_DEN
            SELECT member
            FROM tmp_QM_PCE_B_DEN1
            INTERSECT
            SELECT member
            FROM tmp_QM_PCE_B_DEN2;

     -----------------numerator
     --Cynthia recommended the episode date should be the first episode date , since they would be put on a medication and get refills, but another nurse said as long as there is one visit
     --coded as for any copd episode, if there is a medication dispensed within 30 days it counts , it's actually by episode visits instead of member

     IF OBJECT_ID('tmp_QM_PCE_B_VIS', 'U') IS NOT NULL
         DROP TABLE tmp_QM_PCE_B_VIS;
     CREATE TABLE tmp_QM_PCE_B_VIS
     (member               VARCHAR(50), 
      claim                VARCHAR(50), 
      episode_date         DATE, 
      den                  INT, 
      primary_svc_date_med DATE, 
      num                  INT
     );
     INSERT INTO tmp_QM_PCE_B_VIS
            SELECT a.*, 
                   1 AS den, 
                   b.PRIMARY_SVC_DATE,
                   CASE
                       WHEN b.PRIMARY_SVC_DATE IS NULL
                       THEN 0
                       ELSE 1
                   END AS num
            FROM tmp_QM_PCE_B_TB1 a
                 LEFT JOIN
            (
                SELECT *
                FROM [tvf_get_claims_w_dates]('Bronchodilator Medications', '', '', '1/1/2018', '11/30/2018')
            ) b ON a.member = b.SUBSCRIBER_ID
                   AND a.episode_date <= b.PRIMARY_SVC_DATE
                   AND ABS(DATEDIFF(day, a.episode_date, b.PRIMARY_SVC_DATE)) <= 30
                   AND a.claim <> b.SEQ_CLAIM_ID
            WHERE member IN
            (
                SELECT *
                FROM tmp_QM_PCE_B_DEN1
            );
     IF OBJECT_ID('tmp_QM_PCE_B_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_PCE_B_NUM_T;
     CREATE TABLE tmp_QM_PCE_B_NUM_T(member VARCHAR(50));
     --Numerator step 1 
     INSERT INTO tmp_QM_PCE_B_NUM_T
            SELECT DISTINCT 
                   member
            FROM
            (
                SELECT member, 
                       SUM(den) AS den, 
                       SUM(num) AS num,
                       CASE
                           WHEN SUM(den) = 0
                           THEN 0
                           ELSE CONVERT(FLOAT, SUM(num)) / SUM(den)
                       END AS perc
                FROM tmp_QM_PCE_B_VIS
                GROUP BY member
                HAVING CASE
                           WHEN SUM(den) = 0
                           THEN 0
                           ELSE CONVERT(FLOAT, SUM(num)) / SUM(den)
                       END = 1
            ) A;
     IF OBJECT_ID('tmp_QM_PCE_B_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_PCE_B_NUM;
     CREATE TABLE tmp_QM_PCE_B_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_PCE_B_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_PCE_B_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_PCE_B_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('PCE_B', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_PCE_B_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_PCE_B_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
     (
         SELECT SUM(den)
         FROM tmp_QM_PCE_B_VIS
     ), 
     (
         SELECT SUM(num)
         FROM tmp_QM_PCE_B_VIS
     )
     );
