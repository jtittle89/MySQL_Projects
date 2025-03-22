-- 1. View order_details
SELECT * FROM order_details;

-- 2. What is the date range of the table?
SELECT min(order_date) as min_date, max(order_date) as max_date
FROM order_details;

-- 3. How many orders are in the date range?
SELECT COUNT(distinct order_id) 
FROM order_details;

-- 4. How many items were ordered in the date range?
SELECT COUNT(*) FROM order_details;

-- 5. Which orders had the most items?
SELECT order_id, COUNT(item_id) as num_items
FROM order_details
GROUP BY order_id
ORDER BY num_items DESC;

-- 6. How many orders had more than 12 items?
SELECT COUNT(*)
FROM (SELECT order_id, COUNT(item_id) as num_items
FROM order_details
GROUP BY order_id
HAVING num_items > 12) As num_orders;
