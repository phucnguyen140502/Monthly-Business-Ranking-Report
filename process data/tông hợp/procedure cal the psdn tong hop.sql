CREATE OR REPLACE PROCEDURE cal_the_psdn_tong_hop()
AS $$
BEGIN
	-- tính thẻ PSDN 
	truncate table temp_psdn_tong_hop;
	
	INSERT INTO temp_psdn_tong_hop
	(kpi_month, region_code, avg_psdn)
	select 202302 kpi_month , region_code, avg(the_psdn) avg_the_psdn
	from (
	select region_code, kpi_month, sum(outstanding_principal) the_psdn
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where kpi_month <= 202302 and kpi_month >= 202301 
	and psdn = 1
	group by region_code, kpi_month) x
	group by region_code
	union all
	-- tính HEAD
	select 202302 kpi_month, region_code, avg(the_psdn) avg_the_psdn
	from (
	select kpi_month, 'HEAD' region_code, sum(outstanding_principal) the_psdn
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where kpi_month <= 202302 and kpi_month >= 202301
	and psdn = 1
	group by kpi_month) x 
	group by region_code;
end;
$$ LANGUAGE plpgsql;


call cal_the_psdn_tong_hop(); 

select*from temp_psdn_tong_hop tp ;

