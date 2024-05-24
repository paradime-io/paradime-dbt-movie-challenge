with all_genres as (
    select
    * EXCLUDE value
    ,value as genre
    
    from {{ ref('join_omdb_and_tmdb_by_imdb_id') }}, lateral split_to_table(genre_names,', ')
)

select
*

from all_genres