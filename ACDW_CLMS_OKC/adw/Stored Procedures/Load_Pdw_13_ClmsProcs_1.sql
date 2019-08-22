
CREATE PROCEDURE [adw].[Load_Pdw_13_ClmsProcs]
AS
    INSERT INTO [adw].[Claims_Procs]
               (
	   /* Required */
			   SEQ_CLAIM_ID
			 , SUBSCRIBER_ID
			 , ProcNumber
			 , ProcCode
			 , ProcDate
			
	   /* Optional */
	   /* Not Required */
	   /* Ace Created */
			 , LoadDate
			)
    SELECT 
	   /* REQUIRED */
		cp.ICN				 AS SEQ_CLAIM_ID
        , cp.SAK_RECIP			 AS subscriberID
        , cp.Procedure_Sequence	 AS ProcNum
        , cp.ICD9_Procedure_Code	 AS ProcCode
        , NULL					 AS ProcDate	-- no idea how to derive this from services
	   /* Optional */
	   /* Not Required */
	   /* Ace Created */
	   , cp.LoadDate
    FROM adi.OKC_ICD9_Procedure cp
	   

--        JOIN ast.pstCclfClmKeyList ck ON ck.PRVDR_OSCAR_NUM  = cp.PRVDR_OSCAR_NUM
--    		  AND ck.BENE_EQTBL_BIC_HICN_NUM	    = cp.BENE_EQTBL_BIC_HICN_NUM
--    		  AND ck.CLM_FROM_DT			    = cp.CLM_FROM_DT
--    		  and ck.CLM_THRU_DT			    = cp.CLM_THRU_DT
--        JOIN ast.pstcPrcDeDupUrns  dd ON cp.urn = dd.urn
--        JOIN ast.pstLatestEffectiveClmsHdr lr ON ck.ClmsKey = lr.clmSKey
        --JOIN adi.OKC_Claims ch ON cp.ICN = ch.ICN
    ORDER BY cp.ICN, cp.Procedure_Sequence;
