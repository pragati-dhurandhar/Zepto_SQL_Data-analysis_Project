create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

--data exploration

--count of rows
select count(*) from zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT CASE WHEN outOfStock = true THEN 'Out of Stock' ELSE 'In Stock' END AS status,
COUNT(*) AS total_products
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

--Q9 Calculate the potential revenue lost from products that are currently out of stock
SELECT 
    category, 
    SUM(mrp * quantity) AS potential_revenue_loss
FROM zepto
WHERE outOfStock = true
GROUP BY category
ORDER BY potential_revenue_loss DESC;

--Q10 Identify products that have a high weight (over 500g) but are priced under ₹100, showing the best "bulk" value for customers.
SELECT name, mrp, weightInGms, category
FROM zepto
WHERE weightInGms > 500 AND mrp < 100
ORDER BY weightInGms DESC;

--Q11 Find categories where more than 20% of the products are currently out of stock.
SELECT 
    category, 
    COUNT(*) AS total_products,
    SUM(CASE WHEN outOfStock = true THEN 1 ELSE 0 END) AS out_of_stock_count,
    ROUND(SUM(CASE WHEN outOfStock = true THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100, 2) AS oos_percentage
FROM zepto
GROUP BY category
HAVING (SUM(CASE WHEN outOfStock = true THEN 1 ELSE 0 END)::numeric / COUNT(*) * 100) > 20;

--Q12 List the top 3 products with the highest absolute discount (MRP minus Selling Price) in each category.
SELECT name, category, (mrp - discountedSellingPrice) AS absolute_discount
FROM (
    SELECT name, category, mrp, discountedSellingPrice,
           RANK() OVER(PARTITION BY category ORDER BY (mrp - discountedSellingPrice) DESC) as rnk
    FROM zepto
) t
WHERE rnk <= 3;

--Q13 Compare the average discount percentage for products priced above ₹500 versus those priced below ₹500.
SELECT 
    CASE WHEN mrp > 500 THEN 'Premium (>500)' ELSE 'Budget (<=500)' END AS price_segment,
    ROUND(AVG(discountPercent), 2) AS avg_discount_percent
FROM zepto
GROUP BY 1;

--Q14 Find products where the discount math is incorrect or the price is bugged
SELECT 
    name, 
    mrp, 
    discountedSellingPrice, 
    discountPercent,
    ROUND((1 - (discountedSellingPrice / NULLIF(mrp, 0))) * 100, 2) AS calculated_discount
FROM zepto
WHERE discountedSellingPrice > mrp 
   OR ABS(discountPercent - (1 - (discountedSellingPrice / NULLIF(mrp, 0))) * 100) > 1;

--Q15 Identify products with less than 10 units remaining that are still "In Stock"
SELECT 
    name, 
    category, 
    availableQuantity,
    mrp
FROM zepto
WHERE availableQuantity < 10 
  AND outOfStock = false
ORDER BY availableQuantity ASC;

