

CREATE VIEW [dbo].[VW_Dashboard_BDK_Analysis]
as
select a.*, d.tin, d.npi, d.sex, datediff(year,d.dob, '12/31/2018') as AGE , e.npicnt, f.tincnt , g.CCS_CATEGORY, g.CCS_CATEGORY_DESCRIPTION   ,datediff(day, a.admission_date, a.svc_to_date)+1 as BDK, case when b.seq_claim_id is not null then 'S' else 'M' end as SurgVSMed
, case when c.seq_claim_id is not null then 'N' else 'A' end as AcuteVSNonA
from [adw].[tvf_get_claims_w_dates_5opt]('Inpatient Stay' , '','','','','01/01/2018','12/31/2018') a
left join 
(
select distinct seq_claim_id 
from [adw].[tvf_get_claims_w_dates_5opt]('Surgery' , '','','','','01/01/2018','12/31/2018')


) b on a.seq_claim_id = b.seq_claim_id

left join 
(

select distinct seq_claim_id 
from [adw].[tvf_get_claims_w_dates_5opt]('Nonacute Inpatient Stay' , '','','','','01/01/2018','12/31/2018') 
where prov_type = 1 and prov_spec not in (205,206)  
 

) c on b.seq_claim_id = c.seq_claim_id 

join (select * from adw.tmp_Active_Members d  where exclusion = 'N' )d  on a.subscriber_id = d.hicn 
left join (select npi, count(distinct hicn) as npicnt from adw.tmp_Active_Members where exclusion = 'N' and [plan] <>'' group by npi ) e on d.npi = e.npi
left join (select tin, count(distinct hicn) as tincnt from adw.tmp_Active_Members where exclusion = 'N' and [plan] <>'' group by tin ) f on d.tin = f.tin
left join (select [ICD-10-CM_CODE] as code,[CCS_CATEGORY],[CCS_CATEGORY_DESCRIPTION] from 
[lst].[LIST_ICDCCS] where CCS_CATEGORY_DESCRIPTION not like 'e codes%') g on a.icd_prim_diag = g.code

where a.prov_type = 1 and a.prov_spec not in (205,206)  













/*

select top 1 *  from adw.Claims_Headers a
join adw.Claims_Details b on a.SEQ_CLAIM_ID = b.SEQ_CLAIM_ID
where a.seq_claim_id in (
select distinct seq_claim_id 
from [adw].[tvf_get_claims_w_dates_5opt]('Inpatient Stay' , '','','','','01/01/2018','12/31/2018') ) 
prov_type in (1) --3,63

select distinct seq_claim_id 
from [adw].[tvf_get_claims_w_dates_5opt]('Skilled Nursing Stay' , '','','','','01/01/2018','12/31/2018') 



*/
