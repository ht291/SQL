create database if not exists salesDataWalmart;

use salesDataWalmart;


## creating tables
create table if not exists sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(30) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12,4),
date datetime not null,
time TIME not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,9),
gross_income decimal(12,4),
rating float (2,1)
);


### seeing the data
select * from salesdatawalmart.sales;


-- ---------------------------- FEATURE ENGINEERING ------------------------------
-- ---------  time_of_day

 select time,
  (case 
  when `time` between "00:00:00" and "12:00:00" then "Morning"
  when `time` between "12:01:00" and "16:00:00" then "Afternoon"
  else "Evening"
  end
  ) as time_of_date
 from sales;
 
 alter table sales add column time_of_day varchar(20);
 
 -- to insert data into the column
 update sales set time_of_day = (
 case 
  when `time` between "00:00:00" and "12:00:00" then "Morning"
  when `time` between "12:01:00" and "16:00:00" then "Afternoon"
  else "Evening"
  end
 );
 
 -- ------- day_name
 
 select date,
 dayname(date) as day_name
 from sales;
 
 alter table sales add column day_name varchar(10);
 
 update sales set day_name = dayname(date);
 
 
 -- ------- month_name
 
 select date,
 monthname(date) as month_name
 from sales;
 
 alter table sales add column month_name varchar(10);
 
 update sales set month_name = monthname(date);
 
 
 
 -- ---------------------------------------------------------------------------------------
 -- ------------------------------------- GENERIC -----------------------------------------
 
 -- How many unique cities does the data have?
 select distinct city 
 from sales;
 
 -- in which city is each branch?
 select distinct branch
 from sales;
 
 select distinct city , branch
 from sales;
 
 -- -------------------------------------------------------------------------------------------
 -- --------------------------------------- PRODUCT -------------------------------------------
 
 -- How many unique product lines does the data have?
 select distinct product_line
 from sales;
 
 select count(distinct(product_line))
 from sales;
 
 -- Most common payment method?
 select payment_method, count(payment_method) as cnt
 from sales
 group by payment_method
 order by cnt desc;
 
 -- What is the most selling product line?
 select *
 from sales;
 
 select 
 product_line,count(product_line) as cnt
 from sales 
 group by product_line
 order by cnt desc;
 
 -- What is the total revenue by month?
 select*
 from sales;
 
 select month_name, sum(total) as rev
 from sales
 group by month_name
 order by rev desc;
 
 
 -- What months had the largest COGS?
 select month_name, sum(COGS) as largest_cogs
 from sales
 group by month_name
 order by largest_cogs desc;
 
 -- What product line had the largest revenue?
 select * from sales;
 
 select product_line,  sum(total) as total_rev
 from sales
 group by product_line
 order by total_rev;
 
 -- What is the city with the largest revenue?
 select * from sales;
 
 select city, sum(total) as city_rev
 from sales
 group by city
 order by city_rev desc;
 
 -- What product line had the largest VAT?
 select * from sales;
 
 select product_line, sum(VAT) as total_vat
 from sales
 group by product_line
 order by total_vat desc;
 
 -- Fetch each product line and add a column to those product line showing "Good","Bad". 
 -- Good if its greater than avg sales
 
 
 
 
 -- Which branch sold more products than avg products sold?
 
 select branch, sum(quantity) as qty
 from sales
 group by branch
 having sum(quantity)>(select avg(quantity) from sales);
 
 -- What is the most common product line by gender?
 select gender,product_line, count(gender) as total_cnt
 from sales
 group by gender, product_line
 order by total_cnt desc;
 
-- What is the average rating of each product line?
select round(avg(rating),2) as avg_rating,
product_line
from sales
group by product_line
order by avg_rating desc;