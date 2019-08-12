﻿create procedure [sp_19_Calc_QM_COL]
@years int,
@LOB varchar(20)
as
declare @year int = @years
declare @QM varchar(10) = 'COL'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20))
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt as table (SUBSCRIBER_ID varchar(20))
declare @tablenum as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop as table (SUBSCRIBER_ID varchar(20))


insert into @table1
select SUBSCRIBER_ID from 
adw.[tvf_get_active_members2](concat('12/31/',@year)) 
where AGE BETWEEN 51 and 75





insert into @tableden 
select a.* from @table1 a 








DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT A.subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('FOBT', '', '',  concat('1/1/',@year), concat('12/31/',@year)) a
union 
SELECT DISTINCT A.subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('Flexible Sigmoidoscopy', '', '',  concat('1/1/',@year-4), concat('12/31/',@year)) a	
union 
SELECT DISTINCT A.subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('Colonoscopy', '', '',  concat('1/1/',@year-9), concat('12/31/',@year)) a	
union 
SELECT DISTINCT A.subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('CT Colonography', '', '',  concat('1/1/',@year-4), concat('12/31/',@year)) a	
union 
SELECT DISTINCT A.subscriber_id
	FROM adw.[tvf_get_claims_w_dates]('FIT-DNA', '', '',  concat('1/1/',@year-2), concat('12/31/',@year)) a	








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
