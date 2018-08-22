drop view q22_customer_tmp_cached;
drop view q22_customer_tmp1_cached;
drop view q22_orders_tmp_cached;

create view if not exists q22_customer_tmp_cached as
select
	acctbal,
	custkey,
	substr(phone, 1, 2) as cntrycode
from
	customer
where
	substr(phone, 1, 2) = '13' or
	substr(phone, 1, 2) = '31' or
	substr(phone, 1, 2) = '23' or
	substr(phone, 1, 2) = '29' or
	substr(phone, 1, 2) = '30' or
	substr(phone, 1, 2) = '18' or
	substr(phone, 1, 2) = '17';
 
create view if not exists q22_customer_tmp1_cached as
select
	avg(acctbal) as avg_acctbal
from
	q22_customer_tmp_cached
where
	acctbal > 0.00;

create view if not exists q22_orders_tmp_cached as
select
	custkey
from
	orders
group by
	custkey;

select
	cntrycode,
	count(1) as numcust,
	sum(acctbal) as totacctbal
from (
	select
		cntrycode,
		acctbal,
		avg_acctbal
	from
		q22_customer_tmp1_cached ct1 join (
			select
				cntrycode,
				acctbal
			from
				q22_orders_tmp_cached ot
				right outer join q22_customer_tmp_cached ct
				on ct.custkey = ot.custkey
			where
				ot.custkey is null
		) ct2
) a
where
	acctbal > avg_acctbal
group by
	cntrycode
order by
	cntrycode;
