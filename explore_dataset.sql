USE magist; 
-- Query 1 --
SELECT COUNT(*) FROM orders; 
# The dataset contains almost 100.000 orders 	

 -- Query 1.1  --
SELECT 
    *
FROM
    orders
ORDER BY order_purchase_timestamp DESC;  
#  ..in almost three years -- 

-- Query 2 -- 
SELECT 
    order_status, COUNT(order_status)
FROM
    orders
GROUP BY order_status;

-- Query 3 -- 
SELECT 
    COUNT(customer_id),
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_
FROM
    orders
GROUP BY year_ , month_
ORDER BY year_ , month_; 

# User growth from 1000 to more than 7.000 at the beginning of 2018, afterwards stagnating numbers at like 6.500  
# vielleicht noch Durchschnittswerte errechnen 
# unklar, warum die letzten Monate von 2018 so wenige orders 

-- Query 4 -- 
SELECT 
    COUNT(DISTINCT product_id) AS products_count
FROM
    products;
-- 32.951 products ---

-- Query 5 -- 
SELECT 
    product_category_name, COUNT(*)
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC; 

SELECT 
    product_category_name, COUNT(product_id)
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC; 

-- Ergebnis muss man wahrscheinlich noch übersetzen -- 

-- Query 6 -- 
SELECT * FROM order_items; 

SELECT 
    COUNT(DISTINCT product_id)
FROM
    order_items;
# all 32.951 products have been ordered

-- Query 7 -- 
SELECT 
    product_id, price
FROM
    order_items
ORDER BY price DESC; 
# the most expensive ones cost more than 6.000 (three products)

SELECT 
    product_id, price
FROM
    order_items
ORDER BY price ASC; 
# the cheapest cost less then one euro ore one euro --

-- other solution -- 
SELECT 
    MIN(price) AS cheapest, MAX(price) AS most_expensive
FROM
    order_items;

-- Query 8 
SELECT 
    MIN(payment_value), MAX(payment_value)
FROM
    order_payments; 
    
SELECT 
    payment_value
FROM
    order_payments
ORDER BY payment_value DESC; 
# highest payment value = 13.644, after that also many orders that contain more than 6.000 Euro 

