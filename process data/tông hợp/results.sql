truncate table results ;

INSERT INTO results
(criteria, head, "Đông Bắc Bộ", "Tây Bắc Bộ", "ĐB Sông Hồng", "Bắc Trung Bộ", "Nam Trung Bộ", "Tây Nam Bộ", "Đông Nam Bộ", "Total")
SELECT
    tmp_dvml.criteria,
    tmp_head.head,
    tmp_dvml."Đông Bắc Bộ",
    tmp_dvml."Tây Bắc Bộ",
    tmp_dvml."ĐB Sông Hồng",
    tmp_dvml."Bắc Trung Bộ" ,
    tmp_dvml."Nam Trung Bộ",
    tmp_dvml."Tây Nam Bộ",
    tmp_dvml."Đông Nam Bộ",
    tmp_dvml."Total"
FROM
    tmp_dvml
left JOIN
    tmp_head
ON
    tmp_dvml.criteria = tmp_head.criteria
full join 
	dim_structure ds 
on ds."﻿name" = tmp_dvml.criteria 
order by sortorder ;


select*from results r ;




