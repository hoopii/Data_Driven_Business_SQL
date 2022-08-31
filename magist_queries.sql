USE magist; 

-- Query 1 --
SELECT COUNT(*) FROM orders; 
-- almost like 96.000 orders --

 -- Query 1.1  --
SELECT * FROM orders
ORDER BY order_purchase_timestamp DESC;  
-- ..in almost three years -- 

-- Query 2 -- 
SELECT order_status, COUNT(order_status) FROM orders
GROUP BY order_status;
-- How many were delivered? -- 

-- Query 3 -- 
SELECT COUNT(customer_id), 
YEAR(order_purchase_timestamp) AS year_, 
MONTH(order_purchase_timestamp) AS month_
FROM orders
GROUP BY year_, month_
ORDER BY year_, month_; 

-- User growth from 1000 to more than 7.000 at the beginning of 2018, afterwards stagnating numbers at like 6.500 --- 
-- vielleicht noch Durchschnittswerte errechnen -- 
-- unklar, warum die letzten Monate von 2018 so wenige orders -- 


-- Query 4 -- 
SELECT DISTINCT(product_id), COUNT(product_id)
FROM products;
-- 32.951 Produkte? ---

-- Query 5 -- 
SELECT product_category_name, COUNT(*)
FROM products
GROUP by product_category_name
ORDER BY COUNT(product_id) DESC; 

SELECT product_category_name, COUNT(product_id)
FROM products
GROUP by product_category_name
ORDER BY COUNT(product_id) DESC; 

-- Ergebnis muss man wahrscheinlich noch übersetzen -- 

-- Query 6 -- 
SELECT * FROM order_items; 

SELECT COUNT(DISTINCT product_id)
FROM order_items;
-- alle 32.951 Produkte wurden auch gehandelt 

-- Query 7 -- 
SELECT product_id, price 
FROM order_items
ORDER BY price DESC; 
-- the most expensive ones cost more than 6.000 (three products)

SELECT product_id, price 
FROM order_items
ORDER BY price ASC; 
-- the cheapest cost less then one euro ore one euro --

-- andere Lösung: -- 
SELECT 
    MIN(price) AS cheapest, 
    MAX(price) AS most_expensive
FROM 
	order_items;

-- Query 8 
SELECT 
    MIN(payment_value), 
    MAX(payment_value) 
FROM 
	order_payments; 
    
SELECT payment_value FROM order_payments
ORDER BY payment_value DESC; 

-- Höchster Bestellwert=13.644, dann mehrere Bestellungen auch mit über 6.000 Euro --- 

-- BUSINESS QUESTIONS -- 
-- QUESTIONS ON PRODUCTS -- 
-- 1. What  categories of tech products does Magist have?
SELECT DISTINCT(products.product_category_name), transl.product_category_name_english
FROM products 
LEFT JOIN product_category_name_translation AS transl
ON products.product_category_name = transl.product_category_name; 

-- -- What categories of tech products does Magist have?
-- "audio", 
-- "electronics", 
-- "computers_accessories", 
-- "pc_gamer", 
-- "computers", 
-- "tablets_printing_image", 
-- "telephony";

-- 2. How many products of these tech categories have been sold (within the time window of the database snapshot)?
-- What percentage does that represent from the overall number of products sold?
SELECT product_category_name_english AS transl, 
COUNT(order_items.product_id)
FROM product_category_name_translation AS tabletransl
LEFT JOIN products ON tabletransl.product_category_name = products.product_category_name
LEFT JOIN  order_items
ON products.product_id = order_items.product_id
WHERE product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
GROUP BY product_category_name_english
ORDER BY COUNT(order_items.order_item_id) DESC;  

/* Antwort
computers_accessories	7827 
telephony	4545
electronics	2767
audio	364
computers	203
tablets_printing_image	83
pc_gamer	9 */

-- Are expensive products popular? [Maybe ergänzen noch den "Price"]
SELECT product_category_name_english AS transl, 
COUNT(order_items.order_item_id) / 99441 * 100 AS "%_of_all_orders",
COUNT(order_items.order_item_id) AS "number_of_orders", 
SUM(price),
AVG(price), 
SUM(price) / 1678594.5758354664 * 100 AS "%_of_all_tech_price_total", 
CASE
WHEN price > 1000 THEN 'Expensive'
WHEN price < 1000 AND price > 106 THEN "Mid-Range" 
ELSE "Cheap"
END AS "price_range" 
FROM product_category_name_translation AS tabletransl
LEFT JOIN products ON tabletransl.product_category_name = products.product_category_name
LEFT JOIN  order_items
ON products.product_id = order_items.product_id
WHERE product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
GROUP BY product_category_name_english, price_range
ORDER BY SUM(price) DESC;  

