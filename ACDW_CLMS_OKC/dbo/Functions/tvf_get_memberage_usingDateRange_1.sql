



CREATE FUNCTION [dbo].[tvf_get_memberage_usingDateRange]
(
 @date1  date,
 @date2 date,
 @agestart int,
 @ageend int
)
RETURNS TABLE
AS
     RETURN
(

select * from (
SELECT distinct SUBSCRIBER_ID, m_gender, m_date_of_birth, datediff(year, M_Date_Of_Birth,convert(date,@date1,101)) as AGE1,datediff(year, M_Date_Of_Birth,convert(date,@date2,101)) as AGE2
	from (select distinct hicn as subscriber_id, sex as m_gender,dob as M_Date_Of_Birth from  (select * from  adw.tmp_Active_Members where exclusion = 'N' and [plan] <> '') aa ) a  where datediff(year, M_Date_Of_Birth,convert(date,@date1,101)) > 0 and datediff(year, M_Date_Of_Birth,convert(date,@date2,101))>0
	) b where (age1 between @agestart and  @ageend)  or (age2 between  @agestart and  @ageend) 


)
