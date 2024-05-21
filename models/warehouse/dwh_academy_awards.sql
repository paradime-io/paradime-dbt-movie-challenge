with src as (
    select 
        movie_title,
        imdb_id,
        director_person_identifier,
        director_name,
        director_date_of_birth,
        director_gender,
        person_identifier,
        person_name,
        person_date_of_birth,
        person_gender,
        award_title,
        award_edition,
        award_date,
        nominated,
        won
    from {{ref('academy_awards')}}
)
-- calculate the ages of the directors and/or award recipient/nominee where possible
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
    src