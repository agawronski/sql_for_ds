--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
\c Adventureworks

\dt *.*

:q

\dt purchasing.*
-- purchasing | productvendor       | table | aidangawronski
-- purchasing | purchaseorderdetail | table | aidangawronski
-- purchasing | purchaseorderheader | table | aidangawronski
-- purchasing | shipmethod          | table | aidangawronski
-- purchasing | vendor              | table | aidangawronski

select *
from purchasing.productvendor
limit 10;

select *
from purchasing.purchaseorderdetail
limit 10;

select *
from purchasing.purchaseorderheader
limit 10;

select *
from purchasing.shipmethod
limit 10;

select *
from purchasing.vendor
limit 10;


--------------------------------------------------------------------------------
-- it looks like there are multiple products per order
select *
from purchasing.purchaseorderdetail
limit 10;

-- When did these orders occur ?
-- How many records are there?
-- How many orders are there?
select
min(duedate) as min_duedate,
max(duedate) as max_duedate,
count(*) as num_records,
count(distinct purchaseorderid) as num_orders
from purchasing.purchaseorderdetail;
-- min_duedate     |     max_duedate     | num_records | num_orders
-- ---------------------+---------------------+-------------+------------
-- 2011-04-30 00:00:00 | 2014-10-22 00:00:00 |        8845 |       4012


-- looks like purchaseorderheader has the actual order date
select
min(orderdate) as min_orderdate,
max(orderdate) as max_orderdate,
count(*) as num_records,
count(distinct purchaseorderid) as num_orders
from purchasing.purchaseorderheader;
-- min_orderdate    |    max_orderdate    | num_records | num_orders
-- ---------------------+---------------------+-------------+------------
-- 2011-04-16 00:00:00 | 2014-09-22 00:00:00 |        4012 |       4012



select *
from purchasing.purchaseorderdetail
limit 10;

-- Are there returns?
select *
from purchasing.purchaseorderdetail
where orderqty <= 0
limit 10;

-- Why does receivedqty + rejectedqty not always equal to orderqty?
select *
from purchasing.purchaseorderdetail
where (receivedqty + rejectedqty) != orderqty
limit 10;
-- perhaps they were rejected back to the manufacturer


-- what is APT, and UPT, APU
-- average per transaction
-- units per transaction
-- average per unit
select
(sum(orderqty * unitprice)/count(distinct purchaseorderid)) as apt,
(sum(orderqty)/count(distinct purchaseorderid)) as upt,
(sum(orderqty * unitprice)/sum(orderqty)) as apu
from purchasing.purchaseorderdetail;




select *
from purchasing.purchaseorderdetail
limit 10;

-- what keys might there be?

\dt purchasing.*

\d purchasing.productvendor
-- productid
-- businessentityid

\d purchasing.purchaseorderdetail
-- purchaseorderid
-- productid

\d purchasing.purchaseorderheader
-- purchaseorderid
-- employeeid
-- vendorid
-- shipmethodid

\d purchasing.shipmethod
-- shipmethodid

\d purchasing.vendor
-- businessentityid
--------------------------------------------------------------------------------
-- How many orders are shipped by each method in the entire dataset?
select count(*)
from purchasing.purchaseorderdetail;
-- 8845

select count(distinct purchaseorderid)
from purchasing.purchaseorderdetail;
-- 4012

select count(*)
from purchasing.purchaseorderheader;
-- 4012

select count(distinct purchaseorderid)
from purchasing.purchaseorderheader;
-- 4012
-- each row of purchase order header has exactly 1 purchase order
-- There are the same number of purchase orders in purchaseorderheader as there
-- are in purchaseorderdetail

-- Join purchase order header to shipmethod
select *
from purchasing.purchaseorderheader x
join purchasing.shipmethod y
on x.shipmethodid = y.shipmethodid
limit 10;

-- Frequently when joining tables the number of records resulting is not what
-- you might have expected. In this case we are fine, but this can be a useful
-- check in order to avoid problems down the road.
select count(*)
from purchasing.purchaseorderheader x
join purchasing.shipmethod y
on x.shipmethodid = y.shipmethodid;


-- prefixing with x & y is not necessary except for the on clause
-- but it always it good to include so that you know where the columns are
-- coming from later on
-- furthermore we don't need to count distinct (just count) on "purchaseorderid"
-- & on large datasets count distinct may cause the query to run very slowly
-- however in some cases it may help avoid bugs (arising from misunderstanding
-- of the data, incorrect logic, or unexpected duplicates)
select y.name, count(distinct x.purchaseorderid) as num_orders
from purchasing.purchaseorderheader x
join purchasing.shipmethod y
on x.shipmethodid = y.shipmethodid
group by y.name
order by num_orders desc;


-- How many orders are purchased from each vendor?
-- &
-- What was the cost of the orders?
-- Return the results sorted by greatest cost descending
-- Note that a left join was not necessary here however if there were orders
-- which did not have a vendorid then we would see them final result
select
y.name,
count(distinct x.purchaseorderid) as num_orders,
sum(x.subtotal) as subtotal
from purchasing.purchaseorderheader x
left join purchasing.vendor y
on x.vendorid = y.businessentityid
group by y.name
order by subtotal desc;


-- How many different products are there in the purchase orders data?
select count(distinct productid) as num_products
from purchasing.purchaseorderdetail;


-- How many differenct products does each vendor offer?
-- Which vendor has the most products?
select
y.name,
count(distinct x.productid) as num_products
from (
  select *
  from purchasing.purchaseorderheader a
  left join purchasing.purchaseorderdetail b
  on a.purchaseorderid = b.purchaseorderid
) x
left join purchasing.vendor y
on x.vendorid = y.businessentityid
group by y.name
order by num_products desc
limit 25;

-- How many products are there in the productvendor table

select count(distinct productid) as num_products
from purchasing.productvendor;


select count(*)
from purchasing.productvendor;

select *
from purchasing.productvendor;
limit 10;
















select *
from purchasing.purchaseorderheader x
left join purchasing.purchaseorderdetail y
on x.purchaseorderid = y.purchaseorderid
limit 10;


select *
from purchasing.productvendor
limit 10;

select *
from purchasing.purchaseorderdetail
limit 10;

select *
from purchasing.purchaseorderheader
limit 10;

select *
from purchasing.shipmethod
limit 10;

select *
from purchasing.vendor
limit 10;
















Easy
1)      What is the difference between an inner join and an outer join

2)      What is the total amount spent in the entire dataset?

3)      How many different items have been sold in the entire data set?

4)      What is the total amount spent in 2017?

5)      How many different customers are there in the entire dataset?

Medium
1)      How many customers have made a purchase each year (in the entire dataset)?

2)      How many items total (not distinct) have been sold each year (in the entire dataset)?

3)      How many Females have spent over 500 dollars (in the entire dataset)?

4)      How many customers are there from by country (in the entire dataset) and how many have made a purchase in 2017?

5)      What is the total amount spent by those over age 30 vs under age 30

Hard
1)      How would you calculate the average time between purchases for each customer in the previous example?

2)      How would you get the last transaction for each customer as of the date ‘2017-03-01’?

3)      What is the total number of items purchased by customers over 30 and customers under 30?

4)      What is the average number of distinct items purchased per person by country?

5)      For customers who have bought more than 10 items, and are under 20 what each customers max purchase?




































--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
