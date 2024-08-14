CREATE OR REPLACE PROCEDURE cal_pre_quy_mo_xep_hang()
AS $$
BEGIN
	
	-- loan to new
	truncate table tmp_loan_to_new_xep_hang;
	
	INSERT INTO tmp_loan_to_new_xep_hang
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
	     
	-- phát sinh dư nợ   
    truncate table tmp_phat_sinh_du_no_xep_hang ;

	INSERT INTO tmp_phat_sinh_du_no_xep_hang
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
	
	-- approval rate    
	
	truncate table tmp_approval_rate_xep_hang;
	INSERT INTO tmp_approval_rate_xep_hang
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
	    
    -- npl trước lũy kế 
	truncate table tmp_npl_truoc_wo_luy_ke_xep_hang ;

	INSERT INTO tmp_npl_truoc_wo_luy_ke_xep_hang
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
	
end;
$$ LANGUAGE plpgsql;


call cal_pre_quy_mo_xep_hang(); 


