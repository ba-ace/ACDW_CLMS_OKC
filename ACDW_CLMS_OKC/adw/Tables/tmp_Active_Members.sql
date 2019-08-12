CREATE TABLE [adw].[tmp_Active_Members] (
    [URN]            INT           IDENTITY (1, 1) NOT NULL,
    [MBI]            VARCHAR (50)  NULL,
    [HICN]           VARCHAR (50)  NOT NULL,
    [Plan]           VARCHAR (50)  NULL,
    [SubPlan]        VARCHAR (100) NULL,
    [FirstName]      VARCHAR (50)  NULL,
    [LastName]       VARCHAR (50)  NULL,
    [Sex]            VARCHAR (1)   NULL,
    [DOB]            DATE          NULL,
    [DOD]            DATE          NULL,
    [Exclusion]      VARCHAR (1)   DEFAULT ('N') NULL,
    [Mbr_Type]       VARCHAR (1)   NULL,
    [AWV]            INT           DEFAULT ((0)) NULL,
    [PCP]            INT           DEFAULT ((0)) NULL,
    [IP]             INT           DEFAULT ((0)) NULL,
    [ER]             INT           DEFAULT ((0)) NULL,
    [RA]             INT           DEFAULT ((0)) NULL,
    [CurrentGaps]    INT           DEFAULT ((0)) NULL,
    [HospiceCode]    INT           DEFAULT ((0)) NULL,
    [PCP_Last18Mths] INT           DEFAULT ((0)) NULL,
    [PCP_Last12Mths] INT           DEFAULT ((0)) NULL,
    [AHRGaps]        INT           DEFAULT ((0)) NULL,
    [TIN]            VARCHAR (50)  NULL,
    [TIN_NAME]       VARCHAR (50)  NULL,
    [NPI]            VARCHAR (50)  NULL,
    [NPI_NAME]       VARCHAR (50)  NULL,
    [MBR_YEAR]       INT           NULL,
    [MBR_QTR]        INT           NULL,
    [LOAD_DATE]      DATE          DEFAULT (sysdatetime()) NULL,
    [LOAD_USER]      VARCHAR (50)  DEFAULT (suser_sname()) NULL
);


GO
CREATE NONCLUSTERED INDEX [Ndx_tmpActive_Demog]
    ON [adw].[tmp_Active_Members]([Exclusion] ASC, [Plan] ASC)
    INCLUDE([HICN], [Sex], [DOB]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_exclusionPlanHicn]
    ON [adw].[tmp_Active_Members]([Exclusion] ASC, [Plan] ASC, [HICN] ASC)
    INCLUDE([Mbr_Type]);


GO
CREATE STATISTICS [_dta_stat_URN]
    ON [adw].[tmp_Active_Members]([URN]);


GO
CREATE STATISTICS [_dta_stat_HicnExclusion]
    ON [adw].[tmp_Active_Members]([HICN], [Exclusion]);


GO
CREATE STATISTICS [_dta_stat_PlanHicn]
    ON [adw].[tmp_Active_Members]([Plan], [HICN]);


GO
CREATE STATISTICS [_dta_stat_1711345161_3_9_4]
    ON [adw].[tmp_Active_Members]([HICN], [DOB], [Plan]);


GO
CREATE STATISTICS [_dta_stat_1711345161_4_11_9_3]
    ON [adw].[tmp_Active_Members]([Plan], [Exclusion], [DOB], [HICN]);


GO
CREATE STATISTICS [_dta_stat_1711345161_9_11]
    ON [adw].[tmp_Active_Members]([DOB], [Exclusion]);

