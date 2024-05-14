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

role_details as (
    SELECT
        *,
        REGEXP_REPLACE(REGEXP_SUBSTR(PERSON_NAME, '\\(\.\*\\)$'), '\\(|\\)', '') as person_role_details
    FROM 
        deduped
    WHERE  
        person_role = 'DIRECTOR'
        OR person_role = 'WRITER'
),

cleaned as (
    select 
        movie_id,
        RTRIM(REGEXP_REPLACE(REPLACE(person_name, person_role_details, ''), '\\(|\\)', '')) as person_name,
        person_role,
        UPPER(person_role_details) as person_role_details
    from 
        role_details
    where 
        person_name != 'N/A'
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
        cleaned
)

select 
    *
from 
    identified