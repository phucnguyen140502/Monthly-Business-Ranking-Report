create or replace procedure cal_head_tong_hop ()
AS $$
BEGIN
	--- tính lãi trong hạn chưa phân bổ 
	truncate table tmp_lai_trong_han_chua_phan_bo_tong_hop ;
	INSERT INTO tmp_lai_trong_han_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	--- lãi trong hạn DVML
	select 202302 month_key,  region_code, sum(amount) lai_trong_han
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 3
	group by region_code 
	union all 
	--- lãi trong hạn HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount) lai_trong_han
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'HEAD' and dim_id = 3;

	--- tính lãi quá hạn chưa phân bổ 
	truncate table tmp_lai_qua_han_chua_phan_bo_tong_hop; 
	
	INSERT INTO tmp_lai_qua_han_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key, region_code, sum(amount) lai_qua_han
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 4 and dvml_head = 'DVML'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code 
	union all
	select 202302 month_key, 'HEAD' region_code, sum(amount) lai_qua_han
	from fact_txn_month_raw_data ftmrd 
	where dim_id = 4 and dvml_head = 'HEAD'
	and transaction_date between '2023-01-31' and '2023-02-28'
	group by region_code ;

	--- tính phí bảo hiểm chưa phân bổ 
	truncate table tmp_phi_bao_hiem_chua_phan_bo_tong_hop ;
	INSERT INTO tmp_phi_bao_hiem_chua_phan_bo_tong_hop
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

	--- tính phí tăng han muc chưa phân bổ 
	truncate table tmp_phi_tang_han_muc_chua_phan_bo_tong_hop ;
	INSERT INTO tmp_phi_tang_han_muc_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	--- phí tăng han muc DVML
	select 202302 month_key,  region_code, sum(amount) phi_tang_han_muc
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 6
	group by region_code 
	union all 
	--- phí tăng han muc HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount) phi_tang_han_muc
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'HEAD' and dim_id = 6;

	--- tính phí thanh toán chưa phân bổ 
	truncate table tmp_phi_thanh_toan_cham_chua_phan_bo_tong_hop ;
	INSERT INTO tmp_phi_thanh_toan_cham_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	--- phí thanh toán DVML
	select 202302 month_key,  region_code, sum(amount) phi_thanh_toan_cham
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 7
	group by region_code 
	union all 
	--- phí thanh toán HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount) phi_thanh_toan_cham
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'HEAD' and dim_id = 7;

	--- tính  DT Nguồn vốn  chưa phân bổ 
	truncate table tmp_dt_nguon_von_chua_phan_bo_tong_hop;
	---  DT Nguồn vốn  DVML
	INSERT INTO tmp_dt_nguon_von_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 9
	group by region_code 
	union all 
	---  DT Nguồn vốn  HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dim_id = 9;
	
	--- tính CP vốn TT 1 chưa phân bổ 
	truncate table tmp_cp_von_tt_1_chua_phan_bo_tong_hop;
	--- CP vốn TT 1 DVML
	INSERT INTO tmp_cp_von_tt_1_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 10
	group by region_code 
	union all 
	--- CP vốn TT 1 HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dim_id = 10;
	
	--- tính CP vốn TT 2 chưa phân bổ 
	truncate table tmp_cp_von_tt_2_chua_phan_bo_tong_hop;
	--- CP vốn TT 2 DVML
	INSERT INTO tmp_cp_von_tt_2_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 11
	group by region_code 
	union all 
	--- CP vốn TT 2 HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dim_id = 11;
	
	--- tính CP vốn CCTG chưa phân bổ 
	truncate table tmp_cp_von_cctg_chua_phan_bo_tong_hop;
	--- CP vốn CCTG DVML
	INSERT INTO tmp_cp_von_cctg_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 12
	group by region_code 
	union all 
	--- CP vốn CCTG HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dim_id = 12;
	
	--- tính DT Fintech chưa phân bổ 
	truncate table tmp_dt_fintech_chua_phan_bo_tong_hop ;
	--- DT Fintech DVML
	INSERT INTO tmp_dt_fintech_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 14
	group by region_code 
	union all 
	--- DT Fintech HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'HEAD' and dim_id = 14;
	
	--- tính DT tiểu thương, cá nhân chưa phân bổ 
	truncate table tmp_dt_tieu_thuong_ca_nhan_chua_phan_bo_tong_hop ;
	--- DT tiểu thương, cá nhân DVML
	INSERT INTO tmp_dt_tieu_thuong_ca_nhan_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 15
	group by region_code 
	union all 
	--- DT tiểu thương, cá nhân HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'HEAD' and dim_id = 15;
	
	--- tính DT Kinh Doanh chưa phân bổ 
	truncate table tmp_dt_kinh_doanh_chua_phan_bo_tong_hop ;
	--- DT Kinh Doanh DVML
	INSERT INTO tmp_dt_kinh_doanh_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 16
	group by region_code 
	union all 
	--- DT Kinh Doanh HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'HEAD' and dim_id = 16;
	
	--- tính CP hoa hồng chưa phân bổ 
	truncate table tmp_cp_hoa_hong_chua_phan_bo_tong_hop ;
	--- CP hoa hồng DVML
	INSERT INTO tmp_cp_hoa_hong_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount) lai_trong_han
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 17
	group by region_code 
	union all 
	--- CP hoa hồng HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount) lai_trong_han
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'HEAD' and dim_id = 17;
	
	--- tính CP thuần KD khác chưa phân bổ 
	truncate table tmp_cp_thuan_kd_khac_chua_phan_bo_tong_hop ;
	--- CP thuần KD khác DVML
	INSERT INTO tmp_cp_thuan_kd_khac_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount) lai_trong_han
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 18
	group by region_code 
	union all 
	--- CP thuần KD khác HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount) lai_trong_han
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'HEAD' and dim_id = 18;
	
	--- tính CP hợp tác kd tàu (net) chưa phân bổ 
	truncate table tmp_cp_net_chua_phan_bo_tong_hop ;
	--- CP hợp tác kd tàu (net) DVML
	INSERT INTO tmp_cp_net_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 19
	group by region_code 
	union all 
	--- CP hợp tác kd tàu (net) HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'HEAD' and dim_id = 19;
	
	truncate table tmp_cp_thue_phi_chua_phan_bo_tong_hop ;
	--- CP thuế, phí DVML
	INSERT INTO tmp_cp_thue_phi_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 22
	group by region_code 
	union all 
	--- CP thuế, phí HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'HEAD' and dim_id = 22;
	
	--- tính CP nhân viên chưa phân bổ 
	truncate table tmp_cp_nhan_vien_chua_phan_bo_tong_hop;
	--- CP nhân viên DVML
	INSERT INTO tmp_cp_nhan_vien_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 23
	group by region_code 
	union all 
	--- CP nhân viên HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dim_id = 23 and dvml_head = 'HEAD';
	
	--- tính CP quản lý chưa phân bổ 
	truncate table tmp_cp_quan_ly_chua_phan_bo_tong_hop;
	--- CP quản lý DVML
	INSERT INTO tmp_cp_quan_ly_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 24
	group by region_code 
	union all 
	--- CP quản lý HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dim_id = 24 and dvml_head = 'HEAD';
	
	--- tính CP quản lý chưa phân bổ 
	truncate table tmp_cp_tai_san_chua_phan_bo_tong_hop;
	--- CP quản lý DVML
	INSERT INTO tmp_cp_tai_san_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	select 202302 month_key,  region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 25
	group by region_code 
	union all 
	--- CP quản lý HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount)
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dim_id = 25 and dvml_head = 'HEAD';

	--- tính chi phi dự phòng chưa phân bổ 
	truncate table tmp_chi_phi_du_phong_chua_phan_bo_tong_hop;
	INSERT INTO tmp_chi_phi_du_phong_chua_phan_bo_tong_hop
	(month_key, region_code, amount)
	--- chi phí dự phòng DVML
	select 202302 month_key,  region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'DVML' and dim_id = 26
	group by region_code 
	union all 
	--- chi phí dự phòng HEAD
	select 202302 month_key, 'HEAD' region_code, sum(amount) 
	from fact_txn_month_raw_data ftmrd
	where transaction_date between '2023-01-31' and '2023-02-28'
	and dvml_head = 'HEAD' and dim_id = 26;


	-- HEAD
	truncate table tmp_head_tong_hop;

	INSERT INTO tmp_head_tong_hop
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
	    FROM tmp_lai_trong_han_chua_phan_bo_tong_hop a
	    LEFT JOIN tmp_lai_qua_han_chua_phan_bo_tong_hop b ON a.region_code = b.region_code
	    LEFT JOIN tmp_phi_bao_hiem_chua_phan_bo_tong_hop c ON b.region_code = c.region_code
	    LEFT JOIN tmp_phi_tang_han_muc_chua_phan_bo_tong_hop d ON c.region_code = d.region_code
	    LEFT JOIN tmp_phi_thanh_toan_cham_chua_phan_bo_tong_hop e ON d.region_code = e.region_code
	    left join tmp_dt_nguon_von_chua_phan_bo_tong_hop t on t.region_code = e.region_code
	    left join tmp_cp_von_tt_1_chua_phan_bo_tong_hop u on u.region_code = t.region_code
	    left join tmp_cp_von_cctg_chua_phan_bo_tong_hop w on w.region_code = u.region_code
	    left join tmp_dt_fintech_chua_phan_bo_tong_hop v on v.region_code = w.region_code
	    left join tmp_dt_tieu_thuong_ca_nhan_chua_phan_bo_tong_hop x on x.region_code = v.region_code
	    left join tmp_cp_net_chua_phan_bo_tong_hop y on y.region_code = x.region_code
	    left join tmp_cp_thue_phi_chua_phan_bo_tong_hop z on z.region_code = y.region_code
	    LEFT JOIN tmp_cp_von_tt_2_chua_phan_bo_tong_hop f ON f.region_code = e.region_code
	    LEFT JOIN tmp_cp_von_cctg_chua_phan_bo_tong_hop g ON g.region_code = f.region_code
	    LEFT JOIN tmp_dt_kinh_doanh_chua_phan_bo_tong_hop h ON h.region_code = e.region_code
	    LEFT JOIN tmp_cp_hoa_hong_chua_phan_bo_tong_hop k ON k.region_code = h.region_code
	    LEFT JOIN tmp_cp_thuan_kd_khac_chua_phan_bo_tong_hop l ON l.region_code = k.region_code
	    LEFT JOIN tmp_cp_nhan_vien_chua_phan_bo_tong_hop m ON m.region_code = e.region_code
	    LEFT JOIN tmp_cp_quan_ly_chua_phan_bo_tong_hop n ON n.region_code = m.region_code
	    LEFT JOIN tmp_cp_tai_san_chua_phan_bo_tong_hop o ON o.region_code = n.region_code
	    LEFT JOIN tmp_chi_phi_du_phong_chua_phan_bo_tong_hop s ON s.region_code = o.region_code
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

END;
$$ LANGUAGE plpgsql;

call cal_head_tong_hop();

select*from tmp_head_tong_hop th ;