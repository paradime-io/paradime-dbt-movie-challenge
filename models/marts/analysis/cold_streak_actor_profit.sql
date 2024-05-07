with cte1 as (
select actor, movie_cnt_actor
from {{ ref('mart_actors')}}
where threeday_avg_profit = (select min(threeday_avg_profit) from {{ ref('mart_actors')}} where movie_cnt_actor >2)
)
select *
from {{ ref('mart_actors')}}
where actor in (select actor from cte1)
    and movie_cnt_actor between (select movie_cnt_actor-2 from cte1) and (select movie_cnt_actor from cte1)