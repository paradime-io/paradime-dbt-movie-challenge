-- The resulting table should look exactly like movie_people but with the addition of
-- a datediff field person_age_on_release_date

with src as (
    select 
        imdb_id,
        release_year,
        person_name,
        person_role,
        person_role_details,
        person_identifier,
        date_of_birth,
        gender,
        case 
            when date_of_birth is null or release_year is null
                then null
            else release_year - YEAR(date_of_birth)
        end as person_age_on_release_date
    from 
        {{ref('join_movie_people_and_wikidata_people')}}
)

select 
    *
from 
    src