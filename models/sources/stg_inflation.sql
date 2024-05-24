/*
The source of this data is the Federal Reserve Bank of Minneapolis. https://www.minneapolisfed.org/about-us/monetary-policy/inflation-calculator/consumer-price-index-1913-
It orignaly contained the data for each year from 1913 to 2020, but is filtered here to start in 1920.
Since inflation rate is a rate of chage, it is not calculated for the first year in the dataset (1913).

```dbt
columns:
  - name: YEAR
  - name: CPI
    description: the Annual Average of the consumer price index for the given year.
```
*/

SELECT
  YEAR,
  CPI
FROM {{ ref('seed_inflation') }}
WHERE
  1 = 1
  AND YEAR >= 1920
