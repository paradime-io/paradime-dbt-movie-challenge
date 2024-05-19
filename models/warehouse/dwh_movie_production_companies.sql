-- Might delete this as it's not correct to split by comma - some production companies have commas in their name

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
)

--  consolidated as (
--      SELECT
--          movie_id,
--          replace(genre, 'Sci-Fi', 'Science Fiction') as genre
--      FROM 
--          all_movies_and_genres
--  )

select 
    movie_id,
    production_company
from 
    all_movies_and_production_companies