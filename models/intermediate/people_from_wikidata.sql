with actors_src as (
    select distinct
        person_identifier,
        person_name,
        date_of_birth,
        gender,
        'ACTOR' as job_role
    from 
        {{ref('stg_wikidata_actors')}} 
),

directors_src as (
    select distinct
        person_identifier,
        person_name,
        date_of_birth,
        gender,
        'DIRECTOR' as job_role
    from 
        {{ref('stg_wikidata_directors')}}     
),

all_people as (
    select 
        person_identifier,
        person_name,
        date_of_birth,
        gender,
        job_role
    from actors_src

    union

    select 
        person_identifier,
        person_name,
        date_of_birth,
        gender,
        job_role
    from directors_src

)

select distinct
    person_identifier,
    person_name,
    date_of_birth,
    gender,
    job_role
from 
    all_people