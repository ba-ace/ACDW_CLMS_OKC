create procedure ast.OkcCleanStaging
AS 
    truncate table   [ast].[OKC_STG_Claims]
    truncate table   [ast].[OKC_STG_Eligibility]
    truncate table   [ast].[OKC_STG_ICD9_Diagnosis]
    truncate table   [ast].[OKC_STG_ICD9_Procedure]
    truncate table   [ast].[OKC_STG_PCMH_Assign]
    truncate table   [ast].[OKC_STG_PCMH_Rates]
    truncate table   [ast].[OKC_STG_Prescriptions]
    truncate table   [ast].[OKC_STG_Provider_Info]
    truncate table   [ast].[OKC_STG_Recipient_Info]
    truncate table   [ast].[OKC_STG_Services]
