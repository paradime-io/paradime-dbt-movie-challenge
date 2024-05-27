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

## Awards Showdowns

![oscars](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/awards_showdowns/why_oscars.png?raw=true)

![best_movies](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/awards_showdowns/best_films.png?raw=true)
![correlation](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/awards_showdowns/correlation.png?raw=true)

![best_actors](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/awards_showdowns/best_actors.png?raw=true)
![best_actress](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/awards_showdowns/best_actress.png?raw=true)

![best_directors](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/awards_showdowns/best_director.png?raw=true)

#### Welcome to the dark side

![razzies](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/awards_showdowns/why_razzies.png?raw=true)

![worst_movies](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/awards_showdowns/worst_films.png?raw=true)

![worst_actors](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/awards_showdowns/worst_actors.png?raw=true)
![worst_actress](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/awards_showdowns/worst_actress.png?raw=true)

![worst_directors](https://github.com/paradime-io/paradime-dbt-movie-challenge/blob/movie-santiago-orozco-prediktia-com/snapshots/awards_showdowns/worst_director.png?raw=true)

---

# Conclusions
In the vast expanse of the film industry, myriad stories unfold, each revealing layers of creativity, craftsmanship, and cultural impact. From timeless classics like "Gone with the Wind" to modern blockbusters such as "Titanic" and "Avatar," the cinematic landscape reflects the ever-evolving tastes and preferences of audiences worldwide. These films, spanning decades and genres, serve as windows into the human experience, capturing moments of joy, sorrow, triumph, and tragedy.

Behind the scenes, filmmakers harness the power of technology and global marketing strategies to bring their visions to life, leveraging advancements in CGI, sound design, and distribution to create immersive cinematic experiences. Directors like Steven Spielberg and Peter Jackson craft cinematic masterpieces that transcend time, while emerging talents like James Wan push the boundaries of genre filmmaking, redefining horror and action for a new generation.

Yet, amidst the glitz and glamour of the red carpet, there are also moments of misstep and failure. Films like "Jack and Jill" and "Battlefield Earth" stumble in their execution, facing criticism for their poor storytelling, performances, and production quality. Despite their Razzie wins, these films serve as cautionary tales, reminding us of the inherent risks and challenges inherent in the creative process.

Ultimately, the world of cinema is a kaleidoscope of storytelling, where success and failure intermingle to create a rich tapestry of human expression. Whether celebrated with Oscars or lamented with Razzies, each film contributes to the ongoing dialogue of cinematic exploration, inviting audiences to laugh, cry, and ponder the complexities of the human condition.