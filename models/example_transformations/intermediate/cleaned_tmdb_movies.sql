with numed as (
    select 
        TMDB_ID,
        TITLE,
        ORIGINAL_LANGUAGE,
        STATUS,
        VIDEO,
        RELEASE_DATE,
        RUNTIME,
        BUDGET,
        REVENUE,
        VOTE_AVERAGE,
        VOTE_COUNT, 
        BELONGS_TO_COLLECTION,
        IMDB_ID,
        GENRE_NAMES,
        SPOKEN_LANGUAGES,
        PRODUCTION_COMPANY_NAMES,
        PRODUCTION_COUNTRY_NAMES,
        row_number() over(partition by TMDB_ID order by TMDB_ID) as row_num 
    from 
        {{ ref('stg_tmdb_movies') }} 
)

select
    * 
from 
    numed
where
    row_num = 1