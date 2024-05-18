with 

source as (
    select
        filmid as imdb_id, 
        film as movie_name,
        name as person_name, 
        winner,
        canonicalcategory as canonical_category,
        category,
        class,
        year as ceremony_year, 
        nomineeids as nominee_ids,
        nominees as nominee_names
    from {{ source('MOVIES_ADDITIONAL', 'ACADEMY_AWARDS') }}
)

select * 
from source
