drop table if exists zepto:

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(120),
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--Count of rows

select COUNT(*) from zepto

--Sample data

select * from zepto LIMIT 10

--Null Values

select * from zepto
where name IS NULL

--Different Product Category

select DISTINCT category
from zepto
order by category;

--Product in stock vs out of stock

select outOfStock, COUNT(sku_id)
from zepto
group by outOfStock

--Product names present multiple times

select name, COUNT(sku_id) as "Number of SKUs"
from zepto
group by name
having COUNT(sku_id) >1
ORDER BY COUNT(sku_id) desc

--Data Cleaning

--product with price = 0

select * from zepto
where mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
where mrp = 0;

--Convert paise to rupees

UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp, discountedSellingPrice from zepto;

--Bussiness Problems

-- Q1. Find the top 10 best-value products based on the discount percentage.

select DISTINCT name, mrp, discountPercent
from zepto
order by discountPercent desc
LIMIT 10;

--Q2.What are the Products with High MRP but Out of Stock

select DISTINCT name, mrp
from zepto
where outOfStock = TRUE AND mrp > 300
order by mrp desc;


--Q3.Calculate Estimated Revenue for each category

select category, SUM(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue

-- Q4. Find all products where MRP is greater than â‚¹500 and discount is less than 10%.

select DISTINCT name, mrp, discountPercent
from zepto
where mrp > 500 AND discountPercent <10
order by mrp desc, discountPercent desc

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

select category, ROUND(AVG(discountPercent),2) as avg_discount
from zepto
group by category
order by AVG(discountPercent) desc
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.

select DISTINCT name, weightInGms, discountedSellingPrice, ROUND((discountedSellingPrice/weightInGms),2) as price_per_grm
from zepto
where weightInGms >=100
order by price_per_grm;

--Q7.Group the products into categories like Low, Medium, Bulk.

select DISTINCT name, weightInGms,
CASE
    WHEN weightInGms <1000 THEN 'Low'
    WHEN weightInGms <5000 THEN 'Medium'
	ELSE 'Bulk'
    END as weight_category
from zepto

--Q8.What is the Total Inventory Weight Per Category 

select category,
SUM(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight;
























