with movie_people as (
    select 
        movie_id,
        release_year,
        person_name,
        person_role,
        person_role_details
    from 
        {{ref('movie_people')}} 
),

people_from_wikidata as (
    select
        person_identifier,
        person_name,
        date_of_birth,
        gender,
        job_role
    from {{ref('people_from_wikidata')}}
),

people_with_unique_name as (
    select 
        person_name
    from 
        people_from_wikidata
    group by person_name
    having count(*) = 1 

),

joined_unique_name as (
    select 
        mp.movie_id,
        mp.release_year,
        mp.person_name,
        mp.person_role,
        mp.person_role_details,
        wp.person_identifier,
        wp.date_of_birth,
        wp.gender
    from 
        movie_people as mp
    left join people_with_unique_name as j
        on j.person_name = mp.person_name
    left join people_from_wikidata as wp
        on wp.person_name = j.person_name
),

people_with_unique_name_and_role as (
    select 
        person_name,
        job_role
    from 
        people_from_wikidata
    group by person_name, job_role
    having count(*) = 1
),

-- First match on name and job role where they are unique and match
joined_unique_name_and_role as (
    select 
        mp.movie_id,
        mp.release_year,
        mp.person_name,
        mp.person_role,
        mp.person_role_details,
        nvl(mp.person_identifier, wp.person_identifier) as person_identifier,
        nvl(mp.date_of_birth, wp.date_of_birth) as date_of_birth,
        nvl(mp.gender, wp.gender) as gender
    from 
        joined_unique_name as mp
    left join people_with_unique_name_and_role as j
        on j.person_name = mp.person_name
            and j.job_role = mp.person_role
            and mp.date_of_birth is null -- we didn't find a match last join
    left join people_from_wikidata as wp
        on wp.person_name = j.person_name
            and wp.job_role = j.job_role
)

select 
    movie_id,
    release_year,
    person_name,
    person_role,
    person_role_details,
    person_identifier,
    date_of_birth,
    gender
from 
    joined_unique_name_and_role