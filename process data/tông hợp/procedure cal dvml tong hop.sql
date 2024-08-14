CREATE OR REPLACE PROCEDURE cal_da_phan_bo_tong_hop()
AS $$
BEGIN
	
	truncate table tmp_dvml_tong_hop;
	
	INSERT INTO tmp_dvml_tong_hop
	(criteria, "Đông Bắc Bộ", "Tây Bắc Bộ", "ĐB Sông Hồng", "Bắc Trung Bộ", "Nam Trung Bộ", "Tây Nam Bộ", "Đông Nam Bộ", "Total")
	WITH regional_data AS (
	    SELECT 
	        a.region_code,
	        COALESCE(a.amount_da_phan_bo, 0) AS lai_trong_han,
	        COALESCE(b.amount_da_phan_bo, 0) AS lai_qua_han,
	        COALESCE(c.amount_da_phan_bo, 0) AS phi_bao_hiem,
	        COALESCE(d.amount_da_phan_bo, 0) AS phi_tang_han_muc,
	        COALESCE(e.amount_da_phan_bo, 0) AS phi_thanh_toan_cham,
	        coalesce(t.amount_da_phan_bo, 0) as dt_nguon_von,
	        COALESCE(f.amount_da_phan_bo, 0) AS cp_von_tt_2,
	        COALESCE(u.amount_da_phan_bo, 0) AS cp_von_tt_1,
	        COALESCE(g.amount_da_phan_bo, 0) AS cp_von_cctg,
	        COALESCE(v.amount_da_phan_bo, 0) AS dt_fintech,
	        COALESCE(x.amount_da_phan_bo, 0) AS dt_tieu_thuong_ca_nhan,
	        COALESCE(h.amount_da_phan_bo, 0) AS dt_kinh_doanh,
	        COALESCE(k.amount_da_phan_bo, 0) AS cp_hoa_hong,
	        COALESCE(l.amount_da_phan_bo, 0) AS cp_thuan_kd_khac,
	        COALESCE(y.amount_da_phan_bo, 0) AS cp_net,
	        COALESCE(z.amount_da_phan_bo, 0) AS cp_thue_phi,
	        COALESCE(m.amount_da_phan_bo, 0) AS cp_nhan_vien,
	        COALESCE(n.amount_da_phan_bo, 0) AS cp_quan_ly,
	        COALESCE(o.amount_da_phan_bo, 0) AS cp_tai_san,
	        COALESCE(s.amount_da_phan_bo, 0) AS chi_phi_du_phong
	    FROM tmp_lai_trong_han_da_phan_bo_tong_hop a
	    LEFT JOIN tmp_lai_qua_han_da_phan_bo_tong_hop b ON a.region_code = b.region_code
	    LEFT JOIN tmp_phi_bao_hiem_da_phan_bo_tong_hop c ON b.region_code = c.region_code
	    LEFT JOIN tmp_phi_tang_han_muc_da_phan_bo_tong_hop d ON c.region_code = d.region_code
	    LEFT JOIN tmp_phi_thanh_toan_cham_da_phan_bo_tong_hop e ON d.region_code = e.region_code
	    left join tmp_dt_nguon_von_da_phan_bo_tong_hop t on t.region_code = e.region_code
	    left join tmp_cp_von_tt_1_da_phan_bo_tong_hop u on u.region_code = t.region_code
	    left join tmp_cp_von_cctg_da_phan_bo_tong_hop w on w.region_code = u.region_code
	    left join tmp_dt_fintech_da_phan_bo_tong_hop v on v.region_code = w.region_code
	    left join tmp_dt_tieu_thuong_ca_nhan_da_phan_bo_tong_hop x on x.region_code = v.region_code
	    left join tmp_cp_net_da_phan_bo_tong_hop y on y.region_code = x.region_code
	    left join tmp_cp_thue_phi_da_phan_bo_tong_hop z on z.region_code = y.region_code
	    LEFT JOIN tmp_cp_von_tt_2_da_phan_bo_tong_hop f ON f.region_code = e.region_code
	    LEFT JOIN tmp_cp_von_cctg_da_phan_bo_tong_hop g ON g.region_code = f.region_code
	    LEFT JOIN tmp_dt_kinh_doanh_da_phan_bo_tong_hop h ON h.region_code = e.region_code
	    LEFT JOIN tmp_cp_hoa_hong_da_phan_bo_tong_hop k ON k.region_code = h.region_code
	    LEFT JOIN tmp_cp_thuan_kd_khac_da_phan_bo_tong_hop l ON l.region_code = k.region_code
	    LEFT JOIN tmp_cp_nhan_vien_da_phan_bo_tong_hop m ON m.region_code = e.region_code
	    LEFT JOIN tmp_cp_quan_ly_da_phan_bo_tong_hop n ON n.region_code = m.region_code
	    LEFT JOIN tmp_cp_tai_san_da_phan_bo_tong_hop o ON o.region_code = n.region_code
	    LEFT JOIN tmp_chi_phi_du_phong_da_phan_bo_tong_hop s ON s.region_code = o.region_code
	)
	
	-- 1. Lợi nhuận trước thuế
	SELECT 
	    '1. Lợi nhuận trước thuế' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",							 
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong  END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",									 
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong  END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",							 
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong  END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",								 
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong  END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong  END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong  END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong ), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION all
	
	-- Thu nhap tu hoat dong the
	SELECT 
	    'Thu nhập từ hoạt động thẻ' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION all
	
	-- lai trong han
	SELECT 
	    'Lãi trong hạn' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN lai_trong_han END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN lai_trong_han END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN lai_trong_han END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN lai_trong_han END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN lai_trong_han END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN lai_trong_han END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN lai_trong_han END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(lai_trong_han), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	-- lai qua han
	
	SELECT 
	    'Lãi quá hạn' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN lai_qua_han END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN lai_qua_han END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN lai_qua_han END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN lai_qua_han END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN lai_qua_han END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN lai_qua_han END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN lai_qua_han END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(lai_qua_han), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION all
	
	-- Phi bao hiem
	SELECT 
	    'Phí Bảo hiểm' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN phi_bao_hiem END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN phi_bao_hiem END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN phi_bao_hiem END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN phi_bao_hiem END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN phi_bao_hiem END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN phi_bao_hiem END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN phi_bao_hiem END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(phi_bao_hiem), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION all
	
	-- Phi tang han muc
	SELECT 
	    'Phí tăng hạn mức' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN phi_tang_han_muc END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN phi_tang_han_muc END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN phi_tang_han_muc END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN phi_tang_han_muc END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN phi_tang_han_muc END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN phi_tang_han_muc END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN phi_tang_han_muc END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(phi_tang_han_muc), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	-- Phi thanh toan cham
	SELECT 
	    'Phí thanh toán chậm, thu từ ngoại bảng, khác…' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN phi_thanh_toan_cham END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(phi_thanh_toan_cham), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	union all 
	--  Chi phí thuần KDV  
	SELECT 
	    'Chi phí thuần KDV' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' then dt_nguon_von + cp_von_tt_1 + cp_von_tt_2 + cp_von_cctg END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN dt_nguon_von + cp_von_tt_1 + cp_von_tt_2 + cp_von_cctg END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN dt_nguon_von + cp_von_tt_1 + cp_von_tt_2 + cp_von_cctg END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN dt_nguon_von + cp_von_tt_1 + cp_von_tt_2 + cp_von_cctg END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN dt_nguon_von + cp_von_tt_1 + cp_von_tt_2 + cp_von_cctg END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN dt_nguon_von + cp_von_tt_1 + cp_von_tt_2 + cp_von_cctg END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN dt_nguon_von + cp_von_tt_1 + cp_von_tt_2 + cp_von_cctg END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(dt_nguon_von + cp_von_tt_1 + cp_von_tt_2 + cp_von_cctg), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	--- CP vốn TT 1
	SELECT 
	    'DT Nguồn vốn' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN dt_nguon_von END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN dt_nguon_von END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN dt_nguon_von END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN dt_nguon_von END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN dt_nguon_von END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN dt_nguon_von END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN dt_nguon_von END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(dt_nguon_von), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	--- CP vốn TT 2
	SELECT 
	    'CP vốn TT 2' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN cp_von_tt_2 END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN cp_von_tt_2 END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN cp_von_tt_2 END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN cp_von_tt_2 END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN cp_von_tt_2 END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN cp_von_tt_2 END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN cp_von_tt_2 END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(cp_von_tt_2), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	--- CP vốn TT 1
	SELECT 
	    'CP vốn TT 1' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN cp_von_tt_1 END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN cp_von_tt_1 END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN cp_von_tt_1 END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN cp_von_tt_1 END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN cp_von_tt_1 END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN cp_von_tt_1 END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN cp_von_tt_1 END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(cp_von_tt_1), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	-- CP vốn CCTG
	SELECT 
	    'CP vốn CCTG' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN cp_von_cctg END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN cp_von_cctg END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN cp_von_cctg END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN cp_von_cctg END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN cp_von_cctg END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN cp_von_cctg END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN cp_von_cctg END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(cp_von_cctg), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	-- Chi phí thuần hoạt động khác
	SELECT 
	    'Chi phí thuần hoạt động khác' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN dt_fintech + dt_tieu_thuong_ca_nhan + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac + cp_net END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN dt_fintech + dt_tieu_thuong_ca_nhan + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac + cp_net END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN dt_fintech + dt_tieu_thuong_ca_nhan + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac + cp_net END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN dt_fintech + dt_tieu_thuong_ca_nhan + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac + cp_net END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN dt_fintech + dt_tieu_thuong_ca_nhan + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac + cp_net END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN dt_fintech + dt_tieu_thuong_ca_nhan + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac + cp_net END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN dt_fintech + dt_tieu_thuong_ca_nhan + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac + cp_net END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(dt_fintech + dt_tieu_thuong_ca_nhan + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac + cp_net), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	--   DT Fintech 
	SELECT 
	    'DT Fintech' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN dt_fintech END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN dt_fintech END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN dt_fintech END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN dt_fintech END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN dt_fintech END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN dt_fintech END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN dt_fintech END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(dt_fintech), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	--  DT tiểu thương, cá nhân
	SELECT 
	    'DT tiểu thương, cá nhân' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN dt_tieu_thuong_ca_nhan END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN dt_tieu_thuong_ca_nhan END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN dt_tieu_thuong_ca_nhan END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN dt_tieu_thuong_ca_nhan END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN dt_tieu_thuong_ca_nhan END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN dt_tieu_thuong_ca_nhan END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN dt_tieu_thuong_ca_nhan END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(dt_tieu_thuong_ca_nhan), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	--  DT Kinh doanh 
	SELECT 
	    'DT Kinh doanh' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN dt_kinh_doanh END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN dt_kinh_doanh END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN dt_kinh_doanh END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN dt_kinh_doanh END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN dt_kinh_doanh END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN dt_kinh_doanh END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN dt_kinh_doanh END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(dt_kinh_doanh), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	--  CP hoa hồng  
	SELECT 
	    'CP hoa hồng' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN cp_hoa_hong END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN cp_hoa_hong END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN cp_hoa_hong END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN cp_hoa_hong END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN cp_hoa_hong END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN cp_hoa_hong END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN cp_hoa_hong END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(cp_hoa_hong), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	-- CP thuần KD khác 
	SELECT 
	    'CP thuần KD khác' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(cp_thuan_kd_khac), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	--  CP hợp tác kd tàu (net) 
	SELECT 
	    'CP hợp tác kd tàu (net)' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN cp_net END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN cp_net END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN cp_net END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN cp_net END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN cp_net END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN cp_net END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN cp_net END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(cp_net), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	-- Tổng thu nhập hoạt động
	SELECT 
	    'Tổng thu nhập hoạt động' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	
	-- Tổng chi phí hoạt động
	SELECT 
	    'Tổng chi phí hoạt động' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN cp_nhan_vien + cp_quan_ly + cp_tai_san END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN cp_nhan_vien + cp_quan_ly + cp_tai_san END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN cp_nhan_vien + cp_quan_ly + cp_tai_san END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN cp_nhan_vien + cp_quan_ly + cp_tai_san END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN cp_nhan_vien + cp_quan_ly + cp_tai_san END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN cp_nhan_vien + cp_quan_ly + cp_tai_san END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN cp_nhan_vien + cp_quan_ly + cp_tai_san END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(cp_nhan_vien + cp_quan_ly + cp_tai_san), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	-- CP thuế, phí
	SELECT 
	    'CP thuế, phí' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN cp_thue_phi END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN cp_thue_phi END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN cp_thue_phi END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN cp_thue_phi END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN cp_thue_phi END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN cp_thue_phi END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN cp_thue_phi END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(cp_thue_phi), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	-- CP nhân viên
	SELECT 
	    'CP nhân viên' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN cp_nhan_vien END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN cp_nhan_vien END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN cp_nhan_vien END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN cp_nhan_vien END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN cp_nhan_vien END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN cp_nhan_vien END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN cp_nhan_vien END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(cp_nhan_vien), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	-- CP quản lý
	SELECT 
	    'CP quản lý' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN cp_quan_ly END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN cp_quan_ly END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN cp_quan_ly END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN cp_quan_ly END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN cp_quan_ly END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN cp_quan_ly END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN cp_quan_ly END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(cp_quan_ly), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION ALL
	
	-- CP tài sản
	SELECT 
	    'CP tài sản' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN cp_tai_san END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN cp_tai_san END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN cp_tai_san END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN cp_tai_san END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN cp_tai_san END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN cp_tai_san END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN cp_tai_san END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(cp_tai_san), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	UNION all
	
	-- Chi phí dự phòng
	SELECT 
	    'Chi phí dự phòng' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN chi_phi_du_phong END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN chi_phi_du_phong END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN chi_phi_du_phong END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN chi_phi_du_phong END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN chi_phi_du_phong END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN chi_phi_du_phong END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN chi_phi_du_phong END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(chi_phi_du_phong), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data
	
	union all
	
	-- Sale Manager
	select 
		'2. Số lượng nhân sự ( Sale Manager )' as critera,
		TO_CHAR(SUM(CASE WHEN area_cde = 'B' THEN sale_manager END), 'FM999,999,999,990') AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN area_cde = 'C' THEN sale_manager END), 'FM999,999,999,990') AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN area_cde = 'D' THEN sale_manager END), 'FM999,999,999,990') AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN area_cde = 'E' THEN sale_manager END), 'FM999,999,999,990') AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN area_cde = 'F' THEN sale_manager END), 'FM999,999,999,990') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN area_cde = 'G' THEN sale_manager END), 'FM999,999,999,990') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN area_cde = 'H' THEN sale_manager END), 'FM999,999,999,990') AS "Đông Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN area_cde = 'Total' THEN sale_manager END), 'FM999,999,999,990') AS "Total"
	from sale_manager_by_area_cde smbac 
	
	union all
	
	select 
	'3. Chỉ số tài chính' as criteria,
		null AS "Đông Bắc Bộ",
	    null AS "Tây Bắc Bộ",
	    null AS "ĐB Sông Hồng",
	    null AS "Bắc Trung Bộ",
	    null AS "Nam Trung Bộ",
	    null AS "Tây Nam Bộ",
	    null AS "Đông Nam Bộ",
	    null AS "Total"
	
	union all
	-- CIR (%)
	SELECT 
	    'CIR (%)' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN -(cp_nhan_vien + cp_quan_ly + cp_tai_san) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac) END) * 100, 'FM999,999,999,990.00') || '%' AS "Đông Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN -(cp_nhan_vien + cp_quan_ly + cp_tai_san) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac) END) * 100, 'FM999,999,999,990.00') || '%' AS "Tây Bắc Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN -(cp_nhan_vien + cp_quan_ly + cp_tai_san) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac) END) * 100, 'FM999,999,999,990.00') || '%' AS "ĐB Sông Hồng",
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN -(cp_nhan_vien + cp_quan_ly + cp_tai_san) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac) END) * 100, 'FM999,999,999,990.00') || '%' AS "Bắc Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN -(cp_nhan_vien + cp_quan_ly + cp_tai_san) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac) END) * 100, 'FM999,999,999,990.00') || '%' AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN -(cp_nhan_vien + cp_quan_ly + cp_tai_san) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac) END) * 100, 'FM999,999,999,990.00') || '%' AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN -(cp_nhan_vien + cp_quan_ly + cp_tai_san) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac) END) * 100, 'FM999,999,999,990.00') || '%' AS "Đông Nam Bộ",
	    TO_CHAR(SUM(-(cp_nhan_vien + cp_quan_ly + cp_tai_san) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    											+ cp_von_tt_2 + cp_von_cctg + dt_kinh_doanh + cp_hoa_hong + cp_thuan_kd_khac)) * 100, 'FM999,999,999,990.00') || '%' AS "Total"
	FROM regional_data
	
	union all 
	
	-- Margin (%)
	SELECT 
	    'Margin (%)' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + 
	    											 				phi_thanh_toan_cham + dt_kinh_doanh) END), 'FM999,999,999,990.00') || '%' AS "Đông Bắc Bộ",							 
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + 
	    											 				phi_thanh_toan_cham + dt_kinh_doanh)  END), 'FM999,999,999,990.00') || '%' AS "Tây Bắc Bộ",									 
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + 
	    											 				phi_thanh_toan_cham + dt_kinh_doanh)  END), 'FM999,999,999,990.00') || '%' AS "ĐB Sông Hồng",							 
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + 
	    											 				phi_thanh_toan_cham + dt_kinh_doanh)  END), 'FM999,999,999,990.00') || '%' AS "Bắc Trung Bộ",								 
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + 
	    											 				phi_thanh_toan_cham + dt_kinh_doanh)  END), 'FM999,999,999,990.00') || '%' AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + 
	    											 				phi_thanh_toan_cham + dt_kinh_doanh)  END), 'FM999,999,999,990.00') || '%' AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + 
	    											 				phi_thanh_toan_cham + dt_kinh_doanh)  END), 'FM999,999,999,990.00') || '%' AS "Đông Nam Bộ",
	    TO_CHAR(SUM((lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + 
	    											 				phi_thanh_toan_cham + dt_kinh_doanh) ), 'FM999,999,999,990.00') || '%' AS "Total"
	FROM regional_data
	
	union all 
	
	
	
	-- Hiệu suất trên/vốn (%)
	SELECT
	'Hiệu suất trên/vốn (%)' AS criteria,
	TO_CHAR(COALESCE(SUM(CASE WHEN region_code = 'B' THEN 
	    -(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) 
	    / NULLIF(cp_von_tt_2 + cp_von_cctg, 0) 
	END), 0) * 100, 'FM999,999,999,990.00') || '%' AS "Đông Bắc Bộ",
	TO_CHAR(COALESCE(SUM(CASE WHEN region_code = 'C' THEN 
	    -(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) 
	    / NULLIF(cp_von_tt_2 + cp_von_cctg, 0)
	END), 0) * 100, 'FM999,999,999,990.00') || '%' AS "Tây Bắc Bộ",
	TO_CHAR(COALESCE(SUM(CASE WHEN region_code = 'D' THEN 
	    -(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) 
	    / NULLIF(cp_von_tt_2 + cp_von_cctg, 0)
	END), 0) * 100, 'FM999,999,999,990.00') || '%' AS "ĐB Sông Hồng",
	TO_CHAR(COALESCE(SUM(CASE WHEN region_code = 'E' THEN 
	    -(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) 
	    / NULLIF(cp_von_tt_2 + cp_von_cctg, 0)
	END), 0) * 100, 'FM999,999,999,990.00') || '%' AS "Bắc Trung Bộ",
	TO_CHAR(COALESCE(SUM(CASE WHEN region_code = 'F' THEN 
	    -(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) 
	    / NULLIF(cp_von_tt_2 + cp_von_cctg, 0)
	END), 0) * 100, 'FM999,999,999,990.00') || '%' AS "Nam Trung Bộ",
	TO_CHAR(COALESCE(SUM(CASE WHEN region_code = 'G' THEN 
	    -(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) 
	    / NULLIF(cp_von_tt_2 + cp_von_cctg, 0)
	END), 0) * 100, 'FM999,999,999,990.00') || '%' AS "Tây Nam Bộ",
	TO_CHAR(COALESCE(SUM(CASE WHEN region_code = 'H' THEN 
	    -(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) 
	    / NULLIF(cp_von_tt_2 + cp_von_cctg, 0)
	END), 0) * 100, 'FM999,999,999,990.00') || '%' AS "Đông Nam Bộ",
	TO_CHAR(COALESCE(SUM(
	    -(lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham
	    + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) 
	    / NULLIF(cp_von_tt_2 + cp_von_cctg, 0)
	), 0) * 100, 'FM999,999,999,990.00') || '%' AS "Total"
	FROM regional_data
	
	union all
	
	-- Hiệu suất BQ/ Nhân sự
	SELECT 
	    'Hiệu suất BQ/ Nhân sự' AS criteria,
	    TO_CHAR(SUM(CASE WHEN region_code = 'B' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / sale_manager END), 'FM999,999,999,990.00') AS "Đông Bắc Bộ",							 
	    TO_CHAR(SUM(CASE WHEN region_code = 'C' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / sale_manager  END), 'FM999,999,999,990.00') AS "Tây Bắc Bộ",									 
	    TO_CHAR(SUM(CASE WHEN region_code = 'D' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / sale_manager  END), 'FM999,999,999,990.00') AS "ĐB Sông Hồng",							 
	    TO_CHAR(SUM(CASE WHEN region_code = 'E' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / sale_manager  END), 'FM999,999,999,990.00') AS "Bắc Trung Bộ",								 
	    TO_CHAR(SUM(CASE WHEN region_code = 'F' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong) / sale_manager END), 'FM999,999,999,990.00') AS "Nam Trung Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'G' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong ) / sale_manager END), 'FM999,999,999,990.00') AS "Tây Nam Bộ",
	    TO_CHAR(SUM(CASE WHEN region_code = 'H' THEN (lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong ) / sale_manager END), 'FM999,999,999,990.00') AS "Đông Nam Bộ",
	    TO_CHAR(SUM((lai_trong_han + lai_qua_han + phi_bao_hiem + phi_tang_han_muc + phi_thanh_toan_cham 
	    											 + cp_nhan_vien + cp_quan_ly + cp_tai_san + chi_phi_du_phong ) / sale_manager), 'FM999,999,999,990.00') AS "Total"
	FROM regional_data a
	right join sale_manager_by_area_cde smbac  on a.region_code =  smbac.area_cde  ;
	




end;
$$ LANGUAGE plpgsql;


call cal_da_phan_bo_tong_hop(); 


select*from tmp_dvml_tong_hop;
