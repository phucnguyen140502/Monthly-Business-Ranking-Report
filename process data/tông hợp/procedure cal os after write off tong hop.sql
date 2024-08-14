CREATE OR REPLACE PROCEDURE cal_os_after_wo_tong_hop()
AS $$
BEGIN
	
	-- tính dư nơ trung bình sau wo của nhóm 1 theo các region và max_bucket (các loại nhóm nợ)
	
	-- tính DVML
	truncate table temp_os_after_wo_1_tong_hop ;
	
	INSERT INTO temp_os_after_wo_1_tong_hop
	(kpi_month, region_code, avg_dbgroup_1)
	select 202302 kpi_month , region_code, avg(os_after_wo_1) os_after_wo_1
	from (
	select region_code, kpi_month, sum(outstanding_principal) os_after_wo_1
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where kpi_month <= 202302 and kpi_month >= 202302
	and max_bucket = 1
	group by region_code, kpi_month) x
	group by region_code
	union all
	-- tính HEAD
	select 202302 kpi_month, region_code, avg(os_after_wo_1) avg_os_after_wo_1
	from (
	select kpi_month, 'HEAD' region_code, sum(outstanding_principal) os_after_wo_1
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where kpi_month <= 202302 and kpi_month >= 202301
	and max_bucket = 1
	group by kpi_month) x 
	group by region_code;
	
	--- tính dư nơ cuối kì trung bình sau wo nhóm 2 (max_bucket vào region_code)
	truncate table temp_os_after_wo_2_tong_hop ;
	
	INSERT INTO temp_os_after_wo_2_tong_hop
	(month_key, region_code, avg_dbgroup_2)
	select 202302 month_key, region_code, avg(os_after_wo_2) 
	from (
	select kpi_month, region_code , sum(outstanding_principal) os_after_wo_2
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where max_bucket = 2
	and kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month, region_code ) x
	group by region_code
	union all 
	select 202302 month_key, region_code, avg(os_after_wo_2) 
	from (
	select kpi_month,'HEAD' region_code , sum(outstanding_principal) os_after_wo_2
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where max_bucket = 2
	and kpi_month <= 202302 and kpi_month >= 202302
	group by kpi_month ) x
	group by region_code;

	---- tính dư nơ trung bình sau wo của nhóm 345 theo các region và max_bucket (các loại nhóm nợ)
	
	truncate table temp_os_after_wo_345_tong_hop ;
	
	-- tính DVML
	INSERT INTO temp_os_after_wo_345_tong_hop
	(month_key, region_code, avg_dbgroup_345)
	select 202302 kpi_month, region_code, avg(os_after_wo_345) avg_os_after_wo_345
	from (
	select region_code, kpi_month,
			sum (case
					when coalesce(max_bucket,3,4,5) in (3,4,5) then outstanding_principal 
					else 0
				end
			) os_after_wo_345
			
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where kpi_month <= 202302 and kpi_month >= 202301 
	group by region_code, kpi_month) x
	group by region_code 
	union all
	-- tính HEAD
	select 202302 kpi_month, region_code, avg(os_after_wo_345) avg_os_after_wo_345
	from (
	select 'HEAD' region_code, kpi_month,
			sum (case
					when coalesce(max_bucket,3,4,5) in (3,4,5) then outstanding_principal 
					else 0
				end
			) os_after_wo_345
			
	from fact_kpi_month_raw_data fkmrd 
	join dim_pos dp on fkmrd.pos_city = dp.pos_city 
	where kpi_month <= 202302 and kpi_month >= 202301 
	group by  kpi_month) x
	group by region_code ;

    --- tính dư nơ trung bình sau wo theo các region và max_bucket (các loại nhóm nợ)
	truncate table temp_os_after_wo_tong_hop ;

	INSERT INTO temp_os_after_wo_tong_hop
	(kpi_month, region_code, avg_dbgroup_after_wo)
	select a.kpi_month , a.region_code , a.avg_dbgroup_1 + b.avg_dbgroup_2 + c.avg_dbgroup_345 
	from temp_os_after_wo_1_tong_hop a 
	join temp_os_after_wo_2_tong_hop b on a.region_code = b.region_code
	join temp_os_after_wo_345_tong_hop c on b.region_code = c.region_code; 
end;
$$ LANGUAGE plpgsql;


call cal_os_after_wo_tong_hop(); 

select*from temp_os_after_wo_1_tong_hop toaw ;
select*from temp_os_after_wo_2_tong_hop toaw ;
select*from temp_os_after_wo_345_tong_hop toaw ;
select*from temp_os_after_wo_tong_hop toaw ;