-- Answer for all tech products one group, other solutions: 
SELECT COUNT(order_items.order_item_id) / 99441 * 100 AS "%_of_all_orders",
COUNT(order_items.product_id) AS "number_of_orders", 
AVG(price), 
SUM(price),
CASE
WHEN product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony") 
THEN "tech_product"
ELSE "no tech_product"
END AS product_category
FROM product_category_name_translation AS tabletransl
LEFT JOIN products ON tabletransl.product_category_name = products.product_category_name
LEFT JOIN  order_items
ON products.product_id = order_items.product_id
WHERE product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
GROUP BY product_category
ORDER BY COUNT(order_items.order_item_id) DESC;  
--           %       number orders   AVG price     product_category
-- Answer: 15.8868	15798	106.2536128519728	tech_product

SELECT ROUND(AVG(price), 2)
FROM order_items; 

-- QUESTIONS ON SELLERS 

-- How many months of data are included in the magist database?
SELECT TIMESTAMPDIFF (MONTH, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) + 1
 FROM orders; 
/*Antwort: 
26
*/

-- How many sellers are there? 
SELECT COUNT(DISTINCT seller_id) FROM sellers; 
-- Antwort: 3095
-- How many Tech sellers are there? 
SELECT COUNT(DISTINCT sellers.seller_id) AS "Tech_Sellers", COUNT(DISTINCT sellers.seller_id) / 3085 *100 AS percentage_of_overall_sellers
FROM sellers
LEFT JOIN order_items
ON sellers.seller_id = order_items.seller_id
LEFT JOIN products
ON order_items.product_id = products.product_id
LEFT JOIN product_category_name_translation AS transl
ON products.product_category_name = transl.product_category_name
WHERE transl.product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony"); 
-- Answer: 	Tech_Sellers	percentage_of_overall_sellers
--              454	               14.7164

-- Total amount earned by all sellers? Total amount earned by all tech sellers? 
SELECT SUM(order_items.price), 
CASE
WHEN product_category_name_translation.product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony") 
THEN "tech_product"
ELSE "no tech_product"
END AS product_category
FROM sellers
LEFT JOIN 
order_items
ON sellers.seller_id = order_items.seller_id
LEFT JOIN 
products
ON order_items.product_id = products.product_id
LEFT JOIN
product_category_name_translation
ON products.product_category_name = product_category_name_translation.product_category_name
LEFT JOIN orders
ON order_items.order_id = orders.order_id
WHERE orders.order_status NOT IN ('unavailable', 'canceled')
GROUP BY product_category; 

-- Average monthly income of all sellers? Average monthly income of tech sellers? 
SELECT SUM(order_items.price) / 454 / 26,
CASE
WHEN product_category_name_translation.product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony") 
THEN "tech_product"
ELSE "no tech_product"
END AS product_category
FROM sellers
LEFT JOIN 
order_items
ON sellers.seller_id = order_items.seller_id
LEFT JOIN 
products
ON order_items.product_id = products.product_id
LEFT JOIN
product_category_name_translation
ON products.product_category_name = product_category_name_translation.product_category_name
LEFT JOIN 
orders
ON order_items.order_id = orders.order_id
WHERE orders.order_status NOT IN ('unavailable', 'canceled')
GROUP BY product_category; 
-- Answer: 
-- 1042.1312296019883	no tech_product
-- 146.80275646589925	tech_product --> does this mean, there are mainly like very small selling partners, private persons?
-- --> Tech sellers earn less


-- --> LOOK at Min / MAX, get the distribution: Group by seller_id
	SELECT SUM(order_items.price)
	FROM sellers
	LEFT JOIN 
	order_items
	ON sellers.seller_id = order_items.seller_id
	LEFT JOIN 
	products
	ON order_items.product_id = products.product_id
	LEFT JOIN
	product_category_name_translation
	ON products.product_category_name = product_category_name_translation.product_category_name
	LEFT JOIN 
	orders
	ON order_items.order_id = orders.order_id
	WHERE product_category_name_translation.product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
	GROUP BY sellers.seller_id
	ORDER BY SUM(order_items.price) DESC; 


-- QUESTIONS ON DELIVERY TIME
SELECT * FROM orders; 

-- What’s the average time between the order being placed and the product being delivered?
-- [Vielleicht weil hier die geshippten mit drin sind]
SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) 
FROM orders;
-- 12.5035


-- What’s the average time between the order being placed and the product being delivered?
-- [Vielleicht weil hier die geshippten mit drin sind]
SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 
FROM orders
WHERE product_category_name_translation.product_category_name_english IN 
("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony"); 
-- 12.5035

-- AVG time delivery tech products by price range and volume
SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 
CASE
		WHEN price > 1000 THEN 'Expensive'
		WHEN price < 1000 AND price > 106 THEN "Mid-Range" 
		ELSE "Cheap"
	END AS "price_range",
