with results as(
    select *
    from {{ ref('stg_oscars_results')}}
)

, person_info as(
    select 
        imdb_person_id
        , birth_year
    from {{ ref('stg_imdb_people') }}
)

, individual_nominations as (
    select 
        md5(award_nomination_id || value) as id
        , award_nomination_id
        , value::varchar as nominee_imdb_id
        , ceremony_number
        , to_date(year||'-01-01') as year
        , class
        , canonical_category
        , category
        , film
        , imdb_film_id
        , is_winner
        , is_multi_film_nomination
    from results, lateral flatten(parse_json(to_json(STRTOK_TO_ARRAY(nominees_ids, ', ')))) as individual_nominations
)

select *
, year(year) - person_info.birth_year::int as approximate_age_at_nomination
from individual_nominations
left join person_info
on individual_nominations.nominee_imdb_id = person_info.imdb_person_id,




