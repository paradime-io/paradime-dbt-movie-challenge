    SELECT    
        IMDB_ID, -- Select IMDB_ID from omdb as it's common
        GENRE,
        md_title,
        DIRECTOR,
        RELEASE_YEAR,
        wins,
        nominations,
        COUNTRY,
        ORIGINAL_TITLE,
        PRODUCTION_COMPANY_NAMES,
        PRODUCTION_COUNTRY
    FROM
        {{ ref('int_join_tmdb_omdb') }} 