/*
This model calculates the inflation multiplier for each year in the dataset. The inflation multiplier is the factor by which a value in USD in the given year should be multiplied to get the equivalent value in USD in 2023.
The inflation multiplier is calculated as the cumulative product of (1 + inflation rate) for each year from the given year to 2023.
For the years above 2023 the inflation multiplier is set to 1.0.
This dataset need to be updated yearly.

```dbt
columns:
  - name: YEAR
  - name: INFLATION_RATE
    description: the Annual Percent Change of the CPI between the given year and the previous year. The difference between the price of a basket of good in the current year and the previous year divided by that price in the previous year.
  - name: INFLATION_MULTIPLIER
    description: the multiplier to apply to a value in USD in the given year to get the equivalent value in 2023 USD.
```
*/

WITH

CTE_BASE AS (
  SELECT CPI AS CPI_2023
  FROM {{ ref('stg_inflation') }}
  WHERE
    1 = 1
    AND YEAR = 2023
),

CTE_MATH AS (
  SELECT
    I.YEAR,
    I.CPI,
    B.CPI_2023 / I.CPI AS INFLATION_MULTIPLIER
  FROM {{ ref('stg_inflation') }} AS I
  CROSS JOIN CTE_BASE AS B
  WHERE I.YEAR < EXTRACT(YEAR FROM CURRENT_DATE)
),

CTE_MISSING_YEARS AS (
  SELECT
    Y.DATE_YEAR AS YEAR,
    0.0 AS INFLATION_RATE,
    1.0 AS INFLATION_MULTIPLIER
  FROM {{ ref('all_years') }} AS Y
  WHERE
    1 = 1
    AND Y.DATE_YEAR > 2023
),

CTE_UNION AS (
  SELECT *
  FROM CTE_MATH
  UNION ALL
  SELECT *
  FROM CTE_MISSING_YEARS
)

SELECT *
FROM CTE_UNION
