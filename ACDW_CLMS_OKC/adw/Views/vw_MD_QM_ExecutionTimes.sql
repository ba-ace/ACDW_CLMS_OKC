 create view adw.vw_MD_QM_ExecutionTimes
 AS 
    SELECT h.QmMsrId, h.QMDate, max(h.CreateDate) finishTime
    FROM adw.QM_ResultByMember_History h
    --WHERE h.QMDate >= '01/01/2019'
    GROUP BY h.QmMsrId, h.QMDate
    --order by h.QmMsrId asc, h.QMDate asc, max(h.CreateDate) desc
