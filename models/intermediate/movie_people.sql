with movies_src as (
    select 
        imdb_id,
        release_year,
        director,
        writer,
        actors
    from 
        {{ref('all_movies_combined_columns')}} -- could also use all_movies_combined_columns but don't need to combine columns for director, writer, actors
),

all_movies_and_people  as (
    SELECT 
        imdb_id,
        release_year,
        trim(dir.value) AS person_name,
        'DIRECTOR' AS person_role
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(director, ',') AS dir

    UNION	

    SELECT 
        imdb_id,
        release_year,
        trim(wri.value) AS person_name,
        'WRITER' AS person_role
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(writer, ',') AS wri

    UNION

    SELECT 
        imdb_id,
        release_year,
        trim(act.value) AS person_name,
        'ACTOR' AS person_role
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(actors, ',') AS act
),

deduped as (
    SELECT
        imdb_id,
        release_year,
        person_name,
        person_role,
    FROM
        all_movies_and_people
    QUALIFY ROW_NUMBER() OVER (
            PARTITION BY imdb_id, release_year, person_name, person_role
            ORDER BY imdb_id -- this is arbitrary
        ) = 1
),

-- In some cases there are details about the role after the person's name, in parentheses
-- Eg. A director may appear as "Joe Bloggs (co-director)"
-- Extract this information and insert into PERSON_ROLE_DETAILS field
role_details as (
    SELECT
        *,
        case 
            when person_role = 'DIRECTOR' OR person_role = 'WRITER'
                then REGEXP_REPLACE(REGEXP_SUBSTR(PERSON_NAME, '\\(\.\*\\)$'), '\\(|\\)', '')
            else 
                NULL
        end as person_role_details
    FROM 
        deduped
),

-- Update the PERSON_NAME value to remove any extra information about the role in parentheses
-- Will use PERSON_NAME to generate a unique identifier so only want each person appearing once.
-- "Joe Bloggs" is the same person as "Joe Bloggs (co-director)"
cleaned as (
    select 
        imdb_id,
        release_year,
        case 
            when person_role_details is not null 
                then RTRIM(REGEXP_REPLACE(REPLACE(person_name, person_role_details, ''), '\\(|\\)', '')) 
            else 
                person_name
            end as person_name,
        person_role,
        UPPER(person_role_details) as person_role_details
    from 
        role_details
    where 
        person_name != 'N/A'
),

-- Some people names appear in the movie dataset in a format that does not match names in wikidata.
-- Update these names to wikidata format to help with matching later on
names_fixed as (
    select 
        imdb_id,
        release_year,
        IFNULL(names.to_name, person_name) as person_name,
        person_role,
        person_role_details
    from 
        cleaned
    left join {{ref('person_name_fixes')}} as names 
        on names.from_name = cleaned.person_name

)

select 
    imdb_id,
    release_year,
    person_name,
    person_role,
    person_role_details
from 
    names_fixed