﻿CREATE VIEW [adw].[vw_QM_MbrCareOp_Detail_CL_History]
AS
     SELECT co.ClientMemberKey, 
            co.[QMDate], 
            co.QmMsrId, 
            co.MsrDen, 
            co.MsrNum, 
            co.MBR_TYPE, 
            co.MsrDen - co.MsrNum AS MsrCO
     FROM
     (
         SELECT src.ClientMemberKey, 
                src.[QMDate], 
                src.QmMsrId, 
                src.MsrDen, 
                src.MsrNum, 
                m.MBR_TYPE
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
             FROM adw.QM_ResultByMember_History
             GROUP BY ClientMemberKey, 
                      [QMDate], 
                      QmMsrId
         ) src
         JOIN
         (
             SELECT [HICN], 
                    MBR_TYPE
             FROM dbo.[vw_Dashboard_MemberDemographics]
             WHERE ACTIVE = 1 and CURR_DATE =1 
         ) m ON src.ClientMemberKey = m.HICN
     ) co;


