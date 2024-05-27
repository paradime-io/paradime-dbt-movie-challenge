with results as (
    select *
    from {{ source('OSCARS', 'RAW_OSCARS_NOMINATIONS') }}
)

select 
nomid as award_nomination_id
, ceremony as ceremony_number
, left(year, 4) as year
, class
, canonicalcategory as canonical_category
, category
, film
, filmid as imdb_film_id
, name as nominee_names
, nominees
, nomineeids as nominees_ids
, winner is not null as is_winner
, detail
, note
, citation
, multifilmnomination is not null as is_multi_film_nomination
from results
