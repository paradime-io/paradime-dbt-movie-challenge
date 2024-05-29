WITH source AS (
    SELECT 
        NCONST as imdb_name_id,
        PRIMARYNAME as primary_name,
        BIRTHYEAR as birth_year,
        DEATHYEAR as death_year,
        PRIMARYPROFESSION as primary_profession,
        KNOWNFORTITLES as known_for_titles
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_NAME_BASIC') }}
)

SELECT 
    * 
FROM 
    source