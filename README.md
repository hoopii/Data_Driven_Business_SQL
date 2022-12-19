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
Main business questions the board of directors is searching an answer for in the data are: 
1. is the brazilian online marketplace "Magist" a good fit for high-end tech products, especially for Apple-compatible accessories? 
2. Are deliveries fast enough?

## Dataset
- The dataset is made available by [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)and has been provided by [Olist](https://olist.com/pt-br/), the largest department store in Brazilian marketplaces. 
- Olist connects small businesses from all over Brazil to channels without hassle and with a single contract. Those merchants are able to sell their products through the Olist Store and ship them directly to the customers using Olist logistics partners. See more on our website: www.olist.com
- The dataset has information of 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil. 
- Its features allows viewing an order from multiple dimensions: from order status, price, payment and freight performance to customer location, product attributes and finally reviews written by customers. We also released a geolocation dataset that relates Brazilian zip codes to lat/lng coordinates. 
- For more informataion like data Schema look at the [Kaggle-page](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) directly.
- Note: The files in this repository are named after "Magist" and not Olist, but the data is exactly the same. I used the data in the context of my Data Science Bootcamp at WBS Coding School, where they prepared a use case for us in which the brazilian eCommerce company has been named "Magist" instead of "Olist.


## Skills/Methods
- SQL Queries with MySQL (Workbench)

## Basic Steps for this project
1. Create the database out of the Database dump file by importing in MySQL Workbench



## Files in this repository
- [Description of the dataset](../main/description_dataset.txt)
- [Notebook with the code for all recommendation systems](../main/movies_recommender_systems.ipynb)
- [Data: Movies](../main/movies.csv)
- [Data: Ratings](../main/ratings.csv)
- [Data: Links](../main/links.csv)  
- [Data: Tags](../main/tags.csv)  
