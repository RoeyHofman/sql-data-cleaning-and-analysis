CREATE DATABASE shopping_behavior;

USE shopping_behavior;

SELECT *
FROM shopping_behavior_table;

SELECT *
FROM shopping_behavior_table
WHERE `Customer ID` IS NULL;

SELECT Category,
	    SUM(`Purchase Amount (USD)`) AS total_sales
FROM shopping_behavior_table
GROUP BY Category
ORDER BY total_sales DESC;

SELECT Location,
	   Category,
        SUM(`Purchase Amount (USD)`) AS total_sales
FROM shopping_behavior_table
WHERE Category = "clothing"
GROUP BY  Location,
	      Category
ORDER BY total_sales DESC
LIMIT 5;

SELECT Location,
	   Category,
        SUM(`Purchase Amount (USD)`) AS total_sales
FROM shopping_behavior_table
WHERE Category = "clothing"
GROUP BY  Location,
	      Category
ORDER BY total_sales 
LIMIT 5;

SELECT `Payment Method`,
        SUM(`Purchase Amount (USD)`) AS total_sales
FROM shopping_behavior_table
GROUP BY  `Payment Method`
ORDER BY total_sales DESC
LIMIT 5;

SELECT `Payment Method`,
        SUM(`Purchase Amount (USD)`) AS total_sales,
        COUNT(`Customer ID`) AS amount_of_customers
FROM shopping_behavior_table
GROUP BY  `Payment Method`
ORDER BY total_sales DESC
LIMIT 5;

SELECT `Payment Method`,
        SUM(`Purchase Amount (USD)`) AS total_sales,
        COUNT(`Customer ID`) AS amount_of_customers
FROM shopping_behavior_table
GROUP BY  `Payment Method`
ORDER BY total_sales DESC
LIMIT 5;

SELECT `Payment Method`,
		`Promo Code Used`,
        COUNT(`Promo Code Used`) AS amount_of_discount,
        SUM(`Purchase Amount (USD)`) AS total_sales,
        COUNT(`Customer ID`) AS amount_of_customers
FROM shopping_behavior_table
GROUP BY  `Payment Method`,
		`Promo Code Used`
ORDER BY total_sales DESC
