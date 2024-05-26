with

source as (
    select 
        imdb_id,
        winner,  
        class,
        ceremony_year,
        nominee_ids
    from {{ ref('stg_davidlu__academy_awards') }}
),

remove_invalid_years as (
    select 
        *,
         iff(contains(ceremony_year, '/'), false, true) as valid_year_flag
    from source
    --  where contains(ceremony_year, '/')
    where valid_year_flag = true 
),

split_nominees as (
    select 
        imdb_id,
        iff(winner is null, false, winner) as is_winner,
        ceremony_year,
        class,
        value as person_id
    FROM remove_invalid_years as s, LATERAL SPLIT_TO_TABLE(s.nominee_ids, ',')
)

select *
from split_nominees
