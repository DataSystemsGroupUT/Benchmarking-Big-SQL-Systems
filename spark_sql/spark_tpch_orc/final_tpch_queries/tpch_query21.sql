-- explain

create temporary table l3 stored as orc as 
select orderkey, count(distinct suppkey) as cntSupp
from lineitem
where receiptdate > commitdate and orderkey is not null
group by orderkey
having cntSupp = 1
;

with location as (
select supplier.* from supplier, nation where
supplier.nationkey = nation.nationkey and nation.name = 'SAUDI ARABIA'
)
select sl.name, count(*) as numwait
from
(
select li.suppkey, li.orderkey
from lineitem li join orders o on li.orderkey = o.orderkey and
                      o.orderstatus = 'F'
     join
     (
     select l.orderkey, count(distinct l.suppkey) as cntSupp
     from lineitem l
     group by orderkey
     ) l2 on li.orderkey = l2.orderkey and 
             li.receiptdate > li.commitdate and 
             l2.cntSupp > 1
) l1 join l3 on l1.orderkey = l3.orderkey
 join location sl on l1.suppkey = sl.suppkey
group by
 sl.name
order by
 numwait desc,
 sl.name
limit 100;
