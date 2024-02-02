

--ex01
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING (trim(ordernumber)::integer),
ALTER COLUMN quantityordered TYPE integer USING (trim(quantityordered)::integer),
ALTER COLUMN priceeach TYPE integer USING (trim(priceeach)::integer),
ALTER COLUMN orderlinenumber TYPE varchar USING (trim(orderlinenumber)::varchar),
ALTER COLUMN sales TYPE numeric(7,2) USING (trim(sales)::numeric(7,2)),
ALTER COLUMN orderdate TYPE varchar USING (trim(orderdate)::varchar),
ALTER COLUMN status TYPE text USING (trim(status)::text),
ALTER COLUMN productline TYPE text USING (trim(productline)::text),
ALTER COLUMN msrp TYPE numeric USING (trim(msrp)::numeric),
ALTER COLUMN productcode TYPE varchar USING (trim(productcode)::varchar),
ALTER COLUMN customername TYPE text USING (trim(customername)::text),
ALTER COLUMN phone TYPE varchar USING (trim(phone)::varchar),
ALTER COLUMN addressline1 TYPE varchar USING (trim(addressline1)::varchar),
ALTER COLUMN addressline2 TYPE varchar USING (trim(addressline2)::varachar),
ALTER COLUMN city TYPE text USING (trim(city)::text),
ALTER COLUMN postalcode TYPE varchar USING (trim(postalcode)::varchar),
ALTER COLUMN country TYPE text USING (trim(country)::text),
ALTER COLUMN territory TYPE text USING (trim(territory)::text),
ALTER COLUMN contactfullname TYPE varchar USING (trim(contactfullname)::varchar),
ALTER COLUMN dealsize TYPE text USING (trim(dealsize)::text);
  
--ex02
SELECT *
FROM sales_dataset_rfm_prj
WHERE ordernmber IS NULL 
OR quantityordered IS NULL
OR priceeach IS NULL
OR orderlinenumber IS NULL OR OR orderlinenumber = ''
OR sales IS NULL
OR orderdate IS NULL OR orderdate = '';
  
--ex03
alter table sales_dataset_rfm_prj
add column lastcontactname text,
add column firstcontactname text;
update sales_dataset_rfm_prj
set lastcontactname = LEFT(contactfullname,position('-' in contactfullname)-1),
set firstcontactname =  RIGHT(contactfullname,length(contactfullname) -position('-' in contactfullname));
update sales_dataset_rfm_prj

--ex04
ALTER TABLE sales_dataset_rfm_prj
ADD QTR_ID INT,
ADD MONTH_ID INT,
ADD YEAR_ID INT;

UPDATE sales_dataset_rfm_prj
SET QTR_ID = QUARTER(orderdate),
    MONTH_ID = MONTH(orderdate),
    YEAR_ID = YEAR(orderdate);

--ex05
--su dung  plot box
with cte as(select 
percentile_cont (0.25) within group (order by ordernumber) as Q1,
percentile_cont (0.75) within group (order by ordernumber) as Q3,
percentile_cont (0.75) within group (order by ordernumber) - percentile_cont (0.25) within group (order by ordernumber) as IQR
from sales_dataset_rfm_prj),
cte2 as (select
Q1 - 1.5*IQR AS min_value,
Q3 - 1.5*IQR AS max_value
from cte)
select  * from sales_dataset_rfm_prj
where ordernumber < (select max_value from cte2)
or ordernumber > (select max_value from cte2)
--su dung z core
with cte as (select ordernumber,
			 avg(ordernumber) as avg,
stddev(ordernumber) as stddev
from sales_dataset_rfm_prj
group by ordernumber)
select (ordernumber-avg)/stddev
from cte 


--ex06
create table SALES_DATASET_RFM_PRJ_CLEAN AS (select * from sales_dataset_rfm_prj);


