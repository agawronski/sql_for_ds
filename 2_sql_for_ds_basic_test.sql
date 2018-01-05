--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
\c Adventureworks

\dt *.*

:q

\dt sales.*

-- Schema |            Name             | Type  |     Owner
-- --------+-----------------------------+-------+----------------
-- sales  | countryregioncurrency       | table | aidangawronski
-- sales  | creditcard                  | table | aidangawronski
-- sales  | currency                    | table | aidangawronski
-- sales  | currencyrate                | table | aidangawronski
-- sales  | customer                    | table | aidangawronski
-- sales  | personcreditcard            | table | aidangawronski
-- sales  | salesorderdetail            | table | aidangawronski
-- sales  | salesorderheader            | table | aidangawronski
-- sales  | salesorderheadersalesreason | table | aidangawronski
-- sales  | salesperson                 | table | aidangawronski
-- sales  | salespersonquotahistory     | table | aidangawronski
-- sales  | salesreason                 | table | aidangawronski
-- sales  | salestaxrate                | table | aidangawronski
-- sales  | salesterritory              | table | aidangawronski
-- sales  | salesterritoryhistory       | table | aidangawronski
-- sales  | shoppingcartitem            | table | aidangawronski
-- sales  | specialoffer                | table | aidangawronski
-- sales  | specialofferproduct         | table | aidangawronski
-- sales  | store                       | table | aidangawronski

select *
from sales.countryregioncurrency
limit 10;

select *
from sales.creditcard
limit 10;

select *
from sales.currency
limit 10;

select *
from sales.currencyrate
limit 10;

select *
from sales.customer
limit 10;

select *
from sales.personcreditcard
limit 10;

select *
from sales.salesorderdetail
limit 10;

select *
from sales.salesorderheader
limit 10;

select *
from sales.salesorderheadersalesreason
limit 10;

select *
from sales.salesperson
limit 10;

select *
from sales.salespersonquotahistory
limit 10;

select *
from sales.salesreason
limit 10;

select *
from sales.salestaxrate
limit 10;

select *
from sales.salesterritory
limit 10;

select *
from sales.salesterritoryhistory
limit 10;

select *
from sales.shoppingcartitem
limit 10;

select *
from sales.specialoffer
limit 10;

select *
from sales.specialofferproduct
limit 10;

select *
from sales.store
limit 10;


--------------------------------------------------------------------------------

-- When did the sales occur? (Start and end date?)
-- How many records are there in sales.salesorderheader
-- How many orders have sales have occured?
\d sales.salesorderheader

select
min(orderdate) as min_orderdate,
max(orderdate) as max_orderdate,
count(*) as num_records,
count(distinct salesorderid) as num_purchases
from sales.salesorderheader;

-- min_orderdate    |    max_orderdate    | num_records | num_purchases
-- ---------------------+---------------------+-------------+---------------
-- 2011-05-31 00:00:00 | 2014-06-30 00:00:00 |       31465 |         31465



-- Are there online orders?
-- If so, how many online or offline orders were made and how much (subtotal)
-- What is the average subtotal per online transaction?
-- What is the average subtotal per offline transaction?
select *
from sales.salesorderheader
limit 10;


\d sales.salesorderheader

select distinct onlineorderflag
from sales.salesorderheader;
-- onlineorderflag
-- -----------------
-- f
-- t

-- online orders
select
count(distinct salesorderid) as num_online_purchases,
sum(subtotal) as total_online,
(sum(subtotal)/count(distinct salesorderid)) as apt_online_v1, -- option 1
avg(subtotal) as apt_online_v2 -- option 2
from sales.salesorderheader
where onlineorderflag = 't';

-- offline orders
select
count(distinct salesorderid) as num_offline_purchases,
sum(subtotal) as total_offline,
(sum(subtotal)/count(distinct salesorderid)) as apt_offline_v1, -- option 1
avg(subtotal) as apt_offline_v2 -- option 2
from sales.salesorderheader
where onlineorderflag = 'f';

