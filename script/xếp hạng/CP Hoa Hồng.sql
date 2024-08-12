/*CHI TIÊU CP hoa hồng*/
------ tính tháng 2
select*from dim_structure ds ;
---- step 1: đổ dữ liệu lãi trong hai chưa phân bảo vào temporary table
--- tính CP hoa hồng chưa phân bổ 

truncate table tmp_cp_hoa_hong_chua_phan_bo_sale_manager ;

INSERT INTO tmp_cp_hoa_hong_chua_phan_bo_sale_manager
(month_key, region_code, area_name, email, amount)

select 202302 as month_key, dp.region_code, area_name, email, sum(amount) cp_hoa_hong
from fact_txn_month_raw_data ftmrd 
join dim_pos dp on ftmrd.region_code = dp.region_code 
join kpi_asm_data kad on kad.area_name = dp.region 
where dim_id = 17 and dvml_head = 'DVML'
and transaction_date between '2023-01-31' and '2023-02-28'
group by dp.region_code, area_name, email
union all 
select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) cp_hoa_hong
from fact_txn_month_raw_data ftmrd 
where dim_id = 17 and dvml_head = 'HEAD'
and transaction_date between '2023-01-31' and '2023-02-28'
group by region_code ;

select*from tmp_cp_hoa_hong_chua_phan_bo_sale_manager tlqhcpbsm ;

---- step 2: đổ dữ liệu vào 
--- tính dư nơ cuối kì trung bình sau wo nhóm 345 (max_bucket vào region_code)
truncate table temp_os_after_wo_sale_manager ;

INSERT INTO temp_os_after_wo_sale_manager
(month_key , region_code, area_name, email, avg_dbgroup_after_wo)
select a.month_key , a.region_code , a.area_name, a.email,
a.avg_dbgroup_1 + b.avg_dbgroup_2 + c.avg_dbgroup_345 
from temp_os_after_wo_1_sale_manager a 
join temp_os_after_wo_2_sale_manager b on a.region_code = b.region_code 
		and a.area_name = b.area_name and a.email = b.email 
join temp_os_after_wo_345_sale_manager c on b.region_code = c.region_code
		and b.area_name = c.area_name and b.email = c.email ; 

select*from temp_os_after_wo_sale_manager toawsm ;

---- step 3: đổ data vào tính amount đã phân bổ
truncate table tmp_cp_hoa_hong_da_phan_bo_sale_manager ;

INSERT INTO tmp_cp_hoa_hong_da_phan_bo_sale_manager
(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)

select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
from tmp_cp_hoa_hong_chua_phan_bo_sale_manager x 
join tmp_cp_hoa_hong_chua_phan_bo_sale_manager y 
on y.region_code = 'HEAD'
-- tính tỷ trọng phân bỏ
left join 
(
	select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
	from temp_os_after_wo_sale_manager a 
	join temp_os_after_wo_sale_manager b 
	on b.region_code = 'HEAD'
	where a.region_code <> 'HEAD'
) z
on x.month_key = z.month_key and x.region_code = z.region_code
where x.region_code <> 'HEAD';


select*from tmp_cp_hoa_hong_da_phan_bo_sale_manager tlqhdpbsm ;



