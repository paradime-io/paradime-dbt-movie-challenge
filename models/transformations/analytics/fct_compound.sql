with compound as (
    select
        m.is_scifi,
        avg(compound_plot) as avg_compound_plot,
        avg(compound_overview) as avg_compound_overview,
    from {{ref('int_all_movies')}} as m
    left join {{ref('int_all_movies_sentiment')}} as n 
    group by 
        m.is_scifi
)
select
    *
from compound