with all_genres as (
    select
    imdb_id
    ,title
    ,value as genre
    ,language
    ,country
    ,release_decade
    ,release_year
    ,released_date
    ,runtime
    ,imdb_rating
    ,imdb_votes
    ,box_office
    
    
    from {{ ref('stg_omdb_movies') }}, lateral split_to_table(genre,', ')
)

select
*

from all_genres