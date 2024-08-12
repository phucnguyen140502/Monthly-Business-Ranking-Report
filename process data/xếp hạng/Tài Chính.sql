
truncate table tmp_tai_chinh ;

INSERT INTO tmp_tai_chinh
(month_key, region_code, area_name, email, cir, rank_cir, margin, rank_margin, hs_von, rank_hs_von, hsbq_nhan_su, rank_hsbq_nhan_su, "Điểm FIN", rank_fin)
select csm.*, msm.margin , msm.rank_margin , hvsm.hs_von , hvsm.rank_hs_von ,
hnssm.hsbq_nhan_su, hnssm.rank_hsbq_nhan_su,
rank_margin + rank_hs_von + rank_hsbq_nhan_su + rank_hsbq_nhan_su + rank_cir as "Điểm FIN",
rank() over (order by(rank_margin + rank_hs_von + hsbq_nhan_su + rank_hsbq_nhan_su + rank_cir) desc) as rank_fin
from cir_sale_manager csm 
join margin_sale_manager msm on csm.region_code = msm.region_code 
	and csm.area_name = msm.area_name and csm.email = msm.email 
join hs_von_sale_manager hvsm on hvsm.region_code = msm.region_code 
	and msm.area_name = hvsm.area_name and msm.email = hvsm.email 
join hsbq_nhan_su_sale_manager hnssm on hnssm.region_code = hvsm.region_code 
	and hvsm.area_name = hnssm.area_name and hnssm.email = hvsm.email ;
	
select*from tmp_tai_chinh ttc ;