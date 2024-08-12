truncate table tmp_npl_truoc_wo_luy_ke ;

INSERT INTO tmp_npl_truoc_wo_luy_ke
(kpi_month, region_code, area_name, email, npl_truoc_wo_luy_ke, rank_npl_truoc_wo_luy_ke)
WITH monthly_data AS ( -- tính tổng theo tháng
  SELECT 
    202302 kpi_month,
    region_code, kad.area_name, email,
    SUM(CASE WHEN max_bucket >= 3 THEN outstanding_principal ELSE 0 END) AS npl,
    SUM(outstanding_principal) AS total_outstanding
  FROM 
    fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	join kpi_asm_data kad on kad.area_name = dp.region 
  WHERE write_off_month IS NULL OR write_off_month > kpi_month
  GROUP BY region_code, kad.area_name, email
),
cumulative_data AS ( -- tính lũy kế
  SELECT 
    kpi_month,
    region_code, area_name, email,
    npl,
    total_outstanding,
    SUM(npl) OVER (PARTITION BY region_code, area_name, email ORDER BY kpi_month) AS cumulative_npl,
    SUM(total_outstanding) OVER (PARTITION BY region_code, area_name, email ORDER BY kpi_month) AS cumulative_outstanding
  FROM monthly_data
), 
cummulative_npl as ( -- tính npl lũy kế
SELECT 
  kpi_month,
  region_code, area_name, email,
--  npl,
--  total_outstanding,
--  cumulative_npl,
--  cumulative_outstanding,
  (cumulative_npl*1.0 / NULLIF(cumulative_outstanding, 0)*1.0) * 100 AS cumulative_npl_ratio
FROM cumulative_data
ORDER BY region_code, area_name, email
)
select kpi_month, region_code, area_name, email, cumulative_npl_ratio as npl_truoc_wo_luy_ke,
rank() over (order by cumulative_npl_ratio desc) as rank_npl_truoc_wo_luy_ke
from cummulative_npl;
-- formular: NPL = (Tổng nợ xấu / Tổng dư nợ) * 100%

select*from tmp_npl_truoc_wo_luy_ke tntwlk ;