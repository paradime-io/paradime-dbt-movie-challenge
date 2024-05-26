with 

source as (
    select 
        imdb_id,
        is_winner,  
        class,
        cast(ceremony_year as int) as ceremony_year,
        person_id
    from {{ ref('int_academy_awards_transformed') }}
),

filtered as (
    select *
    from source
    where ceremony_year >= {{ var('start_year') }} 
        -- released movies are granted awards in the following year
        and ceremony_year <= {{ var('end_year') }} + 1  
)

SELECT * 
FROM filtered
