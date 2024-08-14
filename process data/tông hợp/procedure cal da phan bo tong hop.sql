CREATE OR REPLACE PROCEDURE cal_da_phan_bo_tong_hop()
AS $$
BEGIN
	
	--- tính phân bổ lai trong hạn
	truncate table tmp_lai_trong_han_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_lai_trong_han_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_1, avg_dbgroup_1_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_1, z.avg_dbgroup_1_head, 
	x.amount + (y.amount * z.avg_dbgroup_1 / z.avg_dbgroup_1_head) amount_da_phan_bo
	from tmp_lai_trong_han_chua_phan_bo_tong_hop x 
	join tmp_lai_trong_han_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_1  , b.avg_dbgroup_1 as avg_dbgroup_1_head
		from temp_os_after_wo_1_tong_hop a 
		join temp_os_after_wo_1_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD';
		
	--- tính phân bổ trong trong hạn
	truncate table tmp_lai_qua_han_da_phan_bo_tong_hop ;
	
	INSERT INTO tmp_lai_qua_han_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_2, avg_dbgroup_2_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head, 
	z.avg_dbgroup_2, z.avg_dbgroup_2_head, 
	x.amount + (y.amount * z.avg_dbgroup_2 / z.avg_dbgroup_2_head) amount_da_phan_bo
	from tmp_lai_qua_han_chua_phan_bo_tong_hop x 
	join tmp_lai_qua_han_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code , a.avg_dbgroup_2  , b.avg_dbgroup_2 as avg_dbgroup_2_head
		from temp_os_after_wo_2_tong_hop a 
		join temp_os_after_wo_2_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD';

	--- tính phân bổ phí bảo hiểm
	truncate table tmp_phi_bao_hiem_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_phi_bao_hiem_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_psdn, avg_psdn_head, amount_da_phan_bo)
	select x.month_key, x.region_code, 
	CAST(x.amount AS numeric) amount_chua_phan_bo, 
	CAST(y.amount AS numeric) amount_chua_phan_bo_head,
	CAST(z.avg_psdn AS numeric) avg_psdn, 
	CAST(z.avg_psdn_head AS numeric) avg_psdn_head, 
	CAST(x.amount AS numeric) + (CAST(y.amount AS numeric) * CAST(z.avg_psdn AS numeric) / CAST(z.avg_psdn_head AS numeric)) amount_da_phan_bo
	from tmp_phi_bao_hiem_chua_phan_bo_tong_hop x 
	join tmp_phi_bao_hiem_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bổ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_psdn, b.avg_psdn as avg_psdn_head
		from temp_psdn_tong_hop a 
		join temp_psdn_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;
	
	-- tính phân bổ phi tang hang muc
	truncate table tmp_phi_tang_han_muc_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_phi_tang_han_muc_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head,
	avg_dbgroup_1, avg_dbgroup_1_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_1, z.avg_dbgroup_1_head, 
	x.amount + (y.amount * z.avg_dbgroup_1 / z.avg_dbgroup_1_head) amount_da_phan_bo
	from tmp_phi_tang_han_muc_chua_phan_bo_tong_hop x 
	join tmp_phi_tang_han_muc_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_1  , b.avg_dbgroup_1 as avg_dbgroup_1_head
		from temp_os_after_wo_1_tong_hop a 
		join temp_os_after_wo_1_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;
	
	-- tính phân bổ phi thanh toán chậm
	truncate table tmp_phi_thanh_toan_cham_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_phi_thanh_toan_cham_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_345, avg_dbgroup_345_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_345, z.avg_dbgroup_345_head, 
	x.amount + (y.amount * z.avg_dbgroup_345 / z.avg_dbgroup_345_head) amount_da_phan_bo
	from tmp_phi_thanh_toan_cham_chua_phan_bo_tong_hop x 
	join tmp_phi_thanh_toan_cham_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code , a.avg_dbgroup_345  , b.avg_dbgroup_345 as avg_dbgroup_345_head
		from temp_os_after_wo_345_tong_hop a 
		join temp_os_after_wo_345_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	--- tính phân bổ  DT Nguồn vốn 
	truncate table tmp_dt_nguon_von_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_dt_nguon_von_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_dt_nguon_von_chua_phan_bo_tong_hop x 
	join tmp_dt_nguon_von_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_tong_hop a 
		join temp_os_after_wo_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	--- tính phân bổ CP vốn TT 1
	truncate table tmp_cp_von_tt_1_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_cp_von_tt_1_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_cp_von_tt_1_chua_phan_bo_tong_hop x 
	join tmp_cp_von_tt_1_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_tong_hop a 
		join temp_os_after_wo_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	--- tính phân bổ CP vốn TT 2
	truncate table tmp_cp_von_tt_2_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_cp_von_tt_2_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_cp_von_tt_2_chua_phan_bo_tong_hop x 
	join tmp_cp_von_tt_2_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_tong_hop a 
		join temp_os_after_wo_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	---- tính phân bổ CP vốn CCTG
	truncate table tmp_cp_von_cctg_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_cp_von_cctg_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_cp_von_cctg_chua_phan_bo_tong_hop x 
	join tmp_cp_von_cctg_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_tong_hop a 
		join temp_os_after_wo_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	-- tính phân bổ DT Fintech
	truncate table tmp_dt_fintech_da_phan_bo_tong_hop ;
	
	INSERT INTO tmp_dt_fintech_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_dt_fintech_chua_phan_bo_tong_hop x 
	join tmp_dt_fintech_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_tong_hop a 
		join temp_os_after_wo_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	--- tính phân bổ DT tiểu thương, cá nhân
	truncate table tmp_dt_tieu_thuong_ca_nhan_da_phan_bo_tong_hop ;
	
	INSERT INTO tmp_dt_tieu_thuong_ca_nhan_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_dt_tieu_thuong_ca_nhan_chua_phan_bo_tong_hop x 
	join tmp_dt_tieu_thuong_ca_nhan_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_tong_hop a 
		join temp_os_after_wo_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	--- tính phân bổ DT Kinh Doanh
	truncate table tmp_dt_kinh_doanh_da_phan_bo_tong_hop ;
	
	INSERT INTO tmp_dt_kinh_doanh_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_dt_kinh_doanh_chua_phan_bo_tong_hop x 
	join tmp_dt_kinh_doanh_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_tong_hop a 
		join temp_os_after_wo_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	---  tính phân bổ CP hoa hồng
	truncate table tmp_cp_hoa_hong_da_phan_bo_tong_hop ;
	
	INSERT INTO tmp_cp_hoa_hong_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head,
	cast( CAST(x.amount AS NUMERIC) + (CAST(y.amount AS NUMERIC) * CAST(z.avg_dbgroup_after_wo AS NUMERIC) / NULLIF(CAST(z.avg_dbgroup_after_wo_head AS NUMERIC), 0))as int8 ) AS amount_da_phan_bo
	from tmp_cp_hoa_hong_chua_phan_bo_tong_hop x 
	join tmp_cp_hoa_hong_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_tong_hop a 
		join temp_os_after_wo_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	--- tính phân bổ CP thuần KD khác
	truncate table tmp_cp_thuan_kd_khac_da_phan_bo_tong_hop ;
	
	INSERT INTO tmp_cp_thuan_kd_khac_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head,
	cast( CAST(x.amount AS NUMERIC) + (CAST(y.amount AS NUMERIC) * CAST(z.avg_dbgroup_after_wo AS NUMERIC) / NULLIF(CAST(z.avg_dbgroup_after_wo_head AS NUMERIC), 0))as int8 ) AS amount_da_phan_bo
	from tmp_cp_thuan_kd_khac_chua_phan_bo_tong_hop x 
	join tmp_cp_thuan_kd_khac_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_tong_hop a 
		join temp_os_after_wo_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	--- tính phân bổ CP hợp tác kd tàu (net)
	truncate table tmp_cp_net_da_phan_bo_tong_hop ;
	
	INSERT INTO tmp_cp_net_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_cp_net_chua_phan_bo_tong_hop x 
	join tmp_cp_net_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_tong_hop a 
		join temp_os_after_wo_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	--- tính phân bổ CP thuế, phí
	truncate table tmp_cp_thue_phi_da_phan_bo_tong_hop ;
	
	INSERT INTO tmp_cp_thue_phi_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_after_wo, avg_dbgroup_after_wo_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_after_wo, z.avg_dbgroup_after_wo_head, 
	x.amount + (y.amount * z.avg_dbgroup_after_wo / z.avg_dbgroup_after_wo_head) amount_da_phan_bo
	from tmp_cp_thue_phi_chua_phan_bo_tong_hop x 
	join tmp_cp_thue_phi_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.avg_dbgroup_after_wo  , b.avg_dbgroup_after_wo as avg_dbgroup_after_wo_head
		from temp_os_after_wo_tong_hop a 
		join temp_os_after_wo_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	---- tính phân bổ CP nhân viên
	truncate table tmp_cp_nhan_vien_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_cp_nhan_vien_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, employee_count, employee_count_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.employee_count, z.employee_count_head, 
	x.amount + (y.amount * z.employee_count / z.employee_count_head) amount_da_phan_bo
	from tmp_cp_nhan_vien_chua_phan_bo_tong_hop x 
	join tmp_cp_nhan_vien_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.employee_count  , b.employee_count as employee_count_head
		from temp_os_employee_tong_hop a 
		join temp_os_employee_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	---- tính phân bổ CP quản lý
	truncate table tmp_cp_quan_ly_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_cp_quan_ly_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, employee_count, employee_count_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.employee_count, z.employee_count_head, 
	x.amount + (y.amount * z.employee_count / z.employee_count_head) amount_da_phan_bo
	from tmp_cp_quan_ly_chua_phan_bo_tong_hop x 
	join tmp_cp_quan_ly_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.employee_count  , b.employee_count as employee_count_head
		from temp_os_employee_tong_hop a 
		join temp_os_employee_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	--- tính phân bổ CP quản lý
	truncate table tmp_cp_tai_san_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_cp_tai_san_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, employee_count, employee_count_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.employee_count, z.employee_count_head, 
	x.amount + (y.amount * z.employee_count / z.employee_count_head) amount_da_phan_bo
	from tmp_cp_tai_san_chua_phan_bo_tong_hop x 
	join tmp_cp_tai_san_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.kpi_month , a.region_code , a.employee_count  , b.employee_count as employee_count_head
		from temp_os_employee_tong_hop a 
		join temp_os_employee_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.kpi_month and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;

	--- tính phân bổ chi phí dự phòng
	truncate table tmp_chi_phi_du_phong_da_phan_bo_tong_hop;
	
	INSERT INTO tmp_chi_phi_du_phong_da_phan_bo_tong_hop
	(month_key, region_code, amount_chua_phan_bo, amount_chua_phan_bo_head, avg_dbgroup_345, avg_dbgroup_345_head, amount_da_phan_bo)
	select x.month_key, x.region_code, x.amount amount_chua_phan_bo, y.amount amount_chua_phan_bo_head,
	z.avg_dbgroup_345, z.avg_dbgroup_345_head, 
	x.amount + (y.amount * z.avg_dbgroup_345 / z.avg_dbgroup_345_head) amount_da_phan_bo
	from tmp_chi_phi_du_phong_chua_phan_bo_tong_hop x 
	join tmp_chi_phi_du_phong_chua_phan_bo_tong_hop y
	on y.region_code = 'HEAD'
	-- tính tỷ trọng phân bỏ
	left join 
	(
		select a.month_key , a.region_code , a.avg_dbgroup_345  , b.avg_dbgroup_345 as avg_dbgroup_345_head
		from temp_os_before_wo_345_tong_hop a 
		join temp_os_before_wo_345_tong_hop b 
		on b.region_code = 'HEAD'
		where a.region_code <> 'HEAD'
	) z
	on x.month_key = z.month_key and x.region_code = z.region_code
	where x.region_code <> 'HEAD'
	order by x.region_code;


