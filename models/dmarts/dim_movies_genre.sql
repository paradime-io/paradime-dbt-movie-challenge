WITH inter_movies_genre_pivot AS (
    SELECT * FROM {{ ref('inter_movies_genre_pivot') }}
)
select * from inter_movies_genre_pivot