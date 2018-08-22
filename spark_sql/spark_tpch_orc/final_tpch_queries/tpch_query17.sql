with q17_part as (
  select partkey from part where  
  brand = 'Brand#23'
  and container = 'MED BOX'
),
q17_avg as (
  select l.partkey as t_partkey, 0.2 * avg(l.quantity) as t_avg_quantity
  from lineitem l
  where l.partkey IN (select partkey from q17_part)
  group by l.partkey
),
q17_price as (
  select
  quantity,
  partkey,
  extendedprice
  from
  lineitem
  where
  partkey IN (select partkey from q17_part)
)
select cast(sum(extendedprice) / 7.0 as decimal(32,2)) as avg_yearly
from q17_avg, q17_price
where 
t_partkey = partkey and quantity < t_avg_quantity;
