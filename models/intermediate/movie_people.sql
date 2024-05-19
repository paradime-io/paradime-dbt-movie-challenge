with movies_src as (
    select 
        identifier_unique_key as movie_id,
        omdb_director,
        omdb_writer,
        omdb_actors
    from 
        {{ref('join_omdb_and_tmdb')}} -- could also use all_movies_combined_columns but don't need to combine columns for director, writer, actors
),

all_movies_and_people  as (
    SELECT 
        movie_id,
        trim(dir.value) AS person_name,
        'DIRECTOR' AS person_role
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(omdb_director, ',') AS dir

    UNION	

    SELECT 
        movie_id,
        trim(wri.value) AS person_name,
        'WRITER' AS person_role
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(omdb_writer, ',') AS wri

    UNION

    SELECT 
        movie_id,
        trim(act.value) AS person_name,
        'ACTOR' AS person_role
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(omdb_actors, ',') AS act
),

deduped as (
    SELECT
        *
    FROM
        all_movies_and_people
    QUALIFY ROW_NUMBER() OVER (
            PARTITION BY movie_id, person_name, person_role
            ORDER BY movie_id -- this is arbitrary
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
        movie_id,
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
        movie_id,
        IFNULL(names.to_name, person_name) as person_name,
        person_role,
        person_role_details
    from 
        cleaned
    left join {{ref('person_name_fixes')}} as names 
        on names.from_name = cleaned.person_name

),

identified as (
    select 
        movie_id,
        {{ dbt_utils.generate_surrogate_key([
                'person_name'
            ])
        }} as person_id,
        person_name,
        person_role,
        person_role_details
    from 
        names_fixed
)
select 
    movie_id,
    person_id,
    person_name,
    person_role,
    person_role_details
from 
    identified