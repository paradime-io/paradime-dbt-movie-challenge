-- Note that it's not always correct to split by comma - some production companies have commas in their name

with movies_src as (
    select 
        identifier_unique_key,
        production_companies
    from 
        {{ref('all_movies_combined_columns')}}
),

all_movies_and_production_companies  as (
    SELECT 
        identifier_unique_key as movie_id,
        trim(prod.value) AS production_company
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(production_companies, ',') AS prod
),

top_production_companies_flagged as (
    SELECT
        src.movie_id,
        src.production_company,
        CASE 
            WHEN tpc.production_company IS NOT NULL 
                THEN TRUE
            ELSE FALSE
        END AS is_top_production_company
    FROM 
        all_movies_and_production_companies as src
    LEFT JOIN {{ref('top_production_companies')}} as tpc
        ON tpc.production_company = src.production_company
)

select 
    movie_id,
    production_company,
    is_top_production_company
from 
    top_production_companies_flagged