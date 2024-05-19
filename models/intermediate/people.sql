with people_src as (
    select distinct
        person_id,
        person_name,
        person_role
    from 
        {{ref('movie_people')}} -- could also use all_movies_combined_columns but don't need to combine columns for director, writer, actors
),

people_enriched_directors  as (
    select 
        src.person_id,
        src.person_name,
        src.person_role,
        dir.date_of_birth,
        dir.gender
    from 
        people_src as src
    left join {{ref('stg_wikidata_directors')}} as dir 
        on dir.person_name = src.person_name
),

people_enriched_actors as (
    select 
        src.person_id,
        src.person_name,
        src.person_role,
        case 
            when src.person_role = 'ACTOR' 
                or src.date_of_birth is null 
                    then act.date_of_birth
            else src.date_of_birth
        end as date_of_birth,
        case 
            when src.person_role = 'ACTOR' 
                or src.gender is null 
                    then act.gender
            else src.gender
        end as gender
    from 
        people_enriched_directors as src
    left join {{ref('stg_wikidata_actors')}} as act
        on act.person_name = src.person_name
)

select distinct
    person_id,
    person_name,
    date_of_birth,
    gender
from 
    people_enriched_directors