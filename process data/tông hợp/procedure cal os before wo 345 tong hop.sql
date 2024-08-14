CREATE OR REPLACE PROCEDURE cal_os_before_wo_345_tong_hop()
AS $$
BEGIN
	---- tính dư nơ trung bình trước wo của nhóm 345 theo các region và max_bucket (các loại nhóm nợ)

	truncate table temp_os_before_wo_345_tong_hop ;
	
	-- tính DVML
	INSERT INTO temp_os_before_wo_345_tong_hop
	(month_key, region_code, avg_dbgroup_345)
	SELECT 202302 AS kpi_month, region_code, 
	       avg(os_before_wo_2345) AS avg_os_before_wo_2345_cumulative
	FROM (
	    SELECT region_code, kpi_month,
	           SUM(CASE
	               WHEN COALESCE(max_bucket, 3, 4, 5) IN (3, 4, 5) THEN outstanding_principal
	               ELSE 0
	           END) AS os_before_wo_2345
	    FROM fact_kpi_month_raw_data fkmrd
	    JOIN dim_pos dp ON fkmrd.pos_city = dp.pos_city
	    WHERE kpi_month <= 202302 AND kpi_month >= 202301
	    GROUP BY region_code, kpi_month
	) x
	GROUP BY region_code
	
	UNION ALL
	
	-- tính HEAD
	SELECT 202302 AS kpi_month, 'HEAD' AS region_code,
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


call cal_os_before_wo_345_tong_hop(); 

select*from temp_os_before_wo_345_tong_hop tobw ;

