with dim_actors as (
    select
        imdb_id,
        trim(my_split.value) as actors
    from  {{ ref('clean_combined_movies') }}, lateral split_to_table(actors,',') as my_split
    where actors != 'N/A'
)
select
    actors,
    count(*) as num_movies
from dim_actors
group by imdb_id, actors
order by num_movies desc