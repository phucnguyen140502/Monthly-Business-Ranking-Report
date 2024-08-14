CREATE OR REPLACE PROCEDURE cal_os_employee_xep_hang()
AS $$
BEGIN
	--- tính dư nơ cuối kì trung bình sau wo nhóm 345 (max_bucket vào region_code)
	truncate table temp_os_employee_xep_hang ;
	
	INSERT INTO temp_os_employee_xep_hang
	(kpi_month, region_code, area_name, email, employee_count)
	select kpi_month, dp.region_code, area_name, email , count(distinct application_id)
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month, region_code, area_name, email
	union all 
	select kpi_month,'HEAD' region_code , 'HEAD' area_name, 'HEAD' email , count(distinct application_id)
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month;
	
end;
$$ LANGUAGE plpgsql;


call cal_os_employee_xep_hang(); 
	
select*from temp_os_employee_xep_hang toe ;







