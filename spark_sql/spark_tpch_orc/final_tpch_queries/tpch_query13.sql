select
	c_count,
	count(*) as custdist
from
	(
		select
			c.custkey,
			count(orderkey) as c_count
		from
			customer c left outer join orders o on
				c.custkey = o.custkey
				and o.comment not like '%unusual%accounts%'
		group by
			c.custkey
	) orders
group by
	c_count
order by
	custdist desc,
	c_count desc;
