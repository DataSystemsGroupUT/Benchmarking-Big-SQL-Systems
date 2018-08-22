
SELECT count(distinct cs_order_number) as order_count,
               sum(cs_ext_ship_cost) as total_shipping_cost,
               sum(cs_net_profit) as total_net_profit
FROM catalog_sales cs1
JOIN customer_address ca ON (cs1.cs_ship_date_sk = ca.ca_address_sk)
JOIN call_center c ON (cs1.cs_call_center_sk = c.cc_call_center_sk)
JOIN date_dim d ON (cs1.cs_ship_date_sk = d.d_date_sk)
LEFT SEMI JOIN (SELECT cs2.cs_order_number as cs_order_number
                               FROM catalog_sales cs2 JOIN catalog_sales cs3
                               ON (cs2.cs_order_number = cs3.cs_order_number)
                               WHERE cs2.cs_warehouse_sk <> cs3.cs_warehouse_sk
			) cs_ch1
ON (cs1.cs_order_number = cs_ch1.cs_order_number)
LEFT OUTER JOIN catalog_returns cr1 ON (cs1.cs_order_number = cr1.cr_order_number)
WHERE d.d_date between '2002-2-01' and '2002-4-02'
and cs1.cs_ship_date_sk = d_date_sk
and cs1.cs_ship_addr_sk = ca_address_sk
and ca_state = 'GA'
and cs1.cs_call_center_sk = cc_call_center_sk
and cc_county in ('Williamson County','Williamson County','Williamson County','Williamson County',
                  'Williamson County'
)
order by order_count
limit 100;