--/****** Object:  StoredProcedure [dbo].[sp_19_Calc_QM_BCS]    Script Date: 8/12/2019 12:57:50 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

CREATE procedure [dbo].[sp_19_Calc_QM_BCS_2020] 
 @years int ,
 @LOB varchar(20)
as
declare @year int = @years

declare @QM varchar(10) = 'BCS'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()
declare @clientkeyid int = @LOB

declare @table1 as table (SUBSCRIBER_ID varchar(20), Value_Code_System Varchar(20), Value_Code Varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20), Value_Code_System Varchar(20), Value_Code Varchar(20))
declare @tableden as table (SUBSCRIBER_ID varchar(20), Value_Code_System Varchar(20), Value_Code Varchar(20))
declare @tablenumt as table (SUBSCRIBER_ID varchar(20), Value_Code_System Varchar(20), Value_Code Varchar(20))
declare @tablenum as table (SUBSCRIBER_ID varchar(20), Value_Code_System Varchar(20), Value_Code Varchar(20))
declare @tablecareop as table (SUBSCRIBER_ID varchar(20))

--Insert into variable population
insert into @table1 (SUBSCRIBER_ID)
select SUBSCRIBER_ID from 
adw.[tvf_get_active_members2](concat('12/31/',@year)) 
where GENDER = 'F' and AGE between 52 and 75 

--population
insert into @tableden (SUBSCRIBER_ID)
select a.SUBSCRIBER_ID from @table1 a 


DELETE FROM @table1
DELETE FROM @table2

--for members with claims for the period
insert into @table1 (SUBSCRIBER_ID, Value_Code_System, Value_Code) 
select SUBSCRIBER_ID, Value_Code, Value_Code_System from adw.[tvf_get_claims_w_dates_2020]('Mammography','' ,'',concat('10/1/',@year-2),concat('12/31/',@year))

--
insert into @tablenumt(SUBSCRIBER_ID, Value_Code_System, Value_Code)
select * from @table1

--These will give distinct values
/*insert into @tablenum(SUBSCRIBER_ID)
select a.SUBSCRIBER_ID from @tablenumt a 
intersect select b.SUBSCRIBER_ID from @tableden  b*/

--Fetching details level for each subscriber that met measures condition (Numerator)
insert into @tablenum(SUBSCRIBER_ID, Value_Code_System, Value_Code)
select   b.SUBSCRIBER_ID, a.Value_Code, a.Value_Code_System from @tablenumt a 
inner join @tableden  b
on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID

---Inserting records into details table for Num and DEN
Insert into [adw].[QM_ValueCodeDetails](
[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
select @clientkeyid, SUBSCRIBER_ID,	Value_Code_System,Value_Code, @QM ,'NUM',@RUNDATE ,@RUNTIME, SUSER_NAME(), getdate(), SUSER_NAME() from @tablenum

Insert into [adw].[QM_ValueCodeDetails](
[ClientKey], [ClientMemberKey], [ValueCodeSystem],[ValueCode],[QmMsrID],[QmCntCat],[QMDate],[RunDate],[CreatedBy], [LastUpdatedDate],[LastUpdatedBy])
select @clientkeyid, SUBSCRIBER_ID,	'0','0', @QM ,'DEN',@RUNDATE ,@RUNTIME, SUSER_NAME(), getdate(), SUSER_NAME() from @tableden

