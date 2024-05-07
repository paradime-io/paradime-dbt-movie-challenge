with cte1 as (
select writer, film_cnt_writer
from {{ ref('mart_writers')}}
where film_cnt_writer > 2
qualify row_number() over (order by threefilm_avg_imdb_rating asc, writer) = 1
)
select *
from {{ ref('mart_writers')}}
where writer in (select writer from cte1)
    and film_cnt_writer between (select film_cnt_writer - 2 from cte1) and (select film_cnt_writer from cte1)
order by released_date