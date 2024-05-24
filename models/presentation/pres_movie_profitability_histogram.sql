/*
This model is used to create a histogram of the PROFIT_NET of the movies. The PROFIT_NET is grouped into ranges and the number of movies in each range is calculated. 
The ranges are $5M increments from $0 to $250M and a range for movies with a PROFIT_NET less than $0 and a range for movies with a PROFIT_NET of $250M or more.
All calculations are done in 2023 USD.

```dbt
columns:
  - name: PROFIT_RANGE
    description: The range of the PROFIT_NET of the movie. Expressed in 2023 USD.
    meta:
      dimension:
        type: string
  - name: FREQUENCY
    description: The number of movies in the PROFIT_NET range
    meta:
      metrics:
        number_of_movies:
          type: sum
          label: Number of movies
  - name: SORTING_ORDER
    description: The sorting order of the PROFIT_NET range
    meta:
      dimension:
        type: number
        format: id
```
*/

WITH CTE AS (
  SELECT PROFIT_NET
  FROM {{ ref('movies') }}
  WHERE
    1 = 1
    AND PROFIT_NET IS NOT NULL
)

SELECT
  CASE
    WHEN PROFIT_NET < 0 THEN 'Negative'
    WHEN PROFIT_NET >= 250000000 THEN '250M+'
    ELSE CONCAT(FLOOR(PROFIT_NET / 5000000) * 5, 'M - ', (FLOOR(PROFIT_NET / 5000000) + 1) * 5, 'M')
  END AS PROFIT_RANGE,
  COUNT(*) AS FREQUENCY,
  CASE
    WHEN PROFIT_NET < 0 THEN -1
    WHEN PROFIT_NET >= 250000000 THEN 999
    ELSE FLOOR(PROFIT_NET / 5000000)
  END AS SORTING_ORDER
FROM CTE
GROUP BY PROFIT_RANGE, SORTING_ORDER
ORDER BY SORTING_ORDER
