/*
Presentation model to show the net profit of modern superhero vs non superhero movies by year. Only movies with the PRODUCTION_COMPANIES not null are considered.

```dbt
columns:
  - name: IS_SUPERHERO
    description: a boolean indicating if the movie is a superhero movie. This is determined if the movie was produced by Marvel Studios or DC Comics.
    meta:
      dimension:
        type: boolean
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
  - name: RELEASE_YEAR
    description: the year the movie was released
    meta:
      dimension:
        type: number
        format: id
  - name: NUMBER_OF_MOVIES
    description: the number of released movies
    meta:
      dimension:
        hidden: true
      metrics:
        number_of_movies:
          type: sum
          label: Number of Movies
  - name: REVENUE
    description: the revenue of the movie. Expressed in 2023 USD.
    meta:
      dimension:
        hidden: true
      metrics:
        total_revenue:
          type: sum
          label: Total Revenue (2023 USD)
          format: 'usd'
          compact: 'millions'
```
*/

SELECT
  RELEASE_YEAR,
  CASE
    WHEN PRODUCTION_COMPANIES LIKE '%Marvel Studios%' THEN TRUE
    WHEN PRODUCTION_COMPANIES LIKE '%DC Comics%' THEN TRUE
    ELSE FALSE
  END AS IS_SUPERHERO,
  SUM(PROFIT_NET) AS PROFIT_NET,
  SUM(REVENUE_ADJUSTED) AS REVENUE,
  COUNT(*) AS NUMBER_OF_MOVIES
FROM {{ ref('movies') }}
GROUP BY ALL
