# dbt™ Data Modeling Challenge - Movie Edition


## Table of Contents
1. [Introduction](#Introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#Methodology)
4. [Visualizations](#Visualizations)
5. [Final Thoughts](#Example-submission-template)


## Introduction
Welcome to my project for the dbt™ data modeling challenge - Movie Edition, Hosted by [Paradime](https://www.paradime.io/)!. This project takes a look at some of the trends in movies and how these have changed over the years.

### [My GitHub Repo](https://github.com/paradime-io/paradime-dbt-movie-challenge/tree/movie-philip-song-veeva-com)

## Data Sources
My analysis focused on the movie dataset from Paradime TMDB_movies. To supplement this dataset, I used 2 additional sources to enrich the data:
1. Inflation data provided by the BLS data.bls.gov. This allows for a better comparison of box office revenues year over year to account for inflation.
2. Movie data from themoviedb.org. Some of the production company data was missing, and this dataset offers a more complete fill-out.

## Methodology
### Tools Used
- **[Paradime](https://www.paradime.io/)** for SQL transformations, dbt™.
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing.
- **[Lightdash](https://www.lightdash.com/)** & **Excel** for data visualization.
- **Python** for API access to generate the supplemental datasets.

## Visualizations
**Overall Trends**

Movies have long been a staple of culture. As technology and budgets increase over time, movies today are capable of bringing stories to life that previously would have been impossible. And yet, competition for the most valuable resource of all, time, has been fierce.

More and more films are produced every year and audiences continue to go, resulting in more total box office over time. However, as the internet and streaming enter the fray the average box office per movie has been trending down:
![image](https://github.com/paradime-io/paradime-dbt-movie-challenge/assets/62715537/68265115-75b4-4e61-a288-6078ca5792e0)

The average runtime for a film has remained relatively static, although recently it has been trending up. In the era of short-form content and mini-series, movies are not afraid to take their time
![image](https://github.com/paradime-io/paradime-dbt-movie-challenge/assets/62715537/ab65381a-794a-4533-9637-24d23d1a5cdd)

**Who's making our films?**
Movies that end up in theaters are almost never made by a single production company. Thus while this makes success attribution nearly impossible, companies still make their distinguished mark. There is a strong correlation when comparing the number of films produced against total box office revenue. 
Not entirely surprising, given that a movie studio that can't earn a lot of money for their films won't last.
![image](https://github.com/paradime-io/paradime-dbt-movie-challenge/assets/62715537/707f3668-b88a-494b-a39c-137dbf47f5ae)

Of interest are studios like Canal+ and Film4 Productions, who have put out hundreds of films against a much, much smaller total revenue share. Closer investigation reveals that both of these are international companies, whose US box office viewings present only a fraction of their true performance.
![image](https://github.com/philip-song/Personal/assets/62715537/db528cb3-fd2a-4d25-bc4d-0bbd279b2708)



**What Kinds of Movies are Popular?**

Although almost every movie is in multiple genres, there is a surprising consistency in the types of films that production companies make. Dramas and comedies are absolutely always in supply (although not always in demand!).

![image](https://github.com/paradime-io/paradime-dbt-movie-challenge/assets/62715537/e337b4db-1177-4204-868b-0a3b72e376dc)

When it comes to the average box office that a film brings in the story has more variety but a similar consistency. The top spot is almost always a Sci-Fi or Adventure film.
![image](https://github.com/paradime-io/paradime-dbt-movie-challenge/assets/62715537/9eeedc94-ce4e-4101-a01a-997d4f8974fe)


## Final Thoughts
Although analytical movie analysis is full of caveats and incomplete information (we didn't even mention international sales, rescreens, dvd/streaming views, etc), the world of movies is rich with data on the balance between producer and consumer.
There is an entire other world exploring IMDB ratings between the general audience and critics, but at the end of the day, people vote with their time and money on which movies are worth watching. Thanks for reading!