use project1;

-- creating backup

create table Store
like `sql - retail sales analysis_utf`;

Insert Store
select * from `sql - retail sales analysis_utf`;

-- Data Cleaning

select * from Store limit 10;

ALTER TABLE Store
RENAME COLUMN ï»¿transactions_id TO transactions_id;

ALTER TABLE Store
RENAME COLUMN quantiy TO quantity;

-- to check null values

SELECT * 
FROM Store
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL   
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Exploratory Data Analysis

-- How many Sales we Have ? 
SELECT COUNT(*) AS TOTAL_SALES FROM Store;

-- How many unique customers we have ?
SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_CUSTOMERS FROM Store;

-- How many unique customers we have ?
SELECT COUNT(DISTINCT CATEGORY) AS TOTAL_CATEGORY FROM Store;
SELECT DISTINCT CATEGORY FROM Store;

-- Data Analysis & Business Key Problems & Answers.

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM STORE WHERE SALE_DATE = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * FROM STORE 
WHERE CATEGORY = 'CLOTHING'
AND
SALE_DATE LIKE '2022-11%'
AND
QUANTITY >= 4
ORDER BY SALE_DATE;
;

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category:

SELECT category, SUM(total_sale) AS total_sales_INR,
count(*) as total_orders
FROM Store
GROUP BY category;

select * from Store limit 10;

-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(AGE),1) AS AVERAGE_AGE FROM STORE
WHERE CATEGORY = 'BEAUTY';

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM STORE 
WHERE TOTAL_SALE > 1000
ORDER BY TOTAL_SALE;

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT category,gender, COUNT(*) AS total_transactions
FROM Store
GROUP BY 
category,
gender
order by 1;

-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- COUNTED FIRST MONTH 
-- SELECT MIN(sale_date) AS starting_date
-- FROM Store;

-- my first attempt

-- SELECT 
--     SUBSTR(sale_date, 1, 7) AS month,        -- USED THIS SUBSTR BECAUSE DATE STORE IN TEXT FROM ELSE DATE_FORMAT(sale_date, '%Y-%m')
--     AVG(total_sale) AS avg_sale
-- FROM Store
-- GROUP BY month
-- ORDER BY month;

SELECT 
    year,
    month,
    avg_sale
FROM 
(
    SELECT 
        YEAR(sale_date) AS year,                 -- Extract year
        MONTH(sale_date) AS month,               -- Extract month
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS `rank`
    FROM store
    GROUP BY YEAR(sale_date), MONTH(sale_date)  -- Group by year and month
) AS t1
WHERE `rank` = 1
ORDER BY year, month;

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales

SELECT CUSTOMER_ID,
SUM(TOTAL_SALE) AS TOTAL_SALES
FROM STORE
GROUP BY 1
ORDER BY 2
LIMIT 5;

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category
SELECT CATEGORY,COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUS FROM STORE
GROUP BY 1
ORDER BY 2;

-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

SELECT COUNT(TRANSACTIONS_ID) , SALE_TIME < '12:00:00' AS MORNING
FROM STORE
GROUP BY 2;

WITH HOURLY_SALES
AS
(
SELECT *,
	CASE
		WHEN HOUR(SALE_TIME)<12 THEN 'MORNING'
        WHEN HOUR(SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
	END AS SHIFT
    FROM STORE 
)
SELECT SHIFT,COUNT(*) AS SALES FROM HOURLY_SALES
GROUP BY SHIFT;

--  -------------------------------------------END of Project ----------------------------------------