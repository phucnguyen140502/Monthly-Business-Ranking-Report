SELECT a.region_code,
COALESCE(h.amount_da_phan_bo, 0) + COALESCE(k.amount_da_phan_bo, 0) + COALESCE(l.amount_da_phan_bo, 0) + 
COALESCE(f.amount_da_phan_bo, 0) + COALESCE(g.amount_da_phan_bo, 0) + COALESCE(a.amount_da_phan_bo, 0) + 
COALESCE(b.amount_da_phan_bo, 0) + COALESCE(c.amount_da_phan_bo, 0) + COALESCE(d.amount_da_phan_bo, 0) + 
COALESCE(e.amount_da_phan_bo, 0) + COALESCE(m.amount_da_phan_bo, 0) + COALESCE(n.amount_da_phan_bo, 0) + 
COALESCE(o.amount_da_phan_bo, 0) + COALESCE(s.amount_da_phan_bo, 0) AS "1. Lợi nhuận trước thuế",
COALESCE(a.amount_da_phan_bo, 0) + COALESCE(b.amount_da_phan_bo, 0) + COALESCE(c.amount_da_phan_bo, 0) + 
COALESCE(d.amount_da_phan_bo, 0) + COALESCE(e.amount_da_phan_bo, 0) AS "Thu nhập từ hoạt động thẻ",
COALESCE(a.amount_da_phan_bo, 0) AS "lai trong han",
COALESCE(b.amount_da_phan_bo, 0) AS "lai qua han",
COALESCE(c.amount_da_phan_bo, 0) AS "Phi Bao Hiem",
COALESCE(d.amount_da_phan_bo, 0) AS "Phí Tang Han Muc",
COALESCE(e.amount_da_phan_bo, 0) AS "Phí thanh toán chậm, thu từ ngoại bảng, khác… ",
COALESCE(f.amount_da_phan_bo, 0) + COALESCE(g.amount_da_phan_bo, 0) AS "Chi phí thuần KDV",
COALESCE(f.amount_da_phan_bo, 0) AS "CP vốn TT 2",
COALESCE(g.amount_da_phan_bo, 0) AS "CP vốn CCTG",
COALESCE(h.amount_da_phan_bo, 0) + COALESCE(k.amount_da_phan_bo, 0) + COALESCE(l.amount_da_phan_bo, 0) AS "Chi phí thuần hoạt động khác",
COALESCE(h.amount_da_phan_bo, 0) AS "DT Kinh doanh",
COALESCE(k.amount_da_phan_bo, 0) AS "CP hoa hồng",
COALESCE(l.amount_da_phan_bo, 0) AS "CP thuần KD khác",
COALESCE(h.amount_da_phan_bo, 0) + COALESCE(k.amount_da_phan_bo, 0) + COALESCE(l.amount_da_phan_bo, 0) + 
COALESCE(f.amount_da_phan_bo, 0) + COALESCE(g.amount_da_phan_bo, 0) + COALESCE(a.amount_da_phan_bo, 0) + 
COALESCE(b.amount_da_phan_bo, 0) + COALESCE(c.amount_da_phan_bo, 0) + COALESCE(d.amount_da_phan_bo, 0) + 
COALESCE(e.amount_da_phan_bo, 0) AS "Tổng thu nhập hoạt động",
COALESCE(m.amount_da_phan_bo, 0) + COALESCE(n.amount_da_phan_bo, 0) + COALESCE(o.amount_da_phan_bo, 0) AS "Tổng chi phí hoạt động",
COALESCE(m.amount_da_phan_bo, 0) AS "CP nhân viên",
COALESCE(n.amount_da_phan_bo, 0) AS "CP quản lý",
COALESCE(o.amount_da_phan_bo, 0) AS "CP tài sản",
COALESCE(s.amount_da_phan_bo, 0) AS "Chi phí dự phòng"
FROM tmp_lai_trong_han_da_phan_bo a
LEFT JOIN tmp_lai_qua_han_da_phan_bo b ON a.region_code = b.region_code
LEFT JOIN tmp_phi_bao_hiem_da_phan_bo c ON b.region_code = c.region_code
LEFT JOIN tmp_phi_tang_han_muc_da_phan_bo d ON c.region_code = d.region_code
LEFT JOIN tmp_phi_thanh_toan_cham_da_phan_bo e ON d.region_code = e.region_code
LEFT JOIN tmp_cp_von_tt_2_da_phan_bo f ON f.region_code = e.region_code
LEFT JOIN tmp_cp_von_cctg_da_phan_bo g ON g.region_code = f.region_code
LEFT JOIN tmp_dt_kinh_doanh_da_phan_bo h ON h.region_code = e.region_code
LEFT JOIN tmp_cp_hoa_hong_da_phan_bo k ON k.region_code = h.region_code
LEFT JOIN tmp_cp_thuan_kd_khac_da_phan_bo l ON l.region_code = k.region_code
LEFT JOIN tmp_cp_nhan_vien_da_phan_bo m ON m.region_code = e.region_code
LEFT JOIN tmp_cp_quan_ly_da_phan_bo n ON n.region_code = m.region_code
LEFT JOIN tmp_cp_tai_san_da_phan_bo o ON o.region_code = n.region_code
LEFT JOIN tmp_phi_chi_du_phong_da_phan_bo s ON s.region_code = o.region_code;





