truncate table tmp_approval_rate;
INSERT INTO tmp_approval_rate
(month_key, region_code, area_name, email, approval_rate_avg, rank_approval_rate_avg)
WITH monthly_data AS ( -- tìm tháng phát sinh và kết thúc
    SELECT
        month_key,
        area_name,
        sale_name,
        email,
        jan_aa,
        feb_aa,
        mar_aa,
        apr_aa,
        may_aa,
        jan_ai,
        feb_ai,
        mar_ai,
        apr_ai,
        may_ai,
        CASE
            WHEN jan_aa IS NOT NULL THEN 1
            WHEN feb_aa IS NOT NULL THEN 2
            WHEN mar_aa IS NOT NULL THEN 3
            WHEN apr_aa IS NOT NULL THEN 4
            WHEN may_aa IS NOT NULL THEN 5
        END as first_active_month,
        CASE
            WHEN may_aa IS NOT NULL THEN 5
            WHEN apr_aa IS NOT NULL THEN 4
            WHEN mar_aa IS NOT NULL THEN 3
            WHEN feb_aa IS NOT NULL THEN 2
            WHEN jan_aa IS NOT NULL THEN 1
        END as last_active_month
    FROM kpi_asm_data kad 
), cal_aa_avg as ( -- calculate aa
SELECT
    month_key,
    area_name,
    sale_name,
    email,
    first_active_month,
    last_active_month,
    CASE
        WHEN first_active_month = 1 AND last_active_month = 5 THEN ((jan_aa*5 + feb_aa*4 + mar_aa*3 + apr_aa*2 + may_aa)*1.0 ) /  ((jan_ai*5 + feb_ai*4 + mar_ai*3 + apr_ai*2 + may_ai)*1.0 )               
        WHEN first_active_month = 1 AND last_active_month = 4 THEN ((jan_aa*4 + feb_aa*3 + mar_aa*2 + apr_aa)*1.0) / ((jan_ai*4 + feb_ai*3 + mar_ai*2 + apr_ai)*1.0)
        WHEN first_active_month = 1 AND last_active_month = 3 THEN ((jan_aa*3 + feb_aa*2 + mar_aa)*1.0) / ((jan_ai*3 + feb_ai*2 + mar_ai)*1.0)
        WHEN first_active_month = 1 AND last_active_month = 2 THEN ((jan_aa*2 + feb_aa)*1.0) / ((jan_ai*2 + feb_ai)*1.0)
        WHEN first_active_month = 2 AND last_active_month = 5 THEN ((feb_aa*4 + mar_aa*3 + apr_aa*2 + may_aa)*1.0) / ((feb_ai*4 + mar_ai*3 + apr_ai*2 + may_ai)*1.0)
        WHEN first_active_month = 2 AND last_active_month = 4 THEN ((feb_aa*3 + mar_aa*2 + apr_aa)*1.0) / ((feb_ai*3 + mar_ai*2 + apr_ai)*1.0)
        WHEN first_active_month = 2 AND last_active_month = 3 THEN (feb_aa*2 + mar_aa)*1.0 / (feb_aa*2 + mar_aa)*1.0
        WHEN first_active_month = 3 AND last_active_month = 5 THEN (mar_aa*3 + apr_aa*2 + may_aa)*1.0 / (mar_ai*3 + apr_ai*2 + may_ai)*1.0
        WHEN first_active_month = 3 AND last_active_month = 4 THEN (mar_aa*2 + apr_aa)*1.0 / (mar_ai*2 + apr_ai)*1.0
        WHEN first_active_month = 4 AND last_active_month = 5 THEN (apr_aa*2 + may_aa)*1.0 / (apr_ai*2 + may_ai)*1.0
        WHEN first_active_month = 5 AND last_active_month = 5 THEN may_aa*1.0 / may_ai*1.0
        WHEN first_active_month = 4 AND last_active_month = 4 THEN apr_aa*1.0 / apr_ai*1.0
        WHEN first_active_month = 3 AND last_active_month = 3 THEN mar_aa*1.0 / mar_ai*1.0
        WHEN first_active_month = 2 AND last_active_month = 1 THEN feb_aa*1.0 / feb_ai*1.0
        WHEN first_active_month = 1 AND last_active_month = 1 THEN jan_aa*1.0 / jan_ai*1.0
    END AS approval_rate_avg
FROM
    monthly_data
)
select distinct month_key,
		region_code,
		area_name,
		email,
		approval_rate_avg,
		rank() over (order by approval_rate_avg desc) as rank_approval_rate_avg
from cal_aa_avg
join dim_pos dp 
on cal_aa_avg.area_name = dp.region ;
    
    
select*from tmp_approval_rate;
    
    