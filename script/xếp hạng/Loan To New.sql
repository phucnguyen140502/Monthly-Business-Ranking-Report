truncate table tmp_loan_to_new;

INSERT INTO tmp_loan_to_new
(month_key, region_code, area_name, email, ltn_avg, rank_ltn_avg)
WITH monthly_data AS ( -- tìm tháng phát sinh và kết thúc
    SELECT
        month_key,
        area_name,
        sale_name,
        email,
        jan_ltn,
        feb_ltn,
        mar_ltn,
        apr_ltn,
        may_ltn,
        CASE
            WHEN jan_ltn IS NOT NULL THEN 1
            WHEN feb_ltn IS NOT NULL THEN 2
            WHEN mar_ltn IS NOT NULL THEN 3
            WHEN apr_ltn IS NOT NULL THEN 4
            WHEN may_ltn IS NOT NULL THEN 5
        END as first_active_month,
        CASE
            WHEN may_ltn IS NOT NULL THEN 5
            WHEN apr_ltn IS NOT NULL THEN 4
            WHEN mar_ltn IS NOT NULL THEN 3
            WHEN feb_ltn IS NOT NULL THEN 2
            WHEN jan_ltn IS NOT NULL THEN 1
        END as last_active_month
    FROM kpi_asm_data kad 
), cal_ltn_avg as ( -- calculate ltn
SELECT
    month_key,
    area_name,
    sale_name,
    email,
    first_active_month,
    last_active_month,
    jan_ltn, feb_ltn,
    mar_ltn, apr_ltn, may_ltn,
    CASE
        WHEN first_active_month = 1 AND last_active_month = 5 THEN (jan_ltn*5 + feb_ltn*4 + mar_ltn*3 + apr_ltn*2 + may_ltn) / 5.0
        WHEN first_active_month = 1 AND last_active_month = 4 THEN (jan_ltn*4 + feb_ltn*3 + mar_ltn*2 + apr_ltn) / 4.0
        WHEN first_active_month = 1 AND last_active_month = 3 THEN (jan_ltn*3 + feb_ltn*2 + mar_ltn) / 3.0
        WHEN first_active_month = 1 AND last_active_month = 2 THEN (jan_ltn*2 + feb_ltn) / 2.0
        WHEN first_active_month = 2 AND last_active_month = 5 THEN (feb_ltn*4 + mar_ltn*3 + apr_ltn*2 + may_ltn) / 4.0
        WHEN first_active_month = 2 AND last_active_month = 4 THEN (feb_ltn*3 + mar_ltn*2 + apr_ltn) / 3.0
        WHEN first_active_month = 2 AND last_active_month = 3 THEN (feb_ltn*2 + mar_ltn) / 2.0
        WHEN first_active_month = 3 AND last_active_month = 5 THEN (mar_ltn*3 + apr_ltn*2 + may_ltn) / 3.0
        WHEN first_active_month = 3 AND last_active_month = 4 THEN (mar_ltn*2 + apr_ltn) / 2.0
        WHEN first_active_month = 4 AND last_active_month = 5 THEN (apr_ltn*2 + may_ltn) / 2.0
        WHEN first_active_month = 5 AND last_active_month = 5 THEN may_ltn /1.0
        WHEN first_active_month = 4 AND last_active_month = 4 THEN apr_ltn /1.0
        WHEN first_active_month = 3 AND last_active_month = 3 THEN mar_ltn /1.0
        WHEN first_active_month = 2 AND last_active_month = 1 THEN feb_ltn /1.0
        WHEN first_active_month = 1 AND last_active_month = 1 THEN may_ltn /1.0
    END AS ltn_avg
FROM
    monthly_data
)
select distinct month_key,
		region_code,
		area_name,
		email,
		ltn_avg,
		rank() over (order by ltn_avg desc) as rank_ltn_avg
from cal_ltn_avg
join dim_pos dp 
on cal_ltn_avg.area_name = dp.region ;
    
    
select*from tmp_loan_to_new tltn ;
    
    