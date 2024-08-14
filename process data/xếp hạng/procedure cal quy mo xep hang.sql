CREATE OR REPLACE PROCEDURE cal_quy_mo_xep_hang()
AS $$
BEGIN
	
	truncate table tmp_quy_mo_xep_hang ;

	INSERT INTO tmp_quy_mo_xep_hang
	(month_key, region_code, area_name, email, ltn_avg, rank_ltn_avg, psdn_avg, rank_psdn_avg, approval_rate_avg, rank_approval_rate_avg, npl_truoc_wo_luy_ke, rank_npl_truoc_wo_luy_ke, "Điêm Quy Mô", rank_ptkd)
	with cal_diem_quy_mo as (
	select tntwlk.kpi_month as month_key, 
	tltn.region_code, tltn.area_name , tltn.email ,
	tltn.ltn_avg , tltn.rank_ltn_avg ,
	tpsdn.psdn_avg , tpsdn.rank_psdn_avg ,
	tar.approval_rate_avg , tar.rank_approval_rate_avg ,
	tntwlk.npl_truoc_wo_luy_ke , tntwlk.rank_npl_truoc_wo_luy_ke ,
	(rank_ltn_avg + rank_psdn_avg + rank_approval_rate_avg 
	+ rank_npl_truoc_wo_luy_ke) as "Điêm Quy Mô"
	from tmp_loan_to_new_xep_hang tltn 
	join tmp_phat_sinh_du_no_xep_hang tpsdn 
		on tltn.region_code = tpsdn.region_code 
			and tltn.area_name = tpsdn.area_name 
			and tltn.email = tpsdn.email 
	join tmp_approval_rate_xep_hang tar 
		on tpsdn.region_code = tar.region_code 
			and tpsdn.area_name = tar.area_name 
			and tpsdn.email = tar.email 
	join tmp_npl_truoc_wo_luy_ke_xep_hang tntwlk 
		on tpsdn.region_code = tntwlk.region_code 
			and tpsdn.area_name = tntwlk.area_name 
			and tpsdn.email = tntwlk.email 
	)
	select *, 
	rank() over (order by cal_diem_quy_mo."Điêm Quy Mô" desc) as rank_ptkd
	from cal_diem_quy_mo;		
		


end;
$$ LANGUAGE plpgsql;


call cal_quy_mo_xep_hang(); 

select*from tmp_quy_mo_xep_hang tqm ;


