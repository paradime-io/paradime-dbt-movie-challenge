with genre_list as (
    select
        imdb_id, 
        merged_genres 
    from {{ref('int_science_fictions_joined')}}
),
flattened_genres as (
    SELECT 
        g.imdb_id, 
        TRIM(flattened_genre.value::string) AS genre
    FROM genre_list as g,
    LATERAL FLATTEN(g.merged_genres) AS flattened_genre
)
select 
    genre,
    count(distinct imdb_id) as nr_of_movies
from flattened_genres
where genre not in ('Science Fiction', 'Short')
group by 
    genre
order by 2 desc