CREATE TABLE [adw].[QM_ResultByMember_History] (
    [urn]             INT          IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey] VARCHAR (50) NOT NULL,
    [QmMsrId]         VARCHAR (20) NOT NULL,
    [QmCntCat]        VARCHAR (10) NOT NULL,
    [QMDate]          DATE         CONSTRAINT [DF_QM_ResultByMbr_History_QmDate] DEFAULT (CONVERT([date],getdate())) NULL,
    [CreateDate]      DATETIME     CONSTRAINT [DF_QM_ResultByMbr_History_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreateBy]        VARCHAR (50) CONSTRAINT [DF_QM_ResultByMbr_History_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_QMDate]
    ON [adw].[QM_ResultByMember_History]([QMDate] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_QMDateQmMsrid]
    ON [adw].[QM_ResultByMember_History]([QMDate] ASC, [QmMsrId] ASC)
    INCLUDE([CreateDate]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_QM_ResultByMember_History_19_2082106458__K2_K5_K3_4]
    ON [adw].[QM_ResultByMember_History]([ClientMemberKey] ASC, [QMDate] ASC, [QmMsrId] ASC)
    INCLUDE([QmCntCat]);

