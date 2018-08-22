select
	o.orderpriority,
	count(*) as order_count
from
	orders as o
where
	o.orderdate >= '1996-05-01'
	and o.orderdate < '1996-08-01'
	and exists (
		select
			*
		from
			lineitem l
		where
			l.orderkey = o.orderkey
			and l.commitdate < l.receiptdate
	)
group by
	o.orderpriority
order by
	o.orderpriority;
