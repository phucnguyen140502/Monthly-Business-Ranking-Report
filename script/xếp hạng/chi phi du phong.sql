/*CHI TIÊU Chi phí dự phòng*/
------ tính tháng 2
select*from dim_structure ds ;
---- step 1: đổ dữ liệu lãi trong hai chưa phân bảo vào temporary table
--- tính Chi phí dự phòng chưa phân bổ 

truncate table tmp_chi_phi_du_phong_chua_phan_bo_sale_manager ;

INSERT INTO tmp_chi_phi_du_phong_chua_phan_bo_sale_manager
(month_key, region_code, area_name, email, amount)
select 202302 as month_key, dp.region_code, area_name, email, sum(amount) chi_phi_du_phong
from fact_txn_month_raw_data ftmrd 
join dim_pos dp on ftmrd.region_code = dp.region_code 
join kpi_asm_data kad on kad.area_name = dp.region 
where dim_id = 26 and dvml_head = 'DVML'
and transaction_date between '2023-01-31' and '2023-02-28'
group by dp.region_code, area_name, email
union all 
select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) chi_phi_du_phong
from fact_txn_month_raw_data ftmrd 
where dim_id = 26 and dvml_head = 'HEAD'
and transaction_date between '2023-01-31' and '2023-02-28'
group by region_code ;

select*from tmp_chi_phi_du_phong_chua_phan_bo_sale_manager tlqhcpbsm ;

select*from temp_os_employee;

---- step 2: đổ dữ liệu vào 
--- tính dư nơ cuối kì trung bình sau wo nhóm 345 (max_bucket vào region_code)
truncate table temp_os_before_wo_345_sale_manager ;

-- tính DVML
INSERT INTO temp_os_before_wo_345_sale_manager
(month_key, region_code, area_name, email, avg_dbgroup_345)
SELECT 202302 AS kpi_month, region_code, area_name, email,
       avg(os_before_wo_2345) AS avg_os_before_wo_2345_cumulative
FROM (
    SELECT kpi_month,dp.region_code, area_name, email,
           SUM(CASE
               WHEN COALESCE(max_bucket, 3, 4, 5) IN (3, 4, 5) THEN outstanding_principal
               ELSE 0
           END) AS os_before_wo_2345
    FROM fact_kpi_month_raw_data fkmrd
    JOIN dim_pos dp ON fkmrd.pos_city = dp.pos_city
    join kpi_asm_data kad on kad.area_name = dp.region
    WHERE kpi_month <= 202302 AND kpi_month >= 202301
    GROUP BY kpi_month, dp.region_code, area_name, email
) x
GROUP BY region_code, area_name, email

UNION ALL

-- tính HEAD
SELECT 202302 AS kpi_month, 'HEAD' AS region_code, 'HEAD' area_name, 'HEAD' email,
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

select*from temp_os_before_wo_345_sale_manager tobw ;

---- step 3: đổ data vào tính amount đã phân bổ
truncate table tmp_chi_phi_du_phong_da_phan_bo_sale_manager ;

INSERT INTO tmp_chi_phi_du_phong_da_phan_bo_sale_manager
(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_345, avg_dbgroup_345_head, amount_da_phan_bo)
select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
z.avg_dbgroup_345, z.avg_dbgroup_345_head, 
x.amount + (y.amount * z.avg_dbgroup_345 / z.avg_dbgroup_345_head) amount_da_phan_bo
from tmp_chi_phi_du_phong_chua_phan_bo_sale_manager x 
join tmp_chi_phi_du_phong_chua_phan_bo_sale_manager y 
on y.region_code = 'HEAD'
-- tính tỷ trọng phân bỏ
left join 
(
	select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_345  , b.avg_dbgroup_345 as avg_dbgroup_345_head
	from temp_os_before_wo_345_sale_manager a 
	join temp_os_before_wo_345_sale_manager b 
	on b.region_code = 'HEAD'
	where a.region_code <> 'HEAD'
) z
on x.month_key = z.month_key and x.region_code = z.region_code
where x.region_code <> 'HEAD';


select*from tmp_chi_phi_du_phong_da_phan_bo_sale_manager tlqhdpbsm ;


