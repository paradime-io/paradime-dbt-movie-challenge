WITH source AS (
    SELECT 
        tmdb_id
        , title
        , original_title
        , overview
        , tagline
        , keywords
        , original_language
        , status
        , video
        , release_date
        , runtime
        , budget
        , revenue
        , vote_average
        , vote_count
        , homepage
        , poster_path
        , backdrop_path
        , belongs_to_collection
        , imdb_id
        , genre_names
        , spoken_languages
        , production_company_names
        , production_country_names
    FROM 
        {{ source('MOVIE_BASE', 'TMDB_MOVIES') }}
)

SELECT 
    * 
FROM 
    source

