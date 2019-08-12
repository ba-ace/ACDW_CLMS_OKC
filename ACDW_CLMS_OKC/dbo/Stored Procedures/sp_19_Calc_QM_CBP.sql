  create procedure [sp_19_Calc_QM_CBP]
@years int,
@LOB varchar(20)
as
declare @year int = @years

declare @QM varchar(10) = 'CBP'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20), maxdate date )
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt as table (SUBSCRIBER_ID varchar(20))
declare @tablenum as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop as table (SUBSCRIBER_ID varchar(20))


insert into @table1
select distinct SUBSCRIBER_ID from 
adw.[tvf_get_active_members2](concat('1/1/',@year-1))  a
where AGE between 18 and 85




insert into @table2
SELECT DISTINCT a.subscriber_id, max(a.primary_svc_date) as maxdate
	FROM adw.[tvf_get_claims_w_dates]('Outpatient Without UBREV', 'Telephone Visits', 'Online Assessments', concat('1/1/',@year-1), concat('12/31/',@year)) a 
	join adw.[tvf_get_claims_w_dates]('Essential Hypertension', '', '', concat('1/1/',@year-1), concat('12/31/',@year)) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
	group by a.subscriber_id 
	having count(distinct a.primary_svc_date) >=2

insert into @tableden 
select a.* from @table1 a join @table2 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID



DELETE FROM @table1


--select * from @tableden
insert into @table1
select a.subscriber_id From 
adw.[tvf_get_claims_w_dates]('Systolic Less Than 140', '', '', concat('1/1/',@year), concat('12/31/',@year)) a
join 
adw.[tvf_get_claims_w_dates]('Diastolic Less Than 80', 'Diastolic 80-89', '', concat('1/1/',@year), concat('12/31/',@year)) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
join @table2 c on a.SUBSCRIBER_ID = c.SUBSCRIBER_ID and a.PRIMARY_SVC_DATE >= c.maxdate








insert into @tablenumt
select * from @table1







insert into @tablenum
select a.* from @tablenumt a 
intersect select b.* from @tableden  b



insert into @tablecareop
select a.* from @tableden a left join @tablenum b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 

Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'NUM' ,@RUNDATE,@RUNTIME from @tablenum


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareop
