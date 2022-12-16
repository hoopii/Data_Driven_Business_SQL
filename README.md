# Data-Driven Businesses with SQL & Tableau
### Help an e-commerce company make a critical business decision by exploring data in SQL and visualizing it interactively in a Tableau dashboard.

![grafik](../main/picture_repository.png)
 
## Goal
Create user-based, item-based and model-based movie recommender systems as well as simple popularity rankings inspired by Netflix recommendations using a real life dataset of nearly 10.000 movies with more than 100.000 user ratings  

![grafik](../main/Screenshot-2022-01-28-101727.png)



## Dataset
- GroupLens, which gathered this data, is a research group in the Department of Computer Science and Engineering at the University of Minnesota. Since its inception in 1992, GroupLens's research projects have explored a variety of fields including:   
  - recommender systems  
  - online communities  
  -  mobile and ubiquitious technologies   
  -  digital libraries    
  -  local geographic information system   
- This and other GroupLens data sets are publicly available for download at http://grouplens.org/datasets/ 
- GroupLens Research operates a [movie recommender](http://movielens.org) based on collaborative filtering, MovieLens, which is the source of these data
- The dataset (ml-latest-small) describes 5-star rating and free-text tagging activity from [MovieLens](http://movielens.org), a movie recommendation service. 
-  It contains 100.836 ratings and 3683 tag applications across 9.742 movies.     
- These data were created by 610 users between March 29, 1996 and September 24, 2018. This dataset was generated on September 26, 2018.  
--> for more information on the dataset look at the [description file in the repository](../main/description_dataset.txt)  

## Skills/Methods
- Pivot-Tables in Python/Pandas
- Apply cosine_similarity function in Scikit-Learn
- Compute weighted averages
- Work with "surprise", a Python scikit for recommender systems. 
- Apply matrix factorization algorithms for model based recommenders
- Tune model with GridSearch and Cross-Validation
- Automate the process using Python functions

## Basic Steps 
Based on the example User-based Collaborative Filtering: 
1. Create a user-item matrix as data structure for further processing
2. Replace Missing Values
3. Compute Similarities between Users
4. Turn Similarities into Weights using the weighted average
5. Estimate missing Ratings
6. Create a function that takes the users userId, and a number (n) and outputs the n most recommended movies based on the cosine similarity of other users.
7. Evaluate the recommendation system

## Files in this repository
- [Description of the dataset](../main/description_dataset.txt)
- [Notebook with the code for all recommendation systems](../main/movies_recommender_systems.ipynb)
- [Data: Movies](../main/movies.csv)
- [Data: Ratings](../main/ratings.csv)
- [Data: Links](../main/links.csv)  
- [Data: Tags](../main/tags.csv)  
