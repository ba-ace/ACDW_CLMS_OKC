CREATE PROCEDURE [sp_19_Calc_QM_SPR] @years INT, 
                                     @LOB   VARCHAR(20)
AS
     DECLARE @year INT= @years;
     DECLARE @QM VARCHAR(10)= 'SPR';
     DECLARE @RUNDATE DATE= GETDATE();
     DECLARE @RUNTIME DATETIME= GETDATE();
     DECLARE @table1 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @table2 AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @table3 AS TABLE
     (member      VARCHAR(50), 
      IESD_date   DATE, 
      prior730day DATE
     );
     DECLARE @table4 AS TABLE
     (member    VARCHAR(50), 
      IESD_date DATE
     );
     DECLARE @tableden AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenumt AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablenum AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     DECLARE @tablecareop AS TABLE(SUBSCRIBER_ID VARCHAR(20));
     INSERT INTO @table1
            SELECT SUBSCRIBER_ID
            FROM adw.[tvf_get_active_members2](concat('1/31/', @year))
            WHERE AGE BETWEEN 42 AND 120;
     INSERT INTO @table3
            SELECT D.SUBSCRIBER_ID, 
                   D.episode_date, 
                   D.prior730days
            FROM
            (
                SELECT DISTINCT 
                       C.subscriber_id, 
                       C.episode_date, 
                       DATEADD(day, -730, c.episode_date) AS prior730days
                FROM
                (
                    SELECT DISTINCT 
                           B.SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           episode_date, 
                           DENSE_RANK() OVER(PARTITION BY subscriber_id
                           ORDER BY episode_date) AS rank
                    FROM
                    (
                        SELECT A.subscriber_id, 
                               A.SEQ_CLAIM_ID, 
                               A.PRIMARY_SVC_DATE AS episode_date
                        FROM
                        (
                            SELECT DISTINCT 
                                   A.subscriber_id, 
                                   A.SEQ_CLAIM_ID, 
                                   A.PRIMARY_SVC_DATE
                            FROM adw.[tvf_get_claims_w_dates]('ED', '', '', concat('7/1/', @year - 1), concat('6/30/', @year)) a
                                 JOIN adw.[tvf_get_claims_w_dates]('COPD', 'Emphysema', 'Chronic Bronchitis', concat('7/1/', @year - 1), concat('6/30/', @year)) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                        --exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
                            EXCEPT
                            (
                                SELECT DISTINCT 
                                       A.subscriber_id, 
                                       A.SEQ_CLAIM_ID, 
                                       A.PRIMARY_SVC_DATE
                                FROM adw.[tvf_get_claims_w_dates]('ED', '', '', concat('7/1/', @year - 1), concat('6/30/', @year)) a
                                     JOIN adw.[tvf_get_claims_w_dates]('Inpatient Stay', '', '', concat('7/1/', @year - 1), concat('6/30/', @year)) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                                UNION
                                SELECT DISTINCT 
                                       A.subscriber_id, 
                                       A.SEQ_CLAIM_ID, 
                                       A.PRIMARY_SVC_DATE
                                FROM adw.[tvf_get_claims_w_dates]('ED', '', '', concat('7/1/', @year - 1), concat('6/30/', @year)) a
                                     JOIN adw.[tvf_get_claims_w_dates]('Inpatient Stay', '', '', concat('7/1/', @year - 1), concat('6/30/', @year)) b ON(ABS(DATEDIFF(day, b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <= 1)
                                                                                                                                                    AND A.SUBSCRIBER_ID = B.SUBSCRIBER_ID
                                                                                                                                                    AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
                            )
                        ) A
                        UNION
                        --Den cond 2: Acute Inpatient Discharge with 3 related lung conditions
                        (
                            SELECT DISTINCT 
                                   A.subscriber_id, 
                                   A.SEQ_CLAIM_ID, 
                                   a.SVC_TO_DATE AS EpisodeDate
                            FROM adw.[tvf_get_claims_w_dates]('Inpatient Stay', '', '', concat('7/1/', @year - 1), concat('6/30/', @year)) a
                                 JOIN adw.[tvf_get_claims_w_dates]('COPD', 'Emphysema', 'Chronic Bronchitis', concat('7/1/', @year - 1), concat('6/30/', @year)) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                                 JOIN adw.[tvf_get_claims_w_dates]('Inpatient Stay', '', '', concat('7/1/', @year - 1), concat('6/30/', @year)) c ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
                                                                                                                                                 AND a.SEQ_CLAIM_ID <> c.SEQ_CLAIM_ID
                                                                                                                                                 AND a.SVC_TO_DATE <= c.ADMISSION_DATE
                                                                                                                                                 AND ABS(DATEDIFF(day, a.SVC_TO_DATE, c.ADMISSION_DATE)) <= 1
                            WHERE A.SEQ_CLAIM_ID NOT IN
                            (
                                SELECT SEQ_CLAIM_ID
                                FROM adw.[tvf_get_claims_w_dates]('Nonacute Inpatient Stay', '', '', concat('7/1/', @year - 1), concat('6/30/', @year)) b
                            )
                        )
                    ) B
                ) C
                WHERE C.rank = 1
            ) D;
     INSERT INTO @table4
            SELECT E.SUBSCRIBER_ID, 
                   E.episode_date
            FROM
            (
                SELECT DISTINCT 
                       C.subscriber_id, 
                       C.episode_date
                FROM
                (
                    SELECT DISTINCT 
                           B.SUBSCRIBER_ID, 
                           SEQ_CLAIM_ID, 
                           episode_date, 
                           DENSE_RANK() OVER(PARTITION BY subscriber_id
                           ORDER BY episode_date) AS rank
                    FROM
                    (
                        SELECT A.subscriber_id, 
                               A.SEQ_CLAIM_ID, 
                               A.PRIMARY_SVC_DATE AS episode_date
                        FROM
                        (
                            SELECT DISTINCT 
                                   A.subscriber_id, 
                                   A.SEQ_CLAIM_ID, 
                                   A.PRIMARY_SVC_DATE
                            FROM adw.[tvf_get_claims_w_dates]('ED', '', '', concat('1/1/', @year - 100), concat('6/30/', @year)) a
                                 JOIN adw.[tvf_get_claims_w_dates]('COPD', 'Emphysema', 'Chronic Bronchitis', concat('1/1/', @year - 100), concat('6/30/', @year)) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                        --exclude from den cond. 1 ed that results in inpatient stay: 1. same claim both value set, 2. different claim but same date or 1 day after
                            EXCEPT
                            (
                                SELECT DISTINCT 
                                       A.subscriber_id, 
                                       A.SEQ_CLAIM_ID, 
                                       A.PRIMARY_SVC_DATE
                                FROM adw.[tvf_get_claims_w_dates]('ED', '', '', concat('1/1/', @year - 100), concat('6/30/', @year)) a
                                     JOIN adw.[tvf_get_claims_w_dates]('Inpatient Stay', '', '', concat('1/1/', @year - 100), concat('6/30/', @year)) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                                UNION
                                SELECT DISTINCT 
                                       A.subscriber_id, 
                                       A.SEQ_CLAIM_ID, 
                                       A.PRIMARY_SVC_DATE
                                FROM adw.[tvf_get_claims_w_dates]('ED', '', '', concat('1/1/', @year - 100), concat('6/30/', @year)) a
                                     JOIN adw.[tvf_get_claims_w_dates]('Inpatient Stay', '', '', concat('1/1/', @year - 100), concat('6/30/', @year)) b ON(ABS(DATEDIFF(day, b.ADMISSION_DATE, A.PRIMARY_SVC_DATE)) <= 1)
                                                                                                                                                      AND A.SUBSCRIBER_ID = B.SUBSCRIBER_ID
                                                                                                                                                      AND a.SEQ_CLAIM_ID <> b.SEQ_CLAIM_ID
                            )
                        ) A
                        UNION
                        --Den cond 2: Acute Inpatient Discharge with 3 related lung conditions
                        (
                            SELECT DISTINCT 
                                   A.subscriber_id, 
                                   A.SEQ_CLAIM_ID, 
                                   a.SVC_TO_DATE AS EpisodeDate
                            FROM adw.[tvf_get_claims_w_dates]('Inpatient Stay', '', '', concat('1/1/', @year - 100), concat('6/30/', @year)) a
                                 JOIN adw.[tvf_get_claims_w_dates]('COPD', 'Emphysema', 'Chronic Bronchitis', concat('1/1/', @year - 100), concat('6/30/', @year)) b ON a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
                                 JOIN adw.[tvf_get_claims_w_dates]('Inpatient Stay', '', '', concat('1/1/', @year - 100), concat('6/30/', @year)) c ON a.SUBSCRIBER_ID = c.SUBSCRIBER_ID
                                                                                                                                                   AND a.SEQ_CLAIM_ID <> c.SEQ_CLAIM_ID
                                                                                                                                                   AND a.SVC_TO_DATE <= c.ADMISSION_DATE
                                                                                                                                                   AND ABS(DATEDIFF(day, a.SVC_TO_DATE, c.ADMISSION_DATE)) <= 1
                            WHERE A.SEQ_CLAIM_ID NOT IN
                            (
                                SELECT SEQ_CLAIM_ID
                                FROM adw.[tvf_get_claims_w_dates]('Nonacute Inpatient Stay', '', '', concat('1/1/', @year - 100), concat('6/30/', @year)) b
                            )
                        )
                    ) B
                ) C
                WHERE C.rank = 1
            ) E;
     INSERT INTO @tableden
            SELECT a.*
            FROM @table1 a
                 JOIN
            (
                SELECT DISTINCT 
                       member
                FROM
                (
                    SELECT A.member,
                           CASE
                               WHEN B.IESD_date <= A.prior730day
                               THEN 0
                               ELSE 1
                           END AS is_den
                    FROM @table3 A
                         LEFT JOIN @table4 B ON A.member = B.member
                ) A
                WHERE is_den = 1
            ) b ON a.SUBSCRIBER_ID = b.member;
     DELETE FROM @table1;
     DELETE FROM @table2;
     INSERT INTO @table1
            SELECT DISTINCT 
                   member
            FROM
            (
                SELECT DISTINCT 
                       A.member, 
                       A.IESD_date, 
                (
                    SELECT COUNT(B.SEQ_CLAIM_ID)
                    FROM adw.[tvf_get_claims_w_dates]('Spirometry', '', '', concat('1/1/', @year - 100), concat('6/30/', @year)) B
                    WHERE A.member = B.SUBSCRIBER_ID
                ) AS cnt
                FROM
                (
                    SELECT *
                    FROM
                    (
                        SELECT A.member, 
                               A.IESD_date, 
                               A.prior730day,
                               CASE
                                   WHEN B.IESD_date <= A.prior730day
                                   THEN 0
                                   ELSE 1
                               END AS is_den
                        FROM @table3 A
                             LEFT JOIN @table4 B ON A.member = B.member
                    ) A
                    WHERE is_den = 1
                ) A
            ) Z
            WHERE cnt >= 1;
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
                   @QM, 
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
                   @QM, 
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
                   @QM, 
                   'COP', 
                   @RUNDATE, 
                   @RUNTIME
            FROM @tablecareop;
