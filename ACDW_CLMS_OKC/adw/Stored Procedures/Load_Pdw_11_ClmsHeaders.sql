
CREATE PROCEDURE [adw].[Load_Pdw_11_ClmsHeaders]
AS   
    
    INSERT INTO [adw].[Claims_Headers]
           (
	   /* Required */
		   [SEQ_CLAIM_ID]		 -- cur clm id								   
           , [SUBSCRIBER_ID]		 -- hicn or EQTBL HCN ???    
		 , [CATEGORY_OF_SVC]		 --           
           , [ICD_PRIM_DIAG]		 -- prncpl_dgns_cd
           , [PRIMARY_SVC_DATE]	 --            
           , SVC_TO_DATE			             
		 , [CLAIM_THRU_DATE]           		
		 , [SVC_PROV_NPI]
		 , [PROV_SPEC]
		 , [PROV_TYPE]                                            
           , [DRG_CODE] 
		 ,  ADMISSION_DATE
		 ,  PATIENT_STATUS
		 , [CLAIM_STATUS]                      
		 , [CLAIM_TYPE]           
		 , [TOTAL_BILLED_AMT]
		 , LoadDate
		 , VENDOR_ID    		           		  
		 , [SVC_PROV_ID]
	   /* Optional */
		  , [CLAIM_NUMBER]		 -- put composit key in here           
		  , [PAT_CONTROL_NO]
		  , [ATT_PROV_NPI]        		        		  
	   /* Not Required */
		  , [POST_DATE]
            , [CHECK_DATE]
            , [CHECK_NUMBER]
            , [DATE_RECEIVED]
            , [ADJUD_DATE]            
            , [SVC_PROV_FULL_NAME]
            , [PROVIDER_PAR_STAT]
            , [ATT_PROV_ID]
            , [ATT_PROV_FULL_NAME]
            , [REF_PROV_ID]
            , [REF_PROV_FULL_NAME]
            , [VEND_FULL_NAME]
            , [IRS_TAX_ID]
            , [BILL_TYPE]
            , [AUTH_NUMBER]
            , ADMIT_SOURCE_CODE
            , [ADMIT_HOUR]
            , [DISCHARGE_HOUR]
            , [PROCESSING_STATUS]            
	   /* Ace Created */
           )
     SELECT 
	  /* Required */
	   ch.ICN						/* seq_claim_id		   */
	   ,ch.SAK_RECIP				/* SUBSCRIBER_ID		   */
	   , s.State_Category_of_Service	/* CATEGORY_OF_SVC		   */
        , di.ICD9_Diagnosis_Code		/* ICD PRIM DIAG		   */
        , (SELECT MIN(s.First_Date_Of_Service) prim_Svc_date FROM  adi.OKC_Services s WHERE s.ICN = ch.icn)  as PrimarySvcDate
								/* PRIMARY_SVC_DATE		   */
        , (SELECT Max(s.Last_Date_Of_Service) svcToDate FROM  adi.OKC_Services s WHERE s.ICN = ch.icn) as SvcToDate-- what is I??? Last Date of SVC --  svc_to_date		
	   , (SELECT MAX(s.First_Date_Of_Service) ClaimThruDate FROM  adi.OKC_Services s WHERE s.ICN = ch.icn) as ClaimThruDate --DO NOT USE --CLAIM_THRU_DATE	   										
	   , p.Billing_Provider_NPI								--  svc_Prov_Npi
	   , CONVERT(VARCHAR(20), p.Specialty_Primary) ProvSpec		--  PROV_SPEC	   
	   , CONVERT(VARCHAR(20),p.Provider_Type) AS ProvType     --  PROV_TYPE
        , ch.[DRG_CODE]				--  DRG_CODE
	   , CASE WHEN ch.Claim_Type  = 'I' THEN 
			 (SELECT MIN(s.First_Date_Of_Service) prim_Svc_date FROM  adi.OKC_Services s WHERE s.ICN = ch.icn)  
			 ELSE NULL END as AdmissionDate --	Admission Date If claim type inpateint, use calc Primary svc Date 
	   , ch.[PATIENT_STATUS]			--  PATIENT_STATUS
	   , 'P'		ClaimStatus		--  CLAIM_STATUS            
	   , ch.Claim_Type          	 --  CLAIM_TYPE   
	   , tBillAmt.tBillAmt		 --  TOTAL_BILLED_AMT sum services Billed amount*/
	   , ch.LoadDate			 --  LoadDate
	   , p.Billing_Provider_NPI AS VENDOR_ID   -- if vendor id is null, default svc_provider_id or svc_provider_NPI           	   		
	   , p.Billing_Provider_NPI AS [SVC_PROV_ID]		-- if null, then svc_prov_NPI, OR BillingProvNPI
	 /* Optional */
	   , '' AS [CLAIM_NUMBER]		 -- put composit key in here           
	   , '' AS [PAT_CONTROL_NO]
	   , '' AS [ATT_PROV_NPI]     
    /* Not Required */		  
	   , NULL as [POST_DATE]
        , NULL as [CHECK_DATE]
        , NULL as [CHECK_NUMBER]
        , NULL as [DATE_RECEIVED]
        , NULL as [ADJUD_DATE]        
        , NULL as [SVC_PROV_FULL_NAME]
        , NULL as [PROVIDER_PAR_STAT]
        , NULL as [ATT_PROV_ID]
        , NULL as [ATT_PROV_FULL_NAME]
        , NULL as [REF_PROV_ID]
        , NULL as [REF_PROV_FULL_NAME]
        , NULL as [VEND_FULL_NAME]
        , NULL as [IRS_TAX_ID]
        , NULL as [BILL_TYPE]
        , NULL as [AUTH_NUMBER]
        , NULL as [ADMIT_SOURCE_CODE]
        , NULL as [ADMIT_HOUR]
        , NULL as [DISCHARGE_HOUR]
        , NULL as [PROCESSING_STATUS]          	
    /* Ace Created */

    FROM  adi.OKC_Claims ch
	   JOIN (SELECT ch.OKC_ClaimKey
			 , row_NUmber() OVER (PARTITION BY ch.ICN ORDER BY ch.OKC_ClaimKey DESC) AS arn
			 FROM adi.OKC_Claims ch) claimsDeDuplicated ON ch.OKC_ClaimKey = claimsDeDuplicated.OKC_ClaimKey
				and claimsDeDuplicated.arn = 1
	   LEFT JOIN (select s.OKC_ServicesKey, s.icn, s.detail_number, s.provider_id, s.State_Category_of_Service
				, row_NUMBER() OVER (PARTITION BY s.ICN, s.Detail_Number ORDER BY s.LoadDate DESC, s.OKC_ServicesKey desc) arn
				FROM adi.OKC_Services s) s ON ch.ICN = s.ICN and s.Detail_Number = 1 and s.arn = 1
	   LEFT JOIN (SELECT p.OKC_ProviderInfoKey, p.Billing_Provider_NPI, p.Specialty_Primary, p.Provider_Type, p.Provider_ID	   
				, ROW_NUMBER() OVER (PARTITION BY p.PROVIDER_ID ORDER BY p.LoadDate desc, p.Okc_ProviderInfoKey desc) arn
				FROM adi.OKC_ProviderInfo p) p ON s.Provider_ID = p.Provider_ID	and p.arn = 1
	   LEFT JOIN (SELECT CONVERT(MONEY, SUM(ISNULL(s.Billed_Amount,0.00))) tBillAmt, ICN 
				FROM adi.[OKC_Services] s
				GROUP BY ICN/*, detail_number*/) AS tBillAmt ON ch.ICN = tBillAmt.ICN
	   LEFT JOIN (SELECT di.OKC_DIAGNOSISKEY, di.ICN, 
				    CASE WHEN (di.Diagnosis_Sequence = 'A') THEN 0 
					    WHEN (di.Diagnosis_Sequence = 'E') THEN 999
						  ELSE di.Diagnosis_Sequence 
						  END as Diagnosis_Sequence
				    , di.SAK_RECIP, di.ICD9_Diagnosis_Code 
				    , row_number() OVER (PARTITION BY di.ICN, di.DIagnosis_Sequence ORDER BY di.Loaddate DESC, di.Okc_DiagnosisKey DESC) arn
				    FROM adi.OKC_ICD9_Diagnosis di
				    WHERE di.Diagnosis_Sequence = '1') di ON ch.ICN = di.ICN and di.arn = 1;
	   
SELECT h.SEQ_CLAIM_ID, h.CATEGORY_OF_SVC
    , CASE WHEN (h.Category_of_svc = 'D') THEN 'DENTAL'
	   WHEN (h.Category_of_svc = 'I') THEN 'INPATIENT'
	   WHEN (h.Category_of_svc = 'M') THEN 'PHYSICIAN'
	   WHEN (h.Category_of_svc = 'O') THEN 'OUTPATIENT'
	   WHEN (h.Category_of_svc = 'P') THEN 'PHARMACY'
	   END  AS NewCatSvc
FROM adw.Claims_Headers h
where h.CATEGORY_OF_SVC in ('D', 'I', 'M', 'O', 'P');


	   
SELECT top 1 s.*
FROM adi.[OKC_Services] s