# dbt™ Data Modeling Challenge - Movie Edition
## NLP in Science Fiction Movies

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
   - [Tools Used](#tools-used)
   - [Applied Techniques](#applied-techniques)
4. [Visualizations](#visualizations)
   - [Basic Metrics](#basic-metrics)
   - [Sentiment Analysis](#sentiment-analysis)
   - [Word Frequency](#word-frequency)
   - [Collocation](#collocation)
5. [Conclusions](#conclusions)

## Introduction
Welcome to my project for the _dbt™ Data Modeling Challenge - Movie Edition_, hosted by [Paradime](https://www.paradime.io/)! This project delves into the analysis of Science Fiction movies, using Natural Language Processing (NLP) techniques to examine word frequency and sentiment in the plot descriptions of these films.

## Data Sources
My analysis leverages two key data sets:
- TMDB_MOVIES
- OMDB_MOVIES

## Methodology
#### Tools Used
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™.
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing.
- **Python** for natural language processing and data visualization.

#### Applied techniques
- Used SQL and dbt to create base data models.
- Applied Python's NLTK package for NLP to determine word frequency distribution and text sentiment in movie plots. Created new tables in Snowflake to store these metrics.
- Utilized SQL and dbt to create final data models for visualization.
- Employed Python for visualizations, including word clouds and various charts.

## Visualizations

### Basic Metrics

My focus was on Science Fiction movies, and before delving into advanced analytics, I sought to provide context through basic metrics.

#### Ratio of number/budget/revenue of Sci-Fi Movies to Non-Sci-Fi Movies
These pie charts visualizes the proportion of Sci-Fi movies compared to Non-Sci-Fi movies.

![nr_of_movies_pie_chart](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/9cde8aee-53ef-4307-9819-cb4bab554c2b)
![nr_of_movies_per_year](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/06004d25-f78d-4d6f-9996-6e083779bf75)

![sum_budget_pie_chart](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/02767ce7-a506-4e4b-b122-53c1e2d91309)
![sum_revenue_pie_chart](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/fe491008-cf46-4c3b-9333-d65ea1c8fe9a)

#### Insights
While Sci-Fi movies represent only 3.4% of all movies, their production shows a growing trend year by year. Despite their lower numbers, Sci-Fi movies account for 20% of all movie budgets and revenues, indicating higher financial investment and return.

![avg_budget_bar_chart](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/6e0dbb37-f2ea-47a2-9519-d31d0f88391a)
![avg_revenue_bar_chart](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/5284aba9-dac9-43c8-916c-a13f79d07254)

- Sci-Fi movies have significantly higher average revenue compared to Non Sci-Fi movies, approximately 7.8 times higher. This indicates that Sci-Fi movies, despite being fewer in number, tend to generate much higher revenue on average.
   - Non Sci-Fi: $376,652.88
   - Sci-Fi: $2,769,286.56
- The average budget for Sci-Fi movies is also substantially higher, about 7.4 times that of Non Sci-Fi movies. This suggests that Sci-Fi movies generally require more financial investment.
   - Non Sci-Fi: $936,016.54
   - Sci-Fi: $7,298,018.77

#### Average IMDB Rating
This bar chart shows the average IMDb rating and the average number of IMDb votes for Sci-Fi versus Non-Sci-Fi movies.

![avg_imdb_rating_bar_chart](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/031a4aa0-32fb-48db-93df-e9517df6b0b2)
![avg_imdb_votes_bar_chart](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/c583fcb3-6da4-4cb8-b5ab-c620555d8c92)

#### Insights
Non-Sci-Fi movies have higher average IMDb ratings compared to Sci-Fi movies. However, Sci-Fi movies receive significantly more votes, indicating higher viewer engagement and suggesting that Sci-Fi films may be more divisive.

### Conclusion
Sci-Fi movies, although fewer in number, tend to have much higher average revenue and budget compared to Non Sci-Fi movies. This suggests that Sci-Fi movies are a high-investment, high-reward genre. Sci-Fi movies garner significantly more IMDb votes on average, indicating a dedicated and engaged audience.
Despite higher investments and engagement, Sci-Fi movies have lower average IMDb ratings compared to Non Sci-Fi movies. This might point to higher expectations and critical scrutiny for Sci-Fi films or a niche appeal.


### NLP metrics

I applied some Natural Langugae Processing techniques to learn more about Sci-Fi movies. 
The metrics created:
- most common genres among Science Fiction movies
- word frequency in the plot of Sci-Fi movies
- sentiment of the plot of Sci-Fi movies (how positive or negative is the movie)
- most common collocations - the most common word pairs that are used together

#### Most common Sci-Fi genres
Obviously a movie can have multiple genres. It is very rare that a movie only has one genre, Science Fiction, they usually have subgenres like Action, Fantasy, etc. I attempted to see what are the most common subgenres within Sci-Fi. 

![genres](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/4c2f01cb-a3bb-473c-8f9a-592fb0f4d430)

![genre_details](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/73cd9960-650f-4373-8ff1-2965a2cb314c)


#### Insights
- Action has the highest number of movies (4666), followed by Drama (4238) and Horror (3972). Interestingely there's almost as much of comedy Sci-Fis as horror. Fantasy however, only comes in eight for my surprise.
- Biography, News, Talk-Show, Film-Noir, and Game-Show have the fewest movies, each with only one entry.
- Documentary movies have the highest average IMDb rating (6.59), indicating high viewer satisfaction with factual content and storytelling.
- Music and Animation genres also have high average ratings (6.18 and 6.37 respectively), suggesting strong audience appreciation for these genres' creative content.
- Horror movies have the lowest average IMDb rating (4.77), possibly due to the subjective nature of horror content and varying audience preferences.

#### Sentiment Analysis
Sentiment analysis, or opinion mining, is the process of analyzing large volumes of text to determine whether it expresses a positive sentiment, a negative sentiment or a neutral sentiment.
I was curious to see the sentiment of Sci-Fi movies.
We had two datasets that I merged together. Each had a description of the movie, one called `plot` the other `overview`. Some movies had both some only one, some neither. So therefore I analysed both field (plus titles too) and determined the word frequency for the whole genre of Science Fiction and also for Non Sci-Fi movies. One of the datasets also had keywords and tagline information. For sentiment analysis though, I only believe plot and overview are relevant.

#### Average sentiment of Sci-Fi vs. Non Sci-Fi
Sentiment can range between -1 and 1, -1 being the most negative, 1 the most positive sentiment. 

![movie_plot_sentiment](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/879efc95-a1cd-43d8-9ac2-ec4a71aa17b8)
![movie_overview_sentiment](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/901267f1-44c0-4186-950e-46db1e9d4a79)

#### Insight
Although sentiment in both categories are close to neutral we can see that Sci-Fi movies are tend to be slightly negative in sentiment than other movies. 

#### Average sentiment of Subgenres within Sci-Fi

![sentiment_by_genres](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/8d428c80-4c48-4f8a-b04d-7b508fc927f8)

#### Insight
Nothing super surprising here, family movies have the most positive sentiment, and horrors the most negative. However, non others than family are in the positive range.

#### Word Frequency
For determining word frequencies I analyzed all five of the text fields.

- #### Plot:
- Non Sci-Fi:
- ![all_movies_concatenated_plot_wordcloud](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/f4fef515-28c2-4049-a5ee-bb5c8aa11fa2)
- Sci-Fi:
- ![concatenated_plot_wordcloud](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/986fed1b-0015-41c8-8771-28a317398612)

- #### Overview:
- Non Sci-Fi:
- ![all_movies_concatenated_overview_wordcloud](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/6e989652-b672-4e1a-91f8-261bfe838d32)

- Sci-Fi:
- ![concatenated_overview_wordcloud](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/4b162e11-e351-4e57-a098-4f997effdc2c)

- #### Title:
- Non Sci-Fi:
- ![all_movies_concatenated_title_wordcloud](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/cbfb364d-42dc-4451-b937-ee1cc0036ad5)

- Sci-Fi:
- ![concatenated_title_wordcloud](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/9b5407c6-145e-440f-b26a-db6465fcc6c7)

#### Insights
We can see in both Non Sci-Fi and Sci-Fi plots, `life` is a very popular word. We can also see `family`, `mother`, `father` etc. for Non Sci-Fi. For Sci-Fi `world` is one of the highest ranked word and also `alien, future, earth, planet` appears.
For overview of Non Sci-Fi movies, `work, old` and `time` are popular topics. Whereas in Sci-Fi these are: `world, life, earth, find`.
By title, most of Non Sci-Fi movies are a love story! :) Sci-Fi movie titles though, are mostly about `space, aliens` and `time`.


#### Collocation
Collocation is how words go together or form fixed relationships.

#### Most common two-word collocations
This visualization highlights the most frequent word pairs found in the plot descriptions of movies.

![collocation](https://github.com/moses90/paradime-dbt-movie-challenge/assets/23437333/5b458512-6bf4-4dff-835f-c7d3b05f2a91)

#### Insights
- The pair "young woman" appears most frequently, indicating a common theme in both plots and overviews.
- "Near future" and "young man" are also prevalent, suggesting frequent usage of these terms in plot contexts.
- Taglines often include the phrase "one man," likely reflecting heroic or central characters.
- Phrases like "end world" and "outer space" suggest common themes in movie taglines focusing on high stakes and sci-fi settings.
- Titles frequently include specific terms like "kamen rider" and "outer space," suggesting genre-specific titles.
- The presence of "star war" and "star trek" highlights the influence of iconic franchises in movie titles.
- In keywords, "Time travel" and "woman director" are the top collocations, indicating popular themes and notable attributes.
- Keywords like "post-apocalyptic future" and "based novel" suggest recurring narrative settings and source material.


### Conclusions

This comprehensive analysis covers various aspects of movie data, including genre popularity, IMDb ratings, budgets, revenues, and sentiment analysis. Key findings reveal significant differences in average ratings and financial metrics across genres, along with distinct sentiment trends in plot and overview descriptions, providing valuable insights for strategic decision-making in film production and marketing.















