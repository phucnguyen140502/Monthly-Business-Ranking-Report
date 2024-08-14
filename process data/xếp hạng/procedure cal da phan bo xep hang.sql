CREATE OR REPLACE PROCEDURE cal_da_phan_bo_xep_hang()
AS $$
BEGIN
	---- lai trong han
	truncate table tmp_lai_trong_han_da_phan_bo_xep_hang ;
	
	INSERT INTO tmp_lai_trong_han_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_1, avg_dbgroup_1_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_dbgroup_1, z.avg_dbgroup_1_head, 
	x.amount + (y.amount * z.avg_dbgroup_1 / z.avg_dbgroup_1_head) amount_da_phan_bo
	from tmp_lai_trong_han_chua_phan_bo_xep_hang x 
	join tmp_lai_trong_han_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_1  , b.avg_dbgroup_1 as avg_dbgroup_1_head
		from temp_os_after_wo_1_xep_hang a 
		join temp_os_after_wo_1_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';

	-- lai qua han
	truncate table tmp_lai_qua_han_da_phan_bo_xep_hang ;
	
	INSERT INTO tmp_lai_qua_han_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_2, avg_dbgroup_2_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_dbgroup_2, z.avg_dbgroup_2_head, 
	x.amount + (y.amount * z.avg_dbgroup_2 / z.avg_dbgroup_2_head) amount_da_phan_bo
	from tmp_lai_qua_han_chua_phan_bo_xep_hang x 
	join tmp_lai_qua_han_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_2  , b.avg_dbgroup_2 as avg_dbgroup_2_head
		from temp_os_after_wo_2_xep_hang a 
		join temp_os_after_wo_2_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';

	---- phi bao hiem
	truncate table tmp_phi_bao_hiem_da_phan_bo_xep_hang ;
	
	INSERT INTO tmp_phi_bao_hiem_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_psdn, avg_psdn_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_psdn, z.avg_psdn_head, 
	x.amount + (y.amount * z.avg_psdn / z.avg_psdn_head) amount_da_phan_bo
	from tmp_phi_bao_hiem_chua_phan_bo_xep_hang x 
	join tmp_phi_bao_hiem_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code, a.area_name, a.email , a.avg_psdn  , b.avg_psdn as avg_psdn_head
		from temp_psdn_xep_hang a 
		join temp_psdn_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';

	-- tang han muc
	truncate table tmp_phi_tang_han_muc_da_phan_bo_xep_hang ;

	INSERT INTO tmp_phi_tang_han_muc_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_1, avg_dbgroup_1_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_dbgroup_1, z.avg_dbgroup_1_head, 
	x.amount + (y.amount * z.avg_dbgroup_1 / z.avg_dbgroup_1_head) amount_da_phan_bo
	from tmp_phi_tang_han_muc_chua_phan_bo_xep_hang x 
	join tmp_phi_tang_han_muc_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_1  , b.avg_dbgroup_1 as avg_dbgroup_1_head
		from temp_os_after_wo_1_xep_hang a 
		join temp_os_after_wo_1_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';
	
	-- phi thanh toan cham
	truncate table tmp_phi_thanh_toan_cham_da_phan_bo_xep_hang ;

	INSERT INTO tmp_phi_thanh_toan_cham_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_345, avg_dbgroup_345_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_dbgroup_345, z.avg_dbgroup_345_head, 
	x.amount + (y.amount * z.avg_dbgroup_345 / z.avg_dbgroup_345_head) amount_da_phan_bo
	from tmp_phi_thanh_toan_cham_chua_phan_bo_xep_hang x 
	join tmp_phi_thanh_toan_cham_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_345  , b.avg_dbgroup_345 as avg_dbgroup_345_head
		from temp_os_after_wo_345_xep_hang a 
		join temp_os_after_wo_345_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';

	truncate table tmp_cp_von_tt_2_da_phan_bo_xep_hang ;

	INSERT INTO tmp_cp_von_tt_2_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_cp_von_tt_2_chua_phan_bo_xep_hang x 
	join tmp_cp_von_tt_2_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_xep_hang a 
		join temp_os_after_wo_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';
	
	truncate table tmp_cp_von_cctg_da_phan_bo_xep_hang ;

	INSERT INTO tmp_cp_von_cctg_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_cp_von_cctg_chua_phan_bo_xep_hang x 
	join tmp_cp_von_cctg_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_xep_hang a 
		join temp_os_after_wo_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';


	truncate table tmp_dt_kinh_doanh_da_phan_bo_xep_hang ;

	INSERT INTO tmp_dt_kinh_doanh_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_dt_kinh_doanh_chua_phan_bo_xep_hang x 
	join tmp_dt_kinh_doanh_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_xep_hang a 
		join temp_os_after_wo_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';

	truncate table tmp_cp_hoa_hong_da_phan_bo_xep_hang ;

	INSERT INTO tmp_cp_hoa_hong_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_cp_hoa_hong_chua_phan_bo_xep_hang x 
	join tmp_cp_hoa_hong_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_xep_hang a 
		join temp_os_after_wo_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';


	truncate table tmp_cp_thuan_kd_khac_da_phan_bo_xep_hang ;

	INSERT INTO tmp_cp_thuan_kd_khac_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_cp_thuan_kd_khac_chua_phan_bo_xep_hang x 
	join tmp_cp_thuan_kd_khac_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_xep_hang a 
		join temp_os_after_wo_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';

	truncate table tmp_cp_nhan_vien_da_phan_bo_xep_hang ;

	INSERT INTO tmp_cp_nhan_vien_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, employee_count, employee_count_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.employee_count, z.employee_count_head, 
	x.amount + (y.amount * z.employee_count / z.employee_count_head) amount_da_phan_bo
	from tmp_cp_nhan_vien_chua_phan_bo_xep_hang x 
	join tmp_cp_nhan_vien_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code, a.area_name, a.email , a.employee_count  , b.employee_count as employee_count_head
		from temp_os_employee_xep_hang a 
		join temp_os_employee_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD';


	truncate table tmp_cp_quan_ly_da_phan_bo_xep_hang ;

	INSERT INTO tmp_cp_quan_ly_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, employee_count, employee_count_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.employee_count, z.employee_count_head, 
	x.amount + (y.amount * z.employee_count / z.employee_count_head) amount_da_phan_bo
	from tmp_cp_quan_ly_chua_phan_bo_xep_hang x 
	join tmp_cp_quan_ly_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code, a.area_name, a.email , a.employee_count  , b.employee_count as employee_count_head
		from temp_os_employee_xep_hang a 
		join temp_os_employee_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD';


	truncate table tmp_cp_tai_san_da_phan_bo_xep_hang ;

	INSERT INTO tmp_cp_tai_san_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, employee_count, employee_count_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.employee_count, z.employee_count_head, 
	x.amount + (y.amount * z.employee_count / z.employee_count_head) amount_da_phan_bo
	from tmp_cp_tai_san_chua_phan_bo_xep_hang x 
	join tmp_cp_tai_san_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code, a.area_name, a.email , a.employee_count  , b.employee_count as employee_count_head
		from temp_os_employee_xep_hang a 
		join temp_os_employee_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD';

	truncate table tmp_chi_phi_du_phong_da_phan_bo_xep_hang ;

	INSERT INTO tmp_chi_phi_du_phong_da_phan_bo_xep_hang
	(month_key, region_code, area_name, email, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_345, avg_dbgroup_345_head, amount_da_phan_bo)
	select distinct x.month_key, x.region_code, x.area_name, x.email ,x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_dbgroup_345, z.avg_dbgroup_345_head, 
	x.amount + (y.amount * z.avg_dbgroup_345 / z.avg_dbgroup_345_head) amount_da_phan_bo
	from tmp_chi_phi_du_phong_chua_phan_bo_xep_hang x 
	join tmp_chi_phi_du_phong_chua_phan_bo_xep_hang y 
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code, a.area_name, a.email , a.avg_dbgroup_345  , b.avg_dbgroup_345 as avg_dbgroup_345_head
		from temp_os_before_wo_345_xep_hang a 
		join temp_os_before_wo_345_xep_hang b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';


end;
$$ LANGUAGE plpgsql;


call cal_da_phan_bo_xep_hang(); 
	
select*from tmp_lai_trong_han_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_lai_qua_han_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_phi_bao_hiem_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_phi_tang_han_muc_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_phi_thanh_toan_cham_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_cp_von_tt_2_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_cp_von_cctg_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_dt_kinh_doanh_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_cp_hoa_hong_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_cp_thuan_kd_khac_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_cp_nhan_vien_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_cp_quan_ly_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_cp_tai_san_da_phan_bo_xep_hang tlqhdpbsm ;
select*from tmp_chi_phi_du_phong_da_phan_bo_xep_hang tlqhdpbsm ;







