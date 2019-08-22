CREATE TABLE [adi].[OKC_Services] (
    [OKC_ServicesKey]           NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [ICN]                       VARCHAR (13)    NULL,
    [Detail_Number]             NUMERIC (18)    NULL,
    [SAK_RECIP]                 NUMERIC (18)    NULL,
    [Procedure_Code]            VARCHAR (10)    NULL,
    [Procedure_Code_Modifier]   VARCHAR (10)    NULL,
    [Revenue_Code]              NUMERIC (10)    NULL,
    [Provider_ID]               VARCHAR (50)    NULL,
    [Place_Of_Service]          VARCHAR (10)    NULL,
    [First_Date_Of_Service]     DATE            NULL,
    [Last_Date_Of_Service]      DATE            NULL,
    [Billed_Amount]             NUMERIC (18, 3) NULL,
    [Allowed_Amount]            NUMERIC (18, 3) NULL,
    [Paid_Amount]               NUMERIC (18, 3) NULL,
    [Claim_Indicator]           VARCHAR (10)    NULL,
    [Paid_Date]                 DATE            NULL,
    [State_Category_of_Service] VARCHAR (10)    NULL,
    [Health_Program_Code]       VARCHAR (10)    NULL,
    [Fund_Code]                 VARCHAR (10)    NULL,
    [SrcFileName]               VARCHAR (100)   NULL,
    [LoadDate]                  DATE            NOT NULL,
    [CreatedDate]               DATETIME2 (7)   DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                 VARCHAR (50)    DEFAULT (suser_sname()) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [ndx_adiOkcServices_ICN]
    ON [adi].[OKC_Services]([ICN] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_adiOkcServices_IcnDetailNum]
    ON [adi].[OKC_Services]([ICN] ASC, [Detail_Number] ASC);

