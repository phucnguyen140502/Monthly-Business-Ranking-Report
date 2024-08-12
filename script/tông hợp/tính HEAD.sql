truncate table tmp_head;

INSERT INTO tmp_head
(criteria, head)
WITH base_query AS (
    SELECT a.region_code,
        h.amount + k.amount + l.amount + nullif(f.amount,0) + nullif(g.amount,0) + a.amount + b.amount + c.amount + d.amount + e.amount + -- Tổng thu nhập hoạt động
        m.amount + n.amount + o.amount + -- Tổng CP hoạt động
        s.amount -- CP dự phòng
        AS "1. Lợi nhuận trước thuế",
        a.amount + b.amount + c.amount + d.amount + e.amount AS "Thu nhập từ hoạt động thẻ",
        a.amount AS "Lãi trong hạn",
        b.amount AS "Lãi quá hạn",
        c.amount AS "Phí Bảo hiểm",
        d.amount AS "Phí tăng hạn mức",
        e.amount AS "Phí thanh toán chậm, thu từ ngoại bảng, khác…",
		COALESCE(NULLIF(t.amount, 0), 0) + 
		COALESCE(NULLIF(u.amount, 0), 0) + 
		COALESCE(f.amount, 0) + 
		COALESCE(g.amount, 0) AS "Chi phí thuần KDV",
        COALESCE(NULLIF(t.amount, 0), 0) as "DT Nguồn vốn",
        f.amount AS "CP vốn TT 2",
        COALESCE(NULLIF(u.amount, 0), 0) as "CP vốn TT 1",
        g.amount AS "CP vốn CCTG",
		COALESCE(NULLIF(v.amount, 0), 0) + 
		COALESCE(NULLIF(x.amount, 0), 0) + 
		COALESCE(NULLIF(y.amount, 0), 0) + 
		COALESCE(h.amount, 0) + 
		COALESCE(k.amount, 0) + 
		COALESCE(l.amount, 0) AS "Chi phí thuần hoạt động khác",
        COALESCE(NULLIF(v.amount, 0), 0) as "DT Fintech",
        COALESCE(NULLIF(x.amount, 0), 0) as "DT tiểu thương, cá nhân",
        h.amount AS "DT Kinh doanh",
        k.amount AS "CP hoa hồng",
        l.amount AS "CP thuần KD khác",
        COALESCE(NULLIF(y.amount, 0), 0) as "CP hợp tác kd tàu (net)",
        COALESCE(h.amount, 0) + 
		COALESCE(k.amount, 0) + 
		COALESCE(l.amount, 0) + -- CP thuần hoạt động khác
		COALESCE(NULLIF(f.amount, 0), 0) + 
		COALESCE(NULLIF(g.amount, 0), 0) + -- CP thuần KDV
		COALESCE(a.amount, 0) + 
		COALESCE(b.amount, 0) + 
		COALESCE(c.amount, 0) + 
		COALESCE(d.amount, 0) + 
		COALESCE(e.amount, 0) -- Thu nhập từ hoạt động thẻ
		AS "Tổng thu nhập hoạt động",
		COALESCE(NULLIF(z.amount, 0), 0) + 
		COALESCE(m.amount, 0) + 
		COALESCE(n.amount, 0) + 
		COALESCE(o.amount, 0) AS "Tổng chi phí hoạt động",
        COALESCE(NULLIF(z.amount, 0), 0) as "CP thuế, phí",
        m.amount AS "CP nhân viên",
        n.amount AS "CP quản lý",
        o.amount AS "CP tài sản",
        s.amount AS "Chi phí dự phòng"
    FROM tmp_lai_trong_han_chua_phan_bo a
    LEFT JOIN tmp_lai_qua_han_chua_phan_bo b ON a.region_code = b.region_code
    LEFT JOIN tmp_phi_bao_hiem_chua_phan_bo c ON b.region_code = c.region_code
    LEFT JOIN tmp_phi_tang_han_muc_chua_phan_bo d ON c.region_code = d.region_code
    LEFT JOIN tmp_phi_thanh_toan_cham_chua_phan_bo e ON d.region_code = e.region_code
    left join tmp_dt_nguon_von_chua_phan_bo t on t.region_code = e.region_code
    left join tmp_cp_von_tt_1_chua_phan_bo u on u.region_code = t.region_code
    left join tmp_cp_von_cctg_chua_phan_bo w on w.region_code = u.region_code
    left join tmp_dt_fintech_chua_phan_bo v on v.region_code = w.region_code
    left join tmp_dt_tieu_thuong_ca_nhan_chua_phan_bo x on x.region_code = v.region_code
    left join tmp_cp_net_chua_phan_bo y on y.region_code = x.region_code
    left join tmp_cp_thue_phi_chua_phan_bo z on z.region_code = y.region_code
    LEFT JOIN tmp_cp_von_tt_2_chua_phan_bo f ON f.region_code = e.region_code
    LEFT JOIN tmp_cp_von_cctg_chua_phan_bo g ON g.region_code = f.region_code
    LEFT JOIN tmp_dt_kinh_doanh_chua_phan_bo h ON h.region_code = e.region_code
    LEFT JOIN tmp_cp_hoa_hong_chua_phan_bo k ON k.region_code = h.region_code
    LEFT JOIN tmp_cp_thuan_kd_khac_chua_phan_bo l ON l.region_code = k.region_code
    LEFT JOIN tmp_cp_nhan_vien_chua_phan_bo m ON m.region_code = e.region_code
    LEFT JOIN tmp_cp_quan_ly_chua_phan_bo n ON n.region_code = m.region_code
    LEFT JOIN tmp_cp_tai_san_chua_phan_bo o ON o.region_code = n.region_code
    LEFT JOIN tmp_chi_phi_du_phong_chua_phan_bo s ON s.region_code = o.region_code
    WHERE a.region_code = 'HEAD'
)
SELECT  '1. Lợi nhuận trước thuế' AS criteria, "1. Lợi nhuận trước thuế" AS HEAD FROM base_query
UNION ALL
SELECT  'Thu nhập từ hoạt động thẻ' AS criteria, "Thu nhập từ hoạt động thẻ" AS HEAD FROM base_query
UNION ALL
SELECT 'Lãi trong hạn' AS criteria, "Lãi trong hạn" AS HEAD FROM base_query
UNION ALL
SELECT 'Lãi quá hạn' AS criteria, "Lãi quá hạn" AS HEAD FROM base_query
UNION ALL
SELECT 'Phí Bảo hiểm' AS criteria, "Phí Bảo hiểm" AS HEAD FROM base_query
UNION ALL
SELECT 'Phí tăng hạn mức' AS criteria, "Phí tăng hạn mức" AS HEAD FROM base_query
UNION ALL
SELECT 'Phí thanh toán chậm, thu từ ngoại bảng, khác…' AS criteria, "Phí thanh toán chậm, thu từ ngoại bảng, khác…" AS HEAD FROM base_query
UNION all
select 'Chi phí thuần KDV' AS criteria, "Chi phí thuần KDV" AS HEAD FROM base_query
UNION ALL
select 'DT Nguồn vốn' AS criteria, "DT Nguồn vốn" AS HEAD FROM base_query
union all
SELECT 'CP vốn TT 2' AS criteria, "CP vốn TT 2" AS HEAD FROM base_query
UNION all
SELECT 'CP vốn TT 1' AS criteria, "CP vốn TT 1" AS HEAD FROM base_query
union all
SELECT 'CP vốn CCTG' AS criteria, "CP vốn CCTG" AS HEAD FROM base_query
UNION ALL
SELECT 'Chi phí thuần hoạt động khác' AS criteria, "Chi phí thuần hoạt động khác" AS HEAD FROM base_query
union all
SELECT 'DT Fintech' AS criteria, "DT Fintech" AS HEAD FROM base_query
union all
SELECT 'DT tiểu thương, cá nhân' AS criteria, "DT tiểu thương, cá nhân" AS HEAD FROM base_query
union all
SELECT 'DT Kinh doanh' AS criteria, "DT Kinh doanh" AS HEAD FROM base_query
UNION ALL
SELECT 'CP hoa hồng' AS criteria, "CP hoa hồng" AS HEAD FROM base_query
UNION ALL
SELECT 'CP thuần KD khác' AS criteria, "CP thuần KD khác" AS HEAD FROM base_query
UNION all
SELECT 'CP hợp tác kd tàu (net)' AS criteria, "CP hợp tác kd tàu (net)" AS HEAD FROM base_query
UNION ALL
SELECT 'Tổng thu nhập hoạt động' AS criteria, "Tổng thu nhập hoạt động" AS HEAD FROM base_query
UNION ALL
SELECT  'Tổng chi phí hoạt động' AS criteria, "Tổng chi phí hoạt động" AS HEAD FROM base_query
UNION all
SELECT  'CP thuế, phí' AS criteria, "CP thuế, phí" AS HEAD FROM base_query
union all
SELECT  'CP nhân viên' AS criteria, "CP nhân viên" AS HEAD FROM base_query
UNION ALL
SELECT  'CP quản lý' AS criteria, "CP quản lý" AS HEAD FROM base_query
UNION ALL
SELECT  'CP tài sản' AS criteria, "CP tài sản" AS HEAD FROM base_query
UNION ALL
SELECT 'Chi phí dự phòng' AS criteria, "Chi phí dự phòng" AS HEAD FROM base_query   
union all 
select '2. Số lượng nhân sự ( Sale Manager )' as criteria, count(distinct email) as HEAD
from sale_manager sm ;
select*from tmp_head;






