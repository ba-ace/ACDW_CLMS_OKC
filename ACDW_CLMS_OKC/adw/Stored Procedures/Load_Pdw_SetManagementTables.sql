﻿
/* Process pdw */
CREATE PROCEDURE [adw].[Load_Pdw_SetManagementTables]
AS
    -- 1. Get unique list of the claims Header 
    EXEC adw.Load_Pdw_01_DeDupClmsHdr;
    -- 2. Create a SKey for the Claims Headers, this is used to join all of the other entities.
    EXEC adw.Load_Pdw_02_ClmsKeyList;
    -- 3. Get latest Header for a specific claim.
    EXEC adw.Load_Pdw_03_LatestEffectiveClmsHeader;
    -- 4. de dup claims details
    EXEC adw.Load_Pdw_04_DeDupClmsLns
    -- 5. de dup procedures
    EXEC adw.Load_Pdw_05_DeDupClmsProcs;
    -- de dup diags
    EXEC adw.Load_Pdw_06_DeDupClmsDiags;
    -- de dup the Professional claims
    EXEC adw.Load_Pdw_07_DeDupCclf5;
