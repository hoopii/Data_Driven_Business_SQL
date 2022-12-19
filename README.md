# Data-Driven Businesses with SQL & Tableau
### Help an e-commerce company make a critical business decisions by exploring data in SQL and visualizing it interactively in a Tableau dashboard.

![grafik](../main/picture_repository.png)
 
## Ficticious Use Case
The eCommerce company  we are working for is exploring an expansion to the Brazilian market. The problem for the company we're doing analysis for is the lack of knowledge of such a market. The company doesn’t have ties with local providers, package delivery services, or customer service agencies. Creating these ties and knowing the market would take a lot of time, while the board of directors from "Eniac" (the company we do data analysis for) has demanded the expansion to happen within the next year.

Here comes Olist. Olist is a Brazilian Software as a Service company that offers a centralized order management system to connect small and medium-sized stores with the biggest Brazilian marketplaces. Olist is already a big player and allows small companies to benefit from its economies of scale: it has signed advantageous contracts with the marketplaces and with the Post Office, thus reducing the cost of fees and, most importantly, the bureaucracy involved to get things started.

But not everyone in the company is happy moving on with this. There are two main concerns:
- Eniac’s catalog is 100% tech products, and heavily based on Apple-compatible accessories. It is not clear that the marketplaces Olist works with are a good place for these high-end tech products.
- Among Eniac’s efforts to have happy customers, fast deliveries are key. The delivery fees resulting from Olist's deal with the public Post Office might be cheap, but at what cost? Are deliveries fast enough? 

Thankfully, Olist has allowed Eniac to access a snapshot of their database. The data might have the answer to these concerns.  

## Goal
**Main business questions the board of directors is expecting data based answers for:**   
1. Is the brazilian online marketplace "Magist" a good fit for high-end tech products, especially for Apple-compatible accessories? 
2. Are deliveries fast enough?

**More specific business questions coming from different members of the company are:**  

In relation to the products:
- Which categories of tech products does Magist have?
- How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?
- What’s the average price of the products being sold?
- Are expensive tech products popular?

In relation to the sellers:
- How many months of data are included in the magist database?
- How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
- What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
- Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?

In relation to the delivery time:
- What’s the average time between the order being placed and the product being delivered?
- How many orders are delivered on time vs orders delivered with a delay?
- Is there any pattern for delayed orders, e.g. big products being delayed more often?







## Dataset
- The dataset is made available by [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)and has been provided by [Olist](https://olist.com/pt-br/), the largest department store in Brazilian marketplaces. 
- Olist connects small businesses from all over Brazil to channels without hassle and with a single contract. Those merchants are able to sell their products through the Olist Store and ship them directly to the customers using Olist logistics partners. See more on our website: www.olist.com
- The dataset has information of 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil. 
- Its features allows viewing an order from multiple dimensions: from order status, price, payment and freight performance to customer location, product attributes and finally reviews written by customers. We also released a geolocation dataset that relates Brazilian zip codes to lat/lng coordinates. 
- For more informataion like data Schema look at the [Kaggle-page](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) directly.
- Note: The files in this repository are named after "Magist" and not Olist, but the data is exactly the same. I used the data in the context of my Data Science Bootcamp at WBS Coding School, where they prepared a use case for us in which the brazilian eCommerce company has been named "Magist" instead of "Olist.

## Database Schema

![grafik](../main/Schema.png)

## Basic description of tables and their relations:  

**Let’s focus first of all on some tables that are just collections of items, independent of any transaction.  
Unless a new customer makes a purchase, a new product is released, or a new seller is registered, these tables remain unchanged during a transaction:**
- products: contains a row for each product available for sale.
- product_category_name_translation: contains a relation of product categories in its original language, Portuguese, and English.
 - sellers: contains a row for each one of the sellers registered in the marketplace.
 - customers:  contains a row for each customer that has made a purchase.
 - geo: contains a relation between zip codes, coordinates, and states, to obtain more precise information about sellers and customers.
 
**The following tables are the ones responsible for capturing a purchase:**
- orders: every time that an order is placed, a row is inserted in this table. Even if the order contains multiple products, here it will be reflected as a single row with an order_id that uniquely identifies it.
- order_items: this table contains one row for each distinct product of an order.

The relationship between orders and order_items can be better understood with an example. Imagine a customer purchases a Macbook Pro, two dongles, and a keyboard. The following rows would be added to each table:
![grafik](https://user-images.githubusercontent.com/100354393/208524075-64983ff3-b529-490f-9886-3c0bffd09c42.png)
As we can see, the orders table contains only one row per order, in which information for the whole order like its status and delivery date is stored. But, as each order can contain multiple products, which can come from a different seller, have a different price, etc., the order_items table stores this information.

After an order is placed, a customer still needs to pay for it, then they can write a review. This information is stored in the corresponding tables:
- order_payments: customers can pay an order with different methods of payment. Every time a payment is made a row is inserted here. An order can be paid in installments, which means that a single order can have many separate payments.
- order_reviews: customers can leave multiple reviews corresponding to the order they placed.

## Skills/Methods
- SQL Queries with MySQL (Workbench):    
- JOIN multiple tables 
- translate business terms into tables, columns and aggregations.
- transpose business challenge into analytical questioning
- Visualisazions with Tableau

## Basic Steps for this project
1. Create the database out of the Database dump file by importing in MySQL Workbench
2. Explore the dataset and the relations of the tables:    
  - How many orders have been placed at the marketplace? 
  - What are the relations of delivered, cancelled and unavailable orders? 
  - Is the platform growing, are orders going up? 
  - How many prodcuts and which product category do they offer the most?
  - Which products have been ordered the most?
  - What's the price for the most expensive and cheapes products? 
  - What's the highest payment values for single orders? 
3. Answer specific business questions coming from different company members
4.

## Some results: 



## Files in this repository
- [Description of the dataset](../main/description_dataset.txt)
- [Notebook with the code for all recommendation systems](../main/movies_recommender_systems.ipynb)
- [Data: Movies](../main/movies.csv)
- [Data: Ratings](../main/ratings.csv)
- [Data: Links](../main/links.csv)  
- [Data: Tags](../main/tags.csv)  