AVG(product_weight_g*product_length_cm*product_width_cm) AS volume_avg,
SUM(product_weight_g*product_length_cm*product_width_cm) AS volume_sum,
MAX(product_weight_g*product_length_cm*product_width_cm) AS volume_max
FROM orders
LEFT JOIN order_items
ON orders.order_id = order_items.order_id
LEFT JOIN products
ON order_items.product_id = products.product_id
LEFT JOIN product_category_name_translation
ON products.product_category_name = product_category_name_translation.product_category_name
WHERE product_category_name_translation.product_category_name_english IN 
("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
GROUP BY price_range; 


-- other solution
SELECT AVG(TIMESTAMPDIFF(day, order_purchase_timestamp, order_delivered_customer_date))
FROM orders;

-- How many orders are delivered on time vs orders delivered with a delay?
SELECT COUNT(order_id), 6665/89805*100 AS '% of delayed',
CASE
WHEN DATE(order_estimated_delivery_date) < DATE(order_delivered_customer_date) THEN "delivery delayed"
WHEN DATE(order_estimated_delivery_date) >= DATE(order_delivered_customer_date) THEN "delivered on time"
ELSE "unknown"
END AS "Delivery"
FROM orders
WHERE order_status = 'delivered'
GROUP BY Delivery; 
-- Answer: 
-- 89805	delivered on time
-- 6665	delivery delayed
-- 8	unknown

SELECT COUNT(order_id), 6665/89805*100 AS '% of delayed',
CASE
WHEN DATE(order_estimated_delivery_date) < DATE(order_delivered_customer_date) THEN "delivery delayed"
WHEN DATE(order_estimated_delivery_date) >= DATE(order_delivered_customer_date) THEN "delivered on time"
ELSE "unknown"
END AS "Delivery"
FROM orders
WHERE order_status = 'delivered' AND product_category_name_translation.product_category_name_english IN 
("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
GROUP BY Delivery; 
-- Answer: 
-- 89805	delivered on time
-- 6665	delivery delayed
-- 8	unknown

SELECT AVG(DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date)),
CASE
WHEN order_estimated_delivery_date < order_delivered_customer_date THEN "deliverd delayed"
ELSE "delivered on time"
END AS "Delivery"
FROM orders
GROUP BY Delivery; 

--  Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT
	CASE 
		WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 100 THEN "> 100 days delay"
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) >=7  AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) <= 100 THEN "more than one week to two weeks delay"
		WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 3 AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) < 7  THEN "3-7 day delay"
		WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 1  AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) <=3 THEN "1 - 3 days delay"
		ELSE "<= 1 day delay"
	END AS "delay_range", 
AVG(price), 
AVG(product_weight_g) AS weight_avg,
MAX(product_weight_g) AS max_weight,
MIN(product_weight_g) AS min_weight,
SUM(product_weight_g) AS sum_weight,
AVG(product_weight_g*product_length_cm*product_width_cm) AS volume_avg,
SUM(product_weight_g*product_length_cm*product_width_cm) AS volume_sum,
MAX(product_weight_g*product_length_cm*product_width_cm) AS volume_max,
COUNT(*) AS product_count 
FROM orders a
LEFT JOIN order_items b
	ON a.order_id = b.order_id
LEFT JOIN products c
	ON b.product_id = c.product_id
LEFT JOIN product_category_name_translation
	ON c.product_category_name = product_category_name_translation.product_category_name
WHERE DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 0
AND product_category_name_translation.product_category_name_english IN 
("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
GROUP BY delay_range
ORDER BY weight_avg DESC;
-- not really a pattern discernible


--  Is there any pattern for tech products orders by price and weight
SELECT
    CASE
		WHEN price > 1000 THEN 'Expensive'
		WHEN price < 1000 AND price > 106 THEN "Mid-Range" 
		ELSE "Cheap"
	END AS "price_range", 
AVG(product_weight_g) AS weight_avg,
MAX(product_weight_g) AS max_weight,
MIN(product_weight_g) AS min_weight,
SUM(product_weight_g) AS sum_weight,
AVG(product_weight_g*product_length_cm*product_width_cm) AS volume_avg,
SUM(product_weight_g*product_length_cm*product_width_cm) AS volume_sum,
MAX(product_weight_g*product_length_cm*product_width_cm) AS volume_max,
COUNT(*) AS product_count 
FROM orders a
LEFT JOIN order_items b
	ON a.order_id = b.order_id
LEFT JOIN products c
	ON b.product_id = c.product_id
LEFT JOIN product_category_name_translation d
	ON c.product_category_name = d.product_category_name
WHERE DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 0  AND d.product_category_name_english IN 
("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
GROUP BY price_range
ORDER BY weight_avg DESC;


-- AVG Delay by price_range for tech products: 
SELECT AVG(DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date)) AS "average delivery time", 
	CASE
		WHEN price > 1000 THEN 'Expensive'
		WHEN price < 1000 AND price > 106 THEN "Mid-Range" 
		ELSE "Cheap"
	END AS "price_range", 
COUNT(*)
FROM orders a
LEFT JOIN order_items b
	ON a.order_id = b.order_id
LEFT JOIN products c
	ON b.product_id = c.product_id
LEFT JOIN product_category_name_translation d
	ON c.product_category_name = d.product_category_name
WHERE d.product_category_name_english IN 
("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
GROUP BY price_range;





/*  ----------------------------------------------------------------------------------------------------------------------------------------------
Some notes on how to structure the date: 
First slide on some description of the dataset


/* How to make a new column: 
SELECT *, TIMEDIFF(order_purchase_timestamp, order_delivered_customer_date) AS time_difference
FROM orders;