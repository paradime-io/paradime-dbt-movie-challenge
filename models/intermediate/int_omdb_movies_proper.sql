/*
This model cleans up the OMDB_MOVIES table for further analytics.
It filters the results based on the following conditions:
- The OMDB_ID must exist in the TMDB_MOVIES
It deduplicates the results and adds ratings calculated in a separate model.

```dbt
columns:
  - name: IMDB_ID
    tests:
      - unique
  - name: ROTTEN_TOMATOES_RATING
    description: the Rotten Tomatoes rating of the movie. It comes from unpacking the JSON ratings column.
  - name: IMDB_RATING
    description: the IMDB rating of the movie. If not present in the source IMDB_RATING column, it comes from unpacking the JSON ratings column.
  - name: METACRITIC_RATING
    description: the IMDB rating of the movie. If not present in the source METACRITIC_RATING column, it comes from unpacking the JSON ratings column.
```
*/
WITH CTE_FILTER AS (
  SELECT T.*
  FROM {{ ref('stg_omdb_movies') }} AS T
  WHERE
    1 = 1
    AND T.TMDB_ID IS NOT NULL
    AND T.TMDB_ID IN (SELECT TMDB_ID FROM {{ ref('stg_tmdb_movies') }})
),

CTE_DEDUP AS (

  SELECT
    IMDB_ID,
    MAX(TITLE) AS TITLE,
    MAX(RATED) AS RATED,
    MAX(GENRE) AS GENRE,
    MAX(DIRECTOR) AS DIRECTOR,
    MAX(WRITER) AS WRITER,
    MAX(ACTORS) AS ACTORS,
    MAX(PLOT) AS PLOT,
    MAX(LANGUAGE) AS LANGUAGE,
    MAX(COUNTRY) AS COUNTRY,
    MAX(AWARDS) AS AWARDS,
    MAX(POSTER_PATH) AS POSTER_PATH,
    MAX(TYPE) AS TYPE,
    MAX(DVD) AS DVD,
    MAX(PRODUCTION) AS PRODUCTION,
    MAX(RELEASE_YEAR) AS RELEASE_YEAR,
    MAX(RUNTIME) AS RUNTIME,
    MAX(METACRITIC_RATING) AS METACRITIC_RATING,
    MAX(IMDB_VOTES) AS IMDB_VOTES,
    MAX(BOX_OFFICE) AS BOX_OFFICE,
    MAX(TMDB_ID) AS TMDB_ID,
    MAX(IMDB_RATING) AS IMDB_RATING
  FROM CTE_FILTER
  GROUP BY 1
),

CTE_ADD_RATINGS AS (
  SELECT
    C.IMDB_ID,
    C.TITLE,
    C.RATED,
    C.GENRE,
    C.DIRECTOR,
    C.WRITER,
    C.ACTORS,
    C.PLOT,
    C.LANGUAGE,
    C.COUNTRY,
    C.AWARDS,
    C.POSTER_PATH,
    C.TYPE,
    C.DVD,
    C.PRODUCTION,
    C.RELEASE_YEAR,
    C.RUNTIME,
    C.IMDB_VOTES,
    C.BOX_OFFICE,
    C.TMDB_ID,
    COALESCE(C.IMDB_RATING, R.IMDB_RATING) AS IMDB_RATING,
    R.ROTTEN_TOMATOES_RATING,
    COALESCE(C.METACRITIC_RATING, R.METACRITIC_RATING) AS METACRITIC_RATING
  FROM CTE_DEDUP AS C
  LEFT JOIN {{ ref('int_omdb_ratings') }} AS R ON C.IMDB_ID = R.IMDB_ID
)

SELECT *
FROM CTE_ADD_RATINGS
