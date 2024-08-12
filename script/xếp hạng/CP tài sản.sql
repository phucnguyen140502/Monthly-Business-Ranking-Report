/*CHI TIÊU CP tài sản*/
------ tính tháng 2
select*from dim_structure ds ;
---- step 1: đổ dữ liệu lãi trong hai chưa phân bảo vào temporary table
--- tính CP tài sản chưa phân bổ 

truncate table tmp_cp_tai_san_chua_phan_bo_sale_manager ;

INSERT INTO tmp_cp_tai_san_chua_phan_bo_sale_manager
(month_key, region_code, area_name, email, amount)
select 202302 as month_key, dp.region_code, area_name, email, sum(amount) cp_tai_san
from fact_txn_month_raw_data ftmrd 
join dim_pos dp on ftmrd.region_code = dp.region_code 
join kpi_asm_data kad on kad.area_name = dp.region 
where dim_id = 25 and dvml_head = 'DVML'
and transaction_date between '2023-01-31' and '2023-02-28'
group by dp.region_code, area_name, email
union all 
select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) cp_tai_san
from fact_txn_month_raw_data ftmrd 
where dim_id = 25 and dvml_head = 'HEAD'
and transaction_date between '2023-01-31' and '2023-02-28'
group by region_code ;

select*from tmp_cp_tai_san_chua_phan_bo_sale_manager tlqhcpbsm ;

---- step 2: đổ dữ liệu vào 
--- tính dư nơ cuối kì trung bình sau wo nhóm 345 (max_bucket vào region_code)
truncate table temp_os_employee_sale_manager ;

INSERT INTO temp_os_employee_sale_manager
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

select*from temp_os_employee_sale_manager toe ;

---- step 3: đổ data vào tính amount đã phân bổ
truncate table tmp_cp_tai_san_da_phan_bo_sale_manager ;

INSERT INTO tmp_cp_tai_san_da_phan_bo_sale_manager
(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, employee_count, employee_count_head, amount_da_phan_bo)
select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
z.employee_count, z.employee_count_head, 
x.amount + (y.amount * z.employee_count / z.employee_count_head) amount_da_phan_bo
from tmp_cp_tai_san_chua_phan_bo_sale_manager x 
join tmp_cp_tai_san_chua_phan_bo_sale_manager y 
on y.region_code = 'HEAD'
-- tính tỷ trọng phân bỏ
left join 
(
	select a.kpi_month , a.region_code, a.area_name, a.email , a.employee_count  , b.employee_count as employee_count_head
	from temp_os_employee_sale_manager a 
	join temp_os_employee_sale_manager b 
	on b.region_code = 'HEAD'
	where a.region_code <> 'HEAD'
) z
on x.month_key = z.kpi_month and x.region_code = z.region_code
where x.region_code <> 'HEAD';


select*from tmp_cp_tai_san_da_phan_bo_sale_manager tlqhdpbsm ;


