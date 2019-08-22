
CREATE VIEW [adw].[vw_Mbr_Assigned_TIN_NPI_ALL]
AS
     SELECT a.HICN, 
       a.FirstName, 
       a.LastName, 
       a.Sex, 
       a.DOB, 
       a.TIN, 
       a.TIN_NAME, 
       a.NPI, 
       a.NPI_NAME, 
       a.MBR_YEAR, 
       a.MBR_QTR, 
       a.match_npi, 
       a.rank
    FROM
    (
        SELECT a.HICN, 
               a.FirstName, 
               a.LastName, 
               a.Sex, 
               a.DOB, 
               a.TIN, 
               a.TIN_NAME, 
               b.NPI, 
               b.NPI_NAME, 
               a.MBR_YEAR, 
               a.MBR_QTR,
               CASE
                   WHEN b.NPI_name IS NULL
                   THEN 0
                   ELSE 1
               END AS match_npi, 
               ROW_NUMBER() OVER(PARTITION BY a.hicn, 
                                              a.mbr_year, 
                                              a.mbr_qtr
               ORDER BY CASE
                            WHEN b.NPI_name IS NULL
                            THEN 0
                            ELSE 1
                        END DESC, 
                        a.PCSVS DESC, 
                        a.tin DESC, 
                        b.npi DESC) AS rank
        FROM adw.[Member_Practice_History] a
             LEFT JOIN
        (
            SELECT mph.TIN, 
                   mph.TIN_NAME, 
                   mph.NPI, 
                   mph.NPI_NAME, 
                   mph.HICN, 
                   mph.MBR_YEAR, 
                   mph.MBR_QTR
            FROM adw.[Member_Provider_History] mph
        ) b ON a.hicn = b.hicn
               AND a.mbr_year = b.MBR_YEAR
               AND a.mbr_Qtr = b.MBR_QTR
    ) a
    WHERE rank = 1;
