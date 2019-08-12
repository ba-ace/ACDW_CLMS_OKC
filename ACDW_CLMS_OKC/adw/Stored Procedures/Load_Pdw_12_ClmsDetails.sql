CREATE PROCEDURE [adw].[Load_Pdw_12_ClmsDetails]
AS 
    -- INSERT Service Details
    INSERT INTO adw.Claims_Details
		  (
		  /* Required Fields */
		   seq_Claim_ID,
		   line_Number,
		   SUB_LINE_CODE,
		   DETAIL_SVC_DATE,
		   SVC_TO_DATE,
		   PROCEDURE_CODE,               
		   MODIFIER_CODE_1,
		   MODIFIER_CODE_2,
		   MODIFIER_CODE_3,
		   MODIFIER_CODE_4,
		   REVENUE_CODE,
		   PLACE_OF_SVC_CODE1,
		   PLACE_OF_SVC_CODE2,
		   PLACE_OF_SVC_CODE3,
		   QUANTITY,
		   Paid_amt,		   
		   NDC_CODE,                     
		   
		  /* Optional */
		   claim_number,
		   BILLED_AMT,             
		   RX_GENERIC_BRAND_IND,         
		   RX_SUPPLY_DAYS,               
		   RX_DISPENSING_FEE_AMT,        
		   RX_INGREDIENT_AMT,            
		   RX_FORMULARY_IND,             
		   RX_DATE_PRESCRIPTION_WRITTEN, 
		   BRAND_NAME,                   
		   DRUG_STRENGTH_DESC,           
		   GPI,                          
		   GPI_DESC,                     
		   CONTROLLED_DRUG_IND,          
		   COMPOUND_CODE, 
		  /* Not Required */
		  /* Ace Created */
		  LoadDate
		  )
     
	SELECT 
	   /* Required */
	     S.ICN								 as SEQ_CLAIM_ID		   
	   , S.Detail_Number						 AS LINE_NUMBER	
	   , null									 as SUB_LINE_CODE	
	   , ISNULL(s.First_Date_Of_Service, '1/1/1980')	 as DETAIL_SVC_DATE				 
	   , ISNULL(s.Last_Date_Of_Service, '1/1/1980')	 as SVC_TO_DATE					 
	   , s.Procedure_Code						 AS PROCEDURE_CODE	   
	   , s.Procedure_Code_Modifier				 AS MODIFIER_CODE_1	
	   , NULL									 AS MODIFIER_CODE_2	-- not included in 
	   , NULL									 AS MODIFIER_CODE_3	
	   , NULL									 AS MODIFIER_CODE_4	
	   , s.Revenue_Code							 AS REVENUE_CODE	
	   , s.Place_Of_Service						 AS PLACE_OF_SVC_CODE1	
	   , NULL									 AS PLACE_OF_SVC_CODE2	
	   , NULL									 AS PLACE_OF_SVC_CODE3	
	   , 1 									 AS QUANTITY	-- Defualt in a 1, since the value doesn't exist in 
	   , s.Paid_Amount							 AS Paid_Amt	
	   , NULL 								 AS NDC_CODE	-- not an RX, no NDC CODE
	   
	   /* Optional */
	   , NULL		   							 AS CLAIM_NUMBER	
	   , s.Billed_Amount						 AS BILLED_AMT
	   , NULL									 AS RX_GENERIC_BRAND_IND
	   , null									 AS RX_SUPPLY_DAYS           
	   , NULL									 AS RX_DISPENSING_FEE_AMT
	   , NULL									 AS RX_INGREDIENT_AMT         
	   , NULL									 AS RX_FORMULARY_IND             
	   , NULL									 AS RX_DATE_PRESCRIPTION_WRITTEN
	   , NULL									 AS BRAND_NAME  
	   , NULL									 AS DRUG_STRENGTH_DESC
	   , NULL									 AS GPI            
	   , NULL									 AS GPI_DESC
	   , NULL									 AS CONTROLLED_DRUG_IND
	   , NULL									 AS COMPOUND_CODE  
	   /* Not Required */
	   /* Ace Created */
	   , s.LoadDate							 AS LoadDate
	FROM adi.OKC_Services s

