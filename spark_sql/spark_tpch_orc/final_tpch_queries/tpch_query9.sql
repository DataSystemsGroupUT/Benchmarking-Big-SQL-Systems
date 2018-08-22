select 
  nation, o_year, sum(amount) as sum_profit
from 
  (
select 
  name as nation, year(orderdate) as o_year, 
  extendedprice * (1 - discount) -  supplycost * quantity as amount
    from
      orders o join
      (select extendedprice, discount, quantity, orderkey, l2.name, supplycost 
       from part p join
         (select extendedprice, discount, quantity, l1.partkey, orderkey, 
                 l1.name, ps.supplycost 
          from partsupp ps join
            (select l.suppkey, l.extendedprice, l.discount, l.quantity, l.partkey, 
                    l.orderkey, name 
             from
               (select s.suppkey, n.name 
                from nation n join supplier s on n.nationkey = s.nationkey
               ) s1 join lineitem l on s1.suppkey = l.suppkey
            ) l1 on ps.suppkey = l1.suppkey and ps.partkey = l1.partkey
         ) l2 on p.name like '%plum%' and p.partkey = l2.partkey
     ) l3 on o.orderkey = l3.orderkey
  )profit
group by nation, o_year
order by nation, o_year desc;