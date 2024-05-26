WITH source AS (
    SELECT 
        imdb_id
        , title
        , director
        , writer
        , actors
        , genre
        , language
        , country
        , type
        , plot
        , rated
        , ratings
        , metascore
        , imdb_rating
        , imdb_votes
        , released_date
        , release_year
        , runtime
        , dvd
        , box_office
        , poster
        , production
        , website
        , awards
        , tmdb_id
    FROM 
        {{ source('MOVIE_BASE', 'OMDB_MOVIES') }}
)

SELECT 
    * 
FROM 
    source
