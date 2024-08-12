/* CHI TIÊU CP nhân viên */
select*from fact_kpi_month_raw_data fkmrd ;
------ tính tháng 2
select*from dim_structure ds ; 
--- tính tổng thu nhập hoạt động từ thẻ vay ĐVML
---- step 1: đổ dữ liệu CP nhân viên chưa phân bảo vào temporary table

--- tính CP nhân viên chưa phân bổ 
truncate table tmp_cp_nhan_vien_chua_phan_bo;
--- CP nhân viên DVML
INSERT INTO tmp_cp_nhan_vien_chua_phan_bo
(month_key, region_code, amount)
select 202302 month_key,  region_code, sum(amount)
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'DVML' and dim_id = 23
group by region_code 
union all 
--- CP nhân viên HEAD
select 202302 month_key, 'HEAD' region_code, sum(amount)
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dim_id = 23 and dvml_head = 'HEAD';

select*from tmp_cp_nhan_vien_chua_phan_bo;
---- step 2: tính phân bổ nhân viên sm
truncate table temp_os_employee ;

INSERT INTO temp_os_employee 
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

select*from temp_os_employee toe ;
---- step 3: tính phân bổ CP nhân viên
truncate table tmp_cp_nhan_vien_da_phan_bo;

INSERT INTO tmp_cp_nhan_vien_da_phan_bo
(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, employee_count, employee_count_head, amount_da_phan_bo)
select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
z.employee_count, z.employee_count_head, 
x.amount + (y.amount * z.employee_count / z.employee_count_head) amount_da_phan_bo
from tmp_cp_nhan_vien_chua_phan_bo x 
join tmp_cp_nhan_vien_chua_phan_bo y
on y.region_code = 'HEAD'
-- tính tỷ trọng phân bỏ
left join 
(
	select a.kpi_month , a.region_code , a.employee_count  , b.employee_count as employee_count_head
	from temp_os_employee a 
	join temp_os_employee b 
	on b.region_code = 'HEAD'
	where a.region_code <> 'HEAD'
) z
on x.month_key = z.kpi_month and x.region_code = z.region_code
where x.region_code <> 'HEAD'
order by x.region_code;



select*from tmp_cp_nhan_vien_da_phan_bo tcnvdpb ;

