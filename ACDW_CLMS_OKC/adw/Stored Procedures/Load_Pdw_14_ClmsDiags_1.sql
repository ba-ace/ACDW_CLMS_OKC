
CREATE PROCEDURE [adw].[Load_Pdw_14_ClmsDiags]
AS  
    INSERT INTO [adw].[Claims_Diags]
           (
	   /* Required */
		    SEQ_CLAIM_ID
		  , SUBSCRIBER_ID
		  , ICD_FLAG
		  , diagNumber		 
		  , diagCode		  
		  , diagPoa
		  
	/* Optional */
    /* Not Required */
    /* Ace Created */
		  , LoadDate
		 )
    SELECT 
    /* Required */
		cd.ICN						   AS SEQ_CLAIM_ID
        , cd.SAK_RECIP					   AS subscriberID
	   , NULL							   AS ICD_FLAG		
        ,CASE WHEN (cd.Diagnosis_Sequence = 'A') then 0 
		  WHEN (cd.Diagnosis_Sequence = 'E') THEN 999
		  ELSE CONVERT(smallINt, cd.Diagnosis_Sequence) 
		  END						   AS DiagNum                
        , cd.ICD9_Diagnosis_Code			   as diagCode		
        , NULL							   as diagPoa		
	   
	   /* Optional */
	   /* Not Required */
	   /* Ace Created */
	   , cd.LoadDate			 
    FROM adi.OKC_ICD9_Diagnosis cd
--        JOIN ast.pstCclfClmKeyList ck ON ck.PRVDR_OSCAR_NUM  = cp.PRVDR_OSCAR_NUM
--				    AND ck.BENE_EQTBL_BIC_HICN_NUM	    = cp.BENE_EQTBL_BIC_HICN_NUM
--				    AND ck.CLM_FROM_DT			    = cp.CLM_FROM_DT
--				    and ck.CLM_THRU_DT			    = cp.CLM_THRU_DT
--        JOIN ast.pstcDgDeDupUrns  dd ON cp.urn = dd.urn
--        JOIN ast.pstLatestEffectiveClmsHdr lr ON ck.ClmsKey = lr.clmSKey
        JOIN adi.OKC_Claims ch ON cd.ICN = ch.ICN
    ORDER BY cd.ICN, DiagNum;
        
       