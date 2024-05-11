# dbt™ Data Modeling Challenge - Movie Edition

# Movie Insights by Rasmus Engelbrecht

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources-and-data-lineage)
3. [Methodology](#methodology)
   - [Tools Used](#tools-used)
   - [Data Sources and Data Lineage](#data-sources-and-data-lineage)
4. [Visualizations](#visualizations)
   - [What's Popular?](#whats-popular-) 
   - [Temporal Insights](#temporal-insights-)
   - [TMDb vs IMDb](#tmdb--imdb)
5. [Conclusions](#conclusions)

## Introduction
Explore my project for the _dbt™ data modeling challenge - Movie Edition_, Hosted by [Paradime](https://www.paradime.io/)! This project dives into the analysis and visualization of Movie and TV data!

## Data Sources
My analysis leverages four key data sets:
- *IMDB Movies*
- *TMDB Movies*
- *TMDB Popular Movies [Extracted through TMDb API]*
- *TMDB Popular People  [Extracted through TMDb API]*

In addition the following tables were created based on the TMDb and IMDb Movies datasets, by using the SPLIT_TO_TABLE function:
- *Movie Actors*
- *Movie Directors*
- *Movie Genres*
- *Movie Keywords*

The relations are visualised in the below Data Lineage.

### Data Lineage

*Please note that* `int_movies_enriched` *should have been named* `movies_enriched`, *but changing the model name would break all my existing Saved Charts in Lightdash, as explained in this* [Issue](https://github.com/lightdash/lightdash/issues/5264).

## Methodology
#### Tools Used
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™.
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing.
- **[Lightdash](https://www.lightdash.com/)** for data visualization.
- **[Github](https://www.github.com/)** for version control.
- **[Mage.ai](https://www.mage.ai/)** data pipeline tool for extracting, transforming and integrating data.
- **[TMDb API](https://developer.themoviedb.org/reference/intro/getting-started)** API with data for enrichment.



## Visualizations

### What's Popular? 📈

### Temporal Insights 🕰️

### TMDb 🆚 IMDb


## Conclusions
In conclusion, my analysis across three main topics shed light on several key insights in the film industry:

### What's Popular? 📈
- **Dominance of Action and Sci-Fi:** The top 20 most popular movies on TMDb predominantly belong to the Action and Sci-Fi genres, indicating a strong preference for adrenaline-pumping narratives and futuristic storytelling.
- **Audience Preferences:** Titles like "Godzilla Minus One," "Dune: Part Two," and "Oppenheimer" not only rank high in popularity but also boast impressive ratings, reflecting audience appreciation for epic narratives and visually captivating spectacles.
- **Gender Distribution:** Notably, there's a gender disparity among the top 20 most popular actors, with women occupying a significant portion of the list, potentially indicating a trend towards stronger female star quality.

### Temporal Insights 🕰️
- **Impact of COVID-19:** The film industry experienced a sharp decline in Box Office revenue and Profit during the COVID-19 outbreak years (2020-2022) due to widespread theater closures and audience reluctance.
- **Recovery and Resurgence:** However, there has been a noticeable recovery in 2023 and 2024, signaling a resurgence in movie theater attendance and box office success, potentially indicating a return to normalcy for the industry.

### TMDb 🆚 IMDb
- **Differences in User Bases:** TMDb users exhibit preferences for genres like TV Movies, Family, Horror, and Music, which tend to have lower average quality ratings compared to other genres. This divergence raises questions about the demographics and preferences of the TMDb user base, suggesting a potential younger audience or specific interests in these genres.






