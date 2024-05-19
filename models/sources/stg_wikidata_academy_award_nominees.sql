WITH source AS (
    SELECT 
        HUMANLABEL AS person_name,
        AWARDEDITIONLABEL as award_edition,
        TO_DATE(AWARDS_TIMESTAMP) as award_date,
        AWARDLABEL as award_title,
        AWARDWORKLABEL as film_title,
        IMDBID as IMDB_ID,
        DIRECTORLABEL as director_name
    FROM 
        {{ source('ADDITIONAL_SOURCE_DATA', 'WIKIDATA_ACADEMY_AWARD_NOMINEES') }}
)

SELECT 
    * 
FROM 
    source
