﻿
CREATE PROCEDURE adw.[SP_QM_WC3]
AS
     IF OBJECT_ID('tmp_QM_WC3_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_WC3_NUM_T;
     CREATE TABLE tmp_QM_WC3_NUM_T(member VARCHAR(50));
     INSERT INTO tmp_QM_WC3_NUM_T
            SELECT DISTINCT 
                   subscriber_id
            FROM
            (
                SELECT a.subscriber_id, 
                       a.dob, 
                       DATEADD(month, 15, a.dob) AS x15_mth, 
                (
                    SELECT COUNT(DISTINCT seq_claim_id)
                    FROM adw.[tvf_get_claims_w_dates]('Well-Care', '', '', '1/1/1900', DATEADD(month, 15, a.dob)) b
                    WHERE prov_spec IN('Family Practice', 'General Practic', 'Internal Medici', 'Pediatrics', 'Obstetrics & Gy', 'Nurse Practitio', 'Physician Assis', 'Nurse Prac - Me', 'Family Nurse Pr')
                    AND b.subscriber_id = a.subscriber_id
                ) AS num_of_wc_vis
                FROM
                (
                    SELECT DISTINCT 
                           SUBSCRIBER_ID, 
                           dob
                    FROM adw.tvf_get_active_members(1)
                ) a
                WHERE YEAR(DATEADD(month, 15, dob)) = 2018
            ) A
            WHERE A.num_of_wc_vis = 3;
     IF OBJECT_ID('tmp_QM_WC3_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_WC3_NUM;
     CREATE TABLE tmp_QM_WC3_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_WC3_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_WC3_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_WC0_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('WC3', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_WC0_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_WC3_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
