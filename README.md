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

### Getting to know the dataset
Here we present the overview of the values we have in the analysed dataset.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/overview.png?raw=true)

As mentioned before, we have various success indicators. We will start by identifying the top performers 
in these individual success catgeories.

#### 1. Top 10 movies by IMDB rating

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_imdbrating.png?raw=true)

We can see that although these movies have great IMDB ratings, they have very low
number of votes which indicates that their imdb rating is not as indicative.

#### 2. Top 10 movies by number of awards won

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_awards.png?raw=true)


#### 3. Top 10 movies by Inflation Corrected Revenue
Here we use inflation corrected revenue instead of raw revenue numbers to
get a fair comparison for movies released over the years.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_revenue.png?raw=true)

As it can be seen from the above data different movies are winning in different success categories.
We can't easily drive a conclusion of the best movies by looking at these success metrics seperatly.

### Ultimate Combined Movie Success
We will try to use all the success metrics and adjust them with weights to make a final conculsion on the 
best movies ever created. Refer to this section to see how the weights are adjusted.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_ultimate_combined.png?raw=true)

The Dark Knight is the best movie of all times according to our combined success metric!

We can dive deep into individual contributor success metrics for the top 10 list above to understand
why The Dark Knight wins. Below values are presented in their normalized form (0-10) for ease of visualization and 
comparison.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_indv_normalized.png?raw=true)

Looking at above, The Dark Knight wins because it has a very high IMDB rating of 9 but at the same time
it maintains very big numbers of IMDB Voters. These are 2 metrics that has the most effect in our combined success metric.

We can further look at the raw numbers for each movie in the top 10 list.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_deepdive.png?raw=true)

### Change in Movie Success
So far, we have identifed the most successfull movies. In this section we will look at the change in overall movie success
over the years to identify trends.

Below graph shows how combined movie success changes in the last 50 years together with the number of movies released
each year.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/change_in_movie_success.png?raw=true)

The number of movies grew after the end of 90s and reached a peak at 2019. The drop after this year is very likely related to COVID-19
as lots of operations throughout the world came to a halt.
If we look at movie success, we see a sharp drop at the end of 80s. We will dive deeper to investigate why this is happening.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/drop_in_success.png?raw=true)

As mentioned before IMDB Rating and IMDB Votes are very effective metrics for the combined succes. If we look at the above graph, we see
that IMDB rating stays much or less the same over the years but IMDB Votes significantly increases after 90s which in turn increases the significance imdb rating
inside the combined success metric. That is why the overall combined success metric drops. (Lower imdb ratings become more important)
The reason that IMDB Votes suddenly increase at the end of 80s is because 1990 is the year where IMDB began as a fan-operated movie database!


## Conclusions
Share a clear and concise conclusion of your findings!
