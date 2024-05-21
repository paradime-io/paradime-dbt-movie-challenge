WITH extracted as (
    select 
        SPLIT_PART(JSON_EXTRACT_PATH_TEXT(HUMAN, 'value'), '/', -1)AS person_identifier,
        JSON_EXTRACT_PATH_TEXT(HUMANLABEL, 'value') AS person_name,
        TO_DATE(LEFT(JSON_EXTRACT_PATH_TEXT(DOB, 'value'), 10), 'yyyy-mm-dd') AS date_of_birth,
        UPPER(JSON_EXTRACT_PATH_TEXT(GENDERLABEL, 'value')) AS gender
    from 
        {{ source('ADDITIONAL_SOURCE_DATA', 'WIKIDATA_ACTORS') }}
),

-- Choose the earliest DOB for each person. In many cases where two DOB values are assigned to one
-- person, the one we need to discard is '2000-01-01'
deduplicated AS (
    SELECT 
        person_identifier,
        person_name,
        date_of_birth,
        gender,
        ROW_NUMBER() OVER (
            PARTITION BY person_identifier
            ORDER BY date_of_birth
        ) as date_of_birth_row_number,
    FROM 
        extracted
    QUALIFY
        date_of_birth_row_number = 1
)

-- It appears that a DOB of 2000-01-01 is used as a default when not known so remove all 
SELECT 
    person_identifier,
    person_name,
    case 
        when date_of_birth = '2000-01-01' 
            then null 
        else date_of_birth 
    end as date_of_birth,
    gender
FROM 
    deduplicated
