CREATE OR REPLACE PROCEDURE cal_tai_chinh_xep_hang()
AS $$
BEGIN

	
	truncate table tmp_tai_chinh_xep_hang ;
	
	INSERT INTO tmp_tai_chinh_xep_hang
	(month_key, region_code, area_name, email, cir, rank_cir, margin, rank_margin, hs_von, rank_hs_von, hsbq_nhan_su, rank_hsbq_nhan_su, "Điểm FIN", rank_fin)
	select csm.*, msm.margin , msm.rank_margin , hvsm.hs_von , hvsm.rank_hs_von ,
	hnssm.hsbq_nhan_su, hnssm.rank_hsbq_nhan_su,
	rank_margin + rank_hs_von + rank_hsbq_nhan_su + rank_hsbq_nhan_su + rank_cir as "Điểm FIN",
	rank() over (order by(rank_margin + rank_hs_von + hsbq_nhan_su + rank_hsbq_nhan_su + rank_cir) desc) as rank_fin
	from cir_xep_hang csm 
	join margin_xep_hang msm on csm.region_code = msm.region_code 
		and csm.area_name = msm.area_name and csm.email = msm.email 
	join hs_von_xep_hang hvsm on hvsm.region_code = msm.region_code 
		and msm.area_name = hvsm.area_name and msm.email = hvsm.email 
	join hsbq_nhan_su_xep_hang hnssm on hnssm.region_code = hvsm.region_code 
		and hvsm.area_name = hnssm.area_name and hnssm.email = hvsm.email ;
	

end;
$$ LANGUAGE plpgsql;


call cal_tai_chinh_xep_hang(); 

select*from tmp_tai_chinh_xep_hang ttc ;








