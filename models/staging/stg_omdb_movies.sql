WITH source AS (
    SELECT 
        IMDB_ID,
        TMDB_ID,
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
        AWARDS
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}
)

/* How many records are there?
527323
*/
--  select count(*) from source

/* Which ID should we use? 
    - both have nulls, lets dig deeper
*/
--  select
--      count(distinct tmdb_id) = count(*) as TMDB_ID_count,
--      count(distinct imdb_id) = count(*) as IMDB_ID_count,
--  from source

/*Are there any rows with both ids null?
    - there are not. That means its always one or the other.
*/
--  select
--      count(distinct tmdb_id) as TMDB_ID_count,
--      count(distinct imdb_id) as IMDB_ID_count,
--      sum(case when tmdb_id is null and imdb_id is null then 1 else 0 end) as null_count,
--  from source

select * from source
