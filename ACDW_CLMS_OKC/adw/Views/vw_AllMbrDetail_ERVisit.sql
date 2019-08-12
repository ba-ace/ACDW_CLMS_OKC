﻿CREATE VIEW [adw].[vw_AllMbrDetail_ERVisit]
AS
     SELECT a.*, 
            b.VENDOR_ID, 
            b.SVC_PROV_NPI
     FROM
     (
         SELECT *
         FROM [adw].[tvf_get_claims_w_dates]('ED', '', '', '01/01/2001', '01/01/2099')
         UNION
         (
             SELECT a.*
             FROM adw.[tvf_get_claims_w_dates]('ED POS', '', '', '01/01/2001', '01/01/2099') a
                  JOIN [adw].[tvf_get_claims_w_dates]('ED Procedure Code', '', '', '01/01/2001', '01/01/2099') b ON a.seq_claim_id = b.seq_claim_id
         )
     ) a
     JOIN adw.Claims_Headers b ON a.seq_claim_id = b.seq_claim_id
                                  AND a.CATEGORY_OF_SVC <> 'PHYSICIAN'; -- Added. 12.04.2018
