CREATE OR REPLACE PROCEDURE cal_the_psdn_xep_hang()
AS $$
BEGIN
	--- tính dư nơ cuối kì trung bình sau wo nhóm 2 (max_bucket vào region_code)
	truncate table temp_psdn_xep_hang ;
	
	INSERT INTO temp_psdn_xep_hang
	(month_key, region_code, area_name, email, avg_psdn)
	select 202302 month_key, region_code, area_name, email, avg(the_psdn) 
	from (
	select kpi_month,  dp.region_code, area_name, email , sum(outstanding_principal) the_psdn
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	join kpi_asm_data kad on kad.area_name = dp.region
	and psdn = 1
	and kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month, dp.region_code, area_name, email ) x
	group by region_code, area_name, email
	union all
	select 202302 month_key, region_code, 'HEAD' area_name, 'HEAD' email, avg(the_psdn) 
	from (
	select kpi_month,'HEAD' region_code , sum(outstanding_principal) the_psdn
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	and psdn = 1
	and kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month ) x
	group by region_code;
end;
$$ LANGUAGE plpgsql;


call cal_the_psdn_xep_hang(); 

select*from temp_psdn_xep_hang toawsm ;






