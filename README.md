
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
For my submission I decided to t take a t

## Data
My analysis primarly leverages a combination of publically available data from platforms like IMDB,
Netflix, and GitHub. User behavior data from on my streaming behavior is mine and was also given permission to use data from a family member


## Methodology
#### Tools Used
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™.
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing.
- **[Lightdash](https://www.lightdash.com/)** for data visualization.
- **Python** for data scraping and processing

### Data Sources
My analysis primarly leverages the following data sets:
- [Neflix Viewing History](http://www.netflix.com/settings/viewing-history) (~5 years)
- [Netflix Weekly](https://www.netflix.com/tudum/top10)
- [Oscars Nominee Data](https://github.com/DLu/oscar_data?tab=readme-ov-file)
- [IMDB List: Black Attresses](https://m.imdb.com/list/ls066061932/)
- [IMDB List: National Film Registry](https://m.imdb.com/list/ls070798434/)
- [IMDB Basics (People) Dataset](https://developer.imdb.com/non-commercial-datasets/)

### Data Lineage

**Films**
![films](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/dag/films.png?raw=true)

**Moods**
![moods](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/dag/moods.png?raw=true)

**Oscar Nominations**
![oscar-noms](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/dag/oscar_noms.png?raw=true)

**People - Actors**
![actors](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/dag/people_actors.png?raw=true)

**TV**
![tv](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/dag/tv.png?raw=true)

**Watch History**
![history](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/dag/watch_history.png?raw=true)

**Netflix Weekly Top 10**
![weekly](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/dag/weekly.png?raw=true)



## Visualizations

### A Stream at High Tide 🌊
[netflix_top_weekly](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/netflix_bg/Screen%20Shot%202024-05-26%20at%2011.42.53%20PM.png?raw=true)

[hours_viewed](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/netflix_bg/hours_watched.png?raw=true)

[binge](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/netflix_bg/binge_1.png?raw=true)

[binge_2](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/netflix_bg/binge_2.png?raw=true)

### That's a Wrap: 2023 Edition! 🎬
[movie_count](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/count_mov.png?raw=true)
[dow](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/dow.png?raw=true)
[mood](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/mood.png?raw=true)
[awards](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/awards.png)
[famous_trend](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/famous_trending.png)
[crowd_scores](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/crowd_scores.png)

### Oscars Still So White 👎🏾
[oscar_wins](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/oscars_still_so_white/oscar_wins.png?raw=true)
[vioal](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/oscars_still_so_white/viola.png?raw=true)
[ruby](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/oscars_still_so_white/ruby_dee.png?raw=true)


## Conclusions

Share a clear and concise conclusion of your findings!
