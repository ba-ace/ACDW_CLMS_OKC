CREATE PROCEDURE [adw].[Load_Pdw_00_MasterJob]    
AS 
    -- 1.do a backup?
    -- 2.truncate normalized model tables
    -- 3.do setup
    -- 4.execute each table move
    -- 5.validate

    -- 1  Do Initial validation counts and bacup up.
--    EXEC adw.ME_LoadPrep; -- there should be some kind of log of the counts, there should be some kind of error handling 

    -- 2. TRUNCATE Normalized Tables: DO NOT MOVE TO PROC, 
	   -- unless you take the backup with it. 
	   -- Best practice is do not delete with out a backup.     
    TRUNCATE TABLE adw.claims_Details;
    TRUNCATE TABLE adw.Claims_Conditions;
    TRUNCATE TABLE adw.Claims_Diags;
    TRUNCATE TABLE adw.Claims_Procs;
    TRUNCATE TABLE adw.Claims_Member;
    TRUNCATE TABLE adw.Claims_Headers;

    --3. If setup is done already this step could be skipped
    --EXEC adw.Load_Pdw_SetManagementTables;

    -- 4. Execute TABLE moves.
    EXEC adw.Load_Pdw_11_ClmsHeaders;
    EXEC adw.Load_Pdw_12_ClmsDetails;
    EXEC adw.Load_Pdw_13_ClmsProcs;
    EXEC adw.Load_Pdw_14_ClmsDiags;
    EXEC adw.Load_Pdw_15_ClmsMems;
    --EXEC adw.Load_Pdw_20_ClmsHdrsCclf5;
    --EXEC adw.Load_Pdw_21_ClmsDtlsCclf5;
    --EXEC adw.Load_Pdw_22_ClmsDiagsCclf5;

    -- 5. update mbrs assignable
    -- is there a table for member assignable???
    --EXEC adw.InsertMbrEnrFromAssignable 2018, 3; -- year and quarter

    -- 6. Data normalization
    EXEC adw.DataAdj_00_Master;
