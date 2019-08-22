
CREATE PROCEDURE adw.[SP_QM_COL]
AS
     IF OBJECT_ID('tmp_QM_COL_DEN', 'U') IS NOT NULL
         DROP TABLE tmp_QM_COL_DEN;
     CREATE TABLE tmp_QM_COL_DEN(member VARCHAR(50));
     --Denominator: member 3-6 years old
     INSERT INTO tmp_QM_COL_DEN
            SELECT DISTINCT 
                   subscriber_id
            FROM
            (
                SELECT subscriber_id, 
                       dob, 
                       DATEDIFF(year, dob, CONVERT(DATE, '12/31/2018', 101)) AS years
                FROM
                (
                    SELECT *
                    FROM adw.tvf_get_active_members(1)
                ) A
            ) a
            WHERE DATEDIFF(year, dob, CONVERT(DATE, '12/31/2018', 101)) BETWEEN 51 AND 75;

     -----------------numerator

     IF OBJECT_ID('tmp_QM_COL_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_COL_NUM_T;
     CREATE TABLE tmp_QM_COL_NUM_T(member VARCHAR(50));
     --Numerator: wellcare visit with pcp measurement year
     INSERT INTO tmp_QM_COL_NUM_T
            SELECT DISTINCT 
                   A.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('FOBT', '', '', '1/1/2018', '12/31/2018') a
            UNION
            SELECT DISTINCT 
                   A.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Flexible Sigmoidoscopy', '', '', '1/1/2014', '12/31/2018') a
            UNION
            SELECT DISTINCT 
                   A.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('Colonoscopy', '', '', '1/1/2009', '12/31/2018') a
            UNION
            SELECT DISTINCT 
                   A.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('CT Colonography', '', '', '1/1/2014', '12/31/2018') a
            UNION
            SELECT DISTINCT 
                   A.subscriber_id
            FROM adw.[tvf_get_claims_w_dates]('FIT-DNA', '', '', '1/1/2016', '12/31/2018') a;
     IF OBJECT_ID('tmp_QM_COL_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_COL_NUM;
     CREATE TABLE tmp_QM_COL_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_COL_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_COL_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_COL_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('COL', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_COL_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_COL_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
