CREATE VIEW [adw].[vw_Dashboard_Sub_QM_MbrCareOp_Detail_CL]
AS
     SELECT co.ClientMemberKey, 
       co.[QMDate], 
       co.QmMsrID, 
       co.MsrDen, 
       co.MsrNum, 
       co.Mbr_Type, 
       co.MsrDen - co.MsrNum AS MsrCO
FROM
(
    SELECT src.ClientMemberKey, 
           src.[QMDate], 
           src.QmMsrId, 
           src.MsrDen, 
           src.MsrNum, 
           m.Mbr_Type
    FROM
    (
        SELECT ClientMemberKey, 
               [QMDate], 
               QmMsrId,
               CASE
                   WHEN SUM(CASE
                                WHEN(QmCntCat = 'DEN')
                                THEN 1
                                ELSE 0
                            END) >= 1
                   THEN 1
                   ELSE 0
               END AS MsrDen,
               CASE
                   WHEN SUM(CASE
                                WHEN(QmCntCat = 'NUM')
                                THEN 1
                                ELSE 0
                            END) >= 1
                   THEN 1
                   ELSE 0
               END AS MsrNum
        FROM adw.QM_ResultByMember_CL
        GROUP BY ClientMemberKey, 
                 [QMDate], 
                 QmMsrId
    ) src
    JOIN
    (
        SELECT [HICN], 
               [Mbr_Type]
        FROM adw.tmp_active_members
        WHERE Exclusion = 'N'
              AND [plan] <> ''
    ) m ON src.ClientMemberKey = m.HICN
) co;
