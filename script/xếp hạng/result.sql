truncate table xep_hang ;

INSERT INTO xep_hang
(month_key, region_code, area_name, email, "Tổng điểm", "rank", ltn_avg, rank_ltn_avg, psdn_avg, rank_psdn_avg, approval_rate_avg, rank_approval_rate_avg, npl_truoc_wo_luy_ke, rank_npl_truoc_wo_luy_ke, "Điêm Quy Mô", rank_ptkd, cir, rank_cir, margin, rank_margin, hs_von, rank_hs_von, hsbq_nhan_su, rank_hsbq_nhan_su, "Điểm FIN", rank_fin)
select tqm.month_key, tqm.region_code, tqm.area_name, tqm.email,
rank_ptkd + rank_fin as "Tổng điểm", rank() over(order by(rank_ptkd + rank_fin)),
ltn_avg, rank_ltn_avg, psdn_avg, rank_psdn_avg, approval_rate_avg, rank_approval_rate_avg,
npl_truoc_wo_luy_ke, rank_npl_truoc_wo_luy_ke, tqm."Điêm Quy Mô" , rank_ptkd,
cir, rank_cir, margin, rank_margin, hs_von, rank_hs_von, hsbq_nhan_su, rank_hsbq_nhan_su, 
ttc."Điểm FIN", rank_fin
from tmp_quy_mo tqm 
join tmp_tai_chinh ttc on tqm.region_code = ttc.region_code 
	and tqm.area_name = ttc.area_name and tqm.email = ttc.email ;
	
select*from xep_hang xh ;