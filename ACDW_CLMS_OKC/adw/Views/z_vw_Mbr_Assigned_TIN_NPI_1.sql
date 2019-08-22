CREATE VIEW adw.[z_vw_Mbr_Assigned_TIN_NPI]
AS 
     --if pcp exist use it , if there are multiple pcp then use max npi 
     --if pcp doesn't exist use blank, if multiple blank then use max npi 
     --if pcp doesn't exist and blank doesn't exist then use specialist, if multiple specialist then use max npi
     SELECT [HICN], 
            [FirstName], 
            [LastName], 
            [Sex], 
            [DOB], 
            [TIN], 
            [TIN_NAME], 
            [NPI], 
            [NPI_NAME], 
            [MBR_YEAR], 
            [MBR_QTR], 
            1 AS [match_npi], 
            1 AS [rank], 
            1 AS [ranks]
     FROM
     (
         SELECT DISTINCT 
                HICN, 
                MBR_TYPE, 
                DOB, 
                SEX, 
                LASTNAME, 
                FIRSTNAME, 
                MBR_QTR, 
                MBR_YEAR,
                CASE
                    WHEN PCP_NPI IS NOT NULL
                    THEN PCP_NPI
                    WHEN BLANK_NPI IS NOT NULL
                    THEN BLANK_NPI
                    ELSE SPL_NPI
                END AS NPI,
                CASE
                    WHEN PCP_NPI_NAME IS NOT NULL
                    THEN PCP_NPI_NAME
                    WHEN BLANK_NPI_NAME IS NOT NULL
                    THEN BLANK_NPI_NAME
                    ELSE SPL_NPI_NAME
                END AS NPI_NAME,
                CASE
                    WHEN PCP_TIN IS NOT NULL
                    THEN PCP_TIN
                    WHEN BLANK_TIN IS NOT NULL
                    THEN BLANK_TIN
                    ELSE SPL_TIN
                END AS TIN,
                CASE
                    WHEN PCP_TINNAME IS NOT NULL
                    THEN PCP_TINNAME
                    WHEN BLANK_TINNAME IS NOT NULL
                    THEN BLANK_TINNAME
                    ELSE SPL_TINNAME
                END AS TIN_NAME
         FROM adw.[Vw_Activemember_ProviderPracticeProfile]
         WHERE MBR_TYPE = 'A'
     ) A;
