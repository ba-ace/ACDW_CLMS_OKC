


CREATE VIEW [adw].[vw_AllMbrDetail_LastAWVVisit]
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
                         svc_prov_npi DESC) AS rank

         FROM (select * from [dbo].[tvf_get_claims_w_dates_5opt]('Well-Care','','','','','01/01/1900','12/31/2019') )a
     ) a
     WHERE rank = 1; 
