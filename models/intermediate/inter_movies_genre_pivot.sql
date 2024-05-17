WITH inter_movies_genre AS (
    SELECT * FROM {{ ref('inter_movies_genre') }}
)

SELECT
    RELEASE_YEAR,
    "'Comedy'" AS Comedy,
    "'War'" AS War,
    "'Science Fiction'" AS Science_Fiction,
    "'Horror'" AS Horror,
    "'Action'" AS Action,
    "'Crime'" AS Crime,
    "'Drama'" AS Drama,
    "'Animation'" AS Animation,
    "'History'" AS History,
    "'Western'" AS Western,
    "'Family'" AS Family,
    "'Romance'" AS Romance,
    "'Music'" AS Music,
    "'Thriller'" AS Thriller,
    "'Mystery'" AS Mystery,
    "'TV Movie'" AS TV_Movie,
    "'Documentary'" AS Documentary,
    "'Fantasy'" AS Fantasy,
    "'Adventure'" AS Adventure
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