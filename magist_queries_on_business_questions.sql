/*****
In relation to the products:
*****/

-- What categories of tech products does Magist have?
-- "audio", 
-- "electronics", 
-- "computers_accessories", 
-- "pc_gamer", 
-- "computers", 
-- "tablets_printing_image", 
-- "telephony";

-- How many products of these tech categories have been sold (within the time window of the database snapshot)? 
SELECT COUNT(DISTINCT(oi.product_id)) AS tech_products_sold
FROM order_items oi
LEFT JOIN products p 
	USING (product_id)
LEFT JOIN product_category_name_translation pt
	USING (product_category_name)
WHERE product_category_name_english = "audio"
OR product_category_name_english =  "electronics"
OR product_category_name_english =  "computers_accessories"
OR product_category_name_english =  "pc_gamer"
OR product_category_name_english =  "computers"
OR product_category_name_english =  "tablets_printing_image"
OR product_category_name_english =  "telephony";
	-- 3390

-- What percentage does that represent from the overall number of products sold?
SELECT COUNT(DISTINCT(product_id)) AS products_sold
FROM order_items;
	-- 32951
    
SELECT 3390 / 32951; -- This step can also be done on a calculator
	-- 0.1029, therefore 10%

-- What’s the average price of the products being sold?
SELECT ROUND(AVG(price), 2)
FROM order_items;
	-- 120.65

-- Are expensive tech products popular? *
-- * TIP: Look at the function CASE WHEN to accomplish this task.
SELECT COUNT(oi.product_id), 
	CASE 
		WHEN price > 1000 THEN "Expensive"
		WHEN price > 100 THEN "Mid-range"
		ELSE "Cheap"
	END AS "price_range"
FROM order_items oi
LEFT JOIN products p
	ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation pt
	USING (product_category_name)
WHERE pt.product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony")
GROUP BY price_range
ORDER BY 1 DESC;
	-- 11361 cheap
    -- 4263 mid-range
    -- 174 expensive

/*****
In relation to the sellers:
*****/

-- How many months of data are included in the magist database?
SELECT 
    TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp))
FROM
    orders;
	-- 25 months
    
-- How many sellers are there?
SELECT 
    COUNT(DISTINCT seller_id)
FROM
    sellers;
	-- 3095
    
-- How many Tech sellers are there? 
SELECT 
    COUNT(DISTINCT seller_id)
FROM
    sellers
        LEFT JOIN
    order_items USING (seller_id)
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation pt USING (product_category_name)
WHERE
    pt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony');
	-- 454

-- What percentage of overall sellers are Tech sellers?
SELECT (454 / 3095) * 100;
	-- 14.67%
    
 -- What is the total amount earned by all sellers?
	-- we use price from order_items and not payment_value from order_payments as an order may contain tech and non tech product. With payment_value we can't distinguish between items in an order
SELECT 
    SUM(oi.price) AS total
FROM
    order_items oi
        LEFT JOIN
    orders o USING (order_id)
WHERE
    o.order_status NOT IN ('unavailable' , 'canceled');
    -- 13494400.74
    
-- the average monthly income of all sellers?
SELECT 13494400.74/ 3095 / 25;
	-- 174.40

-- What is the total amount earned by all Tech sellers?
SELECT 
    SUM(oi.price) AS total
FROM
    order_items oi
        LEFT JOIN
    orders o USING (order_id)
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation pt USING (product_category_name)
WHERE
    o.order_status NOT IN ('unavailable' , 'canceled')
        AND pt.product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'pc_gamer',
        'computers',
        'tablets_printing_image',
        'telephony');
	-- 1666211.28
    
-- the average monthly income of Tech sellers?
SELECT 1666211.28 / 454 / 25;
	-- 146.80

/*****
In relation to the delivery time:
*****/

-- What’s the average time between the order being placed and the product being delivered?
SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp))
FROM orders;
	-- 12.5035

-- How many orders are delivered on time vs orders delivered with a delay?
SELECT 
	CASE 
		WHEN DATE(order_delivered_customer_date) <= DATE(order_estimated_delivery_date) THEN 'On time'
		ELSE 'Delayed'
    END AS delivery_status, 
COUNT(order_id) AS orders_count
FROM orders
WHERE order_status = 'delivered'
GROUP BY delivery_status;
	-- on time 89805
    -- delayed 6673

-- Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT
	CASE 
		WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 100 THEN "> 100 day Delay"
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) >= 8 AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) < 100 THEN "1 week to 100 day delay"
		WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 3 AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) < 8 THEN "3-7 day delay"
		WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 1 THEN "1 - 3 days delay"
		ELSE "<= 1 day delay"
	END AS "delay_range", 
AVG(product_weight_g) AS weight_avg,
MAX(product_weight_g) AS max_weight,	
MIN(product_weight_g) AS min_weight,
SUM(product_weight_g) AS sum_weight,
COUNT(*) AS product_count 
FROM orders a
LEFT JOIN order_items b
	ON a.order_id = b.order_id
LEFT JOIN products c
	ON b.product_id = c.product_id
WHERE DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 0
GROUP BY delay_range
ORDER BY weight_avg DESC;