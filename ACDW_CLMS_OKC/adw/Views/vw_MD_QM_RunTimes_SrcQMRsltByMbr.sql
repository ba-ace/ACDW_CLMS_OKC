CREATE view adw.vw_MD_QM_RunTimes_SrcQMRsltByMbr
AS 
    /* trys to genereate run time data from qm results */
    SELECT aEnd.QmMeasure, aEnd.QmDate, aBegin.aStartTime, aEnd.aStopTime
        , DATEDIFF(minute, abegin.aStartTime, aEnd.aStopTime) anElapsedTimeEstimate
        , aBegin.QmMeasure AS bgnMeasure, aBegin.QmDate as bgnDate, aBegin.aStartTime as bgnTime 
        , aEnd.QmMeasure as endMeasure , aEnd.QmDate as endDate, aEnd.aStopTime as endTime
    FROM (SELECT h.QmMsrId QmMeasure
    		  , h.QMDate QmDate    
    	       , MAX(H.CreateDate) aStartTime    
    	       , row_NUMBER() OVER (ORDER BY MAX(H.CreateDate)) startAnchor     
    	   FROM [adw].[QM_ResultByMember_History] h
    	   GROUP BY h.QmMsrId , h.QMDate) aBegin
        LEFT JOIN (SELECT 
    		      h.QmMsrId QmMeasure
    		      , h.QMDate QmDate    
    		      , MAX(H.CreateDate) aStopTime        
    		      , (row_NUMBER() OVER (ORDER BY MAX(H.CreateDate)) -1) EndAnchor
    		  FROM [adw].[QM_ResultByMember_History] h
    		  GROUP BY h.QmMsrId , h.QMDate) aEnd 
    			 ON aBegin.startAnchor = aEnd.EndAnchor
    --ORDER BY aEnd.aStopTime asc