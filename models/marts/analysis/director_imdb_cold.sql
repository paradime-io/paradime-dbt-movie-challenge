with cte1 as (
select director, film_cnt_director
from {{ ref('mart_directors')}}
where film_cnt_director > 2
qualify row_number() over (order by threefilm_avg_imdb_rating asc, director) = 1
)
select *
from {{ ref('mart_directors')}}
where director in (select director from cte1)
    and film_cnt_director between (select film_cnt_director - 2 from cte1) and (select film_cnt_director from cte1)
order by released_date