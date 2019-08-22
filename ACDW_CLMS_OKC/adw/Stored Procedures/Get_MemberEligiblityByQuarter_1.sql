

CREATE PROCEDURE [adw].[Get_MemberEligiblityByQuarter]
AS
    -- creates member by quarter data to allow calculation of MLR in dashboards.
     TRUNCATE TABLE adi.MemberEligiblityByQuarter;
     INSERT INTO adi.MemberEligiblityByQuarter
     (year, 
      quarter, 
      hicn, 
      plans
     )
            SELECT DISTINCT 
                   year, 
                   quarter, 
                   sak_recip AS hicn, 
                   plans
            FROM
            (
                SELECT year,
                       CASE
                           WHEN month IN(1, 2, 3)
                           THEN '1'
                           WHEN month IN(4, 5, 6)
                           THEN '2'
                           WHEN month IN(7, 8, 9)
                           THEN '3'
                           WHEN month IN(10, 11, 12)
                           THEN '4'
                           ELSE NULL
                       END AS quarter, 
                       CAST(CAST(year AS VARCHAR(4)) + '-' + CAST(month AS VARCHAR(4)) + '-01' AS DATE) AS date
                FROM
                (
                    SELECT DISTINCT 
                           YEAR(primary_svc_date) AS year
                    FROM adw.claims_headers
                    WHERE YEAR(primary_svc_date) IS NOT NULL
                ) a
                JOIN
                (
                    SELECT DISTINCT 
                           MONTH(primary_svc_date) AS month
                    FROM adw.claims_headers
                    WHERE MONTH(primary_svc_date) IS NOT NULL
                ) b ON 1 = 1
            ) a
            JOIN
            (
                SELECT e.SAK_RECIP, 
                       e.eligibility_code AS plans, 
                       e.Eligibility_Effective_Date AS startdate, 
                       e.Eligibility_End_Date AS enddate
                FROM adi.OKC_Eligibility e
            ) b ON a.date BETWEEN b.startdate AND b.enddate;