CREATE PROCEDURE adw.[SP_QM_WC0]
AS
     IF OBJECT_ID('tmp_QM_WC0_DEN', 'U') IS NOT NULL
         DROP TABLE tmp_QM_WC0_DEN;
     CREATE TABLE tmp_QM_WC0_DEN(member VARCHAR(50));
     INSERT INTO tmp_QM_WC0_DEN
            SELECT DISTINCT 
                   subscriber_id --, m_date_of_birth, dateadd(month,15,M_Date_Of_Birth) 
            FROM
            (
                SELECT *
                FROM tvf_get_active_members(1)
            ) a
            WHERE YEAR(DATEADD(month, 15, dob)) = 2018;
     IF OBJECT_ID('tmp_QM_WC0_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_WC0_NUM_T;
     CREATE TABLE tmp_QM_WC0_NUM_T(member VARCHAR(50));
     INSERT INTO tmp_QM_WC0_NUM_T
            SELECT DISTINCT 
                   subscriber_id
            FROM
            (
                SELECT a.subscriber_id, 
                       a.m_date_of_birth, 
                       DATEADD(month, 15, a.M_Date_Of_Birth) AS x15_mth, 
                (
                    SELECT COUNT(DISTINCT seq_claim_id)
                    FROM [tvf_get_claims_w_dates]('Well-Care', '', '', '1/1/1900', DATEADD(month, 15, a.M_Date_Of_Birth)) b
                    WHERE prov_spec IN('Family Practice', 'General Practic', 'Internal Medici', 'Pediatrics', 'Obstetrics & Gy', 'Nurse Practitio', 'Physician Assis', 'Nurse Prac - Me', 'Family Nurse Pr')
                    AND b.subscriber_id = a.subscriber_id
                ) AS num_of_wc_vis
                FROM
                (
                    SELECT DISTINCT 
                           SUBSCRIBER_ID, 
                           M_Date_Of_Birth, 
                           DENSE_RANK() OVER(PARTITION BY subscriber_id
                           ORDER BY CAST(STR(MBR_YEAR) + '-' + STR(MBR_MTH) + '-01' AS DATE) DESC) AS rank
                    FROM M_MEMBER_ENR
                ) a
                WHERE rank = 1
                      AND YEAR(DATEADD(month, 15, M_Date_Of_Birth)) = 2018
            ) A
            WHERE A.num_of_wc_vis = 0;
     IF OBJECT_ID('tmp_QM_WC0_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_WC0_NUM;
     CREATE TABLE tmp_QM_WC0_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_WC0_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_WC0_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_WC0_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('WC0', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_WC0_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_WC0_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
