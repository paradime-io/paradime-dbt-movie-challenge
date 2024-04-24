WITH source AS (
    SELECT
    TMDB_ID, 
        TITLE, 
        ORIGINAL_TITLE, 
        OVERVIEW, 
        TAGLINE, 
        KEYWORDS, 
        RELEASE_DATE, 
        RUNTIME,
        BUDGET,
        REVENUE, 
        VOTE_AVERAGE, 
        IMDB_ID, 
        GENRE_NAMES, 
    FROM 
        {{source('PARADIME_MOVIE_CHALLENGE','TMDB_MOVIES')}}      
    
)
SELECT 
    * 
FROM source 
