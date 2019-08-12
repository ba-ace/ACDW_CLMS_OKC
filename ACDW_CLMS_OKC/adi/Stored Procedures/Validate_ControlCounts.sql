
CREATE PROCEDURE [adi].[Validate_ControlCounts]
aS 
    -- produces control counts for all loaded table
    SELECT 'ADI_Claims' ,	   COUNT(*)  FROM [adi].OKC_Claims
    Union
    SELECT 'ADI_Eligibility' ,  COUNT(*)  FROM [adi].OKC_Eligibility
    Union
    SELECT 'ADI_ICD9_Diagnosis',COUNT(*)  FROM [adi].OKC_ICD9_Diagnosis
    Union
    SELECT 'ADI_ICD9_Procedure',COUNT(*)  FROM [adi].OKC_ICD9_Procedure
    Union
    SELECT 'ADI_PCMH_Assign' ,  COUNT(*)  FROM [adi].OKC_PcmhAssign
    Union
    SELECT 'ADI_PCMH_Rates' ,   COUNT(*)  FROM [adi].OKC_PcmhRates
    Union
    SELECT 'ADI_Prescriptions' ,COUNT(*)  FROM [adi].OKC_Prescriptions
    Union
    SELECT 'ADI_Provider_Info', COUNT(*)  FROM [adi].OKC_ProviderInfo
    Union
    SELECT 'ADI_Recipient_Info',COUNT(*)  FROM [adi].OKC_RecipientInfo
    Union
    SELECT 'ADI_Services' ,	   COUNT(*)  FROM [adi].OKC_Services
go;
