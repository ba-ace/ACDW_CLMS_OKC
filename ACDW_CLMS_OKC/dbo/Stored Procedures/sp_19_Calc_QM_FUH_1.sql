CREATE procedure [sp_19_Calc_QM_FUH]
@years int,
@LOB varchar(20)
as
declare @year int = @years
declare @QM varchar(10) = 'FUH_30'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()
declare @tableAIP as table (Subscriber_id varchar(20), Seq_claim_id varchar(30), Primary_svc_date date, admission_date date, discharge_date date) 
declare @tableMH as table (Subscriber_id varchar(20), Seq_claim_id varchar(30), Primary_svc_date date, admission_date date, discharge_date date) 
declare @tableEXC as table (Seq_claim_id varchar(30)) 
declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (Subscriber_id varchar(20), Seq_claim_id varchar(30), Primary_svc_date date, admission_date date, discharge_date date) 
declare @tableden as table (Subscriber_id varchar(20), Seq_claim_id varchar(30), Primary_svc_date date, admission_date date, discharge_date date) 
declare @tablenum1 as table (Subscriber_id varchar(20), Seq_claim_id varchar(30), Primary_svc_date date, admission_date date, discharge_date date) 
declare @tablenumt as table (Subscriber_id varchar(20), Seq_claim_id varchar(30), Primary_svc_date date, admission_date date, discharge_date date) 
declare @tablenum as table (Subscriber_id varchar(20), Seq_claim_id varchar(30), Primary_svc_date date, admission_date date, discharge_date date) 
declare @tablecareop as table (Subscriber_id varchar(20), Seq_claim_id varchar(30), Primary_svc_date date, admission_date date, discharge_date date) 

--acute ip 
insert into @tableAIP
SELECT a.SUBSCRIBER_ID, a.SEQ_CLAIM_ID, a.primary_svc_date, a.admission_date, a.SVC_TO_DATE
FROM adw.[tvf_get_claims_w_dates]('Inpatient Stay', '', '', concat('1/1/',@year-1), concat('12/31/',@year)) a 
left join (
SELECT * FROM adw.[tvf_get_claims_w_dates]('Nonacute Inpatient Stay', '', '', concat('1/1/',@year-1), concat('12/31/',@year))
) b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID where b.SEQ_CLAIM_ID is null



--mental health 
insert into @tableMH
SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, primary_svc_date, admission_date, SVC_TO_DATE
FROM adw.[tvf_get_claims_w_dates]('Mental Health Diagnosis', 'Intentional Self-Harm', '', concat('1/1/',@year-1), concat('12/31/',@year)) 



insert into @table1
select SUBSCRIBER_ID from 
adw.[tvf_get_active_members2](concat('12/31/',@year)) 
where AGE between 6 and 120 



insert into @table2
select a.* from @tableAIP a join @tableMH b on a.Seq_claim_id = b.Seq_claim_id 


insert into @tableden 
select a.* from @table2 a join @table1 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID



--DELETE FROM @table1
--DELETE FROM @table2


insert into @tablenumt
select  a.* from @tableden a 
join adw.tvf_get_provspec(@LOB,26,62,68,'','','') b
 on a.Subscriber_id = b.SUBSCRIBER_ID and abs(datediff(day,a.discharge_date, b.primary_svc_date) )<=30 



--insert into @table2
--SELECT SUBSCRIBER_ID, SEQ_CLAIM_ID, primary_svc_date, admission_date, SVC_TO_DATE
--FROM adw.[tvf_get_claims_w_dates]('Mental Health Practitioner', '', '', concat('1/1/',@year-1), concat('12/31/',@year)) 








insert into @tablenum
select a.* from @tablenumt a 




insert into @tablecareop
select a.* from @tableden a left join @tablenum b on a.Seq_claim_id = b.Seq_claim_id where b.Seq_claim_id is null 

--select *, count(distinct seq_claim_id) as visits , concat(@QM, '_DEN') ,@RUNDATE ,@RUNTIME from @tableden a group by subscriber_id

--select *, count(distinct seq_claim_id) as visits , concat(@QM, '_NUM') ,@RUNDATE,@RUNTIME from @tablenum a group by subscriber_id

--select *, count(distinct seq_claim_id) as visits , concat(@QM, '_COP') ,@RUNDATE ,@RUNTIME from @tablecareop a group by subscriber_id

insert into @tablecareop
select a.Subscriber_id,a.Seq_claim_id ,a.Primary_svc_date ,a.admission_date ,a.discharge_date from (select * from (select * , row_number() over (partition by subscriber_id order by primary_svc_date desc ) as rank from @tableden ) z where rank =1 ) a left join @tablenum b on a.Seq_claim_id = b.Seq_claim_id where b.Seq_claim_id is null 


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select subscriber_id, @QM , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select subscriber_id, @QM , 'NUM' ,@RUNDATE,@RUNTIME from @tablenum


Insert into adw.[QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select subscriber_id, @QM , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareop
