/*
Only 12k out of 520k movies in the movies model have both budget and revenue information. This model is filtered to include only those movies.
Although this is a small (3) precentage of the total, it is biased towards more popular movies with higher budget and revenue. Small budget movies are less likely to have revenue information.
It can still be deemed representative of the population of relevant, professional movies.

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
  - name: RELEASE_YEAR
    description: the year the movie was released. The source is the first non-null value from the two sources OMDB and TMDB.
    meta:
      dimension:
        type: number
        format: id
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
        average_budget_2023_USD:
          type: average
          label: Average Budget (2023 USD)
          format: 'usd'
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
        average_revenue_2023_USD:
          type: average
          label: Average Revenue (2023 USD)
          format: 'usd'
  - name: PROFIT
    description: the profit of the movie. The difference between the adjusted revenue and the adjusted budget of the movie. Expressed in 2023 USD.
    meta:
      dimension:
        hidden: true
      metrics:
        total_profit:
          type: sum
          label: Total Profit (2023 USD)
          format: 'usd'
        average_profit:
          type: average
          label: Average Profit (2023 USD)
          format: 'usd'
        median_profit:
          type: median
          label: Median Profit (2023 USD)
          format: 'usd'
```
*/
SELECT
  *,
  PROFIT_NET AS PROFIT
FROM {{ ref('movies') }}
