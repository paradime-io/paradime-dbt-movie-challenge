# **dbt™ Data Modeling Challenge - Movie Edition**
Project for the dbt™ data modeling challenge - Movie Edition, Hosted by Paradime!

*Prepared by **✋ [Işın Pesch](https://www.linkedin.com/in/isin-pesch-32b489163/)***

## **Table of Contents**
1. [Introduction](#introduction)
2. [Data Sources and Data Lineage](#data-sources-and-data-lineage)
   - [Sources and Seeds](#sources-and-seeds)
   - [Intermediate Layer](#intermediate-layer)
   - [Mart Layer](#mart-layer)
   - [Other Layers](#other-layers)
   - [Data Lineage](#data-lineage)
3. [Methodology](#methodology)
   - [Tools Used](#tools-used)
   - [Data Preparation and Cleaning](#data-preparation-and-cleaning)
   - [Calculating Movie Success](#calculating-movie-success)

4. [Visualizations](#visualizations)
   - [Getting to Know the Dataset](#getting-to-know-the-dataset)
   - [Ultimate Combined Movie Success](#getting-to-know-the-dataset)
   - [Change in Movie Success](#change-in-movie-success)
   - [Most Popular Months for Movie Releases](#most-popular-months-for-movie-releases)

5. [Conclusions](#conclusions)

## **Introduction**
This project explores insights related to movies and specifically focuses on movie success and visualises them in Lightdash.

# **Data Sources and Data Lineage 🕸️**
My analysis leverages the below data sets:
### **Sources and Seeds**
- *`tmdb_movies`* (already provided)
- *`omdb_movies`* (already provided)

New Datasets:
- *`imdb_ratings`* (newly imported from the imdb website)
- *`rotten_tomatoes_rating`s* (newly imported Kaggle dataset)
- *`normalized_revenues_movies`* (based on a newly imported Kaggle dataset `us_inflation_rates.csv` for US inflation and prepared by `revenue_inflation_adjustment.py`)

### **Intermediate Layer**
- *`int_movies_mapping`* (int model bringing all movie sources together)
- *`int_combined_movie_success`* (int model to calculate combined success ratings)

### **Mart Layer**
- *`movie_success`* (model for individual movie success ratings)
- *`actor_director_success`* (model for actor-director success ratings)

### **Other Models**
- *`revenue_inflation_adjustment.py`*: This python script takes the raw revenue data from omdb_movies and normalizes 
the revenue numbers by using the US inflation rates over the years and creates a table in snowflake to `write` the results.
- *`calculate_combined_success.sql`*: This macro calculates the ultimate combined movie success rating
based on the other success ratings and their given weights.
- *`generate_unique_key`*: This macro creates a unique key for given fields.
- *`.sqlfluff`*: This file makes sure that all the models are up to good formatting standards accroding to extensive set of rules defined.

### **Data Lineage**
![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/lineage.png?raw=true)

# **Methodology 🧪**
### **Tools Used**
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™.
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing.
- **[Lightdash](https://www.lightdash.com/)** for data visualization.
- **Python scripts** for calculations and reads/writes to database.
- **dbt Tests** for maintaining data accuracy.
- **dbt MD** for removing redundant yml descriptions.

### **Data Preparation and Cleaning 🧼**
After investigating the given data sources, I quickly relaized that the data accuracy and 
quality is not great. Some of the columns have great percentage of null values and some have wrong data 
(eg. *Adolf Hitler* seems to be a main actor in a movie 😄).

The below steps are followed to mitigate these:
- `select distinct` to ensure that there are not duplicate rows in `stg` models (there are many entries of the same movie).
- Tests for uniqueness on the `imdb_id` (this is the join key for all sources) to make sure that each movie appears only once.
- Removing all rows that doesn't have `imdb_id`.
- Coalescing values from different sources to ensure completness (eg. `imdb_rating` from `imdb` and `omdb`)

### **Calculating Movie Success 🏅**
Movie success is the central metric for all insights in this project. That is why creating a robust ultimate success indicator
is one of the key aspects of the modelling as well.

There are various metrics that could indicate the success of a movie. Below is the list of
metrics that we have in the source data (inc. new datasets):
- Revenue
- Imdb rating, together with number of votes
- Viewer vote average, together with number of votes
- Number of awards won
- Tomato meter
- Rotten tomato audience score

Since these metrics are all showing different aspects of success, we will create an ultimate
success metric that will combine all of them according to their subjective importance.

1. We combine available rotten tomato metrics together to just have a single average
rotten tomato rating for each movie.

2. We use the US inflation data so that revenues are not biased by yearly inflations and can 
be comparable to each other in fair way.

3. We normalize each of the feature to be a value between 0-10 so that 
they are comparable to each other.

4. We assign weights to each feature to create the ultimate success metric.

Weights assigned are:
- `imdb_rating = 1`
- `imdb_votes = 0.8`
- `combined_rotten_tomato_rating = 0.5`
- `number_of_awards_won = 0.3`
- `viewer_vote_average = 0.8`
- `viewer_vote_count = 0.5`
- `revenue = 0.4`

Above weights are assigned according to the subjective importance of each metric. IMDB and viewer votes are
populated for most of the data and a very well accepted and popular success indicator, that is why they have higher weights.
The combined rotten tomato rating is a good indicator as well and in fact most of the time could be more stricter than IMDB but we
don't have good data coverage for this one. Hence, the lower weight.
There are a lot of nulls for revenue in the dataset so the weight of this one is kept low.


# **Visualizations 📊**

### **Getting to know the dataset 🔎**
Here we present the overview of the values we have in the analysed dataset.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/overview.png?raw=true)

As mentioned before, we have various success indicators. We will start by identifying the top performers 
in these individual success catgeories.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_imdbrating.png?raw=True)

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_awards.png?raw=True)

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_revenue.png?raw=True)

As it can be seen from the above data different movies are winning in different success categories.
We can't easily drive a conclusion for the best movies by just looking at these success metrics separately.

### **Ultimate Combined Movie Success 🥇**
We will try to use all the success metrics and adjust them with weights to make a final conculsion on the 
best movies ever created. Refer to [this](#calculating-movie-success) section to see how weights are adjusted.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_ultimate_combined.png?raw=True)

We can dive deep into individual contributor success metrics for the top 10 list above to understand
why `The Dark Knight` wins. 

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_indiv_metrics.png?raw=true)


We can further look at the raw numbers for each movie in the top 10 list.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_deepdive.png?raw=True)

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_cmb_roi.png?raw=True)

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_roi.png?raw=True)

### **Change in Movie Success ⏳**
So far, we have identifed the most successfull movies. In this section we will look at the change in overall movie success
over the years to identify trends.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/change_in_movie_success.png?raw=True)


![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/drop_in_success.png?raw=True)


### **Most Popular Months for Movie Releases 🗓️**

Since we were looking at the yearly changes, we can further look into months to see if we have any trendy months for movie releases.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/popular_months_of_release.png?raw=True)


### **Actor and Director Success 👬**
So far, we have looked at the success for each individual movie. It would be interesting to see the most successful actor-director
pair that have at least 2 different movies and still managed to maintain a good success record over different movies.  

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_actor_director_success.png?raw=true)


Below, we can see the deep dive into the individual success metrics of the Top 10 Actor - Director pair.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_actor_director_deep_dive.png?raw=true)

Lastly, we show the Actor - Director Pair with the most movies below.

![plot](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-isin-pesch-deel-com/images/top10_actor_dir_movie_occ.png?raw=true)



# **Conclusions 🏁**
- TODO
