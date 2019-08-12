
CREATE PROCEDURE [adw].[Load_Pdw_15_ClmsMems]
AS 
    -- insert Claims.Members
    INSERT INTO [adw].[Claims_Member]
           (    -- REQUIRED
		    SUBSCRIBER_ID	
		  , IsActiveMember	
		  , DOB	
		  , MEMB_LAST_NAME	
		  , MEMB_MIDDLE_INITIAL
		  , MEMB_FIRST_NAME	
		  , GENDER	
		  , MEMB_ZIP	
		  , MEDICAID_NO
		  , MEDICARE_NO
		  , COMPANY_CODE
		  , LINE_OF_BUSINESS_DESC
		  , LoadDate
           )
     SELECT 
	   /* required */
	     m.SAK_RECIP		  as SUBSCRIBER_ID		    
	   , 1				  AS isActive -- will review and update
	   ,	m.Date_of_Birth	  as DOB				    
	   , NULL				  as MEMB_LAST_NAME		    
	   , NULL				  as MEMB_MIDDLE_INITIAL	    
	   , NULL				  as MEMB_FIRST_NAME	    
	   , m.Gender			  as GENDER			    
	   , m.Zip			  as MEMB_ZIP			    	   
	  /* Optional */
	   , ''				  AS  MEDICAID_NO
        , ''				  AS  MEDICARE_NO
	  /* Not required */ 
	   , ''				  AS COMPANY_CODE
	   , ''				  AS LINE_OF_BUSINESS_DESC
	  /* Ace created */			 
	  , m.LoadDate
    FROM adi.OKC_RecipientInfo m
       
       