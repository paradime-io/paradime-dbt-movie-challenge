WITH source AS (
    SELECT 
        SPLIT_PART(HUMAN, '/', -1) as person_identifier,
        HUMANLABEL AS person_name,
        AWARDEDITIONLABEL as award_edition,
        TO_DATE(AWARDS_TIMESTAMP) as award_date,
        AWARDLABEL as award_title,
        AWARDWORKLABEL as film_title,
        IMDBID as IMDB_ID,
        SPLIT_PART(DIRECTOR, '/', -1) as director_person_identifier,
        DIRECTORLABEL as director_name
    FROM 
        {{ source('ADDITIONAL_SOURCE_DATA', 'WIKIDATA_ACADEMY_AWARD_NOMINEES') }}
)

SELECT 
    * 
FROM 
    source
