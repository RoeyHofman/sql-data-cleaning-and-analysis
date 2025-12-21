/* 
SQL Data Cleaning and Analysis Project
Author: Roey Hofman

Project Overview:
This SQL project focuses on cleaning raw data and then analyzing it in order to generate reliable
and meaningful reports. Proper data preparation is essential to ensure accurate insights and
prevent misleading results during the analysis stage.
*/

/* =====================================================
Step 1: Data Cleaning
Purpose:
Prepare the dataset for analysis by improving data quality, consistency, and usability.
===================================================== 
/* 
1.1. Remove Duplicates
Objective:
Identify and eliminate duplicate records to prevent inflated counts, incorrect aggregations,
and biased metrics in the analysis.
Duplicates are typically defined based on business-relevant columns.
*/

/* Checking product table */
SELECT *
FROM product_info;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY product_id,product_name) AS row_num
FROM product_info;

WITH duplicates_cet AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY product_id, product_name) AS row_num
FROM product_info
)
SELECT *
FROM duplicates_cet
WHERE row_num > 1;

/* Checking customer table*/

SELECT *
FROM customer_info;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY customer_id, email, region 
 ) AS row_num
FROM customer_info;

WITH duplicates_customers_cet AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY customer_id, email, region 
 ) AS row_num
FROM customer_info
)
SELECT *
FROM duplicates_customers_cet
WHERE row_num > 1;


/* Checking orders table*/

SELECT *
FROM sales_data;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY order_id,customer_id,order_date,delivery_status 
 ) AS row_num
FROM sales_data;

WITH duplicates_orders_cet AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY order_id, customer_id, order_date, delivery_status 
 ) AS row_num
FROM sales_data
)
SELECT *
FROM duplicates_orders_cet
WHERE row_num > 1;


/* 
1.2. Standardize the Data
Objective:
Ensure consistent formatting across the dataset.
This includes normalizing date formats, text casing, measurement units,
and categorical values to allow accurate grouping, filtering, and comparison.
*/

/* Checking product table */


SELECT *
FROM product_info;

SELECT DISTINCT category
FROM product_info;


/* Checking customer table*/

SELECT *
FROM customer_info;

SELECT DISTINCT gender
FROM customer_info;

SELECT * 
FROM customer_info
WHERE gender LIKE 'femle%';

UPDATE customer_info
SET gender = 'Female'
WHERE gender LIKE 'femle%';

SELECT DISTINCT region
FROM customer_info;

SELECT DISTINCT loyalty_tier
FROM customer_info;

SELECT loyalty_tier,
	    TRIM(loyalty_tier)
FROM customer_info;


UPDATE customer_info
SET loyalty_tier = TRIM(loyalty_tier);


SELECT DISTINCT loyalty_tier
FROM customer_info;


SELECT * 
FROM customer_info
WHERE loyalty_tier LIKE 'gld%';


UPDATE customer_info
SET loyalty_tier = 'Gold'
WHERE loyalty_tier LIKE 'gld%';


SELECT * 
FROM customer_info
WHERE loyalty_tier LIKE 'sll%';


UPDATE customer_info
SET loyalty_tier = 'Silver'
WHERE loyalty_tier LIKE 'sll%';


SELECT * 
FROM customer_info
WHERE loyalty_tier LIKE 'brn%';


UPDATE customer_info
SET loyalty_tier = 'bronze'
WHERE loyalty_tier LIKE 'brn%';

SELECT signup_date,
    STR_TO_DATE(signup_date , '%d-%m-%y') AS converted_date
FROM customer_info;


SELECT signup_date
FROM customer_info
WHERE STR_TO_DATE(signup_date, '%d-%m-%y') IS NULL
  AND signup_date IS NOT NULL;
  
  
UPDATE customer_info
SET signup_date = NULL
WHERE signup_date = '';

  
UPDATE customer_info
SET signup_date = STR_TO_DATE(signup_date , '%d-%m-%y');

ALTER TABLE customer_info
MODIFY COLUMN signup_date DATE;

/* Checking orders table*/


SELECT *
FROM sales_data;


SELECT DISTINCT delivery_status
FROM sales_data;


SELECT delivery_status,
	    TRIM(delivery_status)
FROM sales_data;


UPDATE sales_data
SET delivery_status = TRIM(delivery_status);


SELECT *
FROM sales_data
WHERE delivery_status LIKE 'delr%';


UPDATE sales_data
SET delivery_status = 'Deliverd'
WHERE delivery_status LIKE 'delr%';


SELECT DISTINCT payment_method
FROM sales_data;


SELECT *
FROM sales_data
WHERE payment_method LIKE '%transfr%';


UPDATE sales_data
SET payment_method = 'bank transfer'
WHERE payment_method LIKE '%transfr%';


SELECT DISTINCT region
FROM sales_data;


SELECT *
FROM sales_data
WHERE region LIKE 'nr%';


UPDATE sales_data
SET region = 'North'
WHERE region LIKE 'nr%';


