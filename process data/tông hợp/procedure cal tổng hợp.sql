CREATE OR REPLACE PROCEDURE cal_tong_hop()
AS $$
BEGIN
	
	truncate table tong_hop ;

	INSERT INTO tong_hop
	(criteria, head, "Đông Bắc Bộ", "Tây Bắc Bộ", "ĐB Sông Hồng", "Bắc Trung Bộ", "Nam Trung Bộ", "Tây Nam Bộ", "Đông Nam Bộ", "Total")
	SELECT
	    tmp_dvml_tong_hop.criteria,
	    tmp_head_tong_hop.head,
	    tmp_dvml_tong_hop."Đông Bắc Bộ",
	    tmp_dvml_tong_hop."Tây Bắc Bộ",
	    tmp_dvml_tong_hop."ĐB Sông Hồng",
	    tmp_dvml_tong_hop."Bắc Trung Bộ" ,
	    tmp_dvml_tong_hop."Nam Trung Bộ",
	    tmp_dvml_tong_hop."Tây Nam Bộ",
	    tmp_dvml_tong_hop."Đông Nam Bộ",
	    tmp_dvml_tong_hop."Total"
	FROM
	    tmp_dvml_tong_hop
	left JOIN
	    tmp_head_tong_hop
	ON
	    tmp_dvml_tong_hop.criteria = tmp_head_tong_hop.criteria
	full join 
		dim_structure ds 
	on ds."﻿name" = tmp_dvml_tong_hop.criteria 
	order by sortorder ;


end;
$$ LANGUAGE plpgsql;


call cal_tong_hop(); 


select*from tong_hop th ;
