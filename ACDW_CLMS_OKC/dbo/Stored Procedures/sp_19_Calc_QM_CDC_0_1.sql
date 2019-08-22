
create procedure [sp_19_Calc_QM_CDC_0]
@years int,
@LOB varchar(20)
as
declare @year int = @years

declare @QM varchar(10) = 'CDC_0'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20))
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt as table (SUBSCRIBER_ID varchar(20))
declare @tablenum as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop as table (SUBSCRIBER_ID varchar(20))


insert into @table1
select distinct a.SUBSCRIBER_ID from 
adw.[tvf_get_active_members2](concat('12/31/',2018)) a join (SELECT DISTINCT subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('HbA1c Tests', '', '', concat('1/1/',@year), concat('12/31/',@year))) b on a.subscriber_id = b.SUBSCRIBER_ID
where AGE  BETWEEN 18 AND 75



insert into @table2
SELECT DISTINCT subscriber_id --, count(distinct seq_claim_id), count(distinct primary_svc_date)
		FROM (
			SELECT A.*
			FROM (
				SELECT subscriber_id
					,SEQ_CLAIM_ID
					,PRIMARY_SVC_DATE
				FROM adw.[tvf_get_claims_w_dates]('Outpatient', 'ED', 'Nonacute Inpatient', concat('1/1/',@year-1), concat('12/31/',@year))
				
				UNION
				
				SELECT subscriber_id
					,SEQ_CLAIM_ID
					,PRIMARY_SVC_DATE
				FROM adw.[tvf_get_claims_w_dates]('Observation', '', '', concat('1/1/',@year-1), concat('12/31/',@year))
				) A
			INNER JOIN (
				SELECT subscriber_id
					,SEQ_CLAIM_ID
					,PRIMARY_SVC_DATE
				FROM adw.[tvf_get_claims_w_dates]('Diabetes', '', '', concat('1/1/',@year-1), concat('12/31/',@year))
				) B
				ON A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID
			) C
		GROUP BY subscriber_id
		HAVING (count(DISTINCT seq_claim_id) >= 2)
			AND (count(DISTINCT primary_svc_date) >= 2)


insert into @table2
SELECT DISTINCT A.subscriber_id--, A.seq_claim_id
		FROM adw.[tvf_get_claims_w_dates]('Acute Inpatient', '', '', concat('1/1/',@year-1), concat('12/31/',@year)) A join adw.[tvf_get_claims_w_dates]('Diabetes', '', '', concat('1/1/',@year-1), concat('12/31/',@year)) B
		on A.SEQ_CLAIM_ID = B.SEQ_CLAIM_ID




insert into @table2
SELECT DISTINCT subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('Diabetes Medications', '', '', concat('1/1/',@year-1), concat('12/31/',@year))



insert into @tableden 
select a.* from @table1 a join @table2 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID










DELETE FROM @table1
DELETE FROM @table2

insert into @table1 
select distinct a.SUBSCRIBER_ID from (select * from (
select subscriber_id , seq_claim_id, row_number() over (partition by subscriber_id order by primary_svc_date desc) as rank  from adw.[tvf_get_claims_w_dates]('HbA1c Tests', '', '', concat('1/1/',@year), concat('12/31/',@year))a ) b where rank = 1
) a left join  (
  select distinct seq_claim_id, code
   from (select distinct seq_claim_id ,1 as code from adw.[tvf_get_claims_w_dates]('HbA1c Level Less Than 7.0','' ,'',concat('1/1/',@year), concat('12/31/',@year) ) 
   union 
   select distinct seq_claim_id,2 as code from adw.[tvf_get_claims_w_dates]('','HbA1c Level 7.0-9.0' ,'',concat('1/1/',@year), concat('12/31/',@year) ) 
   union  
   select distinct seq_claim_id,3 as code from adw.[tvf_get_claims_w_dates]('','' ,'HbA1c Level Greater Than 9.0',concat('1/1/',@year), concat('12/31/',@year) ) 
  )A ) C on a.seq_claim_id = c.seq_claim_id 
  where c.code in (1,2,3)  


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
