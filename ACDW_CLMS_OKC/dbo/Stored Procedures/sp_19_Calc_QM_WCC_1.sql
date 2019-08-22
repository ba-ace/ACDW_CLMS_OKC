create procedure [sp_19_Calc_QM_WCC]
@years int,
@LOB varchar(20)
as
declare @year int = @years
declare @QMBM varchar(10) = 'WCC_BM'
declare @QMCN varchar(10) = 'WCC_CN'
declare @QMPA varchar(10) = 'WCC_PA'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20))
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumtb as table (SUBSCRIBER_ID varchar(20))
declare @tablenumb as table (SUBSCRIBER_ID varchar(20))
declare @tablecareopb as table (SUBSCRIBER_ID varchar(20))
declare @tablenumtc as table (SUBSCRIBER_ID varchar(20))
declare @tablenumc as table (SUBSCRIBER_ID varchar(20))
declare @tablecareopc as table (SUBSCRIBER_ID varchar(20))
declare @tablenumtp as table (SUBSCRIBER_ID varchar(20))
declare @tablenump as table (SUBSCRIBER_ID varchar(20))
declare @tablecareopp as table (SUBSCRIBER_ID varchar(20))


insert into @table1
select SUBSCRIBER_ID from 
adw.[tvf_get_active_members2](concat('12/31/',@year)) 
where AGE BETWEEN 3 and 17 


insert into @table2
SELECT DISTINCT subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('Outpatient', '', '', concat('1/1/',@year-2), concat('12/31/',@year))


insert into @tableden 
select a.* from @table1 a join @table2 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID









DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('BMI Percentile','','' ,concat('01/01/',@year),concat('12/31/',@year))



insert into @tablenumtb
select * from @table1






insert into @tablenumb
select a.* from @tablenumtb a 
intersect select b.* from @tableden  b



insert into @tablecareopb
select a.* from @tableden a left join @tablenumb b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 



Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMBM , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMBM , 'NUM' ,@RUNDATE,@RUNTIME from @tablenumb


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMBM , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareopb






DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('Physical Activity Counseling','','' ,concat('01/01/',@year),concat('12/31/',@year))



insert into @tablenumtp
select * from @table1






insert into @tablenump
select a.* from @tablenumtp a 
intersect select b.* from @tableden  b



insert into @tablecareopp
select a.* from @tableden a left join @tablenump b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 



Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMPA , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMPA , 'NUM' ,@RUNDATE,@RUNTIME from @tablenump


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMPA , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareopp







DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('Nutrition Counseling','','' ,concat('01/01/',@year),concat('12/31/',@year))



insert into @tablenumtc
select * from @table1






insert into @tablenumc
select a.* from @tablenumtc a 
intersect select b.* from @tableden  b



insert into @tablecareopc
select a.* from @tableden a left join @tablenumc b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 

Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMCN , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMCN , 'NUM' ,@RUNDATE,@RUNTIME from @tablenumc


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QMCN , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareopc
