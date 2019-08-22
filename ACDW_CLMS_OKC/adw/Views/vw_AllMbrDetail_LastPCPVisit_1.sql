

CREATE VIEW [adw].[vw_AllMbrDetail_LastPCPVisit]
AS
     SELECT *
     FROM
     (
         SELECT DISTINCT 
                a.SUBSCRIBER_ID, 
                a.[SVC_PROV_NPI], 
          (
             SELECT max(b.LBN_Name)
             FROM lst.LIST_NPPES b
             WHERE b.NPI = a.SVC_PROV_NPI
         ) AS LBN,
                a.PRIMARY_SVC_DATE AS SVC_DATE, 
                row_number() OVER(PARTITION BY subscriber_id
                ORDER BY primary_svc_date DESC, 
                         aco_npi DESC) AS rank

         FROM adw.[vw_AllMbrDetail_PCPVisit] a
     ) a
     WHERE rank = 1; 
