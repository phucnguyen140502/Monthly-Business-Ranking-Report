truncate table margin_sale_manager;

INSERT INTO margin_sale_manager
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
    FROM tmp_lai_trong_han_da_phan_bo_sale_manager a
    LEFT JOIN tmp_lai_qua_han_da_phan_bo_sale_manager b ON a.region_code = b.region_code and a.area_name = b.area_name and a.email = b.email
    LEFT JOIN tmp_phi_bao_hiem_da_phan_bo_sale_manager c ON b.region_code = c.region_code and b.area_name = c.area_name and b.email = c.email
    LEFT JOIN tmp_phi_tang_han_muc_da_phan_bo_sale_manager d ON c.region_code = d.region_code and c.area_name = d.area_name and c.email = d.email
    LEFT JOIN tmp_phi_thanh_toan_cham_da_phan_bo_sale_manager e ON d.region_code = e.region_code and d.area_name = e.area_name and d.email = e.email
    LEFT JOIN tmp_dt_kinh_doanh_da_phan_bo_sale_manager h ON h.region_code = e.region_code and h.area_name = e.area_name and h.email = e.email
    LEFT JOIN tmp_cp_hoa_hong_da_phan_bo_sale_manager k ON k.region_code = h.region_code and k.area_name = h.area_name and k.email = h.email
    LEFT JOIN tmp_cp_thuan_kd_khac_da_phan_bo_sale_manager l ON l.region_code = k.region_code and l.area_name = k.area_name and l.email = k.email
    LEFT JOIN tmp_cp_nhan_vien_da_phan_bo_sale_manager m ON m.region_code = e.region_code and m.area_name = e.area_name and m.email = e.email
    LEFT JOIN tmp_cp_quan_ly_da_phan_bo_sale_manager n ON n.region_code = m.region_code and n.area_name = m.area_name and n.email = m.email
    LEFT JOIN tmp_cp_tai_san_da_phan_bo_sale_manager o ON o.region_code = n.region_code and o.area_name = n.area_name and o.email = n.email
    LEFT JOIN tmp_chi_phi_du_phong_da_phan_bo_sale_manager s ON s.region_code = o.region_code and s.area_name = o.area_name and s.email = o.email
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
select *, rank() over(order by margin desc)
from calculate_margin;


select*from margin_sale_manager;
