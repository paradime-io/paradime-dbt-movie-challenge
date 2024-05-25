with movies_src as (
    select 
        imdb_id,
        production_countries
    from 
        {{ref('all_movies_combined_columns')}}
),

all_movies_and_countries  as (
    SELECT 
        imdb_id,
        trim(country.value) AS production_country
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(production_countries, ',') AS country
),

consolidated as (
    SELECT
        imdb_id,
        IFNULL(country_lookup.to_name, countries.production_country) as production_country
    FROM 
        all_movies_and_countries as countries
    LEFT JOIN {{ref('movie_country_consolidation')}} as country_lookup
        ON country_lookup.from_name = countries.production_country
)

select 
    imdb_id,
    production_country
from 
    consolidated