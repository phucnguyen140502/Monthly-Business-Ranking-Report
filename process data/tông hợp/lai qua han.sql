/*CHI TIÊU LÃI QUÁ HẠN*/
------ tính tháng 2

---- step 1: đổ dữ liệu lãi trong hai chưa phân bảo vào temporary table
--- tính lãi quá hạn chưa phân bổ 
truncate table tmp_lai_qua_han_chua_phan_bo; 

INSERT INTO tmp_lai_qua_han_chua_phan_bo
(month_key, region_code, amount)
select 202302 month_key, region_code, sum(amount) lai_qua_han
from fact_txn_month_raw_data ftmrd 
where dim_id = 4 and dvml_head = 'DVML'
and transaction_date between '2023-01-31' and '2023-02-28'
group by region_code 
union all
select 202302 month_key, 'HEAD' region_code, sum(amount) lai_qua_han
from fact_txn_month_raw_data ftmrd 
where dim_id = 4 and dvml_head = 'HEAD'
and transaction_date between '2023-01-31' and '2023-02-28'
group by region_code ;

select*from tmp_lai_qua_han_chua_phan_bo tlthcpb ;

---- step 2: đổ dữ liệu vào 
--- tính dư nơ cuối kì trung bình sau wo nhóm 2 (max_bucket vào region_code)
truncate table temp_os_after_wo_2 ;

INSERT INTO temp_os_after_wo_2
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

select*from temp_os_after_wo_2 toaw ;

---- step 3: đổ data vào tính amount đã phân bổ
truncate table tmp_lai_qua_han_da_phan_bo ;

INSERT INTO tmp_lai_qua_han_da_phan_bo
(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_2, avg_dbgroup_2_head, amount_da_phan_bo)
select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
z.avg_dbgroup_2, z.avg_dbgroup_2_head, 
x.amount + (y.amount * z.avg_dbgroup_2 / z.avg_dbgroup_2_head) amount_da_phan_bo
from tmp_lai_qua_han_chua_phan_bo x 
join tmp_lai_qua_han_chua_phan_bo y
on y.region_code = 'HEAD'
-- tính tỷ trọng phân bỏ
left join 
(
	select a.month_key , a.region_code , a.avg_dbgroup_2  , b.avg_dbgroup_2 as avg_dbgroup_2_head
	from temp_os_after_wo_2 a 
	join temp_os_after_wo_2 b 
	on b.region_code = 'HEAD'
	where a.region_code <> 'HEAD'
) z
on x.month_key = z.month_key and x.region_code = z.region_code
where x.region_code <> 'HEAD';

select*from tmp_lai_qua_han_da_phan_bo tlqhdpb ;














