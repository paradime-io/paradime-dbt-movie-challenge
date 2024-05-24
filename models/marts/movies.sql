/*
This model combines the data from the two sources to create a comprehensive mart of movies.
It only includes movies that are present in both sources: TMDB and OMDB.
It only includes movies that were released between 1920 and 2023.

```dbt
columns:
  - name: IMDB_ID
    description: the key from the IMDB database
    meta:
      dimension:
        type: string
      metrics:
        count:
          type: count
          label: Number of movies
  - name: TITLE
    description: the title of the movie
    meta:
      dimension:
        type: string
        hidden: false
  - name: RELEASE_YEAR
    description: the year the movie was released. The source is the first non-null value from the two sources OMDB and TMDB.
    meta:
       dimension:
         type: number
         time_intervals: ['YEAR_NUM']
  - name: RUNTIME
    description: the runtime of the movie in minutes. The source is the first non-null value from the two sources OMDB and TMDB.
    meta:
      dimension:
        hidden: true
      metrics:
        average_runtime:
          type: average
        median_runtime:
          type: median
  - name: BUDGET
    description: the budget of the movie. The source is TMDB as this is the only source that provides this information. This is in USD as pf the release year of the movie.
    meta:
      dimension:
        hidden: true
      metrics:
        total_budget:
          type: sum
        average_budget:
          type: average
  - name: REVENUE
    description: the revenue of the movie. The source is the first non-null value from the two sources OMDB (column BOX_OFFICE) and TMDB. This is in USD as of the release year of the movie.
    meta:
      dimension:
        hidden: true
      metrics:
        total_revenue:
          type: sum
        average_revenue:
          type: average
  - name: DIRECTOR
    description: the director of the movie. The source is OMDB as this is the only source that provides this information. Some movies have multiple directors. There is no further splitting of the names as majority of the movies have only one director. THe field is also susceptible to typing errors as the names are not standardized.
    meta:
      dimension:
        hidden: false
        type: string
  - name: BUDGET
    description: the budget of the movie. The source is TMDB as this is the only source that provides this information. This is in USD as of the release year of the movie and should not be added across years as the value of the dollar changes in time.
    meta:
      dimension:
        hidden: true
  - name: REVENUE
    description: the revenue of the movie. The source is the first non-null value from the two sources OMDB (column BOX_OFFICE) and TMDB. This is in USD as of the release year of the movie and should not be added across years as the value of the dollar changes in time.
    meta:
      dimension:
        hidden: true
  - name: BUDGET_ADJUSTED
    description: the budget of the movie adjusted for inflation expressed in 2023 USD.
    meta:
      dimension:
        hidden: true
      metrics:
        total_budget_2023_USD:
          type: sum
          label: Total Budget (2023 USD)
          format: 'usd'
          compact: 'millions'
        average_budget_2023_USD:
          type: average
          label: Average Budget (2023 USD)
          format: 'usd'
          compact: 'millions'
  - name: REVENUE_ADJUSTED
    description: the revenue of the movie adjusted for inflation to 2023 USD.
    meta:
      dimension:
        hidden: true
      metrics:
        total_revenue_2023_USD:
          type: sum
          label: Total Revenue (2023 USD)
          format: 'usd'
          compact: 'millions'
        average_revenue_2023_USD:
          type: average
          label: Average Revenue (2023 USD)
          format: 'usd'
          compact: 'millions'
  - name: PROFIT_NET
    description: the profit of the movie. The difference between the adjusted revenue and the adjusted budget of the movie. Expressed in 2023 USD.
    meta:
      dimension:
        hidden: true
      metrics:
        total_profit:
          type: sum
          label: Total Net Profit (2023 USD)
          format: 'usd'
          compact: 'millions'
        average_profit:
          type: average
          label: Average Net Profit (2023 USD)
          format: 'usd'
          compact: 'millions'
  - name: HAS_PROFIT
    description: 1 if the movie is profitable, 0 otherwise
    meta:
      dimension:
        hidden: true
      metrics:
        count_profitable_movies:
          type: sum
          label: Number of profitable movies
  - name: HAS_LOSS
    description: 1 if the movie is loss-making, 0 otherwise
    meta:
      dimension:
        hidden: true
      metrics:
        count_loss_movies:
          type: sum
          label: Number of loss-making movies
  - name: PROFIT_2023_USD
    description: the profit of the movie. The difference between the adjusted revenue and the adjusted budget of the movie. Expressed in 2023 USD. Only for the profitable movies.
    meta:
      dimension:
        hidden: true
      metrics:
        total_profit_2023_USD:
          type: sum
          label: Total Profit (2023 USD)
          format: 'usd'
          compact: 'millions'
        total_profit_2023_USD_B:
          type: sum
          label: Total Profit (2023 USD Billions)
          format: 'usd'
          compact: 'billions'
        average_profit_2023_USD:
          type: average
          label: Average Profit (2023 USD)
          format: 'usd'
          compact: 'millions'
  - name: LOSS_2023_USD
    description: the loss of the movie. The difference between the adjusted revenue and the adjusted budget of the movie. Expressed in 2023 USD. Only for the loss-making movies.
    meta:
      dimension:
        hidden: true
      metrics:
        total_loss_2023_USD:
          type: sum
          label: Total Loss (2023 USD)
          format: 'usd'
          compact: 'millions'
        total_loss_2023_USD_B:
          type: sum
          label: Total Loss (2023 USD Billions)
          format: 'usd'
          compact: 'billions'
        average_loss_2023_USD:
          type: average
          label: Average Loss (2023 USD)
          format: 'usd'
          compact: 'millions'
  - name: IMDB_RATING
    description: the rating of the movie on IMDB. Scaled to a 0-1 scale.
    meta:
      dimension:
        hidden: true
      metrics:
        average_imdb_rating:
          type: average
  - name: ROTTEN_TOMATOES_RATING
    description: the rating of the movie on Rotten Tomatoes. Scaled to a 0-1 scale.
    meta:
      dimension:
        hidden: true
      metrics:
        average_rotten_tomatoes_rating:
          type: average
          label: Average Rotten Tomatoes Rating
  - name: METACRITIC_RATING
    description: the rating of the movie on Metacritic. Scaled to a 0-1 scale.
    meta:
      dimension:
        hidden: true
      metrics:
        average_metacritic_rating:
          type: average
          label: Average Metacritic Rating
  - name: NUMBER_OF_RATINGS_SOURCES
    description: the number of sources from which the ratings are available. This is used to calculate the COMBINED_RATING.
    meta:
      dimension:
        hidden: true
  - name: COMBINED_RATING
    description: the average of the IMDB, Rotten Tomatoes, and Metacritic ratings. Scaled to a 0-1 scale.
    meta:
      dimension:
        hidden: true
      metrics:
        average_combined_rating:
          type: average
          label: Average Combined Ratingo
          format: 'percent'
  - name: IMDB_VOTES
    description: the number of votes received on IMDB.
    meta:
      dimension:
        hidden: false
      metrics:
        total_imdb_votes:
          type: sum
          label: Total IMDB Votes
  - name: PRODUCTION_COMPANIES
    description: the production companies of the movie. The source is the first non-null value from the two sources TMDB and OMDB. THe latter has the values not null for 0.5% of the movies, while the former for 45%. THere cam be more than one comnpany for a movie. In such case they are listed in a comma-separated list.
    meta:
      dimension:
        hidden: false
        type: string
  - name: GENRES
    description: A coma separated the list of all distinct genres allocated to the movie in either source.
    meta:
      dimension:
        hidden: false
        type: string
```
*/
WITH CTE AS (
  SELECT
    COALESCE(T.IMDB_ID, O.IMDB_ID) AS IMDB_ID,
    COALESCE(T.TITLE, O.TITLE) AS TITLE,

    COALESCE(O.RELEASE_YEAR, T.RELEASE_YEAR) AS RELEASE_YEAR,
    COALESCE(O.RUNTIME, T.RUNTIME) AS RUNTIME,

    T.BUDGET,
    NULLIF(GREATEST(COALESCE(O.BOX_OFFICE, 0), COALESCE(T.REVENUE, 0)), 0) AS REVENUE,

    LEFT(COALESCE(O.POSTER_PATH, T.POSTER_PATH), 6) AS POSTER_PATH,

    {# (T.IMDB_ID IS NOT NULL) AS TMDB_EXISTS, #}
    {# (O.IMDB_ID IS NOT NULL) AS OMDB_EXISTS #}


    {# ?T.ORIGINAL_LANGUAGE, #}
    {# T.SPOKEN_LANGUAGES, #}
    {# O.LANGUAGE, #}
    {# O.COUNTRY,
    T.PRODUCTION_COUNTRY_NAMES, #}

    COALESCE(T.PRODUCTION_COMPANY_NAMES, O.PRODUCTION) AS PRODUCTION_COMPANIES,

    O.DIRECTOR,

    O.IMDB_RATING,
    O.ROTTEN_TOMATOES_RATING,
    O.METACRITIC_RATING,
    O.IMDB_VOTES

       {#O.WRITER,
       O.ACTORS, #}

       {# T.OVERVIEW,
       T.TAGLINE,
       T.KEYWORDS,
       O.PLOT,
       O.AWARDS, #}

       {# T.VOTE_AVERAGE,
       T.VOTE_COUNT,
       O.ROTTEN_TOMATOES_RATING,
       O.METACRITIC_RATING,
       O.NUMBER_OF_RATINGS_SOURCES,
       O.COMBINED_RATING, #}

  {# T.ORIGINAL_TITLE, #}
  {# T.STATUS, #}
  {# T.VIDEO, #}
  {# T.BELONGS_TO_COLLECTION, #}
  {# O.DVD, #}

  FROM {{ ref('int_omdb_movies_proper') }} AS O
  INNER JOIN {{ ref('int_tmdb_movies_proper') }} AS T ON O.IMDB_ID = T.IMDB_ID
),

CTE_FILTER AS (
  SELECT *
  FROM CTE
  WHERE RELEASE_YEAR BETWEEN 1920 AND 2023
),

CTE_GENRES_TO_STRING AS (
  SELECT
    IMDB_ID,
    LISTAGG(GENRE, ', ') AS GENRES
  FROM {{ ref('int_movies_genres') }}
  GROUP BY IMDB_ID
),

CTE_ADD_GENRES AS (
  SELECT
    C.*,
    G.GENRES
  FROM CTE_FILTER AS C
  LEFT JOIN CTE_GENRES_TO_STRING AS G ON C.IMDB_ID = G.IMDB_ID
),

CTE_TRANSFORM_SCORES AS (
  SELECT
    *,
    CASE WHEN IMDB_RATING IS NOT NULL THEN 1 ELSE 0 END
    + CASE WHEN ROTTEN_TOMATOES_RATING IS NOT NULL THEN 1 ELSE 0 END
    + CASE WHEN METACRITIC_RATING IS NOT NULL THEN 1 ELSE 0 END AS NUMBER_OF_RATINGS_SOURCES
  FROM CTE_ADD_GENRES
),

CTE_COMBINED_SCORES AS (
  SELECT
    *,
    CASE
      WHEN NUMBER_OF_RATINGS_SOURCES = 0 THEN NULL
      ELSE
        ROUND(((COALESCE(IMDB_RATING, 0) + COALESCE(ROTTEN_TOMATOES_RATING, 0) + COALESCE(METACRITIC_RATING, 0)) / NUMBER_OF_RATINGS_SOURCES), 2)
    END AS COMBINED_RATING
  FROM CTE_TRANSFORM_SCORES
),

CTE_INFLATION AS (
  SELECT
    M.*,
    I.INFLATION_MULTIPLIER,
    ROUND(M.BUDGET * I.INFLATION_MULTIPLIER, 0) AS BUDGET_ADJUSTED,
    ROUND(M.REVENUE * I.INFLATION_MULTIPLIER, 0) AS REVENUE_ADJUSTED
  FROM CTE_COMBINED_SCORES AS M
  LEFT JOIN {{ ref('inflation') }} AS I ON M.RELEASE_YEAR = I.YEAR
),

CTE_PROFIT AS (
  SELECT
    *,
    REVENUE - BUDGET AS PROFIT_NET
  FROM CTE_INFLATION
)

SELECT
  *,
  IFF(PROFIT_NET >= 0, 1, 0) AS HAS_PROFIT,
  IFF(PROFIT_NET < 0, 1, 0) AS HAS_LOSS,
  IFF(PROFIT_NET >= 0, PROFIT_NET, 0) AS PROFIT_2023_USD,
  IFF(PROFIT_NET < 0, PROFIT_NET, 0) AS LOSS_2023_USD
FROM CTE_PROFIT
