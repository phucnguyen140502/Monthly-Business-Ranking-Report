
/* CHI TIÊU PHÍ TĂNG HẠN MỨC */
------ tính tháng 2
select*from dim_structure ds ;

---- step 1: đổ dữ liệu phí tăng han muc chưa phân bảo vào temporary table
--- tính phí tăng han muc chưa phân bổ 
truncate table tmp_phi_tang_han_muc_chua_phan_bo ;
INSERT INTO tmp_phi_tang_han_muc_chua_phan_bo
(month_key, region_code, amount)
--- phí tăng han muc DVML
select 202302 month_key,  region_code, sum(amount) phi_tang_han_muc
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'DVML' and dim_id = 6
group by region_code 
union all 
--- phí tăng han muc HEAD
select 202302 month_key, 'HEAD' region_code, sum(amount) phi_tang_han_muc
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'HEAD' and dim_id = 6;

select*from tmp_phi_tang_han_muc_chua_phan_bo tlthcpb ;

---- step 2: tính dư nơ trung bình sau wo của nhóm 1 theo các region và max_bucket (các loại nhóm nợ)
select*from fact_txn_month_raw_data ftmrd ;
select*from dim_pos dp ;

-- tính DVML
truncate table temp_os_after_wo_1 ;

INSERT INTO temp_os_after_wo_1
(kpi_month, region_code, avg_dbgroup_1)
select 202302 kpi_month , region_code, avg(os_after_wo_1) os_after_wo_1
from (
select region_code, kpi_month, sum(outstanding_principal) os_after_wo_1
from fact_kpi_month_raw_data fkmrd 
join dim_pos dp on fkmrd.pos_city = dp.pos_city 
where kpi_month <= 202302 and kpi_month >= 202301 
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

select*from temp_os_after_wo_1;

--- step 3: tính phân bổ phi tang hang muc
truncate table tmp_phi_tang_han_muc_da_phan_bo;

INSERT INTO tmp_phi_tang_han_muc_da_phan_bo
(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head,
avg_dbgroup_1, avg_dbgroup_1_head, amount_da_phan_bo)
select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
z.avg_dbgroup_1, z.avg_dbgroup_1_head, 
x.amount + (y.amount * z.avg_dbgroup_1 / z.avg_dbgroup_1_head) amount_da_phan_bo
from tmp_phi_tang_han_muc_chua_phan_bo x 
join tmp_phi_tang_han_muc_chua_phan_bo y
on y.region_code = 'HEAD'
-- tính tỷ trọng phân bỏ
left join 
(
	select a.kpi_month , a.region_code , a.avg_dbgroup_1  , b.avg_dbgroup_1 as avg_dbgroup_1_head
	from temp_os_after_wo_1 a 
	join temp_os_after_wo_1 b 
	on b.region_code = 'HEAD'
	where a.region_code <> 'HEAD'
) z
on x.month_key = z.kpi_month and x.region_code = z.region_code
where x.region_code <> 'HEAD'
order by x.region_code;

select*from tmp_phi_tang_han_muc_da_phan_bo tlthdpb ;


















