
/* CHI TIÊU CP hợp tác kd tàu (net) */
------ tính tháng 2
select*from dim_structure ds ;

---- step 1: đổ dữ liệu CP hợp tác kd tàu (net) chưa phân bảo vào temporary table

--- tính CP hợp tác kd tàu (net) chưa phân bổ 
truncate table tmp_cp_net_chua_phan_bo ;
--- CP hợp tác kd tàu (net) DVML
INSERT INTO tmp_cp_net_chua_phan_bo
(month_key, region_code, amount)
select 202302 month_key,  region_code, sum(amount) 
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'DVML' and dim_id = 19
group by region_code 
union all 
--- CP hợp tác kd tàu (net) HEAD
select 202302 month_key, 'HEAD' region_code, sum(amount) 
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'HEAD' and dim_id = 19;

select*from tmp_cp_net_chua_phan_bo tdkd ;

---- step 2: tính dư nơ trung bình sau wo theo các region và max_bucket (các loại nhóm nợ)
select*from fact_txn_month_raw_data ftmrd ;
select*from dim_pos dp ;

select*from temp_os_after_wo_1 toaw ;
select*from temp_os_after_wo_2 toaw ;
select*from temp_os_after_wo_345 toaw ;

truncate table temp_os_after_wo ;

INSERT INTO temp_os_after_wo
(kpi_month, region_code, avg_dbgroup_after_wo)
select a.kpi_month , a.region_code , a.avg_dbgroup_1 + b.avg_dbgroup_2 + c.avg_dbgroup_345 
from temp_os_after_wo_1 a 
join temp_os_after_wo_2 b on a.region_code = b.region_code
join temp_os_after_wo_345 c on b.region_code = c.region_code; 

select*from temp_os_after_wo toaw ;

--- step 3: tính phân bổ CP hợp tác kd tàu (net)
truncate table tmp_cp_net_da_phan_bo ;

INSERT INTO tmp_cp_net_da_phan_bo
(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
from tmp_cp_net_chua_phan_bo x 
join tmp_cp_net_chua_phan_bo y
on y.region_code = 'HEAD'
-- tính tỷ trọng phân bỏ
left join 
(
	select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
	from temp_os_after_wo a 
	join temp_os_after_wo b 
	on b.region_code = 'HEAD'
	where a.region_code <> 'HEAD'
) z
on x.month_key = z.kpi_month and x.region_code = z.region_code
where x.region_code <> 'HEAD'
order by x.region_code;

select*from tmp_cp_net_da_phan_bo tdkddpb ;















