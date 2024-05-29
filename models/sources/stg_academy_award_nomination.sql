WITH source AS (
    SELECT 
        AWARDNAME AS award_name,
        AWARDNOMINATIONID AS award_nomination_id,
        CATEGORYNAME AS category_name,
        ISWINNER AS is_winner,
        PRIMARYNOMINEECONST AS primary_nominee_id,
        PRIMARYNOMINEENAME AS primary_nominee_name,
        SECONDARYNOMINEECONST AS secondary_nominee_id,
        SECONDARYNOMINEENAME AS secondary_nominee_name,
        YEAR
    FROM 
        {{ source('ADDITIONAL_DATA', 'ACADEMY_AWARD_NOMINATION') }}
)

SELECT 
    * 
FROM 
    source