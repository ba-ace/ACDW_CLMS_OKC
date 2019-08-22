
CREATE view [dbo].[VW_Dashboard_ER_Analysis]
as
select  a.*, d.tin, d.npi, d.sex
, datediff(year,d.dob, '12/31/2018') as AGE
 , e.npicnt, f.tincnt ,g.CCS_CATEGORY,g.CCS_CATEGORY_DESCRIPTION



from (select aa.* from dbo.[tvf_get_claims_w_dates_5opt]('ED' ,'','','','','01/01/2018','12/31/2018') aa join 
dbo.[tvf_get_claims_w_dates_5opt]('ED POS' ,'','','','','01/01/2018','12/31/2018') bb on aa.SEQ_CLAIM_ID = bb.SEQ_CLAIM_ID

) a
join (select distinct hicn as hicn, max(Sex) as sex, max(DOB) as dob, max(TIN) as TIN, max(NPI) as npi 
from adw.tmp_Active_Members  where mbr_year = 2018 group by hicn) d on a.subscriber_id = d.hicn 
left join 
(select NPI as npi, count(distinct HICN)  as npicnt
from adw.tmp_Active_Members  where mbr_year = 2018  group by NPI ) e on d.npi = e.npi
left join 
(select TIN as TIN, count(distinct HICN)  as tincnt
from adw.tmp_Active_Members  where mbr_year = 2018  group by TIN) f on d.tin = f.tin
  left join 
 (select distinct [ICD-10-CM_CODE]  as code,[CCS_CATEGORY],[CCS_CATEGORY_DESCRIPTION] from 
ACDW_CLMS_OKC.[lst].[LIST_ICDCCS] where CCS_CATEGORY_DESCRIPTION not like 'e codes%' and version = 'ICD10CM') g on a.ICD_PRIM_DIAG = g.code
