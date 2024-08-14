CREATE OR REPLACE PROCEDURE cal_os_employee_count_and_sale_manager_tong_hop()
AS $$
BEGIN
	----tính phân bổ nhân viên sm
	truncate table temp_os_employee_tong_hop ;
	
	INSERT INTO temp_os_employee_tong_hop
	(kpi_month, region_code, employee_count)
	select kpi_month, region_code , count(distinct application_id)
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month, region_code 
	union all 
	select kpi_month,'HEAD' region_code , count(distinct application_id)
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month;
	

	truncate table sale_manager_by_area_cde ;
	   
	INSERT INTO sale_manager_by_area_cde
	(month_key, area_cde, sale_manager)
	select 202302 month_key ,'total' area_cde, count(distinct email) sale_manager 
	from sale_manager sm  
	union all
	select 202302 month_key, area_cde , count(distinct email) sale_manager
	from sale_manager sm 
	group by area_cde ;
	

end;
$$ LANGUAGE plpgsql;


call cal_os_employee_count_and_sale_manager_tong_hop(); 

select*from temp_os_employee_tong_hop toe ;
select*from sale_manager_by_area_cde smbac ;

