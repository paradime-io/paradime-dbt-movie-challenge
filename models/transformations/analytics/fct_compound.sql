with compound as (
    select
        m.is_scifi,
        avg(compound_plot) as avg_compound_plot,
        avg(compound_overview) as avg_compound_overview,
        avg(compound_keywords) as avg_compound_keywords,
        avg(compound_title) as avg_compound_title
    from {{ref('int_all_movies')}} as m
    left join {{ref('int_all_movies_sentiment')}} as n 
    on m.imdb_id = n.imdb_id
    group by 
        m.is_scifi
)
select
    *
from compound