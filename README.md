# dbt™ Data Modeling Challenge - Movie Edition

# Final Submission 

## Table of Contents
1. [Introduction](#introduction)
2. [Data Sources](#data-sources)
3. [Methodology](#methodology)
   - [Tools Used](#tools-used)
   - [Data Lineage](#data-lineage)
4. [Visualizations](#visualizations)
   - [🎫 The Golden Ticket](#unveiling-film-industry-economics)
   - [🌟 Midas Touch](#unveiling-the-golden-directors-and-writers-of-film-finance)
   - [🏆 The Good, the Bad, and the Razzie](#awards-showdowns)
5. [Conclusions](#conclusions)

---

## Introduction
A simple intro. Example - "Explore my project for the _dbt™ data modeling challenge - Movie Edition_, Hosted by [Paradime](https://www.paradime.io/)! This project dives into the analysis and visualization of Movie and TV data!"

---

## Data Sources
My analysis movie datasets from Paradime:

- *`OMDB_MOVIES`*
- *`TMDB_MOVIES`*

Additional Data Sources

- [Box Office Mojo](https://www.boxofficemojo.com/) for countries, releases, franchises and brands.
- [Oscars Awards](https://awardsdatabase.oscars.org) with the initial file found in [Kaggle](https://www.kaggle.com/datasets/unanimad/the-oscar-award/data)
- [Razzie Awards](https://www.imdb.com/event/ev0000558/overview/?ref_=ev_sa_1) with the initial file found in [Kaggle](https://www.kaggle.com/datasets/martj42/golden-raspberry-awards)
- [Consumer Price Index (CPI)](https://data.bls.gov/timeseries/CUUR0000SA0)

---

## Methodology
#### Tools Used
- **[Paradime](https://www.paradime.io/)** for SQL, dbt™.
- **[Snowflake](https://www.snowflake.com/)** for data storage and computing.
- **[Lightdash](https://www.lightdash.com/)** for data visualization.
- **[Python](https://www.python.org)** for web scraping.

### Data Lineage

#### Gross films

![lng_gross_films](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/lineage/lng_grossing_film.png?raw=true)

#### Directors/Writers gross

![lng_directos_writers_gross](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/lineage/lng_midas_touch_gross.png?raw=true)

#### Awards movies

![lng_awards_movies](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/lineage/lng_awared_movie.png?raw=true)

#### Awards people

![lng_awards_people](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/lineage/lng_awared_people.png?raw=true)

#### Gross by regions

![lng_gross_regions](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/lineage/lng_Gross%20by%20regions.png?raw=true)

#### ROI

![lng_roi](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/lineage/lng_ROI.png?raw=true)

# Visualizations

## Unveiling Film Industry Economics

![highest_gross](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/golden_ticket/highest_worldwide_gross.png?raw=true)

![highest_roi](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/golden_ticket/highest_roi.png?raw=true)

![contribution](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/golden_ticket/contribution_of_each_region.png?raw=true)

---

## Unveiling the Golden Directors and Writers of Film Finance

![directors_gross](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/midas_touch/directors_median_gross.png?raw=true)

![writers_gross](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/midas_touch/writers_median_gross.png?raw=true)

![directors_roi](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/midas_touch/directors_median_roi.png?raw=true)

![writers_roi](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/midas_touch/writers_median_roi.png?raw=true)

---

# Conclusions
🎬 In summary, our exploration of the film industry's data reveals a dynamic landscape characterized by the interplay of various factors. From timeless classics to modern blockbusters, directors and writers play pivotal roles in shaping the financial success of films, with their talent and creativity driving box office performance.

📊 Analysis of ROI highlights the profitability of low-budget productions, particularly in niche genres like horror, while the median worldwide gross showcases the monumental success of visionary creators like Peter Jackson and Stan Lee.

🌍 Moreover, the global distribution of box office revenue underscores the significance of diverse markets, with regions like the United States, Europe, and Asia-Pacific each contributing uniquely to the industry's economic ecosystem.
