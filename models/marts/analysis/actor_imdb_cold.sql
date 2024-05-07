with cte1 as (
select actor, film_cnt_actor
from {{ ref('mart_actors')}}
where film_cnt_actor > 2
qualify row_number() over (order by threefilm_avg_imdb_rating, actor) = 1
)
select *
from {{ ref('mart_actors')}}
where actor in (select actor from cte1)
    and film_cnt_actor between (select film_cnt_actor - 2 from cte1) and (select film_cnt_actor from cte1)
order by released_date