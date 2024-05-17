WITH inter_movies_genre AS (
    SELECT * FROM {{ ref('inter_movies_genre') }}
)

SELECT *
FROM inter_movies_genre
PIVOT (
  count(tmdb_id) FOR genre_name IN (
    'Comedy',
    'War',
    'Science Fiction',
    'Horror',
    'Action',
    'Crime',
    'Drama',
    'Animation',
    'History',
    'Western',
    'Family',
    'Romance',
    'Music',
    'Thriller',
    'Mystery',
    'TV Movie',
    'Documentary',
    'Fantasy',
    'Adventure')
)
order by release_year