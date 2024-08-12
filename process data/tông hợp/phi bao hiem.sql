
/* CHI TIÊU PHÍ BẢO HIỂM */
------ tính tháng 2
select*from dim_structure ds ;

---- step 1: đổ dữ liệu phí tăng han muc chưa phân bảo vào temporary table
--- tính phí tăng bảo hiểm chưa phân bổ 
truncate table tmp_phi_bao_hiem_chua_phan_bo ;
INSERT INTO tmp_phi_bao_hiem_chua_phan_bo
(month_key, region_code, amount)
--- phí bảo hiểm DVML
select 202302 month_key,  region_code, sum(amount) phi_bao_hiem
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'DVML' and dim_id = 5
group by region_code 
union all 
--- phí bảo hiêm HEAD
select 202302 month_key, 'HEAD' region_code, sum(amount) phi_bao_hiem
from fact_txn_month_raw_data ftmrd
where transaction_date between '2023-01-31' and '2023-02-28'
and dvml_head = 'HEAD' and dim_id = 5;

select*from tmp_phi_bao_hiem_chua_phan_bo tpbhcpb ;

--- step 2: tính thẻ PSDN 
truncate table temp_psdn;

INSERT INTO temp_psdn
(kpi_month, region_code, avg_psdn)
select 202302 kpi_month , region_code, avg(the_psdn) avg_the_psdn
from (
select region_code, kpi_month, sum(outstanding_principal) the_psdn
from fact_kpi_month_raw_data fkmrd 
join dim_pos dp on fkmrd.pos_city = dp.pos_city 
where kpi_month <= 202302 and kpi_month >= 202301 
and psdn = 1
group by region_code, kpi_month) x
group by region_code
union all
-- tính HEAD
select 202302 kpi_month, region_code, avg(the_psdn) avg_the_psdn
from (
select kpi_month, 'HEAD' region_code, sum(outstanding_principal) the_psdn
from fact_kpi_month_raw_data fkmrd 
join dim_pos dp on fkmrd.pos_city = dp.pos_city 
where kpi_month <= 202302 and kpi_month >= 202301
and psdn = 1
group by kpi_month) x 
group by region_code;

select*from temp_psdn tp ;


--- step 3: tính phân bổ phí bảo hiểm
truncate table tmp_phi_bao_hiem_da_phan_bo;

INSERT INTO tmp_phi_bao_hiem_da_phan_bo
(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_psdn, avg_psdn_head, amount_da_phan_bo)
select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
z.avg_psdn, z.avg_psdn_head, 
x.amount + (y.amount * z.avg_psdn / z.avg_psdn_head) amount_da_phan_bo
from tmp_phi_bao_hiem_chua_phan_bo x 
join tmp_phi_bao_hiem_chua_phan_bo y
on y.region_code = 'HEAD'
-- tính tỷ trọng phân bỏ
left join 
(
	select a.kpi_month , a.region_code , a.avg_psdn  , b.avg_psdn as avg_psdn_head
	from temp_psdn a 
	join temp_psdn b 
	on b.region_code = 'HEAD'
	where a.region_code <> 'HEAD'
) z
on x.month_key = z.kpi_month and x.region_code = z.region_code
where x.region_code <> 'HEAD'
order by x.region_code;

select*from tmp_phi_bao_hiem_da_phan_bo tpbhdpb ;
























