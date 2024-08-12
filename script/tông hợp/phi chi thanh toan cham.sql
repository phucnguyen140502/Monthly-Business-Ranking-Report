
/* CHI TIÊU PHÍ THANH TOÁN KHÁC */
------ tính tháng 2
select*from dim_structure ds ;

---- step 1: đổ dữ liệu phí thanh toán chậm chưa phân bảo vào temporary table
--- tính phí thanh toán chưa phân bổ 
truncate table tmp_phi_thanh_toan_cham_chua_phan_bo ;
INSERT INTO tmp_phi_thanh_toan_cham_chua_phan_bo
(month_key, region_code, amount)
--- phí thanh toán DVML
select 202302 month_key,  region_code, sum(amount) phi_thanh_toan_cham
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'DVML' and dim_id = 7
group by region_code 
union all 
--- phí thanh toán HEAD
select 202302 month_key, 'HEAD' region_code, sum(amount) phi_thanh_toan_cham
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'HEAD' and dim_id = 7;

select*from tmp_phi_thanh_toan_cham_chua_phan_bo tlthcpb ;

---- step 2: tính dư nơ trung bình sau wo của nhóm 345 theo các region và max_bucket (các loại nhóm nợ)
select*from fact_txn_month_raw_data ftmrd ;
select*from dim_pos dp ;

truncate table temp_os_after_wo_345 ;

-- tính DVML
INSERT INTO temp_os_after_wo_345
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

select*from temp_os_after_wo_345;

--- step 3: tính phân bổ phi thanh toán chậm
truncate table tmp_phi_thanh_toan_cham_da_phan_bo;

INSERT INTO tmp_phi_thanh_toan_cham_da_phan_bo
(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_345, avg_dbgroup_345_head, amount_da_phan_bo)
select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
z.avg_dbgroup_345, z.avg_dbgroup_345_head, 
x.amount + (y.amount * z.avg_dbgroup_345 / z.avg_dbgroup_345_head) amount_da_phan_bo
from tmp_phi_thanh_toan_cham_chua_phan_bo x 
join tmp_phi_thanh_toan_cham_chua_phan_bo y
on y.region_code = 'HEAD'
-- tính tỷ trọng phân bỏ
left join 
(
	select a.month_key , a.region_code , a.avg_dbgroup_345  , b.avg_dbgroup_345 as avg_dbgroup_345_head
	from temp_os_after_wo_345 a 
	join temp_os_after_wo_345 b 
	on b.region_code = 'HEAD'
	where a.region_code <> 'HEAD'
) z
on x.month_key = z.month_key and x.region_code = z.region_code
where x.region_code <> 'HEAD'
order by x.region_code;

select*from tmp_phi_thanh_toan_cham_da_phan_bo tlthdpb ;

















