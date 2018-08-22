select
	sum(extendedprice * discount) as revenue
from
	lineitem
where
	shipdate >= '1993-01-01'
	and shipdate < '1994-01-01'
	and discount between 0.06 - 0.01 and 0.06 + 0.01
	and quantity < 25;
