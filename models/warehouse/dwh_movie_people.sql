-- The resulting table should look exactly like movie_people but with the addition of
-- a datediff field person_age_on_release_date

with src as (
    select 
        movie_id,
        person_id,
        person_name,
        person_role,
        person_role_details
    from 
        {{ref('movie_people')}}
), 

movie_release_dates as (
    select 
        identifier_unique_key as movie_id,
        release_year,
        coalesce(release_date, to_date(concat(release_year, '-01-01'), 'yyyy-mm-dd')) as release_date,
    from
        {{ref('all_movies_combined_columns')}}
),

people_dob as (
    select 
        person_id,
        date_of_birth
    from 
        {{ref('people')}}
), 

joined as (
    select
        src.movie_id,
        src.person_id,
        src.person_name,
        src.person_role,
        src.person_role_details,
        datediff('YEAR', dob.date_of_birth, rel.release_date) as person_age_on_release_date
    from 
        src
    join movie_release_dates as rel 
        on rel.movie_id = src.movie_id
    left join people_dob as dob 
        on dob.person_id = src.person_id
)
select 
    *
from 
    joined