


/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[vw_Dashboard_utilization]
AS
     SELECT [MBI], 
            [HICN], 
            [FirstName], 
            [LastName], 
            [Sex], 
            [DOB], 
            a.[MBR_YEAR], 
            a.[MBR_QTR], 
     (
         SELECT COUNT(DISTINCT b.[HICN])
         FROM vw_Dashboard_MemberDemographics b
         WHERE b.npi = a.npi
               AND b.MBR_YEAR = a.MBR_YEAR
     ) AS yr_uniq_npi_mbr_cnt, 
            [TIN], 
            [TIN_NAME], 
            [NPI], 
            [NPI_NAME], 
            utilization_type, 
            b.SEQ_CLAIM_ID, 
            b.PRIMARY_SVC_DATE, 
            b.SVC_PROV_NPI,
			b.ADMISSION_DATE,
			b.SVC_TO_DATE
     FROM vw_Dashboard_MemberDemographics a
          LEFT JOIN
     (
         SELECT *, 
                YEAR(PRIMARY_SVC_DATE) AS MBR_YEAR,
                CASE
                    WHEN MONTH(primary_svc_date) IN(1, 2, 3)
                    THEN 1
                    WHEN MONTH(primary_svc_date) IN(4, 5, 6)
                    THEN 2
                    WHEN MONTH(primary_svc_date) IN(7, 8, 9)
                    THEN 3
                    WHEN MONTH(primary_svc_date) IN(10, 11, 12)
                    THEN 4
                    ELSE NULL
                END AS MBR_QTR, 
                'ER' AS utilization_type
         FROM adw.[vw_AllMbrDetail_ERVisit]
     ) b ON a.HICN = b.SUBSCRIBER_ID
            AND a.MBR_QTR = b.MBR_QTR
            AND a.MBR_YEAR = b.MBR_YEAR
     UNION
     SELECT [MBI], 
            [HICN], 
            [FirstName], 
            [LastName], 
            [Sex], 
            [DOB], 
            a.[MBR_YEAR], 
            a.[MBR_QTR], 
     (
         SELECT COUNT(DISTINCT b.[HICN])
         FROM vw_Dashboard_MemberDemographics b
         WHERE b.npi = a.npi
               AND b.MBR_YEAR = a.MBR_YEAR
     ) AS yr_uniq_npi_mbr_cnt, 
            [TIN], 
            [TIN_NAME], 
            [NPI], 
            [NPI_NAME], 
            utilization_type, 
            b.SEQ_CLAIM_ID, 
            b.PRIMARY_SVC_DATE, 
            b.SVC_PROV_NPI,
			b.ADMISSION_DATE,
			b.SVC_TO_DATE
     FROM vw_Dashboard_MemberDemographics a
          LEFT JOIN
     (
         SELECT *, 
                YEAR(PRIMARY_SVC_DATE) AS MBR_YEAR,
                CASE
                    WHEN MONTH(primary_svc_date) IN(1, 2, 3)
                    THEN 1
                    WHEN MONTH(primary_svc_date) IN(4, 5, 6)
                    THEN 2
                    WHEN MONTH(primary_svc_date) IN(7, 8, 9)
                    THEN 3
                    WHEN MONTH(primary_svc_date) IN(10, 11, 12)
                    THEN 4
                    ELSE NULL
                END AS MBR_QTR, 
                'IP' AS utilization_type
         FROM adw.[vw_AllMbrDetail_IPVisit]
     ) b ON a.HICN = b.SUBSCRIBER_ID
            AND a.MBR_QTR = b.MBR_QTR
            AND a.MBR_YEAR = b.MBR_YEAR
     UNION
     SELECT [MBI], 
            [HICN], 
            [FirstName], 
            [LastName], 
            [Sex], 
            [DOB], 
            a.[MBR_YEAR], 
            a.[MBR_QTR], 
     (
         SELECT COUNT(DISTINCT b.[HICN])
         FROM vw_Dashboard_MemberDemographics b
         WHERE b.npi = a.npi
               AND b.MBR_YEAR = a.MBR_YEAR
     ) AS yr_uniq_npi_mbr_cnt, 
            [TIN], 
            [TIN_NAME], 
            [NPI], 
            [NPI_NAME], 
            utilization_type, 
            b.SEQ_CLAIM_ID, 
            b.PRIMARY_SVC_DATE, 
            b.SVC_PROV_NPI,
			b.ADMISSION_DATE,
			b.SVC_TO_DATE
     FROM vw_Dashboard_MemberDemographics a
          LEFT JOIN
     (
         SELECT *, 
                YEAR(PRIMARY_SVC_DATE) AS MBR_YEAR,
                CASE
                    WHEN MONTH(primary_svc_date) IN(1, 2, 3)
                    THEN 1
                    WHEN MONTH(primary_svc_date) IN(4, 5, 6)
                    THEN 2
                    WHEN MONTH(primary_svc_date) IN(7, 8, 9)
                    THEN 3
                    WHEN MONTH(primary_svc_date) IN(10, 11, 12)
                    THEN 4
                    ELSE NULL
                END AS MBR_QTR, 
                'PCP' AS utilization_type
         FROM adw.[vw_AllMbrDetail_PCPVisit]
     ) b ON a.HICN = b.SUBSCRIBER_ID
            AND a.MBR_QTR = b.MBR_QTR
            AND a.MBR_YEAR = b.MBR_YEAR

	
