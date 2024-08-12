
/* CHI TIÊU CHI PHÍ DỰ PHÒNG */
------ tính tháng 2
select*from dim_structure ds ;

---- step 1: đổ dữ liệu chi phi dự phòng chưa phân bảo vào temporary table
truncate table tmp_chi_phi_du_phong_chua_phan_bo;

--- tính chi phi dự phòng chưa phân bổ 
INSERT INTO tmp_chi_phi_du_phong_chua_phan_bo
(month_key, region_code, amount)
--- chi phí dự phòng DVML
select 202302 month_key,  region_code, sum(amount) 
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'DVML' and dim_id = 26
group by region_code 
union all 
--- chi phí dự phòng HEAD
select 202302 month_key, 'HEAD' region_code, sum(amount) 
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'HEAD' and dim_id = 26;

select*from tmp_chi_phi_du_phong_chua_phan_bo tcpdpcpb ;
---- step 2: tính dư nơ trung bình sau wo của nhóm 345 theo các region và max_bucket (các loại nhóm nợ)
select*from fact_txn_month_raw_data ftmrd ;
select*from dim_pos dp ;

truncate table temp_os_before_wo_345 ;

-- tính DVML
INSERT INTO temp_os_before_wo_345
(month_key, region_code, avg_dbgroup_345)
SELECT 202302 AS kpi_month, region_code, 
       avg(os_before_wo_2345) AS avg_os_before_wo_2345_cumulative
FROM (
    SELECT region_code, kpi_month,
           SUM(CASE
               WHEN COALESCE(max_bucket, 3, 4, 5) IN (3, 4, 5) THEN outstanding_principal
               ELSE 0
           END) AS os_before_wo_2345
    FROM fact_kpi_month_raw_data fkmrd
    JOIN dim_pos dp ON fkmrd.pos_city = dp.pos_city
    WHERE kpi_month <= 202302 AND kpi_month >= 202301
    GROUP BY region_code, kpi_month
) x
GROUP BY region_code

UNION ALL

-- tính HEAD
SELECT 202302 AS kpi_month, 'HEAD' AS region_code,
       SUM(os_before_wo_2345) / COUNT(DISTINCT kpi_month) AS avg_os_before_wo_2345_cumulative
FROM (
    SELECT 'HEAD' AS region_code, kpi_month,
           SUM(CASE
               WHEN COALESCE(max_bucket, 3, 4, 5) IN (3, 4, 5) THEN outstanding_principal
               ELSE 0
           END) AS os_before_wo_2345
    FROM fact_kpi_month_raw_data fkmrd
    JOIN dim_pos dp ON fkmrd.pos_city = dp.pos_city
    WHERE kpi_month <= 202302 AND kpi_month >= 202301
    GROUP BY kpi_month
) x
GROUP BY region_code;

select*from temp_os_before_wo_345 tobw ;

--- step 3: tính phân bổ chi phí dự phòng
truncate table tmp_phi_chi_du_phong_da_phan_bo;

INSERT INTO tmp_phi_chi_du_phong_da_phan_bo
(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_345, avg_dbgroup_345_head, amount_da_phan_bo)
select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
z.avg_dbgroup_345, z.avg_dbgroup_345_head, 
x.amount + (y.amount * z.avg_dbgroup_345 / z.avg_dbgroup_345_head) amount_da_phan_bo
from tmp_chi_phi_du_phong_chua_phan_bo x 
join tmp_chi_phi_du_phong_chua_phan_bo y
on y.region_code = 'HEAD'
-- tính tỷ trọng phân bỏ
left join 
(
	select a.month_key , a.region_code , a.avg_dbgroup_345  , b.avg_dbgroup_345 as avg_dbgroup_345_head
	from temp_os_before_wo_345 a 
	join temp_os_before_wo_345 b 
	on b.region_code = 'HEAD'
	where a.region_code <> 'HEAD'
) z
on x.month_key = z.month_key and x.region_code = z.region_code
where x.region_code <> 'HEAD'
order by x.region_code;

select*from tmp_phi_chi_du_phong_da_phan_bo tpcdpdpb ;


















