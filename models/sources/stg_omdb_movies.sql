WITH source AS (
    SELECT 
        IMDB_ID,
        TITLE,
        DIRECTOR,
        WRITER,
        ACTORS,
        GENRE,
        LANGUAGE,
        COUNTRY,
        TYPE,
        PLOT,
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
        POSTER,
        PRODUCTION,
        WEBSITE,
        AWARDS,
        TMDB_ID
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}
)
, rt_scores as (
    select
        imdb_id, 
        rats.value:Source, 
        -- get rotten tomatoes score from json object
        max(substring(rats.value:Value, 0, length(rats.value:Value)-1)::int) as rotten_tomatoes_score
    from source mov, lateral flatten (input => mov.ratings) rats
    where rats.value:Source = 'Rotten Tomatoes'
    group by 1, 2
)
SELECT 
    source.*,
    rt_scores.rotten_tomatoes_score
FROM 
    source
left join rt_scores
    on source.imdb_id = rt_scores.imdb_id