-- Alternatively, a superior method (can be used for Intermediate Test)
select
onlineorderflag,
count(distinct salesorderid) as num_purchases,
sum(subtotal) as total,
(sum(subtotal)/count(distinct salesorderid)) as apt_v1, -- option 1
avg(subtotal) as apt_v2 -- option 2
from sales.salesorderheader
group by onlineorderflag;



-- Do other columns sum to equal totaldue?
\d sales.salesorderheader

select subtotal, taxamt, freight, totaldue
from sales.salesorderheader
limit 10;

select (subtotal + taxamt + freight), totaldue
from sales.salesorderheader
limit 10;

select *
from sales.salesorderheader
where (subtotal + taxamt + freight) != totaldue
limit 10;


-- Do any of the items sold have a discount applied?
\dt sales.*

select *
from sales.salesorderdetail
limit 10;

\d sales.salesorderdetail

select *
from sales.salesorderdetail
where unitpricediscount != 0
limit 10;

select salesorderid, salesorderdetailid, orderqty, productid, unitprice, unitpricediscount
from sales.salesorderdetail
where unitpricediscount != 0
limit 20;

-- https://technet.microsoft.com/en-us/library/ms124498(v=sql.100).aspx
-- If so does the unitprice include the discount?
\d sales.salesorderheader

select salesorderid, subtotal
from sales.salesorderheader
limit 10;

\d sales.salesorderdetail

select salesorderid, orderqty, unitprice, unitpricediscount
from sales.salesorderdetail
limit 10;

select salesorderid, subtotal
from sales.salesorderheader
where salesorderid = 43875;

select
sum(unitprice),
sum(orderqty * unitprice),
sum(unitpricediscount),
sum(orderqty * unitpricediscount)
from sales.salesorderdetail
where salesorderid = 43875;

select
sum(orderqty * unitprice)
from sales.salesorderdetail
where salesorderid = 43875;




-------------------------------------------
-- Why doesn't it match ????????????


-------------------------------------------


-- what is APT, and UPT, APU
-- average per transaction
-- units per transaction
-- average per unit
select
(sum(orderqty * unitprice)/count(distinct salesorderid)) as apt,
(sum(orderqty)/count(distinct salesorderid)) as upt,
(sum(orderqty * unitprice)/sum(orderqty)) as apu
from sales.salesorderdetail;


-- what join keys might there be?

\dt sales.*


\d sales.countryregioncurrency
-- countryregioncode
-- currencycode

\d sales.creditcard
-- creditcardid

\d sales.currency
-- currencycode

\d sales.currencyrate
-- currencyrateid

\d sales.customer
-- customerid
-- personid
-- storeid
-- territoryid

\d sales.personcreditcard
-- businessentityid

\d sales.salesorderdetail
-- salesorderdetailid

\d sales.salesorderheader
-- salesorderid

\d sales.salesorderheadersalesreason
-- salesorderid
-- salesreasonid

\d sales.salesperson
-- businessentityid
-- territoryid

\d sales.salespersonquotahistory
-- businessentityid

\d sales.salesreason
-- salesreasonid

\d sales.salestaxrate
-- salestaxrateid
-- stateprovinceid

\d sales.salesterritory
-- territoryid

\d sales.salesterritoryhistory
-- businessentityid
-- territoryid

\d sales.shoppingcartitem
-- shoppingcartitemid
-- shoppingcartid
-- productid

\d sales.specialoffer
-- specialofferid

\d sales.specialofferproduct
-- specialofferid
-- productid

\d sales.store
-- businessentityid
-- salespersonid




--------------------------------------------------------------------------------
-- How many sales people are there?
\d sales.salesperson

select count(*)
from sales.salesperson;

-- How many sales were made by each sales person? (Hard question)




\d sales.salesorderheader
-- salespersonid
-- territoryid

\d sales.salesperson
-- businessentityid
-- territoryid



select carriertrackingnumber, count(*)
from sales.salesorderdetail
group by carriertrackingnumber;


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
