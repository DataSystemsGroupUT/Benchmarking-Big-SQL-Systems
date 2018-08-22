select 
  o_year, sum(case when nation = 'BRAZIL' then volume else 0.0 end) / sum(volume) as mkt_share
from 
  (
select 
  year(orderdate) as o_year, extendedprice * (1-discount) as volume, 
  n2.name as nation
    from
      nation n2 join
        (select orderdate, discount, extendedprice, s.nationkey 
         from supplier s join
          (select orderdate, discount, extendedprice, suppkey 
           from part p join
             (select orderdate, partkey, discount, extendedprice, suppkey 
              from lineitem l join
                (select orderdate, orderkey 
                 from orders o join
                   (select c.custkey 
                    from customer c join
                      (select n1.nationkey 
                       from nation n1 join region r
                       on n1.regionkey = r.regionkey and r.name = 'AMERICA'
                       ) n11 on c.nationkey = n11.nationkey
                    ) c1 on c1.custkey = o.custkey
                 ) o1 on l.orderkey = o1.orderkey and o1.orderdate >= '1995-01-01' 
                         and o1.orderdate < '1996-12-31'
              ) l1 on p.partkey = l1.partkey and p.type = 'ECONOMY ANODIZED STEEL'
           ) p1 on s.suppkey = p1.suppkey
        ) s1 on s1.nationkey = n2.nationkey
  ) all_nation
group by o_year
order by o_year;