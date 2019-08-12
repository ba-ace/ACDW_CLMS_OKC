CREATE VIEW adw.[vw_QM_CareGap_By_Mbr_CL]
AS
     SELECT ClientMemberKey AS HICN, 
            Mbr_Type, 
            QmMsrID AS CGQM, 
            1 AS CntCG
     FROM adw.vw_QM_MbrCareOp_Detail_CL
     WHERE(MsrCO = 1);
