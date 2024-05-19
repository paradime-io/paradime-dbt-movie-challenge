with src as (
    select 
        person_id,
        person_name,
        date_of_birth,
        gender
    from 
        {{ref('people')}}
)