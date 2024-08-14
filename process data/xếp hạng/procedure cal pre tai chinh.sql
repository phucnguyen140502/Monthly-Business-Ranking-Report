CREATE OR REPLACE PROCEDURE cal_pre_tai_chinh_xep_hang()
AS $$
BEGIN

	-- CIR
	truncate table cir_xep_hang;
	
	INSERT INTO cir_xep_hang
	(month_key, region_code, area_name, email, cir, rank_cir)
	WITH regional_data AS (
	    SELECT 
	        a.month_key, a.region_code, a.area_name, a.email,
	        COALESCE(a.amount_da_phan_bo, 0) AS lai_trong_han,
	        COALESCE(b.amount_da_phan_bo, 0) AS lai_qua_han,
	        COALESCE(c.amount_da_phan_bo, 0) AS phi_bao_hiem,
	        COALESCE(d.amount_da_phan_bo, 0) AS phi_tang_han_muc,
	        COALESCE(e.amount_da_phan_bo, 0) AS phi_thanh_toan_cham,
	        COALESCE(h.amount_da_phan_bo, 0) AS dt_kinh_doanh,
	        COALESCE(k.amount_da_phan_bo, 0) AS cp_hoa_hong,
	        COALESCE(l.amount_da_phan_bo, 0) AS cp_thuan_kd_khac,
	        COALESCE(m.amount_da_phan_bo, 0) AS cp_nhan_vien,
	        COALESCE(n.amount_da_phan_bo, 0) AS cp_quan_ly,
	        COALESCE(o.amount_da_phan_bo, 0) AS cp_tai_san,
	        COALESCE(s.amount_da_phan_bo, 0) AS chi_phi_du_phong
	    FROM tmp_lai_trong_han_da_phan_bo_xep_hang a
	    LEFT JOIN tmp_lai_qua_han_da_phan_bo_xep_hang b ON a.region_code = b.region_code and a.area_name = b.area_name and a.email = b.email
	    LEFT JOIN tmp_phi_bao_hiem_da_phan_bo_xep_hang c ON b.region_code = c.region_code and b.area_name = c.area_name and b.email = c.email
	    LEFT JOIN tmp_phi_tang_han_muc_da_phan_bo_xep_hang d ON c.region_code = d.region_code and c.area_name = d.area_name and c.email = d.email
	    LEFT JOIN tmp_phi_thanh_toan_cham_da_phan_bo_xep_hang e ON d.region_code = e.region_code and d.area_name = e.area_name and d.email = e.email
	    LEFT JOIN tmp_dt_kinh_doanh_da_phan_bo_xep_hang h ON h.region_code = e.region_code and h.area_name = e.area_name and h.email = e.email
	    LEFT JOIN tmp_cp_hoa_hong_da_phan_bo_xep_hang k ON k.region_code = h.region_code and k.area_name = h.area_name and k.email = h.email
	    LEFT JOIN tmp_cp_thuan_kd_khac_da_phan_bo_xep_hang l ON l.region_code = k.region_code and l.area_name = k.area_name and l.email = k.email
	    LEFT JOIN tmp_cp_nhan_vien_da_phan_bo_xep_hang m ON m.region_code = e.region_code and m.area_name = e.area_name and m.email = e.email
	    LEFT JOIN tmp_cp_quan_ly_da_phan_bo_xep_hang n ON n.region_code = m.region_code and n.area_name = m.area_name and n.email = m.email
	    LEFT JOIN tmp_cp_tai_san_da_phan_bo_xep_hang o ON o.region_code = n.region_code and o.area_name = n.area_name and o.email = n.email
	    LEFT JOIN tmp_chi_phi_du_phong_da_phan_bo_xep_hang s ON s.region_code = o.region_code and s.area_name = o.area_name and s.email = o.email
	),
	calculate_cir as (
	SELECT 
	    month_key, 
	    region_code, 
	    area_name, 
	    email,
	    ( 
	        -(cp_nhan_vien + cp_quan_ly + cp_tai_san) / 
	        (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac)
	    )  AS cir
	FROM 
	    regional_data)
	select *, rank() over(order by cir desc) rank_cir
	from calculate_cir;
	
	-- Margin
	truncate table margin_xep_hang;
	
	INSERT INTO margin_xep_hang
	(month_key, region_code, area_name, email, margin, rank_margin)
	WITH regional_data AS (
	    SELECT 
	        a.month_key, a.region_code, a.area_name, a.email,
	        COALESCE(a.amount_da_phan_bo, 0) AS lai_trong_han,
	        COALESCE(b.amount_da_phan_bo, 0) AS lai_qua_han,
	        COALESCE(c.amount_da_phan_bo, 0) AS phi_bao_hiem,
	        COALESCE(d.amount_da_phan_bo, 0) AS phi_tang_han_muc,
	        COALESCE(e.amount_da_phan_bo, 0) AS phi_thanh_toan_cham,
	        COALESCE(h.amount_da_phan_bo, 0) AS dt_kinh_doanh,
	        COALESCE(k.amount_da_phan_bo, 0) AS cp_hoa_hong,
	        COALESCE(l.amount_da_phan_bo, 0) AS cp_thuan_kd_khac,
	        COALESCE(m.amount_da_phan_bo, 0) AS cp_nhan_vien,
	        COALESCE(n.amount_da_phan_bo, 0) AS cp_quan_ly,
	        COALESCE(o.amount_da_phan_bo, 0) AS cp_tai_san,
	        COALESCE(s.amount_da_phan_bo, 0) AS chi_phi_du_phong
	    FROM tmp_lai_trong_han_da_phan_bo_xep_hang a
	    LEFT JOIN tmp_lai_qua_han_da_phan_bo_xep_hang b ON a.region_code = b.region_code and a.area_name = b.area_name and a.email = b.email
	    LEFT JOIN tmp_phi_bao_hiem_da_phan_bo_xep_hang c ON b.region_code = c.region_code and b.area_name = c.area_name and b.email = c.email
	    LEFT JOIN tmp_phi_tang_han_muc_da_phan_bo_xep_hang d ON c.region_code = d.region_code and c.area_name = d.area_name and c.email = d.email
	    LEFT JOIN tmp_phi_thanh_toan_cham_da_phan_bo_xep_hang e ON d.region_code = e.region_code and d.area_name = e.area_name and d.email = e.email
	    LEFT JOIN tmp_dt_kinh_doanh_da_phan_bo_xep_hang h ON h.region_code = e.region_code and h.area_name = e.area_name and h.email = e.email
	    LEFT JOIN tmp_cp_hoa_hong_da_phan_bo_xep_hang k ON k.region_code = h.region_code and k.area_name = h.area_name and k.email = h.email
	    LEFT JOIN tmp_cp_thuan_kd_khac_da_phan_bo_xep_hang l ON l.region_code = k.region_code and l.area_name = k.area_name and l.email = k.email
	    LEFT JOIN tmp_cp_nhan_vien_da_phan_bo_xep_hang m ON m.region_code = e.region_code and m.area_name = e.area_name and m.email = e.email
	    LEFT JOIN tmp_cp_quan_ly_da_phan_bo_xep_hang n ON n.region_code = m.region_code and n.area_name = m.area_name and n.email = m.email
	    LEFT JOIN tmp_cp_tai_san_da_phan_bo_xep_hang o ON o.region_code = n.region_code and o.area_name = n.area_name and o.email = n.email
	    LEFT JOIN tmp_chi_phi_du_phong_da_phan_bo_xep_hang s ON s.region_code = o.region_code and s.area_name = o.area_name and s.email = o.email
	),
	calculate_margin as (
	SELECT 
	    month_key, 
	    region_code, 
	    area_name, 
	    email,
	    ( 
	        (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + 
	    											 				phi_thanh_toan_cham + dt_kinh_doanh)
	    )  AS margin
	FROM 
	    regional_data)
	select *, rank() over(order by margin desc) rank_margin
	from calculate_margin;


	truncate table hs_von_xep_hang;

	INSERT INTO hs_von_xep_hang
	(month_key, region_code, area_name, email, hs_von, rank_hs_von)
	WITH regional_data AS (
	    SELECT 
	        a.month_key, a.region_code, a.area_name, a.email,
	        COALESCE(a.amount_da_phan_bo, 0) AS lai_trong_han,
	        COALESCE(b.amount_da_phan_bo, 0) AS lai_qua_han,
	        COALESCE(c.amount_da_phan_bo, 0) AS phi_bao_hiem,
	        COALESCE(d.amount_da_phan_bo, 0) AS phi_tang_han_muc,
	        COALESCE(e.amount_da_phan_bo, 0) AS phi_thanh_toan_cham,
	        COALESCE(h.amount_da_phan_bo, 0) AS dt_kinh_doanh,
	        COALESCE(k.amount_da_phan_bo, 0) AS cp_hoa_hong,
	        COALESCE(l.amount_da_phan_bo, 0) AS cp_thuan_kd_khac,
	        COALESCE(m.amount_da_phan_bo, 0) AS cp_nhan_vien,
	        COALESCE(n.amount_da_phan_bo, 0) AS cp_quan_ly,
	        COALESCE(o.amount_da_phan_bo, 0) AS cp_tai_san,
	        COALESCE(s.amount_da_phan_bo, 0) AS chi_phi_du_phong,
	        COALESCE(r.amount_da_phan_bo, 0) AS cp_von_tt_2,
	        COALESCE(r.amount_da_phan_bo, 0) AS cp_von_cctg
	    FROM tmp_lai_trong_han_da_phan_bo_xep_hang a
	    LEFT JOIN tmp_lai_qua_han_da_phan_bo_xep_hang b ON a.region_code = b.region_code and a.area_name = b.area_name and a.email = b.email
	    LEFT JOIN tmp_phi_bao_hiem_da_phan_bo_xep_hang c ON b.region_code = c.region_code and b.area_name = c.area_name and b.email = c.email
	    LEFT JOIN tmp_phi_tang_han_muc_da_phan_bo_xep_hang d ON c.region_code = d.region_code and c.area_name = d.area_name and c.email = d.email
	    LEFT JOIN tmp_phi_thanh_toan_cham_da_phan_bo_xep_hang e ON d.region_code = e.region_code and d.area_name = e.area_name and d.email = e.email
	    LEFT JOIN tmp_dt_kinh_doanh_da_phan_bo_xep_hang h ON h.region_code = e.region_code and h.area_name = e.area_name and h.email = e.email
	    LEFT JOIN tmp_cp_hoa_hong_da_phan_bo_xep_hang k ON k.region_code = h.region_code and k.area_name = h.area_name and k.email = h.email
	    LEFT JOIN tmp_cp_thuan_kd_khac_da_phan_bo_xep_hang l ON l.region_code = k.region_code and l.area_name = k.area_name and l.email = k.email
	    LEFT JOIN tmp_cp_nhan_vien_da_phan_bo_xep_hang m ON m.region_code = e.region_code and m.area_name = e.area_name and m.email = e.email
	    LEFT JOIN tmp_cp_quan_ly_da_phan_bo_xep_hang n ON n.region_code = m.region_code and n.area_name = m.area_name and n.email = m.email
	    LEFT JOIN tmp_cp_tai_san_da_phan_bo_xep_hang o ON o.region_code = n.region_code and o.area_name = n.area_name and o.email = n.email
	    LEFT JOIN tmp_chi_phi_du_phong_da_phan_bo_xep_hang s ON s.region_code = o.region_code and s.area_name = o.area_name and s.email = o.email
	    left join tmp_cp_von_tt_2_da_phan_bo_xep_hang r on r.region_code = s.region_code and r.area_name = s.area_name and r.email = s.email
	    left join tmp_cp_von_cctg_da_phan_bo_xep_hang u on r.region_code = u.region_code and r.area_name = u.area_name and r.email = u.email
	),
	calculate_hs_von as (
	SELECT 
	    month_key, 
	    region_code, 
	    area_name, 
	    email,
	    ( 
	        coalesce (-(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) 
	    / NULLIF(cp_von_tt_2 + cp_von_cctg, 0),0)
	    )  AS hs_von
	FROM 
	    regional_data)
	select *, rank() over(order by hs_von desc) rank_hs_von
	from calculate_hs_von;

	TRUNCATE TABLE hsbq_nhan_su_xep_hang;

	INSERT INTO hsbq_nhan_su_xep_hang
	(month_key, region_code, area_name, email, hsbq_nhan_su, rank_hsbq_nhan_su)
	WITH regional_data AS (
	    SELECT 
	        a.month_key, a.region_code, a.area_name, a.email,
	        COALESCE(a.amount_da_phan_bo, 0) AS lai_trong_han,
	        COALESCE(b.amount_da_phan_bo, 0) AS lai_qua_han,
	        COALESCE(c.amount_da_phan_bo, 0) AS phi_bao_hiem,
	        COALESCE(d.amount_da_phan_bo, 0) AS phi_tang_han_muc,
	        COALESCE(e.amount_da_phan_bo, 0) AS phi_thanh_toan_cham,
	        COALESCE(h.amount_da_phan_bo, 0) AS dt_kinh_doanh,
	        COALESCE(k.amount_da_phan_bo, 0) AS cp_hoa_hong,
	        COALESCE(l.amount_da_phan_bo, 0) AS cp_thuan_kd_khac,
	        COALESCE(m.amount_da_phan_bo, 0) AS cp_nhan_vien,
	        COALESCE(n.amount_da_phan_bo, 0) AS cp_quan_ly,
	        COALESCE(o.amount_da_phan_bo, 0) AS cp_tai_san,
	        COALESCE(s.amount_da_phan_bo, 0) AS chi_phi_du_phong
	    FROM tmp_lai_trong_han_da_phan_bo_xep_hang a
	    LEFT JOIN tmp_lai_qua_han_da_phan_bo_xep_hang b ON a.region_code = b.region_code and a.area_name = b.area_name and a.email = b.email
	    LEFT JOIN tmp_phi_bao_hiem_da_phan_bo_xep_hang c ON b.region_code = c.region_code and b.area_name = c.area_name and b.email = c.email
	    LEFT JOIN tmp_phi_tang_han_muc_da_phan_bo_xep_hang d ON c.region_code = d.region_code and c.area_name = d.area_name and c.email = d.email
	    LEFT JOIN tmp_phi_thanh_toan_cham_da_phan_bo_xep_hang e ON d.region_code = e.region_code and d.area_name = e.area_name and d.email = e.email
	    LEFT JOIN tmp_dt_kinh_doanh_da_phan_bo_xep_hang h ON h.region_code = e.region_code and h.area_name = e.area_name and h.email = e.email
	    LEFT JOIN tmp_cp_hoa_hong_da_phan_bo_xep_hang k ON k.region_code = h.region_code and k.area_name = h.area_name and k.email = h.email
	    LEFT JOIN tmp_cp_thuan_kd_khac_da_phan_bo_xep_hang l ON l.region_code = k.region_code and l.area_name = k.area_name and l.email = k.email
	    LEFT JOIN tmp_cp_nhan_vien_da_phan_bo_xep_hang m ON m.region_code = e.region_code and m.area_name = e.area_name and m.email = e.email
	    LEFT JOIN tmp_cp_quan_ly_da_phan_bo_xep_hang n ON n.region_code = m.region_code and n.area_name = m.area_name and n.email = m.email
	    LEFT JOIN tmp_cp_tai_san_da_phan_bo_xep_hang o ON o.region_code = n.region_code and o.area_name = n.area_name and o.email = n.email
	    LEFT JOIN tmp_chi_phi_du_phong_da_phan_bo_xep_hang s ON s.region_code = o.region_code and s.area_name = o.area_name and s.email = o.email
	),
	calculate_hsbq_nhan_su AS (
	    SELECT 
	        a.month_key, 
	        a.region_code, 
	        a.area_name, 
	        a.email,
	        ( 
	            (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	                                                 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong ) / smbac.sale_manager
	        ) AS hsbq_nhan_su
	    FROM 
	        regional_data a
	     JOIN sale_manager_by_area_cde smbac ON a.region_code = smbac.area_cde 
	)
	SELECT 
	    month_key, 
	    region_code, 
	    area_name, 
	    email, 
	    hsbq_nhan_su, 
	    rank() OVER (ORDER BY hsbq_nhan_su DESC) AS rank_hsbq_nhan_su
	FROM 
	    calculate_hsbq_nhan_su;



end;
$$ LANGUAGE plpgsql;


call cal_da_phan_bo_xep_hang(); 
	
select*from cir_xep_hang;
select*from margin_xep_hang;
select*from hs_von_xep_hang;
SELECT * FROM hsbq_nhan_su_xep_hang;








