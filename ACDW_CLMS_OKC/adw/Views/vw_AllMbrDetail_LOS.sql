

CREATE VIEW [adw].[vw_AllMbrDetail_LOS]
AS
     SELECT seq_claim_id, datediff(day,admission_date, svc_to_date) +1 as LOS, svc_to_date, admission_date, PRIMARY_SVC_DATE, SUBSCRIBER_ID from adw.Claims_Headers where admission_date is not null and svc_to_date is not null
