truncate table tmp_phat_sinh_du_no ;

INSERT INTO tmp_phat_sinh_du_no
(month_key, region_code, area_name, email, psdn_avg, rank_psdn_avg)
WITH monthly_data AS ( -- tìm tháng phát sinh và kết thúc
    SELECT
        month_key,
        area_name,
        sale_name,
        email,
        jan_psdn,
        feb_psdn,
        mar_psdn,
        apr_psdn,
        may_psdn,
        CASE
            WHEN jan_psdn IS NOT NULL THEN 1
            WHEN feb_psdn IS NOT NULL THEN 2
            WHEN mar_psdn IS NOT NULL THEN 3
            WHEN apr_psdn IS NOT NULL THEN 4
            WHEN may_psdn IS NOT NULL THEN 5
        END as first_active_month,
        CASE
            WHEN may_psdn IS NOT NULL THEN 5
            WHEN apr_psdn IS NOT NULL THEN 4
            WHEN mar_psdn IS NOT NULL THEN 3
            WHEN feb_psdn IS NOT NULL THEN 2
            WHEN jan_psdn IS NOT NULL THEN 1
        END as last_active_month
    FROM kpi_asm_data kad 
), cal_psdn_avg as ( -- calculate psdn
SELECT
    month_key,
    area_name,
    sale_name,
    email,
    first_active_month,
    last_active_month,
    jan_psdn, feb_psdn,
    mar_psdn, apr_psdn, may_psdn,
    CASE
        WHEN first_active_month = 1 AND last_active_month = 5 THEN (jan_psdn*5 + feb_psdn*4 + mar_psdn*3 + apr_psdn*2 + may_psdn) / 5.0
        WHEN first_active_month = 1 AND last_active_month = 4 THEN (jan_psdn*4 + feb_psdn*3 + mar_psdn*2 + apr_psdn) / 4.0
        WHEN first_active_month = 1 AND last_active_month = 3 THEN (jan_psdn*3 + feb_psdn*2 + mar_psdn) / 3.0
        WHEN first_active_month = 1 AND last_active_month = 2 THEN (jan_psdn*2 + feb_psdn) / 2.0
        WHEN first_active_month = 2 AND last_active_month = 5 THEN (feb_psdn*4 + mar_psdn*3 + apr_psdn*2 + may_psdn) / 4.0
        WHEN first_active_month = 2 AND last_active_month = 4 THEN (feb_psdn*3 + mar_psdn*2 + apr_psdn) / 3.0
        WHEN first_active_month = 2 AND last_active_month = 3 THEN (feb_psdn*2 + mar_psdn) / 2.0
        WHEN first_active_month = 3 AND last_active_month = 5 THEN (mar_psdn*3 + apr_psdn*2 + may_psdn) / 3.0
        WHEN first_active_month = 3 AND last_active_month = 4 THEN (mar_psdn*2 + apr_psdn) / 2.0
        WHEN first_active_month = 4 AND last_active_month = 5 THEN (apr_psdn*2 + may_psdn) / 2.0
        WHEN first_active_month = 5 AND last_active_month = 5 THEN may_psdn / 1.0
        WHEN first_active_month = 4 AND last_active_month = 4 THEN apr_psdn / 1.0
        WHEN first_active_month = 3 AND last_active_month = 3 THEN mar_psdn / 1.0
        WHEN first_active_month = 2 AND last_active_month = 1 THEN feb_psdn / 1.0
        WHEN first_active_month = 1 AND last_active_month = 1 THEN may_psdn / 1.0
    END AS psdn_avg
FROM
    monthly_data
)
select distinct month_key,
		region_code,
		area_name,
		email,
		psdn_avg,
		rank() over (order by psdn_avg desc) as rank_psdn_avg
from cal_psdn_avg
join dim_pos dp 
on cal_psdn_avg.area_name = dp.region ;


select*from tmp_phat_sinh_du_no tpsdn ;
    

