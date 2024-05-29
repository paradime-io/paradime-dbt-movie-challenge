WITH source AS (
    SELECT 
        TCONST as imdb_id,
        TITLETYPE as title_type,
        PRIMARYTITLE as primary_title,
        ORIGINALTITLE as original_title,
        ISADULT as is_adult,
        STARTYEAR as start_year,
        ENDYEAR as end_year,
        RUNTIMEMINUTES as runtime_minute_total,
        genres
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_TITLE_BASIC') }}
)

SELECT 
    * 
FROM 
    source