create temporary table q2_minimum_cost_supplier_tmp1 stored as orc as
select 
  s.acctbal, s.name as s_name, n.name as n_name, p.partkey, ps.supplycost, p.mfgr, s.address, s.phone, s.comment 
from 
  nation n join region r 
  on 
    n.regionkey = r.regionkey and r.name = 'EUROPE' 
  join supplier s 
  on 
s.nationkey = n.nationkey 
  join partsupp ps 
  on  
s.suppkey = ps.suppkey 
  join part p 
  on 
    p.partkey = ps.partkey and p.size = 15 and p.type like '%BRASS' ;

create temporary table q2_minimum_cost_supplier_tmp2 stored as orc as
select 
  partkey, min(supplycost) as min_supplycost
from  
  q2_minimum_cost_supplier_tmp1 
group by partkey;

select 
  t1.acctbal, t1.s_name, t1.n_name, t1.partkey, t1.mfgr, t1.address, t1.phone, t1.comment 
from 
  q2_minimum_cost_supplier_tmp1 t1 join q2_minimum_cost_supplier_tmp2 t2 
on 
  t1.partkey = t2.partkey and t1.supplycost=t2.min_supplycost 
order by acctbal desc, n_name, s_name, partkey 
limit 100;
