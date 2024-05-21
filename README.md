# dbt™ Data Modeling Challenge - Movie Edition
Project for the dbt™ data modeling challenge - Movie Edition, Hosted by Paradime!

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources-and-data-lineage)
3. [Methodology](#methodology)
   - [Tools Used](#tools-used)
   - [Applied Techniques](#applied-techniques)
   - [Data Sources and Data Lineage](#data-sources-and-data-lineage)
4. [Visualizations](#visualizations)
   - [Vizualization #1](vizualization-1)
   - [Vizualization #2](Vizualization-2)
   - [Vizualization #3](Vizualization-3)
   - etc
5. [Conclusions](#conclusions)

## Introduction
This project explores insights related to movies and specifically focuses on movie success and visualises them in Lightdash.

## Data Sources and Data Lineage
My analysis leverage below data sets:
### Sources and Seeds
- *tmdb_movies* (already provided)
- *omdb_movies* (already provided)

New Datasets:
- *imdb_ratings* (newly imported from imdb website)
- *rotten_tomatoes_ratings* (newly imported by using Kaggle dataset)
- *normalized_revenues_movies* (prepared by using Kaggle US inflation dataset and revenue_inflation_adjustment.py)

### Intermediate layer
- *int_movies_mapping* (int model bringing all movie sources together)
- *int_combined_movie_success* (int model to calculate combined success ratings)

### Mart layer
- *movie_success* (model for individual movie success ratings)
- *actor_director_success* (model for actor-director success ratings)

### Other models
- *revenue_inflation_adjustment.py*: This python script takes the raw revenue data from omdb_movies and normalizes 
the revenue numbers by using the US inflation rates over the years.
- *calculate_combined_success.sql*: This macro calculates the ultmate combined movie success rating
based on the other success ratings and their given weights
- *generate_unique_key*: This macro creates a unique key for given fields.
- *.sqlfluff*: This file makes sure that all the models are up to good formatting standards accroding to extensive set of rules defined.

### Data Lineage
- Copy and paste your data lineage image here. Watch this [YouTube Tutorial](https://youtu.be/wQtIn-tnnbg?feature=shared&t=135) to learn how.

## Methodology
### Tools Used
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™.
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing.
- **[Lightdash](https://www.lightdash.com/)** for data visualization.
- **Python scripts** for calculations and read/write to database.
- **dbt Tests** for maintaining data accuracy.
- **dbt MD** for removing redundant yml descriptions.

### Data Preparation and Cleaning
After investigating the given data sources, it is quickly relaized that data accuracy and 
quality is not great. Some of the columns have great percentage of null values and some have wrong data 
(eg. *Adolf Hitler* seems to be a main actor in a movie :)
Below steps are followed to mitigate these:
- Select distinct to ensure that there are not duplicate rows in stg models.
- Tests for uniqueness on the imdb_id (this is the join key for all sources) to make sure that each movie appears only once.
- Removing all rows that doesn't have imdb_id.
- Coalescing values from different sources to ensure completness. (eg. imdb_rating from imdb and omdb)

### Calculating Movie Success
Movie success is the centre metric for all insights in this project. That is why creating a robust ultimate success indicator
is one of the key aspects of modelling as well.

There are various metrics that could indicate the success of a movie. Below is the list of
metrics that we have in the source data (inc. new datasets):
- Revenue
- Imdb rating, together with number of votes.
- Viewer vote average, together with number of votes.
- Number of awards won
- Tomato meter
- Rotten tomatoe audience score

Since these metrics are all showing different aspects of success, we will create an ultimate
success metric that will combine all of them according to their subjective importance.

1. we combine available rotten tomato metrics together to just have a single average
rotten tomatoe rating for each movie.

2. we use the US inflation data so that revenues are not biased by yearly inflations and can 
be comparable to each other in fair way.

3. we normalize each of the feature to be a value between 0-10 so that 
they are comparable between each other.

4. we assign weights to each feature to create the ultimate success metric.

Weights assigned are:
- imdb_rating = 1
- imdb_votes = 0.8
- combined_rotten_tomato_rating = 0.5
- number_of_awards_won = 0.3
- viewer_vote_average = 0.8
- viewer_vote_count = 0.5
- revenue = 0.4


## Visualizations

### vizualization 1
- #### Visualizations title
- #### Intro sentence to vizualization
- #### Image of vizualization
- #### Insights

### vizualization 2
- #### Visualizations title
- #### Intro sentence to vizualization
- #### Image of vizualization
- #### Insights

### vizualization 3
- #### Visualizations title
- #### Intro sentence to vizualization
- #### Image of vizualization
- #### Insights

## Conclusions
Share a clear and concise conclusion of your findings!
