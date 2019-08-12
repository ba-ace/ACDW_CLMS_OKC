
CREATE VIEW [adw].[vw_AllMbrDetail_AWV_CY]
AS
     SELECT a.*, 
            b.VENDOR_ID, 
            b.SVC_PROV_NPI
     FROM adw.[tvf_get_claims_w_dates]('Well-Care', '', '', '01/01/2018', '01/01/2019') a
          JOIN adw.Claims_Headers b ON a.seq_claim_id = b.seq_claim_id;

