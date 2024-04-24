WITH source AS (
    SELECT 
        IMDB_ID,
	    TYPE,
	    PRIMARY_TITLE,
	    ORIGINAL_TITLE,
	    IS_ADULT,
	    START_YEAR,
	    END_YEAR,
	    RUNTIME_MINUTES,
	    GENRES
    FROM 
        {{ source('ADDITIONAL_SOURCES', 'IMDB_BASICS_MOVIES') }}
)

SELECT 
    * 
FROM 
    source
