CREATE PROCEDURE adw.ME_LoadPrep
AS
    /* validate load counts */
    SELECT convert(date, CreatedDate), count(*) clmCnt
    FROM adi.OKC_Claims
    GROUP BY convert(date, CreatedDate)
    ORDER BY convert(date, CreatedDate) desc
    
    SELECT convert(date, CreatedDate), count(*) ClmEligCnt
    FROM adi.OKC_Eligibility 
    GROUP BY convert(date, CreatedDate)
    ORDER BY convert(date, CreatedDate) DESC
    
    SELECT convert(date, CreatedDate), count(*) clmDiagCnt
    FROM adi.OKC_ICD9_Diagnosis
    GROUP BY convert(date, CreatedDate)
    ORDER BY convert(date, CreatedDate) DESC
    
    SELECT convert(date, CreatedDate), count(*) clmProcCnt
    FROM adi.OKC_ICD9_Procedure
    GROUP BY convert(date, CreatedDate)
    ORDER BY convert(date, CreatedDate) DESC
    
    SELECT convert(date, CreatedDate), count(*) clmProvCnt
    FROM adi.OKC_ProviderInfo 
    GROUP BY convert(date, CreatedDate)
    ORDER BY convert(date, CreatedDate) desc
        
    SELECT convert(date, CreatedDate), count(*) clmRecipCnt
    FROM adi.OKC_RecipientInfo
    GROUP BY convert(date, CreatedDate)
    ORDER BY convert(date, CreatedDate) desc
    
    SELECT convert(date, CreatedDate), count(*) clmSvcCnt
    FROM adi.OKC_Services 
    GROUP BY convert(date, CreatedDate)
    ORDER BY convert(date, CreatedDate) desc
    
    SELECT convert(date, CreatedDate), count(*) clmRxCnt
    FROM adi.OKC_Prescriptions 
    GROUP BY convert(date, CreatedDate)
    ORDER BY convert(date, CreatedDate) desc

    SELECT convert(date, CreatedDate), count(*) clmPcmhRatesCnt
    FROM adi.OKC_PcmhRates
    GROUP BY convert(date, CreatedDate)
    ORDER BY convert(date, CreatedDate) desc

    SELECT convert(date, CreatedDate), count(*) clmPcmhAsgnCnt
    FROM adi.OKC_PcmhAssign 
    GROUP BY convert(date, CreatedDate)
    ORDER BY convert(date, CreatedDate) desc
    
    
    /*SELECT --convert(date, createdate), count(*)    
    FROM adi.CCLF8 c
    GROUP BY convert(date, createDate)
    ORDER BY convert(date, createDate) DESC
    */
    
    /*
    SELECT convert(date, createdate), count(*)
    FROM adi.CCLF9 c
    GROUP BY convert(date, createDate)
    ORDER BY convert(date, createDate) DESC
    */
    
    
    /* UPdate Stats */
    
    EXEC sys.sp_updatestats;
    
    
    /* Backup CCACO prior to process */
    DECLARE @nvDate NVARCHAR(10) = REPLACE(CONVERT(NVARCHAR(10), GETDATE(), 102), '.', '');
    DECLARE @BkName NVARCHAR(100) = N'H:\ACECAREDW\ACDW_CLMS_OKC_'+ @nvDate + '.bak' ;
    SELECT @BkName
    
    BACKUP DATABASE ACDW_CLMS_OKC
        TO  DISK = @bkName
        WITH COPY_ONLY
        , NOFORMAT
        , NOINIT
        ,  NAME = N'ACDW_CLMS_OKC-Full Database Backup'
        , SKIP
        , NOREWIND
        , NOUNLOAD
        , COMPRESSION
        ,  STATS = 10
