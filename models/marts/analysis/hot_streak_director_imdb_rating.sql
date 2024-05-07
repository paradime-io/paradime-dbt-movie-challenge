with cte1 as (
select director, film_cnt_actor
from {{ ref('mart_director')}}
where film_cnt_actor > 2
qualify row_number() over (order by threefilm_avg_profit desc, actor) = 1
)
select *
from {{ ref('mart_director')}}
where actor in (select director from cte1)
    and film_cnt_actor between (select film_cnt_actor - 2 from cte1) and (select film_cnt_actor from cte1)
order by released_date