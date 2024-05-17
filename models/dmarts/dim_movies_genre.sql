WITH inter_movies_genre_per_year_percentage AS (
    SELECT * FROM {{ ref('inter_movies_genre_per_year_percentage') }}
)

select * from inter_movies_genre_per_year_percentage
