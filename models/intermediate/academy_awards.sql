with academy_award_winners as (
    select 
        film_title as movie_title,
        imdb_id,
        person_identifier,
        person_name,
        director_person_identifier,
        director_name,
        award_title,
        award_edition,
        award_date,
        FALSE as nominated, -- wins don't also count as nominations
        TRUE as won
    from 
        {{ref('stg_wikidata_academy_award_winners')}} 
),

academy_award_nominees as (
    select 
        nom.film_title as movie_title,
        nom.imdb_id,
        nom.person_identifier,
        nom.person_name,
        nom.director_person_identifier,
        nom.director_name,
        nom.award_title,
        nom.award_edition,
        nom.award_date,
        TRUE as nominated,
        FALSE as won
    from 
        {{ref('stg_wikidata_academy_award_nominees')}} as nom
    left join academy_award_winners as win 
        on win.imdb_id = nom.imdb_id
            and win.person_identifier = nom.person_identifier
            and win.person_name = nom.person_name
            and win.award_title = nom.award_title
            and win.award_date = nom.award_date
    where 
        win.award_title is null -- do not insert a nominee who won this award
),

awards_and_nominations as (
    select 
        movie_title,
        imdb_id,
        director_person_identifier,
        director_name,
        person_identifier,
        person_name,
        award_title,
        award_edition,
        award_date,
        nominated,
        won
    from 
        academy_award_winners
    
    union 

    select 
        movie_title,
        imdb_id,
        director_person_identifier,
        director_name,
        person_identifier,
        person_name,
        award_title,
        award_edition,
        award_date,
        nominated,
        won
    from 
        academy_award_nominees
),

-- Don't want duplicates caused by different job_role values
-- This might be better as a macro really
distinct_people_dob_gender as (
    select distinct 
        person_identifier,
        date_of_birth,
        gender
    from 
        {{ref('people_from_wikidata')}}
),

-- add the DOB and gender of the award winner/nominee and the director if available
-- in people data pulled from wikidata
awards_and_nominations_enriched as (
    select 
        movie_title,
        imdb_id,
        director_person_identifier,
        director_name,
        wd.date_of_birth as director_date_of_birth,
        wd.gender as director_gender,
        awa.person_identifier,
        person_name,
        wp.date_of_birth as person_date_of_birth,
        wp.gender as person_gender,
        award_title,
        award_edition,
        award_date,
        nominated,
        won
    from 
        awards_and_nominations as awa 
    left join distinct_people_dob_gender as wp 
        on wp.person_identifier = awa.person_identifier
    left join distinct_people_dob_gender as wd 
        on wd.person_identifier = awa.director_person_identifier
)

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
from 
    awards_and_nominations_enriched