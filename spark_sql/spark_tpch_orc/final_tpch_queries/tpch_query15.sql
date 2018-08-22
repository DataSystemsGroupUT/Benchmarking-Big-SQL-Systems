drop view revenue_cached;
drop view max_revenue_cached;

create view revenue_cached as
select
	suppkey as supplier_no,
	sum(extendedprice * (1 - discount)) as totarevenue
from
	lineitem
where
	shipdate >= '1996-01-01'
	and shipdate < '1996-04-01'
group by suppkey;

create view max_revenue_cached as
select
	max(totarevenue) as max_revenue
from
	revenue_cached;

select
	s.suppkey,
	s.name,
	s.address,
	s.phone,
	totarevenue
from
	supplier s,
	revenue_cached,
	max_revenue_cached
where
	s.suppkey = supplier_no
	and totarevenue = max_revenue 
order by s.suppkey;
