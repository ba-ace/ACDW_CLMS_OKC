﻿CREATE PROCEDURE adw.[SP_QM_WC36]
AS
     IF OBJECT_ID('tmp_QM_WC36_DEN', 'U') IS NOT NULL
         DROP TABLE tmp_QM_WC36_DEN;
     CREATE TABLE tmp_QM_WC36_DEN(member VARCHAR(50));
     --Denominator: member 3-6 years old
     INSERT INTO tmp_QM_WC36_DEN
            SELECT DISTINCT 
                   subscriber_id
            FROM
            (
                SELECT subscriber_id, 
                       dob, 
                       DATEDIFF(year, dob, CONVERT(DATE, '12/31/2018', 101)) AS years
                FROM
                (
                    SELECT DISTINCT 
                           SUBSCRIBER_ID, 
                           dob
                    FROM tvf_get_active_members(1)
                ) a
            ) a
            WHERE DATEDIFF(year, dob, CONVERT(DATE, '12/31/2018', 101)) BETWEEN 3 AND 6;

     -----------------numerator

     IF OBJECT_ID('tmp_QM_WC36_NUM_T', 'U') IS NOT NULL
         DROP TABLE tmp_QM_WC36_NUM_T;
     CREATE TABLE tmp_QM_WC36_NUM_T(member VARCHAR(50));
     --Numerator: wellcare visit with pcp measurement year
     INSERT INTO tmp_QM_WC36_NUM_T
            SELECT DISTINCT 
                   A.subscriber_id
            FROM [tvf_get_claims_w_dates]('Well-Care', '', '', '1/1/2018', '12/31/2018') a
            WHERE prov_spec IN('Family Practice', 'General Practic', 'Internal Medici', 'Pediatrics', 'Obstetrics & Gy', 'Nurse Practitio', 'Physician Assis', 'Nurse Prac - Me', 'Family Nurse Pr');
     IF OBJECT_ID('tmp_QM_WC36_NUM', 'U') IS NOT NULL
         DROP TABLE tmp_QM_WC36_NUM;
     CREATE TABLE tmp_QM_WC36_NUM(member VARCHAR(50));

     --meas year screening by professional
     INSERT INTO tmp_QM_WC36_NUM
            SELECT DISTINCT 
                   *
            FROM tmp_QM_WC36_NUM_T
            INTERSECT
            SELECT DISTINCT 
                   *
            FROM tmp_QM_WC36_DEN;
     INSERT INTO tmp_QM_MSR_CNT
     VALUES
     ('WC36', 
     (
         SELECT COUNT(*)
         FROM tmp_QM_WC36_DEN
     ), 
     (
         SELECT COUNT(*)
         FROM tmp_QM_WC36_NUM
     ), 
      0, 
      CONVERT(DATE, GETDATE(), 101), 
      NULL, 
      NULL
     );
