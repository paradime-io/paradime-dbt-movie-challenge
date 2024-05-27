
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
A high-level overview of Netflix and a zoomed look at my streaming habits over five years.

Despite multiple price hikes and even password-sharing crackdowns (April 2023), Netflix’s weekly Top 10 listings would suggest that demand (at least for the platform’s most popular content) is quite resilient. In particular, the #1 movie seems to account for a huge proportion of the views of the top 10 films. In the first week of December 2023, the #1 film Leave the World Behind with its star-studded cast of Julia Roberts, Mehreshala Ali, and Ethan Hawke accounted for ⅓ of views for the top ten. Similarly, Damsel, featuring Netflix favorite Millie Bobby Brown, accounted for over half the views for the top ten. My gut tells me that there are synergistic effects from having a movie with big stars and the ability to promote/suggest it to users within the app.
![netflix_top_weekly](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/netflix_bg/Screen%20Shot%202024-05-26%20at%2011.42.53%20PM.png?raw=true)

As the world shut down in early 2020, I, like others, found myself inside more often. While it definitely feels like I streamed months of my life away during the ramp of the pandemic, it looks like my view hours viewed volume stayed about level. (Although I left a job in Feb 2020, I did not necessarily gain any leisure time thanks to the classes I enrolled in.) In 2022, I had about twice as many hours logged on Netflix. 
![hours_viewed](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/netflix_bg/hours_watched.png?raw=true)

One last look at my habits isolation – I wanted to better understand what my content-consumption rate looked like – specifically how quickly I watched shows each year. Below each point represents a series of various lengths (ex. 25-minute shows like Seinfield and hourlong series like Stranger Things.) and average speeds at which I consumed those series each year.
![binge](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/netflix_bg/binge_1.png?raw=true)

If we look specifically at 2019 and 2020, we again see lower activity. Notice all those longer series I watched, some of which I consumed two or four(!) episodes at a time.
![binge_2](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/netflix_bg/binge_2.png?raw=true)

Overall, that lack of a lockdown-era uptick is probably unique to me. I would love to see results for other individuals.

### That's a Wrap: 2023 Edition! 🎬
![movie_count](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/count_mov.png?raw=true)
![dow](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/dow.png?raw=true)
![mood](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/mood.png?raw=true)
![awards](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/awards_watched.png?raw=true)
![famous_trend](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/famous_trending.png?raw=true)
![crowd_scores](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/crowd_scores.png?raw=true)

### Oscars Still So White 👎🏾
![oscar_wins](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/oscars_still_so_white/oscar_wins.png?raw=true)
![viola](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/oscars_still_so_white/viola.png?raw=true)
![awards](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/oscars_still_so_white/awards.png?raw=true)
![ruby](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/oscars_still_so_white/ruby_dee.png?raw=true)


## Conclusions

Share a clear and concise conclusion of your findings!
