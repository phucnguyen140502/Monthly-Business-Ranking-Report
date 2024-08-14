CREATE OR REPLACE PROCEDURE cal_head_xep_hang()
AS $$
BEGIN
	--- tính LÃI TRONG HẠN chưa phân bổ 

	truncate table tmp_lai_trong_han_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_lai_trong_han_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) lai_trong_han
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 4 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) lai_trong_han
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 4 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;

	--- tính lãi quá hạn chưa phân bổ 

	truncate table tmp_lai_qua_han_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_lai_qua_han_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) lai_qua_han
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 4 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) lai_qua_han
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 4 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;


	--- tính Phí Bảo Hiểm chưa phân bổ 
	
	truncate table tmp_phi_bao_hiem_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_phi_bao_hiem_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) phi_bao_hiem
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 5 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) phi_bao_hiem
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 5 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;
	
	--- tính Phí Tăng Hạn Mức chưa phân bổ 

	truncate table tmp_phi_tang_han_muc_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_phi_tang_han_muc_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) phi_tăng_han_muc
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 6 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) phi_tăng_han_muc
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 6 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;
	
	--- tính PHÍ THANH TOÁN KHÁC chưa phân bổ 

	truncate table tmp_phi_thanh_toan_cham_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_phi_thanh_toan_cham_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) phi_thanh_toan_cham
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 7 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) phi_thanh_toan_cham
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 7 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;

	--- tính DT Nguồn vốn chưa phân bổ 

	truncate table tmp_dt_nguon_von_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_dt_nguon_von_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) dt_nguon_von
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 10 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) dt_nguon_von
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 10 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;

	--- tính CP vốn TT 2 chưa phân bổ 
	
	truncate table tmp_cp_von_tt_2_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_cp_von_tt_2_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) cp_von_tt_2
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 11 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) cp_von_tt_2
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 11 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;

	--- tính CP vốn CCTG chưa phân bổ 

	truncate table tmp_cp_von_cctg_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_cp_von_cctg_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) cp_von_cctg
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 12 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) cp_von_cctg
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 12 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;

	--- tính DT Kinh doanh chưa phân bổ 

	truncate table tmp_dt_kinh_doanh_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_dt_kinh_doanh_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) dt_kinh_doanh
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 16 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) dt_kinh_doanh
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 16 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;


	--- tính CP hoa hồng chưa phân bổ 

	truncate table tmp_cp_hoa_hong_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_cp_hoa_hong_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) cp_hoa_hong
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 17 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) cp_hoa_hong
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 17 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;

	--- tính CP thuần KD khác  chưa phân bổ 

	truncate table tmp_cp_thuan_kd_khac_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_cp_thuan_kd_khac_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) cp_thuan_kd_khac
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 18 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) cp_thuan_kd_khac
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 18 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;

	--- tính CP nhân viên chưa phân bổ 
	truncate table tmp_cp_nhan_vien_chua_phan_bo_xep_hang ;

	INSERT INTO tmp_cp_nhan_vien_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) cp_nhan_vien
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 23 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) cp_nhan_vien
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 23 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;

	--- tính CP quản lý chưa phân bổ 

	truncate table tmp_cp_quan_ly_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_cp_quan_ly_chua_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount)
	select 202302 as month_key, dp.region_code, area_name, email, sum(amount) cp_quan_ly
	from fact_txn_month_raw_data ftmrd 
	join dim_pos dp on ftmrd.region_code = dp.region_code 
	join kpi_asm_data kad on kad.area_name = dp.region 
	where dim_id = 24 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by dp.region_code, area_name, email
	union all 
	select 202302 month_key, 'HEAD' region_code, 'HEAD' area_name, null email, sum(amount) cp_quan_ly
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 24 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;

	--- tính CP tài sản chưa phân bổ 
	
	truncate table tmp_cp_tai_san_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_cp_tai_san_chua_phan_bo_xep_hang
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

	--- tính Chi phí dự phòng chưa phân bổ 

	truncate table tmp_chi_phi_du_phong_chua_phan_bo_xep_hang ;
	
	INSERT INTO tmp_chi_phi_du_phong_chua_phan_bo_xep_hang
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
end;
$$ LANGUAGE plpgsql;


call cal_head_xep_hang(); 

select*from tmp_lai_trong_han_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_lai_qua_han_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_phi_bao_hiem_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_phi_tang_han_muc_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_phi_thanh_toan_cham_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_dt_nguon_von_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_cp_von_tt_2_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_cp_von_cctg_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_dt_kinh_doanh_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_cp_hoa_hong_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_cp_thuan_kd_khac_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_cp_nhan_vien_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_cp_quan_ly_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_cp_tai_san_chua_phan_bo_xep_hang tlqhcpbsm ;
select*from tmp_chi_phi_du_phong_chua_phan_bo_xep_hang tlqhcpbsm ;







