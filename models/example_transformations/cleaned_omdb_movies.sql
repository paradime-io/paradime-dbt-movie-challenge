with numed as (
    select 
        IMDB_ID,
        TITLE,
        DIRECTOR,
        WRITER,
        ACTORS,
        GENRE,
        LANGUAGE,
        COUNTRY,
        TYPE,
        RATED,
        RATINGS,
        METASCORE,
        IMDB_RATING,
        IMDB_VOTES,
        RELEASED_DATE,
        RELEASE_YEAR,
        RUNTIME,
        DVD,
        BOX_OFFICE,
        PRODUCTION,
        AWARDS,
        TMDB_ID,
        row_number() over(partition by IMDB_ID order by IMDB_ID) as row_num 
    from 
        {{ ref('stg_omdb_movies') }} 
)

select
    * 
from 
    numed
where
    TITLE <> '#DUPE#' and
    row_num = 1 