CREATE OR REPLACE PROCEDURE cal_os_before_wo_345_xep_hang()
AS $$
BEGIN

--- tính dư nơ cuối kì trung bình sau wo nhóm 345 (max_bucket vào region_code)
	truncate table temp_os_before_wo_345_xep_hang ;

	-- tính DVML
	INSERT INTO temp_os_before_wo_345_xep_hang
	(month_key, region_code, area_name, email, avg_dbgroup_345)
	SELECT 202302 AS kpi_month, region_code, area_name, email,
	       avg(os_before_wo_2345) AS avg_os_before_wo_2345_cumulative
	FROM (
	    SELECT kpi_month,dp.region_code, area_name, email,
	           SUM(CASE
	               WHEN COALESCE(max_bucket, 3, 4, 5) IN (3, 4, 5) THEN outstanding_principal
	               ELSE 0
	           END) AS os_before_wo_2345
	    FROM fact_kpi_month_raw_data fkmrd
	    JOIN dim_pos dp ON fkmrd.pos_city = dp.pos_city
	    join kpi_asm_data kad on kad.area_name = dp.region
	    WHERE kpi_month <= 202302 AND kpi_month >= 202301
	    GROUP BY kpi_month, dp.region_code, area_name, email
	) x
	GROUP BY region_code, area_name, email
	
	UNION ALL
	
	-- tính HEAD
	SELECT 202302 AS kpi_month, 'HEAD' AS region_code, 'HEAD' area_name, 'HEAD' email,
	       SUM(os_before_wo_2345) / COUNT(DISTINCT kpi_month) AS avg_os_before_wo_2345_cumulative
	FROM (
	    SELECT 'HEAD' AS region_code, kpi_month,
	           SUM(CASE
	               WHEN COALESCE(max_bucket, 3, 4, 5) IN (3, 4, 5) THEN outstanding_principal
	               ELSE 0
	           END) AS os_before_wo_2345
	    FROM fact_kpi_month_raw_data fkmrd
	    JOIN dim_pos dp ON fkmrd.pos_city = dp.pos_city
	    WHERE kpi_month <= 202302 AND kpi_month >= 202301
	    GROUP BY kpi_month
	) x
	GROUP BY region_code;
	
end;
$$ LANGUAGE plpgsql;


call cal_os_before_wo_345_xep_hang(); 
	
	
select*from temp_os_before_wo_345_xep_hang tobw ;







