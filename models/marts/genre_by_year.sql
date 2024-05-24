/*
This model is used to calculate the number of occurrences of each genre in a given year and net pofit associated with this genre.
To account for movies with multiple genres allocated to them, it uses number of genres per movie that year.
It excludes short films as this is a descriptor of the length and not genre.
TV specific genres (Game-Show, Talk-Show, Reality-TV, TV Movie, News) are excluded as well.
It includes movies from 1920 onwards and up to the previous full year.

```dbt
columns:
  - name: GENRE
    description: the genre of the movie
    meta:
      dimension:
        type: string
  - name: RELEASE_YEAR
    description: the year the movie was released
    meta:
      dimension:
        type: number
        time_intervals: ['YEAR_NUM']
  - name: RELEASE_DECADE
    description: the decade the movie was released
    meta:
      dimension:
        time_intervals: ['YEAR_NUM']
  - name: GENRE_OCCURRENCES
    description: the number of occurences of the genre in the given year
    meta:
      dimension:
        hidden: true
      metrics:
        number_of_movies:
          type: sum
  - name: PERCENT_OF_MOVIES_THAT_YEAR
    description: the percentage of movies that year that are of the given genre
    meta:
      dimension:
        hidden: true
      metrics:
        percent_of_movies:
          type: sum
  - name: PROFIT_NET_ALLOCATED_TO_GENRE
    description: the profit net allocated to the genre. As a movie might have more than one genre, the profit net is divided by the number of genres allocated to the movie. Value in 2023 USD.
    meta:
      dimension:
        hidden: true
      metrics:
        profit_net_allocated_to_genre:
          type: sum
          format: 'usd'
          compact: millions
```
*/

WITH CTE_GENRES_WIHT_YEAR AS (
  SELECT
    G.IMDB_ID,
    G.GENRE,
    M.RELEASE_YEAR,
    1 / G.NUMBER_OF_GENRES_THIS_MOVIE AS PROPORTION_GENRES_THIS_MOVIE,
    M.PROFIT_NET / G.NUMBER_OF_GENRES_THIS_MOVIE AS PROFIT_NET_ALLOCATED_TO_GENRE
  FROM {{ ref('int_movies_genres') }} AS G
  LEFT JOIN {{ ref('movies') }} AS M ON G.IMDB_ID = M.IMDB_ID
  WHERE
    1 = 1
    AND M.RELEASE_YEAR IS NOT NULL
    AND M.RELEASE_YEAR >= 1920
    AND M.RELEASE_YEAR < YEAR(CURRENT_DATE)
    AND G.GENRE NOT IN ('Short')
    AND G.GENRE NOT IN ('Game-Show', 'Talk-Show', 'Reality-TV', 'TV Movie', 'News')
),

CTE_GENRE_BY_YEAR AS (
  SELECT
    G.GENRE,
    G.RELEASE_YEAR,
    ROUND(SUM(PROPORTION_GENRES_THIS_MOVIE), 0) AS GENRE_OCCURRENCES,
    ROUND(SUM(G.PROFIT_NET_ALLOCATED_TO_GENRE), 0) AS PROFIT_NET_ALLOCATED_TO_GENRE
  FROM CTE_GENRES_WIHT_YEAR AS G
  GROUP BY ALL
),

CTE_PERCENT_THIS_YEAR AS (
  SELECT
    *,
    ROUND(GENRE_OCCURRENCES / SUM(GENRE_OCCURRENCES) OVER (PARTITION BY RELEASE_YEAR), 4) AS PERCENT_OF_MOVIES_THAT_YEAR
  FROM CTE_GENRE_BY_YEAR
)

SELECT
  C.*,
  Y.DECADE AS RELEASE_DECADE
FROM CTE_PERCENT_THIS_YEAR AS C
INNER JOIN {{ ref('all_years') }} AS Y ON C.RELEASE_YEAR = Y.DATE_YEAR
