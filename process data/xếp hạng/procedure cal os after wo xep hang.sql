CREATE OR REPLACE PROCEDURE cal_os_after_wo_xep_hang()
AS $$
BEGIN
	
	--- tính dư nơ cuối kì trung bình sau wo nhóm 1 (max_bucket vào region_code)
	truncate table temp_os_after_wo_1_xep_hang ;

	INSERT INTO temp_os_after_wo_1_xep_hang
	(month_key, region_code, area_name, email, avg_dbgroup_1)
	select 202302 month_key, region_code, area_name, email, avg(os_after_wo_1) 
	from (
	select kpi_month,  dp.region_code, area_name, email , sum(outstanding_principal) os_after_wo_1
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	join kpi_asm_data kad on kad.area_name = dp.region
	where max_bucket = 1
	and kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month, dp.region_code, area_name, email ) x
	group by region_code, area_name, email
	union all
	select 202302 month_key, region_code, 'HEAD' area_name, 'HEAD' email, avg(os_after_wo_1) 
	from (
	select kpi_month,'HEAD' region_code , sum(outstanding_principal) os_after_wo_1
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where max_bucket = 1
	and kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month ) x
	group by region_code;

	--- tính dư nơ cuối kì trung bình sau wo nhóm 2 (max_bucket vào region_code)
	truncate table temp_os_after_wo_2_xep_hang ;
	
	INSERT INTO temp_os_after_wo_2_xep_hang
	(month_key, region_code, area_name, email, avg_dbgroup_2)
	select 202302 month_key, region_code, area_name, email, avg(os_after_wo_2) 
	from (
	select kpi_month,  dp.region_code, area_name, email , sum(outstanding_principal) os_after_wo_2
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	join kpi_asm_data kad on kad.area_name = dp.region
	where max_bucket = 2
	and kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month, dp.region_code, area_name, email ) x
	group by region_code, area_name, email
	union all
	select 202302 month_key, region_code, 'HEAD' area_name, 'HEAD' email, avg(os_after_wo_2) 
	from (
	select kpi_month,'HEAD' region_code , sum(outstanding_principal) os_after_wo_2
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where max_bucket = 2
	and kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month ) x
	group by region_code;

	--- tính dư nơ cuối kì trung bình sau wo nhóm 345 (max_bucket vào region_code)
	truncate table temp_os_after_wo_345_xep_hang ;
	
	INSERT INTO temp_os_after_wo_345_xep_hang
	(month_key, region_code, area_name, email, avg_dbgroup_345)
	select 202302 month_key, region_code, area_name, email, avg(os_after_wo_345) 
	from (
	select kpi_month,  dp.region_code, area_name, email , sum(outstanding_principal) os_after_wo_345
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	join kpi_asm_data kad on kad.area_name = dp.region
	where max_bucket = 1
	and kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month, dp.region_code, area_name, email ) x
	group by region_code, area_name, email
	union all
	select 202302 month_key, region_code, 'HEAD' area_name, 'HEAD' email, avg(os_after_wo_345) 
	from (
	select kpi_month,'HEAD' region_code , sum(outstanding_principal) os_after_wo_345
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where max_bucket = 1
	and kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month ) x
	group by region_code;


	--- tính dư nơ cuối kì trung bình sau wo (max_bucket vào region_code)
	truncate table temp_os_after_wo_xep_hang ;
	
	INSERT INTO temp_os_after_wo_xep_hang
	(month_key , region_code, area_name, email, avg_dbgroup_after_wo)
	select a.month_key , a.region_code , a.area_name, a.email ,
	a.avg_dbgroup_1 + b.avg_dbgroup_2 + c.avg_dbgroup_345 
	from temp_os_after_wo_1_xep_hang a 
	join temp_os_after_wo_2_xep_hang b on a.region_code = b.region_code 
			and a.area_name = b.area_name and a.email = b.email 
	join temp_os_after_wo_345_xep_hang c on b.region_code = c.region_code
			and b.area_name = c.area_name and b.email = c.email ;
end;
$$ LANGUAGE plpgsql;


call cal_os_after_wo_xep_hang(); 


select*from temp_os_after_wo_1_xep_hang toawsm ;
select*from temp_os_after_wo_2_xep_hang toawsm ;
select*from temp_os_after_wo_345_xep_hang toawsm ;
select*from temp_os_after_wo_xep_hang toawsm ;