SELECT *
FROM sales_data
WHERE delivery_status = "";

 
UPDATE sales_data
SET delivery_status = null
WHERE delivery_status = "";


SELECT order_date,
    STR_TO_DATE(order_date , '%d-%m-%y') AS converted_date
FROM sales_data;


SELECT order_date
FROM sales_data
WHERE STR_TO_DATE(order_date, '%d-%m-%y') IS NULL
  AND order_date IS NOT NULL;
  
  
UPDATE sales_data
SET order_date = NULL
WHERE order_date = '';

  
UPDATE sales_data
SET order_date = STR_TO_DATE(order_date , '%d-%m-%y');

ALTER TABLE sales_data
MODIFY COLUMN order_date DATE;


/* 
1.3. Handle Null or Blank Values
Objective:
Detect missing or empty values and apply an appropriate strategy.
Depending on the context, missing data may be filled, removed, or flagged
to maintain data integrity and analytical reliability.
*/
/* Checking product table */

SELECT *
FROM product_info
WHERE product_id IS NULL;

SELECT *
FROM product_info
WHERE base_price IS NULL;


/* Checking customer table*/


SELECT *
FROM customer_info;


/* Checking orders table*/


SELECT *
FROM sales_data
WHERE unit_price IS NULL;


SELECT *
FROM sales_data
WHERE payment_method IS NULL;


SELECT *
FROM sales_data
WHERE payment_method = "";


UPDATE sales_data
SET payment_method = null
WHERE payment_method = "";


SELECT *
FROM sales_data
WHERE order_id IS NULL;


/* 
1.4. Remove Unnecessary Columns
Objective:
Drop columns that are not required for analysis or reporting.
This simplifies the dataset, improves query performance,
and keeps the analysis focused on relevant information.
*/
/* Checking product table */


SELECT *
FROM product_info;


/* Checking customer table*/


SELECT *
FROM customer_info;


/* Checking orders table*/


SELECT *
FROM sales_data;


/* =====================================================
STEP 2: Analytical Questions and Business Insights
Purpose:
The following sections outline the key analytical questions addressed in this project.
Each analysis is designed to support data-driven decision making and provide
clear business insights for reporting and stakeholder review.
===================================================== */

/* -----------------------------------------------------
1. Payment Method Analysis
Objective:
Analyze customer payment behavior to identify the most commonly used payment methods,
their performance, and their distribution across regions.
----------------------------------------------------- */


SELECT 
    region,
    payment_method,
    COUNT(*) AS amount_of_orders,
    AVG(unit_price * quantity) AS avg_sales,
    SUM(unit_price * quantity) AS total_sales
FROM sales_data
WHERE payment_method IS NOT NULL
  AND delivery_status IS NOT NULL
GROUP BY region,
	     payment_method
ORDER BY region, 
	     total_sales DESC;
        


/* 
1.1 Most Frequently Used Payment Method
Objective:
Determine which payment method is used most often across all transactions.
This insight helps identify customer preferences and supports optimization
of payment options.
*/


SELECT 
    payment_method,
    COUNT(*) AS amount_of_orders,
    AVG(unit_price * quantity) AS avg_sales,
    SUM(unit_price * quantity) AS total_sales
FROM sales_data
WHERE payment_method IS NOT NULL
  AND delivery_status IS NOT NULL
GROUP BY payment_method
ORDER BY total_sales DESC;

/* 
1.2 Payment Method with the Highest Number of Canceled Shipments
Objective:
Identify which payment method is most frequently associated with canceled shipments.
This analysis may reveal potential friction points or operational issues
related to specific payment types.
*/


SELECT 
    payment_method,
    COUNT(*) AS amount_of_orders,
    AVG(unit_price * quantity) AS avg_sales,
    SUM(unit_price * quantity) AS total_sales
FROM sales_data
WHERE payment_method IS NOT NULL
  AND delivery_status = 'Cancelled'
GROUP BY payment_method
ORDER BY total_sales DESC;

/* 
1.3 Distribution of Cancelled Payment Methods by Region
Objective:
Analyze how payment method cancelled varies across different regions.
This helps uncover regional preferences and supports localized business strategies.
*/

SELECT 
	region,
    payment_method,
    COUNT(*) AS amount_of_orders,
    AVG(unit_price * quantity) AS avg_sales,
    SUM(unit_price * quantity) AS total_sales
FROM sales_data
WHERE payment_method IS NOT NULL
  AND delivery_status = 'Cancelled'
GROUP BY region,
	     payment_method
ORDER BY region, 
	     total_sales DESC;


/* 
1.4 Revenue by Region
Objective:
Calculate total revenue generated in each region.
This provides a geographic view of performance and highlights high and low revenue areas.
*/


SELECT 
	region,
    COUNT(*) AS amount_of_orders,
    AVG(unit_price * quantity) AS avg_sales,
    SUM(unit_price * quantity) AS total_sales
