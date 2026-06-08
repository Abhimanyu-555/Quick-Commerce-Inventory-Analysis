drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR (120),
name VARCHAR (150) NOT NULL,
mrp NUMERIC (8,2),
discount NUMERIC (5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC (8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);




--data exploration

--count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE 
name IS NULL
OR
category IS NULL 
OR
mrp IS NULL
OR
discount IS NULL
OR
availableQuantity IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different produnt categories
SELECT DISTINCT category FROM zepto ORDER BY category;

--products in available in stock or out of stock 
SELECT outOfStock, COUNT (sku_id)
FROM zepto
GROUP BY outOfStock;

--product name present multiple times
SELECT name, COUNT (skU_ID) AS "NUMBER OF SKUs"
FROM zepto
GROUP BY name
HAVING count (sku_id) > 1
ORDER BY COUNT (sku_id) DESC;




--data cleaning

--product with price 0
SELECT * FROM zepto
WHERE
mrp = 0
OR
discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupee
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto


--TOP 10 BEST-VALUE PRODUCTS BASED ON THE DISCOUNT PERCENTAGE
SELECT DISTINCT name, mrp, discount FROM zepto
ORDER BY discount DESC
LIMIT 10;

--PRODUCTS WITH HIGH MRP AND OUT OF STOCK
SELECT DISTINCT name, mrp FROM zepto
WHERE outOfStock = TRUE and
mrp > 150
ORDER BY mrp DESC
LIMIT 10;


--ESTIMATE REVENUE OF EACH CATEGORY
SELECT category,
SUM(discountedSellingPrice*availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;


--PRODUCTS WITH MRP > 500 & DISCOUNT < 10%
SELECT DISTINCT name, mrp, discount FROM zepto
WHERE mrp > 500 and discount < 10
ORDER BY mrp DESC;

--TOP 5 CATOGORIES OFFERING HIGHEST AVERAGE DISCOUNT PERCENTAGE.
SELECT category,
ROUND(AVG(discount),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--FIND THE PROICE/GRAM FOR PRODUCTS ABOVE 100 GM AND SORT BY BEST VALUE
SELECT DISTINCT name, weightInGms, discountedSellingPrice, 
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gm
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gm;

--GROUP THE PRODUCTS INTO WEIGHT CATEGORIES
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
     WHEN weightInGms < 5000 THEN 'Medium'
     ELSE 'Bulk'
     END AS weight_category 
     FROM zepto;

--TOTAL INVENTORY WEIGHT/CATEGORY
SELECT category,
SUM(weightInGms * availableQuantity) AS category_weight_in_gms
FROM zepto
GROUP BY category
ORDER BY category_weight_in_gms;













