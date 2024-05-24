/*
This model cleans up the TMDB_MOVIES table for further analytics.
It filters the results based on the following conditions:

- The TMDB_ID must exist in the OMDB_MOVIES
- The STATUS column must be 'Released'.

```dbt
columns:
  - name: TMDB_ID
    tests:
      - unique
      - not_null
```
*/

SELECT
  T.TMDB_ID,
  T.TITLE,
  T.ORIGINAL_TITLE,
  T.OVERVIEW,
  T.TAGLINE,
  T.KEYWORDS,
  T.ORIGINAL_LANGUAGE,
  T.STATUS,
  T.VIDEO,
  T.RELEASE_YEAR,
  T.RUNTIME,
  T.BUDGET,
  T.REVENUE,
  T.VOTE_AVERAGE,
  T.VOTE_COUNT,
  T.POSTER_PATH,
  T.BELONGS_TO_COLLECTION,
  T.IMDB_ID,
  T.GENRE,
  T.SPOKEN_LANGUAGES,
  T.PRODUCTION_COMPANY_NAMES,
  T.PRODUCTION_COUNTRY_NAMES
FROM {{ ref('stg_tmdb_movies') }} AS T
WHERE
  1 = 1
  AND T.TMDB_ID IS NOT NULL
  AND T.TMDB_ID IN (SELECT TMDB_ID FROM {{ ref('stg_omdb_movies') }})
  AND T.STATUS = 'Released'

