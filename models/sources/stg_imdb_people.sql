WITH imdb_people AS (
    select *
    from {{ source('IMDB', 'RAW_IMDB_PEOPLE') }}
)

select 
    imdb_person_id
    , primaryname as primary_name
    , case when birthyear = '\\N' then null else birthyear::int end as birth_year
    , case when deathyear = '\\N' then null else deathyear::int end as death_year
    , primaryprofession as primary_profession
    , knownfortitles as known_for_titles
    , primaryprofession ilike any ('%actor%', '%actress%') as is_actor
    -- gender is a construct but this appears align with imdb reporting elsewhere
    -- at least appearing to avoid misgendering non-binary folks: https://m.imdb.com/search/name/?gender=non_binary
    --, primaryprofession ilike '%actress%' as is_female_actor
    , primaryprofession ilike '%director%' as is_director
    , primaryprofession ilike '%producer%' as is_producer
    , primaryprofession ilike '%writer%' as is_writer
from imdb_people
