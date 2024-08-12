/* CHI TIÊU CP vốn CCTG */
------ tính tháng 2
select*from dim_structure ds ; 
--- tính tổng thu nhập hoạt động từ thẻ vay ĐVML
---- step 1: đổ dữ liệu CP vốn CCTG chưa phân bảo vào temporary table

--- tính CP vốn CCTG chưa phân bổ 
truncate table tmp_cp_von_cctg_chua_phan_bo;
--- CP vốn CCTG DVML
INSERT INTO tmp_cp_von_cctg_chua_phan_bo
(month_key, region_code, amount)
select 202302 month_key,  region_code, sum(amount)
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'DVML' and dim_id = 12
group by region_code 
union all 
--- CP vốn CCTG HEAD
select 202302 month_key, 'HEAD' region_code, sum(amount)
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dim_id = 12;

select*from tmp_cp_von_cctg_chua_phan_bo;
---- step 2: tính phân bổ nhân viên sm
select*from temp_os_after_wo toaw ;

---- step 3: tính phân bổ CP vốn CCTG
truncate table tmp_cp_von_cctg_da_phan_bo;

INSERT INTO tmp_cp_von_cctg_da_phan_bo
(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
from tmp_cp_von_cctg_chua_phan_bo x 
join tmp_cp_von_cctg_chua_phan_bo y
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




select*from tmp_cp_von_cctg_da_phan_bo ;



