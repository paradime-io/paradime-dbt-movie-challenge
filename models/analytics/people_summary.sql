-- One row per person in the resulting table, including:
-- all relevant fields from dwh_movie_people
-- any summary data aggregated on a per-person basis from other tables, eg. dwh_movies

with movie_people as (
    select 
        imdb_id,
        release_year,
        person_name,
        person_role,
        person_role_details,
        person_identifier,
        date_of_birth,
        gender,
        person_age_on_release_date
    from 
        {{ref('dwh_movie_people')}}
),

movies as (
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
        imdb_rating,
        rotten_tomatoes_rating,
        metacritic_rating,
        bechdel_rating
    from 
        {{ref('dwh_movies')}}
)

select
    mp.imdb_id,
    mp.person_name,
    mp.person_role,
    mp.person_role_details,
    mp.person_identifier,
    mp.date_of_birth,
    mp.gender,
    mp.person_age_on_release_date,
    m.original_language,
    m.release_date,
    m.release_year,
    {{target.schema}}.f_get_decade_from_year(m.release_year) as release_decade,
    m.runtime,
    m.awards,
    m.budget,
    m.revenue,
    m.imdb_votes,
    m.imdb_rating,
    m.rotten_tomatoes_rating,
    m.metacritic_rating,
    m.bechdel_rating,
    mc.production_country
from 
    movie_people as mp
join movies as m
    on m.imdb_id = mp.imdb_id
left join {{ref('dwh_movie_countries')}} as mc 
    on mc.imdb_id = mp.imdb_id
