-- Could just move the logic from "people" model into here but unsure 
-- if extra logic will be needed in this step
with src as (
    select 
        person_id,
        person_name,
        date_of_birth,
        gender
    from 
        {{ref('people')}}
)
select 
    *
from 
    src