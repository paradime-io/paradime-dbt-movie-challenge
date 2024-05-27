with actors as (
    select *
    FROM {{ ref('stg_imdb_people') }}
    where is_actor
)

, black_female_actors as (
    select *
    from {{ ref('stg_imdb_black_female_actors')}}
)

, nonbinary_folks as(
    select *
    from {{ ref('stg_imdb_nonbinary_identifying_people')}}
)

select actors.*
, primary_profession ilike '%,%' as is_multi_hyphenate
, regexp_count(primary_profession, ',') + 1 as num_professions
, black_female_actors.imdb_person_id is not null as is_black_female_actor
, nonbinary_folks.imdb_person_id is not null as is_nonbinary
from actors
left join black_female_actors
on actors.imdb_person_id = black_female_actors.imdb_person_id
left join nonbinary_folks
on actors.imdb_person_id = nonbinary_folks.imdb_person_id