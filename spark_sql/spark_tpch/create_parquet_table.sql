drop database spark_tpch_prod;
CREATE DATABASE IF NOT EXISTS spark_tpch_prod
  COMMENT 'For tpch spark at 300GB scale factor';

USE spark_tpch_prod;

drop table if exists NATION_text;
create table NATION_text
( N_NATIONKEY  int,
  N_NAME       string,
  N_REGIONKEY  int,
  N_COMMENT    string
) USING csv
OPTIONS(header "false", delimiter "|", path "/tpch_spark/input/nation.tbl")
;
drop table if exists NATION;
create table NATION 
using parquet
as (select * from NATION_text)
;

drop table if exists REGION_text;
create table REGION_text
( R_REGIONKEY  int,
  R_NAME       string,
  R_COMMENT    string
) USING csv
OPTIONS(header "false", delimiter "|", path "/tpch_spark/input/region.tbl")
;
drop table if exists REGION;
create table REGION 
using parquet
as (select * from REGION_text)
;

drop table if exists PART_text;
create table PART_text
( P_PARTKEY     int,
  P_NAME        string,
  P_MFGR        string,
  P_BRAND       string,
  P_TYPE        string,
  P_SIZE        int,
  P_CONTAINER   string,
  P_RETAILPRICE double ,
  P_COMMENT     string
) USING csv
OPTIONS(header "false", delimiter "|", path "/tpch_spark/input/part.tbl")
;
drop table if exists PART;
create table PART 
using parquet
as (select * from PART_text)
;

drop table if exists SUPPLIER_text;
create table SUPPLIER_text
( S_SUPPKEY     int,
  S_NAME        string,
  S_ADDRESS     string,
  S_NATIONKEY   int,
  S_PHONE       string,
  S_ACCTBAL     double ,
  S_COMMENT     string
) USING csv
OPTIONS(header "false", delimiter "|", path "/tpch_spark/input/supplier.tbl")
;
drop table if exists SUPPLIER;
create table SUPPLIER 
using parquet
as (select * from SUPPLIER_text)
;

drop table if exists PARTSUPP_text;
create table PARTSUPP_text
( PS_PARTKEY     int,
  PS_SUPPKEY     int,
  PS_AVAILQTY    int,
  PS_SUPPLYCOST  double  ,
  PS_COMMENT     string
) USING csv
OPTIONS(header "false", delimiter "|", path "/tpch_spark/input/partsupp.tbl")
;
drop table if exists PARTSUPP;
create table PARTSUPP 
using parquet
as (select * from PARTSUPP_text)
;

drop table if exists CUSTOMER_text;
create table CUSTOMER_text
( C_CUSTKEY     int,
  C_NAME        string,
  C_ADDRESS     string,
  C_NATIONKEY   int,
  C_PHONE       string,
  C_ACCTBAL     double   ,
  C_MKTSEGMENT  string,
  C_COMMENT     string 
) USING csv
OPTIONS(header "false", delimiter "|", path "/tpch_spark/input/customer.tbl")
;
drop table if exists CUSTOMER;
create table CUSTOMER 
using parquet
as (select * from CUSTOMER_text)
;

drop table if exists ORDERS_text;
create table ORDERS_text
( O_ORDERKEY       int,
  O_CUSTKEY        int,
  O_ORDERSTATUS    CHAR(1) ,
  O_TOTALPRICE     double ,
  O_ORDERDATE      string,
  O_ORDERPRIORITY  string,  
  O_CLERK          string, 
  O_SHIPPRIORITY   int,
  O_COMMENT        string 
) USING csv
OPTIONS(header "false", delimiter "|", path "/tpch_spark/input/orders.tbl")
;
drop table if exists ORDERS;
create table ORDERS 
using parquet
as (select * from ORDERS_text)
;

drop table if exists LINEITEM_text;
create table LINEITEM_text
( L_ORDERKEY    int,
  L_PARTKEY     int,
  L_SUPPKEY     int,
  L_LINENUMBER  int,
  L_QUANTITY    double ,
  L_EXTENDEDPRICE  double ,
  L_DISCOUNT     double ,
  L_TAX          double ,
  L_RETURNFLAG   string ,
  L_LINESTATUS   string ,
  L_SHIPDATE     string,
  L_COMMITDATE   string,
  L_RECEIPTDATE  string,
  L_SHIPINSTRUCT string,
  L_SHIPMODE     string,
  L_COMMENT      string 
) USING csv
OPTIONS(header "false", delimiter "|", path "/tpch_spark/input/lineitem.tbl")
;
drop table if exists LINEITEM;
create table LINEITEM 
using parquet
as (select * from LINEITEM_text)
;

