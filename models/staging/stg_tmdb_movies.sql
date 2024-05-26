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

, filtered AS (
    SELECT
        *
    FROM
        source
    WHERE
        status = 'Released'
        -- To avoid films with incorrect financial information
        AND budget IS NOT NULL 
        AND budget > 0 
        AND revenue > 0 
        AND budget <> revenue
)

SELECT 
    * 
    , year(release_date) AS release_year
FROM 
    filtered

