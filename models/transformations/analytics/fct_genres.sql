with genre_list as (
    select
        sfj.imdb_id, 
        sfj.merged_genres,
        sfj.imdb_rating,
        sfj.budget,
        sfj.revenue,
        s.compound_plot,
        s.compound_overview
    from {{ref('int_science_fictions_joined')}} as sfj
    left join {{ref('int_sentiment')}} as s
    on sfj.imdb_id = s.imdb_id
),
flattened_genres as (
    SELECT 
        g.imdb_id, 
        g.imdb_rating,
        g.budget,
        g.revenue,
        g.compound_plot,
        g.compound_overview,
        TRIM(flattened_genre.value::string) AS genre
    FROM genre_list as g,
    LATERAL FLATTEN(g.merged_genres) AS flattened_genre
)
select 
    genre,
    count(distinct imdb_id) as nr_of_movies,
    avg(imdb_rating) as avg_imdb_rating,
    avg(budget) as avg_budget,
    avg(revenue) as avg_revenue,
    avg(compound_plot) as avg_plot_sentiment,
    avg(compound_overview) as avg_overview_sentiment
from flattened_genres
where genre not in ('Science Fiction', 'Short')
group by 
    genre
order by 2 desc