# dbt™ Data Modeling Challenge - Movie Edition

## Table of Contents
1. [Introduction](#introduction)
2. [Methodology](#methodology)
3. [Data Sources and Modelling](#data-sources-and-modelling)
   - [Movie Data](#movie-data)
   - [Additional Data](#additional-data)
   - [Data Integration](#data-integration)
   - [Data Lineage and Schemas](#data-lineage-and-schemas)
4. [Data Visualizations](#data-visualizations)
   - [Getting to know the data](#getting-to-know-the-data)
   - [Demographic analysis](#demographic-analysis)
   - [Academy Awards deep-dive](#academy-awards-deep-dive)
5. [Project Outcomes](#project-outcomes)

---
## Introduction
I'm well known amongst friends for missing pop culture references relating to film... Even the most popular movies have somehow escaped my viewing. I also love data, so participating in this data challenge hosted by [Paradime](https://www.paradime.io/) seemed like the perfect chance to combine one passion with a personal blind spot to learn something new!

## Methodology
#### Tools Used
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing
- **[Lightdash](https://www.lightdash.com/)** for data visualization
- **[Wikidata Query Service](https://query.wikidata.org/)** for sourcing additional datasets
- **SPARQL** and **Python** for retrieving larger datasets from [Wikidata](#wikidata)

## Data Sources and Modelling

### Movie Data
I decided to focus on movies rather than TV series and use 2 of the 3 tables provided:
- `omdb_movies`
- `tmdb_movies`

### Additional Data
I wanted to explore the **demographic information** of people involved in making movies, the nominees and winners of **Academy Awards**, and the **Bechdel Test rating** of movies. I found the following datasets online:
- Movie Director Date of Birth and Gender - sourced from [Wikidata](#wikidata)
- Actor Date of Birth and Gender - sourced from [Wikidata](#wikidata)
- Academy Award winners and nominees - sourced from [Wikidata](#wikidata)
- Bechdel Test movie ratings - sourced from https://bechdeltest.com/

### Wikidata source data
For queries with a smaller result set, the [Wikidata Query Service](https://query.wikidata.org/) can be used. 
I modified an example SPARQL query to return data on Academy Award winners and Academy Award nominees - see [sparql_queries](https://github.com/paradime-io/paradime-dbt-movie-challenge/tree/movie-imogenssford/sparql_queries) folder.

For the larger Movie Director and Actor datasets I used python to query wikidata and return results in smaller chunks - see [python_scripts](https://github.com/paradime-io/paradime-dbt-movie-challenge/tree/movie-imogenssford/python_scripts) folder.



### Data Integration
To join `omdb_movies` and `tmdb_movies` I used the `imdb_id` field. I analysed the data in each table to decide:
1. Which fields to take forward into the downstream models
2. How to combine fields containing similar data in different tables, to maximize the amount of useable data retrieved from the sources

![join omdb and tmdb](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-imogenssford/screenshots/join_omdb_and_tmdb.png)

To combine data in the two tables I defined some [javascript UDFs](https://github.com/paradime-io/paradime-dbt-movie-challenge/tree/movie-imogenssford/macros/udfs) and learnt how to use [macros](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-imogenssford/macros/create_udfs.sql) to manage the creation of the UDFs when `dbt run` is called.

Integrating data about movie entities from additonal data sources was done using `imdb_id`.

Integrating data relating to the **people** involved in creating movies was more complicated due to the lack of unique identifiers for the people in the original dataset: `omdb_movies` contains a comma-separated list of people names in the **DIRECTOR**, **WRITER**, and **ACTORS** fields. People names are also often suffixed with further detail about the person's role, eg. "(co-director)"

Joining people data together involved a few steps including splitting comma-separated lists of names in `omdb_movies`, extracting extra information in parentheses to another column, and then joining onto data from wikidata using person name. A **seed file** was also used to perform name corrections where the same person was referred to by different names in different datasets.

## Data Lineage and Schemas

### Data Lineage
The data lineage for the main two analytics models used for visualization are shown below.

#### People summary
![data-lineage-people-summary](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-imogenssford/screenshots/data-lineage-people-summary.png)

#### Academy awards movies
![data-lineage-academy-awards-movies](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-imogenssford/screenshots/data-lineage-academy-awards-movies.png)

### Schemas
1. **STAGING** 
    - Models materialized as views
    - Models reflect source data
    - Minimal data manipulation except for deduplication, extracting values from JSON fields etc.
2. **INTERMEDIATE**
    - Models materialized as views
    - Most data integration happens in this layer: joining data from different sources
    - Data is restructured, filtered, and cleaned
3. **WAREHOUSE**
    - Models materialized as tables
    - Should contain consolidated good quality data about all entities separately
    - Intended to be flexible enough that data can be aggregated according to analytics requirements in the `ANALYTICS` schema
    - Minimal duplication of information about entities that are linked. Joining should happen as and when required in the `ANALYTICS` schema
4. **ANALYTICS**
    - Models materialized as views
    - Data joined, aggregated and filtered to make it suitable for visualization and analysis

## Data Visualizations

### Getting to know the data
As I want to interrogate the demographic information of the people in movies, I first wanted to get a feel for where and when the movies in the dataset have been made.
![1-getting-to-know-the-data](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-imogenssford/screenshots/1-getting-to-know-the-data.png)

### Demographic analysis
![2-age-gender-actors-directors](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-imogenssford/screenshots/2-age-gender-actors-directors.png)

![3-age-gender-actors-20th-21st-centuries](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-imogenssford/screenshots/3-age-gender-actors-20th-21st-centuries.png)

![4-age-gender-actors-uk-india](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-imogenssford/screenshots/4-age-gender-actors-uk-india.png)


### Academy Awards deep-dive
![5-awards-actors-directors-21st-century](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-imogenssford/screenshots/5-awards-actors-directors-21st-century.png)

![6-awards-budgets-and-ratings-winners-vs-nominees](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-imogenssford/screenshots/6-awards-budgets-and-ratings-winners-vs-nominees.png)


## Project Outcomes
I've learnt that the movie industry is very big and constantly evolving. The age and gender distributions of actors is changing to include more women at more ages overall, and this distribution appears to vary between country. 

Women are not well represented amongst directors, but many of the most successful actors of the 21st century to date are female.

Before this challenge, I had very limited experience with DBT, had never written a SPARQL query, and had never used Paradime. So the greatest outcome for me has been gaining new skills whilst also satisfying my curiosity about the movie industry!