/* ?????????  should we link to OKC CLAIMS to ensure only rows with headers make it in???????????  */
              
    /* Insert Pharmacy details */
    INSERT INTO adw.Claims_Details
		  (
	      /* Required */
		   seq_Claim_ID,
		   claim_number,
		   line_Number,
		   SUB_LINE_CODE,
		   DETAIL_SVC_DATE,
		   SVC_TO_DATE,
		   PROCEDURE_CODE,               
		   MODIFIER_CODE_1,
		   MODIFIER_CODE_2,
		   MODIFIER_CODE_3,
		   MODIFIER_CODE_4,
		   REVENUE_CODE,
		   PLACE_OF_SVC_CODE1,
		   PLACE_OF_SVC_CODE2,
		   PLACE_OF_SVC_CODE3,
		   QUANTITY,
		   Paid_amt,		   
		   NDC_CODE,                     		   
		  /* Optional */
		   BILLED_AMT,             
		   RX_GENERIC_BRAND_IND,         
		   RX_SUPPLY_DAYS,               
		   RX_DISPENSING_FEE_AMT,        
		   RX_INGREDIENT_AMT,            
		   RX_FORMULARY_IND,             
		   RX_DATE_PRESCRIPTION_WRITTEN, 
		   BRAND_NAME,                   
		   DRUG_STRENGTH_DESC,           
		   GPI,                          
		   GPI_DESC,                     
		   CONTROLLED_DRUG_IND,          
		   COMPOUND_CODE,
	       /* Not Required */
		  /* Ace Created */
		  LoadDate
		   )     
    SELECT 
    /* Required */
	      rx.ICN		  						as seq_Claim_ID
         , NULL		   						as claim_number
         , rx.Detail_Number						as line_Number
         , null								as SUB_LINE_CODE
         , ISNULL(rx.Dispensed_Date, '1/1/1980')		as DETAIL_SVC_DATE 
         , ISNULL(NULL, '1/1/1980')				as SVC_TO_DATE	    -- these dates do not exist, we could pull the dates from the Header down after we get headers
         , null								as PROCEDURE_CODE               		    
	    , NULL								as MODIFIER_CODE_1
         , NULL		  						as MODIFIER_CODE_2
         , NULL		  						as MODIFIER_CODE_3
         , NULL		  						as MODIFIER_CODE_4
         , null								as REVENUE_CODE
         , null			   					as PLACE_OF_SVC_CODE1
         , NULL								as PLACE_OF_SVC_CODE2
         , NULL								as PLACE_OF_SVC_CODE3
	    , rx.Dispensed_Qty						as QUANTITY
         , rx.Paid_Amount						as Paid_amt
	    , rx.NDC_Code							as NDC_CODE	    	 	
	 /* Optional */
	    , rx.Billed_Amount						as BILLED_AMT                   		    	    
	    , null								as RX_GENERIC_BRAND_IND         
	    , rx.Days_Supply						as RX_SUPPLY_DAYS               
	    , NULL								as RX_DISPENSING_FEE_AMT        
	    , NULL								as RX_INGREDIENT_AMT            
	    , NULL								as RX_FORMULARY_IND             
	    , NULL								as RX_DATE_PRESCRIPTION_WRITTEN 
	    , NULL								as BRAND_NAME                   
	    , NULL								as DRUG_STRENGTH_DESC           
	    , NULL								as GPI                         
	    , NULL								as GPI_DESC                     
	    , NULL								as CONTROLLED_DRUG_IND          
	    , NULL								as COMPOUND_CODE                	      												
    /* Not Required */
    /* Ace Created */
	    , rx.LoadDate							AS LoadDate	    
       FROM adi.OKC_Prescriptions rx
	   	-- removed because the prescriptions seem to not have headers
            --JOIN adi.OKC_Claims ch ON rx.ICN = ch.ICN
       ORDER BY rx.ICN, rx.Detail_Number;


          
           
           
           
           
          

