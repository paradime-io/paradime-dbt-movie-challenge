SELECT
    is_scifi,
    count(distinct imdb_id) as nr_of_movies,
    avg(revenue) as avg_revenue,
    avg(budget) as avg_budget,
    sum(revenue) as sum_revenue,
    sum(budget) as sum_budget,
    avg(imdb_rating) as avg_imdb_rating,
    avg(imdb_votes) as avg_imdb_votes,
    sum(imdb_votes) as sum_imdb_votes,
    avg(merged_runtime) as avg_runtime,
    sum(merged_runtime) as sum_runtime
from {{ref('int_all_movies')}}
group by 
    is_scifi