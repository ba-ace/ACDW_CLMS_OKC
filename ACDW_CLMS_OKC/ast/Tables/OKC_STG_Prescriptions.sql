﻿CREATE TABLE [ast].[OKC_STG_Prescriptions] (
    [Seq_ID]                    NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [ICN]                       VARCHAR (50)    NULL,
    [Detail_Number]             NUMERIC (18)    NULL,
    [SAK_RECIP]                 NUMERIC (18)    NULL,
    [Dispensed_Date]            DATE            NULL,
    [NDC_Code]                  VARCHAR (50)    NULL,
    [Prescriber_ID]             VARCHAR (50)    NULL,
    [Dispensed_Qty]             NUMERIC (18)    NULL,
    [Days_Supply]               NUMERIC (18)    NULL,
    [Billed_Amount]             NUMERIC (18, 3) NULL,
    [Allowed_Amount]            NUMERIC (18, 3) NULL,
    [Paid_Amount]               NUMERIC (18, 3) NULL,
    [Claim_Indicator]           VARCHAR (50)    NULL,
    [Paid_Date]                 DATE            NULL,
    [Pharmacy_ID]               VARCHAR (50)    NULL,
    [State_Category_of_Service] VARCHAR (20)    NULL,
    [Health_Program_Code]       VARCHAR (20)    NULL,
    [Fund_code]                 VARCHAR (20)    NULL,
    [fileName]                  VARCHAR (50)    NULL,
    [createddate]               DATETIME        NULL
);

