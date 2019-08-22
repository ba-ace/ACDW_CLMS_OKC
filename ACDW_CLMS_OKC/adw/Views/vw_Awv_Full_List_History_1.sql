
CREATE VIEW [adw].[vw_Awv_Full_List_History]
AS
     SELECT hicn, 
            first_name, 
            last_name, 
            sex, 
            dob, 
            mbr_type, 
            aco_npi AS NPI, 
            concat(d.PCP_LAST_NAME, ', ', d.PCP_FIRST_NAME) AS NPI_NAME, 
            run_mth, 
            RUN_YEAR
     FROM adw.[Member_Unassigned_AWV_History] a
          LEFT JOIN lst.LIST_PCP d ON a.ACO_NPI = d.PCP_NPI
     WHERE hicn IN
     (
         SELECT hicn
         FROM [tmp_Active_Members]
         WHERE exclusion = 'N'
     )
     UNION
     SELECT hicn, 
            first_name, 
            last_name, 
            sex, 
            dob, 
            'A' AS mbr_type, 
            NPI, 
            NPI_NAME, 
            RUN_MTH, 
            RUN_YEAR
     FROM adw.[Member_Assigned_AWV_History]
     WHERE hicn IN
     (
         SELECT hicn
         FROM adw.[tmp_Active_Members]
         WHERE exclusion = 'N'
     );
