CREATE TABLE [adw].[Claims_Details] (
    [URN]                          BIGINT          IDENTITY (1, 1) NOT NULL,
    [CLAIM_NUMBER]                 VARCHAR (50)    NULL,
    [SEQ_CLAIM_ID]                 VARCHAR (50)    NULL,
    [LINE_NUMBER]                  SMALLINT        NULL,
    [SUB_LINE_CODE]                VARCHAR (50)    NULL,
    [DETAIL_SVC_DATE]              DATE            NULL,
    [SVC_TO_DATE]                  DATE            NULL,
    [PROCEDURE_CODE]               VARCHAR (50)    NULL,
    [MODIFIER_CODE_1]              VARCHAR (20)    NULL,
    [MODIFIER_CODE_2]              VARCHAR (20)    NULL,
    [MODIFIER_CODE_3]              VARCHAR (20)    NULL,
    [MODIFIER_CODE_4]              VARCHAR (20)    NULL,
    [REVENUE_CODE]                 SMALLINT        NULL,
    [PLACE_OF_SVC_CODE1]           VARCHAR (10)    NULL,
    [PLACE_OF_SVC_CODE2]           VARCHAR (10)    NULL,
    [PLACE_OF_SVC_CODE3]           VARCHAR (10)    NULL,
    [QUANTITY]                     NUMERIC (12, 2) NULL,
    [BILLED_AMT]                   MONEY           NULL,
    [PAID_AMT]                     MONEY           NULL,
    [NDC_CODE]                     VARCHAR (20)    NULL,
    [RX_GENERIC_BRAND_IND]         VARCHAR (50)    NULL,
    [RX_SUPPLY_DAYS]               VARCHAR (50)    NULL,
    [RX_DISPENSING_FEE_AMT]        MONEY           NULL,
    [RX_INGREDIENT_AMT]            MONEY           NULL,
    [RX_FORMULARY_IND]             VARCHAR (50)    NULL,
    [RX_DATE_PRESCRIPTION_WRITTEN] DATE            NULL,
    [BRAND_NAME]                   VARCHAR (50)    NULL,
    [DRUG_STRENGTH_DESC]           VARCHAR (50)    NULL,
    [GPI]                          VARCHAR (50)    NULL,
    [GPI_DESC]                     VARCHAR (50)    NULL,
    [CONTROLLED_DRUG_IND]          VARCHAR (50)    NULL,
    [COMPOUND_CODE]                VARCHAR (50)    NULL,
    [LoadDate]                     DATETIME        NOT NULL,
    [CreatedDate]                  DATETIME        DEFAULT (sysdatetime()) NOT NULL,
    [CreatedBy]                    VARCHAR (50)    DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]              DATETIME        DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]                VARCHAR (50)    DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsDets_RevCode]
    ON [adw].[Claims_Details]([REVENUE_CODE] ASC)
    INCLUDE([SEQ_CLAIM_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsDets_ProcedureCode]
    ON [adw].[Claims_Details]([PROCEDURE_CODE] ASC)
    INCLUDE([SEQ_CLAIM_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsDets_NdcCode]
    ON [adw].[Claims_Details]([NDC_CODE] ASC)
    INCLUDE([SEQ_CLAIM_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_Clms_Dets_ProcCode]
    ON [adw].[Claims_Details]([PROCEDURE_CODE] ASC)
    INCLUDE([SEQ_CLAIM_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_Clms_Details_PlcOfSvc]
    ON [adw].[Claims_Details]([SEQ_CLAIM_ID] ASC)
    INCLUDE([PLACE_OF_SVC_CODE1]);


GO
CREATE NONCLUSTERED INDEX [NdxClmDetails_SEQ_CLAIM_ID]
    ON [adw].[Claims_Details]([SEQ_CLAIM_ID] ASC)
    INCLUDE([URN], [CLAIM_NUMBER], [DETAIL_SVC_DATE], [SVC_TO_DATE], [PROCEDURE_CODE], [REVENUE_CODE]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmDet_POS]
    ON [adw].[Claims_Details]([PLACE_OF_SVC_CODE1] ASC)
    INCLUDE([SEQ_CLAIM_ID]);


GO
CREATE STATISTICS [_dta_stat_1298819689_13_20]
    ON [adw].[Claims_Details]([REVENUE_CODE], [NDC_CODE]);


GO
CREATE STATISTICS [_dta_stat_1298819689_13_3_20_8_14]
    ON [adw].[Claims_Details]([REVENUE_CODE], [SEQ_CLAIM_ID], [NDC_CODE], [PROCEDURE_CODE], [PLACE_OF_SVC_CODE1]);


GO
CREATE STATISTICS [_dta_stat_1298819689_14_13_20]
    ON [adw].[Claims_Details]([PLACE_OF_SVC_CODE1], [REVENUE_CODE], [NDC_CODE]);


GO
CREATE STATISTICS [_dta_stat_1298819689_14_3_13_20]
    ON [adw].[Claims_Details]([PLACE_OF_SVC_CODE1], [SEQ_CLAIM_ID], [REVENUE_CODE], [NDC_CODE]);


GO
CREATE STATISTICS [_dta_stat_1298819689_20_3_8_14]
    ON [adw].[Claims_Details]([NDC_CODE], [SEQ_CLAIM_ID], [PROCEDURE_CODE], [PLACE_OF_SVC_CODE1]);


GO
CREATE STATISTICS [_dta_stat_1298819689_8_13_20_14]
    ON [adw].[Claims_Details]([PROCEDURE_CODE], [REVENUE_CODE], [NDC_CODE], [PLACE_OF_SVC_CODE1]);


GO
CREATE STATISTICS [_dta_stat_1298819689_8_3_14_13]
    ON [adw].[Claims_Details]([PROCEDURE_CODE], [SEQ_CLAIM_ID], [PLACE_OF_SVC_CODE1], [REVENUE_CODE]);


GO

CREATE TRIGGER adw.ClaimsDetails_AfterUpdate
ON adw.Claims_Details
AFTER UPDATE 
AS
   UPDATE adw.Claims_Details
   SET LastUpdatedDate = SYSDATETIME()
	, LastUpdatedBy   = SYSTEM_USER
   FROM Inserted i
   WHERE adw.Claims_Details.URN = i.URN;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SKEY', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Details', @level2type = N'COLUMN', @level2name = N'URN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Claim Business Key', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Details', @level2type = N'COLUMN', @level2name = N'CLAIM_NUMBER';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Claim Unique ID: FKey to CLaims_Header', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Details', @level2type = N'COLUMN', @level2name = N'SEQ_CLAIM_ID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Claims Details sequence identifier: Seq_claim_id + Line_number + sub_Line_code are natural Key', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Details', @level2type = N'COLUMN', @level2name = N'LINE_NUMBER';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Claims Details: line version action code, Null means it is original row.', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Details', @level2type = N'COLUMN', @level2name = N'SUB_LINE_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'date of service for the detail event: Prescribe date or Procedure Date', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Details', @level2type = N'COLUMN', @level2name = N'DETAIL_SVC_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date the service runs to if multiple days', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Details', @level2type = N'COLUMN', @level2name = N'SVC_TO_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'code of procedure: could be from multiple code systems', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'Claims_Details', @level2type = N'COLUMN', @level2name = N'PROCEDURE_CODE';

