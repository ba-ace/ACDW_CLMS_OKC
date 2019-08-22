


CREATE VIEW [adw].[z_vw_ActiveMember_ProviderPracticeProfile]
AS
     SELECT DISTINCT 
            a.hicn, 
            a.Mbr_Type, 
            a.dob, 
            a.Sex, 
            a.LastName, 
            a.FirstName, 
            a.MBR_QTR, 
            a.mbr_year, 
            b.npi AS PCP_NPI, 
            b.PCP_NAME AS PCP_NPI_NAME, 
            b.prim_specialty AS PCP_SPEC, 
            b.tin AS PCP_TIN, 
            b.TIN_NAME AS PCP_TINNAME, 
            c.npi AS BLANK_NPI, 
            c.PCP_NAME AS BLANK_NPI_NAME, 
            c.PRIM_SPECIALTY AS BLANK_SPEC, 
            c.tin AS BLANK_TIN, 
            c.TIN_NAME AS BLANK_TINNAME, 
            d.NPI AS SPL_NPI, 
            d.PCP_NAME AS SPL_NPI_NAME, 
            d.PRIM_SPECIALTY AS SPL_SPEC, 
            d.tin AS SPL_TIN, 
            d.TIN_NAME AS SPL_TINNAME
     FROM adw.tmp_Active_Members a
          LEFT JOIN
     (
         SELECT *
         FROM
         (
             SELECT DISTINCT 
                    a.hicn, 
                    a.NPI, 
                    b.PCP_NAME, 
                    b.PRIM_SPECIALTY, 
                    c.TIN, 
                    c.TIN_NAME, 
                    c.PCSVS, 
                    ROW_NUMBER() OVER(PARTITION BY a.hicn
                    ORDER BY c.pcsvs DESC, 
                             c.tin DESC, 
                             a.npi DESC) AS rank
             FROM
             (
                 SELECT *
                 FROM adw.[Member_Provider_History] a
                 WHERE a.mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                       AND a.mbr_qtr =
                 (
                     SELECT MAX(mbr_qtr)
                     FROM adw.[Member_Provider_History]
                     WHERE mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                 )
             ) a
             LEFT JOIN
             (
                 SELECT DISTINCT 
                        pcp_npi, 
                        PRIM_SPECIALTY, 
                        concat(PCP_LAST_NAME, ', ', PCP_FIRST_NAME) AS PCP_NAME
                 FROM lst.[LIST_PCP]
             ) b ON a.npi = b.PCP_NPI
             LEFT JOIN
             (
                 SELECT *
                 FROM adw.[Member_Practice_History] a
                 WHERE a.mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                       AND a.mbr_qtr =
                 (
                     SELECT MAX(mbr_qtr)
                     FROM adw.[Member_Provider_History]
                     WHERE mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                 )
             ) c ON a.tin = c.tin
                    AND a.hicn = c.hicn
             WHERE prim_specialty = 'PCP - Primary Care Physician'
         ) z
         WHERE rank = 1
     ) b ON a.hicn = b.hicn
          LEFT JOIN
     (
         SELECT *
         FROM
         (
             SELECT DISTINCT 
                    a.hicn, 
                    a.NPI, 
                    b.PCP_NAME, 
                    b.PRIM_SPECIALTY, 
                    c.TIN, 
                    c.TIN_NAME, 
                    c.PCSVS, 
                    ROW_NUMBER() OVER(PARTITION BY a.hicn
                    ORDER BY c.pcsvs DESC, 
                             c.tin DESC, 
                             a.npi DESC) AS rank
             FROM
             (
                 SELECT *
                 FROM adw.[Member_Provider_History] a
                 WHERE a.mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                       AND a.mbr_qtr =
                 (
                     SELECT MAX(mbr_qtr)
                     FROM adw.[Member_Provider_History]
                     WHERE mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                 )
             ) a
             LEFT JOIN
             (
                 SELECT DISTINCT 
                        pcp_npi, 
                        PRIM_SPECIALTY, 
                        concat(PCP_LAST_NAME, ', ', PCP_FIRST_NAME) AS PCP_NAME
                 FROM lst.[LIST_PCP]
             ) b ON a.npi = b.PCP_NPI
             LEFT JOIN
             (
                 SELECT *
                 FROM adw.[Member_Practice_History] a
                 WHERE a.mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                       AND a.mbr_qtr =
                 (
                     SELECT MAX(mbr_qtr)
                     FROM adw.[Member_Provider_History]
                     WHERE mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                 )
             ) c ON a.tin = c.tin
                    AND a.hicn = c.hicn
             WHERE prim_specialty in (NULL, '')
         ) z
         WHERE rank = 1
     ) c ON a.hicn = c.hicn
          LEFT JOIN
     (
         SELECT *
         FROM
         (
             SELECT DISTINCT 
                    a.hicn, 
                    a.NPI, 
                    b.PCP_NAME, 
                    b.PRIM_SPECIALTY, 
                    c.TIN, 
                    c.TIN_NAME, 
                    c.PCSVS, 
                    ROW_NUMBER() OVER(PARTITION BY a.hicn
                    ORDER BY c.pcsvs DESC, 
                             c.tin DESC, 
                             a.npi DESC) AS rank
             FROM
             (
                 SELECT *
                 FROM adw.[Member_Provider_History] a
                 WHERE a.mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                       AND a.mbr_qtr =
                 (
                     SELECT MAX(mbr_qtr)
                     FROM adw.[Member_Provider_History]
                     WHERE mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                 )
             ) a
             LEFT JOIN
             (
                 SELECT DISTINCT 
                        pcp_npi, 
                        PRIM_SPECIALTY, 
                        concat(PCP_LAST_NAME, ', ', PCP_FIRST_NAME) AS PCP_NAME
                 FROM lst.[LIST_PCP]
             ) b ON a.npi = b.PCP_NPI
             LEFT JOIN
             (
                 SELECT *
                 FROM adw.[Member_Practice_History] a
                 WHERE a.mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                       AND a.mbr_qtr =
                 (
                     SELECT MAX(mbr_qtr)
                     FROM adw.[Member_Provider_History]
                     WHERE mbr_year = (
                     SELECT MAX(mbr_year)
                     FROM adw.[Member_Provider_History]
                 )
                 )
             ) c ON a.tin = c.tin
                    AND a.hicn = c.hicn
             WHERE prim_specialty NOT IN('', NULL,'PCP - Primary Care Physician')
         ) z
         WHERE rank = 1
     ) d ON a.hicn = d.hicn;

