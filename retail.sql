-- SQL PROJECT -- RETAIL SALES ANALYSIS --

drop table if exists retail;
create table retail(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(10),
age int,
category varchar(35),
quantiy int,
price_per_unit float,
cogs float,
total_sale float
);

copy retail from 'C:\Users\Admin\Desktop\SQL\RETAIL_SALES_ANALYSIS\retail_sales.csv' with csv header;

select * from retail;

select count(*) from retail;

select * from retail 
where transactions_id is null;

select * from retail 
where sale_date is null;

select * from retail 
where sale_time is null;

select * from retail
where 
transactions_id is null 
or sale_date is null 
or sale_time is null 
or gender is null 
or category is null 
or quantiy is null 
or cogs is null 
or total_sale is null;

delete from retail 
where 
transactions_id is null 
or sale_date is null 
or sale_time is null 
or gender is null 
or category is null 
or quantiy is null 
or cogs is null 
or total_sale is null;

--- DATA EXPLORATION ---

--1.How many sales we have --
select count(*) as total_sales from retail;

--2.How many unique customers we have --
select count(distinct customer_id) as no_of_customer from retail;

--3.How many categories we have --
select distinct category from retail;

-- Data Analysis and Buisness key problems --

--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retail where sale_date='2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category
--- is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from retail 
where category = 'Clothing' and quantiy >= 4 
and TO_CHAR(sale_date,'YYYY-MM')='2022-11';

--3.Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,SUM(total_sale) as net_sale,count(*) as total_orders from retail
group by category;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select round(avg(age),2)
from retail
where category='Beauty';

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail where
total_sale>1000;

--6.Write a SQL query to find the total number of transactions (transaction_id)
--  made by each gender in each category.

select category,gender,count(*) as total_transactions
from retail
group by category,gender
order by category;

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

with cte as
( select extract(month from sale_date) as month,
  extract(year from sale_date)as year,
  avg(total_sale) as avg_sale,
  rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
  from retail
  group by month,year
)
select year,month,avg_sale from cte where rank=1;

--8.Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id,sum(total_sale) as total_sales
from retail
group by 1
order by 2 desc limit 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.:

select category,count(distinct customer_id) as total
from retail
group by category;

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, 
--   Afternoon Between 12 & 17, Evening >17):

with cte as(
select 
case when extract(hour from sale_time)<12 then 'Morning'
     when extract(hour from sale_time)between 12 and 17 then 'afternoon'
	 else 'evening'
end as shift
from retail
)
select shift,count(*)as total_sale 
from cte
group by shift;



