CREATE TABLE [adi].[OKC_PcmhAssign] (
    [OKC_PcmhAssignKey]          NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [Provider_ID]                VARCHAR (50)  NULL,
    [SAK_RECIP]                  NUMERIC (18)  NULL,
    [Sooner_Care_Program]        VARCHAR (50)  NULL,
    [Sooner_Care_Effective_Date] DATE          NULL,
    [Sooner_Care_End_Date]       DATE          NULL,
    [SrcFileName]                VARCHAR (100) NULL,
    [LoadDate]                   DATE          NOT NULL,
    [CreatedDate]                DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                  VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL
);

