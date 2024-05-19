with academy_award_winners as (
    select 
        film_title as movie_title,
        imdb_id,
        person_name,
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
        nom.person_name,
        nom.award_title,
        nom.award_edition,
        nom.award_date,
        TRUE as nominated,
        FALSE as won
    from 
        {{ref('stg_wikidata_academy_award_nominees')}} as nom
    left join academy_award_winners as win 
        on win.imdb_id = nom.imdb_id
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
        person_name,
        award_title,
        award_edition,
        award_date,
        nominated,
        won
    from 
        academy_award_nominees
),

movie_id_from_imdb_id as (
    select 
        mov.identifier_unique_key as movie_id,
        movie_title,
        imdb_id,
        person_name,
        award_title,
        award_edition,
        award_date,
        nominated,
        won
    from 
        awards_and_nominations as aw
    left join {{ref('all_movies_combined_columns')}} as mov
        on mov.omdb_imdb_id = aw.imdb_id
),

-- Now get the person_id from the name. We could generate it by getting a hash of the person_name
-- but only want to populate it for cases where we already know this person worked on this movie,
-- ie. they appear in movie_people
person_id_from_name as (
    select distinct -- the same person can have two roles in a movie. Only want to know they worked on the movie so distinct required
        aw.movie_id,
        movie_title,
        imdb_id,
        aw.person_name,
        ppl.person_id,
        award_title,
        award_edition,
        award_date,
        nominated,
        won
    from 
        movie_id_from_imdb_id as aw
    left join {{ref('movie_people')}} as ppl 
        on ppl.person_name = aw.person_name
        and ppl.movie_id = aw.movie_id
)

select 
    movie_id,
    movie_title,
    imdb_id,
    person_name,
    person_id,
    award_title,
    award_edition,
    award_date,
    nominated,
    won
from 
    person_id_from_name