FROM sales_data
WHERE delivery_status != 'Cancelled'
GROUP BY region
ORDER BY region, 
	     total_sales DESC;
         
/* -----------------------------------------------------
2. Revenue and Product Performance Analysis
Objective:
Evaluate revenue distribution, product performance, customer value,
and discount behavior to support strategic planning.
----------------------------------------------------- */

SELECT ci.loyalty_tier,
	   COUNT(sd.quantity) AS amount_of_orders,
	   AVG(sd.unit_price * sd.quantity) AS avg_sales,
	   SUM(sd.unit_price * sd.quantity) AS total_sales
FROM customer_info ci
JOIN sales_data sd
	 USING(customer_id)
GROUP BY ci.loyalty_tier
ORDER BY total_sales DESC;

/* 
2.1 Revenue by Product Category
Objective:
Analyze total revenue generated for each product category.
This helps identify the most profitable categories and overall revenue drivers.
*/


SELECT pi.category,
       SUM(sd.quantity) AS amount_of_items,
       SUM(sd.unit_price * sd.quantity) AS total_sales
FROM product_info pi
JOIN sales_data sd
	USING(product_id)
GROUP BY pi.category
ORDER BY total_sales DESC;


/* 
2.2 Top 5 Best-Selling Products
Objective:
Identify the five products with the highest sales volume or revenue.
These products represent key contributors to business success.
*/


SELECT pi.product_id,
	   pi.product_name,
       SUM(sd.quantity) AS amount_of_items,
       SUM(sd.unit_price * sd.quantity) AS total_sales
FROM product_info pi
JOIN sales_data sd
	USING(product_id)
GROUP BY pi.product_id,
	   pi.product_name
ORDER BY total_sales DESC
LIMIT 5;


/* 
2.3 Bottom 5 Least-Selling Products
Objective:
Identify the five products with the lowest sales performance.
This insight can support decisions related to product optimization,
pricing, or discontinuation.
*/


SELECT pi.product_id,
	   pi.product_name,
       SUM(sd.quantity) AS amount_of_items,
       SUM(sd.unit_price * sd.quantity) AS total_sales
FROM product_info pi
JOIN sales_data sd
	USING(product_id)
GROUP BY pi.product_id,
	   pi.product_name
ORDER BY total_sales
LIMIT 5;


/* 
2.4 Product with the Highest Number of Discounts Applied
Objective:
Determine which product has received discounts most frequently.
This helps assess promotional strategies and their impact on specific products.
2.5Average Discount per Product
Objective:
Calculate the average discount applied to each product.
This helps evaluate pricing strategies and promotional intensity.
2.6 Average Price per Product
Objective:
Calculate the average selling price for each product.
This metric provides insight into pricing behavior and revenue consistency.
*/

SELECT pi.product_id,
	   pi.product_name,
       pi.category,
       AVG(sd.unit_price) AS avg_price,
       AVG(sd.discount_applied) AS avg_discount
FROM product_info pi
JOIN sales_data sd
	USING (product_id)
GROUP BY pi.product_id,
	   pi.product_name,
       pi.category
ORDER BY AVG(sd.discount_applied) DESC
LIMIT 5;


/* 
2.7 Top 5 Highest-Value Customers
Objective:
Identify the five customers who generated the highest total revenue.
This analysis supports customer segmentation and retention strategies.
*/


SELECT ci.customer_id,
	   ci.loyalty_tier,
       SUM(sd.quantity * sd.unit_price) AS total_sales
FROM customer_info ci
JOIN sales_data sd
	 USING(customer_id)
GROUP BY ci.customer_id,
	     ci.loyalty_tier
ORDER BY SUM(sd.quantity * sd.unit_price) DESC
LIMIT 5;


/* 
2.8 Revenue by Customer Category
Objective:
Calculate total revenue for each customer category or segment.
This provides insight into the value of different customer groups.
*/


SELECT ci.loyalty_tier,
       SUM(sd.quantity * sd.unit_price) AS total_sales
FROM customer_info ci
JOIN sales_data sd
	 USING(customer_id)
GROUP BY ci.loyalty_tier
ORDER BY SUM(sd.quantity * sd.unit_price) DESC;



/* 
2.9 Average Time from Customer Registration to First Purchase
Objective:
Measure the average time elapsed between a customer's registration date
and their first completed transaction.
This metric reflects customer onboarding effectiveness and conversion speed.
*/


WITH first_purchase_per_customer AS (
    SELECT
        sd.customer_id,
        MIN(sd.order_date) AS first_purchase_date
    FROM sales_data sd
    WHERE sd.order_date IS NOT NULL
    GROUP BY sd.customer_id
)
SELECT
    AVG(
        DATEDIFF(
            fp.first_purchase_date,
            ci.signup_date
        )
    ) AS avg_days_to_first_purchase
FROM customer_info ci
JOIN first_purchase_per_customer fp
   USING(customer_id)
WHERE ci.signup_date IS NOT NULL;

