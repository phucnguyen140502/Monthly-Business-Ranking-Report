
truncate table sale_manager_by_area_cde ;
   
INSERT INTO sale_manager_by_area_cde
(month_key, area_cde, sale_manager)
select 202302 month_key ,'total' area_cde, count(distinct email) sale_manager 
from sale_manager sm  
union all
select 202302 month_key, area_cde , count(distinct email) sale_manager
from sale_manager sm 
group by area_cde ;

select*from sale_manager_by_area_cde smbac ;
