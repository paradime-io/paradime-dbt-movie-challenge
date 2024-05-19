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
- *imdb_ratings* (newly imported from imdb website)
- *rotten_tomatoes_ratings* (newly imported by using Kaggle dataset)
- *normalized_revenues_movies* (prepared by using Kaggle US inflation dataset and revenue_inflation_adjustment.py)

### Intermediate layer
- *int_movies_mapping* (int model bringing all movie sources together)
- *int_combined_movie_success* (int model to calculate combined success ratings)

### Mart layer
- *movie_success* (model for individual movie success ratings)
- *actor_director_success* (model for actor-director success ratings)

### Data Lineage
- Copy and paste your data lineage image here. Watch this [YouTube Tutorial](https://youtu.be/wQtIn-tnnbg?feature=shared&t=135) to learn how.

## Methodology
#### Tools Used
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™.
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing.
- **[Lightdash](https://www.lightdash.com/)** for data visualization.
- **Other tool(s) used** and why.


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
