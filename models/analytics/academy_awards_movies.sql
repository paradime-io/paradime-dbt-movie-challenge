with awards as (
    select 
        movie_title,
        imdb_id,
        director_person_identifier,
        director_name,
        director_date_of_birth,
        datediff('YEAR', director_date_of_birth, award_date) as director_age,
        director_gender,
        person_identifier,
        person_name,
        person_date_of_birth,
        datediff('YEAR', person_date_of_birth, award_date) as person_age,
        person_gender,
        award_title,
        award_edition,
        award_date,
        nominated,
        won
    from
        {{ref('dwh_academy_awards')}}
),

movies as (
    select 
        imdb_id,
        title,
        languages,
        original_language,
        release_date,
        release_year,
        runtime,
        awards,
        budget,
        revenue,
        imdb_votes,
        imdb_rating,
        rotten_tomatoes_rating,
        metacritic_rating,
        bechdel_rating
    from 
        {{ref('dwh_movies')}}
)

select 
    a.movie_title,
    a.imdb_id,
    a.director_person_identifier,
    a.director_name,
    a.director_date_of_birth,
    a.director_age,
    a.director_gender,
    a.person_identifier,
    a.person_name,
    a.person_date_of_birth,
    a.person_age,
    a.person_gender,
    a.award_title,
    a.award_edition,
    a.award_date,
    a.nominated,
    a.won,
    m.title,
    m.languages,
    m.original_language,
    m.release_date,
    m.release_year,
    m.runtime,
    m.awards,
    m.budget,
    m.revenue,
    m.imdb_votes,
    m.imdb_rating,
    m.rotten_tomatoes_rating,
    m.metacritic_rating,
    m.bechdel_rating
from 
    awards as a 
left join movies as m 
    on m.imdb_id = a.imdb_id