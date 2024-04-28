WITH omdb AS (
    select *
    from {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}
)

, cleaned_omdb as (
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
        TMDB_ID,
        regexp_substr(awards, '\\d{1,3} win') AS award_wins,
        regexp_substr(awards, '\\d{1,3} nominations') AS nominations,
        regexp_substr(awards, '\\d{1,3} Oscar') AS oscars,
        regexp_substr(awards, '\\d{1,3} Primetime Emmy') AS primetime_emmys,
        regexp_substr(awards, '\\d{1,3} Golden Globe') AS golden_globes,
        regexp_substr(awards, '\\d{1,3} BAFTA') AS baftas,
        coalesce(regexp_substr(award_wins, '\\d{1,3}'), 0)::int AS num_award_wins,
        coalesce(regexp_substr(nominations, '\\d{1,3}'), 0)::int AS num_nominations,
        coalesce(regexp_substr(oscars, '\\d{1,3}'), 0)::int AS num_oscars,
        coalesce(regexp_substr(primetime_emmys, '\\d{1,3}'), 0)::int AS num_primetime_emmys,
        coalesce(regexp_substr(golden_globes, '\\d{1,3}'), 0)::int AS num_golden_globes,
        coalesce(regexp_substr(baftas, '\\d{1,3}'), 0)::int AS num_baftas

    FROM omdb
)
, rt_scores as (
    select
        imdb_id, 
        rats.value:Source, 
        -- get rotten tomatoes score from json object
        max(substring(rats.value:Value, 0, length(rats.value:Value)-1)::int) as rotten_tomatoes_score
    from omdb mov, lateral flatten (input => mov.ratings) rats
    where rats.value:Source = 'Rotten Tomatoes'
    group by 1, 2
)
SELECT 
    cleaned_omdb.*,
    rt_scores.rotten_tomatoes_score
FROM 
    cleaned_omdb
left join rt_scores
    on cleaned_omdb.imdb_id = rt_scores.imdb_id
