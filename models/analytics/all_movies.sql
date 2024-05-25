-- One row per movie in the resulting table, including:
-- all relevant fields from dwh_movies
-- any summary data aggregated on a per-movie basis from other tables, eg. dwh_movie_people

with movies as (
    select 
        *
    from 
        {{ref('dwh_movies')}}
),

movie_people_summary as (
    select 
        imdb_id,
        --  release_year,
        TO_BOOLEAN(
            max(
                case 
                    when person_role = 'DIRECTOR' and gender = 'FEMALE' 
                        then 1 
                    else 0 
                end
            ) 
        ) as has_female_director
        --  person_name,
        --  person_role,
        --  person_role_details,
        --  date_of_birth,
        --  gender,
        --  person_age_on_release_date
    from 
        {{ref('dwh_movie_people')}}
    group by 
        imdb_id
)

select
    imdb_id,
    title,
    original_title,
    tagline,
    keywords,
    languages,
    original_language,
    genres,
    production_companies,
    production_countries,
    release_date,
    release_year,
    release_status,
    runtime,
    awards,
    dvd,
    budget,
    revenue,
    collection_name,
    imdb_votes,
    mp.has_female_director
from 
    movies as m
left join movie_people_summary as mp
    on mp.imdb_id = m.imdb_id
