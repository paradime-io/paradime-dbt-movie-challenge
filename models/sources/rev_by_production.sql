with production_unnest as (
select TRIM(b.value::string) AS production,
release_year,
ADJ_BOX_OFFICE
FROM
{{ source('PARADIME_MOVIE_CHALLENGE_FINAL', 'OMDB_INFLATION_ADJUSTED') }} a
,LATERAL FLATTEN(INPUT => SPLIT(a.production_companies, ',')) b
WHERE RELEASE_YEAR BETWEEN 1990 AND 2023

)

select production,
release_year,
ROUND(sum(ADJ_BOX_OFFICE),0) AS TOTAL_BOX_OFFICE, -- SHARED REVENUE
count(*) as total_films_by_production
from production_unnest
GROUP BY PRODUCTION, RELEASE_YEAR
HAVING TOTAL_BOX_OFFICE >0
ORDER BY PRODUCTION,RELEASE_YEAR