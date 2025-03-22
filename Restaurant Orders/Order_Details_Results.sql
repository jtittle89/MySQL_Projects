-- 1. Combine tables
SELECT *
FROM order_details od LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id;

-- 2. Least and most ordered items and their categories.
SELECT item_id, category, COUNT(*) item_count
FROM order_details od LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY item_id, category
ORDER by item_count DESC;

-- 3. Top 5 orders that spent the most money.
SELECT order_id, SUM(price) as total_spend
FROM order_details od LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;

-- 4. View details of highest spent order.
SELECT *
FROM order_details od LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE order_id = 440
ORDER BY category;

-- 5. View details of top 5 highest orders.
SELECT *
FROM order_details od LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE order_id IN(440,2075,1957,330,2675);