end;
$$ LANGUAGE plpgsql;


call cal_da_phan_bo_tong_hop(); 

select*from tmp_lai_trong_han_da_phan_bo_tong_hop tlthdpb ;
select*from tmp_lai_qua_han_da_phan_bo_tong_hop tlqhdpb ;
select*from tmp_phi_bao_hiem_da_phan_bo_tong_hop tpbhdpb ;
select*from tmp_phi_tang_han_muc_da_phan_bo_tong_hop tlthdpb ;
select*from tmp_phi_thanh_toan_cham_da_phan_bo_tong_hop tlthdpb ;
select*from tmp_dt_nguon_von_da_phan_bo_tong_hop ;
select*from tmp_cp_von_tt_1_da_phan_bo_tong_hop ;
select*from tmp_cp_von_tt_2_da_phan_bo_tong_hop ;
select*from tmp_cp_von_cctg_da_phan_bo_tong_hop ;
select*from tmp_dt_fintech_da_phan_bo_tong_hop tdkddpb ;
select*from tmp_dt_tieu_thuong_ca_nhan_da_phan_bo_tong_hop tdkddpb ;
select*from tmp_dt_kinh_doanh_da_phan_bo_tong_hop tdkddpb ;
select*from tmp_cp_hoa_hong_da_phan_bo_tong_hop tdkddpb ;
select*from tmp_cp_thuan_kd_khac_da_phan_bo_tong_hop ;
select*from tmp_cp_net_da_phan_bo_tong_hop tdkddpb ;
select*from tmp_cp_thue_phi_da_phan_bo_tong_hop tdkddpb ;
select*from tmp_cp_nhan_vien_da_phan_bo_tong_hop tcnvdpb ;
select*from tmp_cp_quan_ly_da_phan_bo_tong_hop tcqldpb ;
select*from tmp_cp_tai_san_da_phan_bo_tong_hop tctsdpb ;
select*from tmp_chi_phi_du_phong_da_phan_bo_tong_hop tpcdpdpb ;


