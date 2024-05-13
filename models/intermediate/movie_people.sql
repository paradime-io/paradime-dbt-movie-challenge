with movies_src as (
    select 
        identifier_unique_key,
        omdb_director,
        omdb_writer,
        omdb_actors
    from 
        {{ref('join_omdb_and_tmdb')}} -- could also use all_movies_combined_columns but don't need to combine columns for director, writer, actors
),

all_movies_and_people  as (
    SELECT 
        identifier_unique_key,
        trim(dir.value) AS person_name,
        'DIRECTOR' AS person_role
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(omdb_director, ',') AS dir

    UNION	

    SELECT 
        identifier_unique_key,
        trim(wri.value) AS person_name,
        'WRITER' AS person_role
    FROM movies_src,
        LATERAL SPLIT_TO_TABLE(omdb_writer, ',') AS wri

    UNION

    SELECT 
        identifier_unique_key,
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
            PARTITION BY identifier_unique_key, person_name, person_role
            ORDER BY identifier_unique_key -- this is arbitrary
        ) = 1
),

cleaned as (
    select 
        identifier_unique_key as movie_id,
        {{ dbt_utils.generate_surrogate_key([
                'person_name'
            ])
        }} as person_id,
        person_name,
        person_role
    from 
        deduped
    where 
        person_name != 'N/A'

)

select 
    *
from 
    cleaned