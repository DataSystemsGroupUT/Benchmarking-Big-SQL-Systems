-- explain formatted 
with tmp1 as (
    select partkey from part where name like 'forest%'
),
tmp2 as (
    select s.name, s.address, s.suppkey
    from supplier s, nation n
    where s.nationkey = n.nationkey
    and n.name = 'CANADA'
),
tmp3 as (
    select l.partkey, 0.5 * sum(quantity) as sum_quantity, l.suppkey
    from lineitem l, tmp2
    where l.shipdate >= '1994-01-01' and shipdate <= '1995-01-01'
    and l.suppkey = tmp2.suppkey 
    group by l.partkey, l.suppkey
),
tmp4 as (
    select ps.partkey, ps.suppkey, ps.availqty
    from partsupp ps
    where ps.partkey IN (select partkey from tmp1)
),
tmp5 as (
select
    t4.suppkey
from
    tmp4 t4, tmp3 t3
where
    t4.partkey = t3.partkey
    and t4.suppkey = t3.suppkey
    and availqty > sum_quantity
)
select
    s.name,
    s.address
from
    supplier s
where
    s.suppkey IN (select suppkey from tmp5)
order by s.name;
