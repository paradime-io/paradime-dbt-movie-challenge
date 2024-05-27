
## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources-and-data-lineage)
3. [Methodology](#methodology)
   - [Tools Used](#tools-used)
   - [Applied Techniques](#applied-techniques)
   - [Data Sources and Data Lineage](#data-sources-and-data-lineage)
4. [Visualizations](#visualizations)
   - Oscars Still So White
   - A Stream at High Tide
   - That’s a Wrap: 2023 Edition
5. [Conclusions](#conclusions)

## Introduction
For my submission, I wanted to understand how intersections of technology, art, and culture continue to shape how we see ourselves, our friends and families, and everything happening in the world. My goal is to unpack a few analytical questions that are meaningful to me.

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

### Oscars (Still) So White 👎🏾
A brief look at race, gender, and age at the Academy Awards. 

Despite widespread backlash a few years back, the Oscars still fail to highlight the work of talented black womxn actors. Below is the very short list of Black women who have won for acting categories.

![oscar_wins](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/oscars_still_so_white/oscar_wins.png?raw=true)

Viola Davis tops the list, having received both nominations and wins for films like Ma Rainey’s Black Bottom (a Netflix released), Fences, and The Help. In addition to performing well commercially, her films have received positive response from critics.

![viola](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/oscars_still_so_white/viola.png?raw=true)

Zooming out a bit, we can see that Black women actors with Academy Award nominations typically skew younger, and generally have fewer nominations over their lifetimes. Both of those things feel problematic to me. The two exceptions to these are Viola Davis whose Oscar success is described above, and Ruby Dee who was nominated for her first Oscar in 2008 for “Best Performance by an Actress in a Supporting Role” in American Gangster, about 6 years before she passed away.

![awards](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/oscars_still_so_white/awards.png?raw=true)

In addition to acting in American Gangster, Ruby Dee starred in films that are largely considered to be some of the most important films ever. Both A Raisin in the Sun (1961) and Do the Right Thing (1989) are hugely popular and culturally significant films that have been added to the National Film Registry.

![ruby](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/oscars_still_so_white/ruby_dee.png?raw=true)

Clearly, there is a gap in recognizing the talent of Black women.

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
A deep-dive into the movies I watched on Netflix in 2023 with insights on a second user’s profile for comparison.

Taste is subjective. That being said, I started my investigation with the hypothesis that my taste in movies is becoming increasingly less sophsticated. I wanted to compare my Netflix watch history to someone culturally tapped into the art world. For this deep dive, I was given data from my uber-talented cousin Zoe, a filmmaker who is seven years younger than me.

Kicking things off, my cousin (right side) beat my Netflix film count by about 30%.

![movie_count](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/count_mov.png?raw=true)

While my movie-watching in 2023 happened almost exclusively during the weekends, Zoe’s watched movies throughout the week to a greater extent.

![dow](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/dow.png?raw=true)

Each show or movie on Netflix has a set of moods associated with it. After analyzing, the moods based using watch times, it looks like my most common film moods were “offbeat”, “investigative”, and “gritty”. Zoe’s biggest moods were “dark”, “chilling”, and “imaginative”. Her mood profile seems more dramatic and intense.

![mood](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/mood.png?raw=true)

There’s no good way to separate high-brow content from low-brow content. Award-winning titles have an air of prestige. Trending titles don’t necessarily need to be “good”. (As an example Madame Web is #2 in the U.S. on Netflix at the moment, with poor reviews as evidenced by an 11% Rotten Tomatoes score.) In 2023, I watched more trending films than I did award-winning films. Zoe did the opposite.

![famous_trend](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/famous_trending.png?raw=true)
![awards](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/award_watched.png?raw=true)
![trending](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/trending.png?raw=true)

As a final test, I wanted to see what the critics online thought about the films we both watched in 2023. The average Rotten Tomatoes scores and Metascores ratings seemed slightly higher than my cousin’s. 

![crowd_scores](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-sperry-classy-org/images/viz/thats_a_wrap/crowd_scores.png?raw=true)

There is no accounting for good taste, but this analysis has at least alleviated some of my initial concerns.

## Conclusions

- Hollywood still has work to do to acknowledge the accomplishments of diverse talent
- Despite global uncertainty, streaming services like Netflix have many levers in their arsenal to influence the content we consume and how much.
- I did a halfway decent job of staying culturally relevant last year, at least as far as films go.

