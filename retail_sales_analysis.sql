SELECT *
FROM retail_sales 
-- create a backup table
CREATE TABLE retail_sales2 AS (
        SELECT * 
        FROM retail_sales
)

--SELECT * FROM retail_sales2

--finding NULL values
SELECT *
FROM retail_sales 
WHERE sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

--Renaming column name
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;

--DATA EXPLORATION
--How many sales we have

SELECT COUNT(*) AS total_sales
FROM retail_sales;

-- How many unique customers do we have
SELECT COUNT (DISTINCT customer_id) AS total_customers
FROM retail_sales;

--how many categories do we have

SELECT DISTINCT category AS categories
FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE (category = 'Clothing' AND 
     quantity >= 4) AND
     TO_CHAR(sale_date, 'YYYY-MM')= '2022-11';
   -- Or ( EXTRACT (month FROM sale_date) = 11 AND
   --   EXTRACT (year FROM  sale_date) = 2022)

   -- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
   SELECT category,
         SUM(total_sale) as net_sales,
         COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT  ROUND(AVG(age::INT),1) AS average_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT  
        category, 
        gender,
        COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category,gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year, MAX(avg_tota_sale)
FROM(
    SELECT EXTRACT(YEAR FROM sale_date) AS year,
            EXTRACT(MONTH FROM sale_date) AS month,
            AVG(total_sale) AS avg_tota_sale
    FROM retail_sales
    GROUP BY 1,2
    ORDER BY 1,2
) AS avg_sales_per_month
GROUP BY year;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id,
        SUM(total_sale)
FROM retail_sales
--WHERE total_sale IS NOT NULL
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;


SELECT * FROM retail_sales

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,
        COUNT(DISTINCT customer_id) AS customers_per_category
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale AS (
    SELECT *,
            CASE
                WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
                WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
                ELSE 'Evening'
            END AS shift
    FROM retail_sales
)
SELECT shift,
        COUNT(transactions_id) AS num_of_orders
FROM hourly_sale
GROUP BY shift
ORDER BY 1;

--End of project

