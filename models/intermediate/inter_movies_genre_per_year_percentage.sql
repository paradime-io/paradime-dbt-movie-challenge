WITH inter_movies_genre_per_year AS (
    SELECT * FROM {{ ref('inter_movies_genre_per_year') }}
)
select
    *,
    round((Comedy / total_movies)*100, 2) as Comedy_percentage,
    round((War / total_movies)*100, 2) as War_percentage,
    round((Science_Fiction / total_movies)*100, 2) as Science_Fiction_percentage,
    round((Horror / total_movies)*100, 2) as Horror_percentage,
    round((Action / total_movies)*100, 2) as Action_percentage,
    round((Crime / total_movies)*100, 2) as Crime_percentage,
    round((Drama / total_movies)*100, 2) as Drama_percentage,
    round((Animation / total_movies)*100, 2) as Animation_percentage,
    round((History / total_movies)*100, 2) as History_percentage,
    round((Western / total_movies)*100, 2) as Western_percentage,
    round((Family / total_movies)*100, 2) as Family_percentage,
    round((Romance / total_movies)*100, 2) as Romance_percentage,
    round((Music / total_movies)*100, 2) as Music_percentage,
    round((Thriller / total_movies)*100, 2) as Thriller_percentage,
    round((TV_Movie / total_movies)*100, 2) as TV_Movie_percentage,
    round((Documentary / total_movies)*100, 2) as Documentary_percentage,
    round((Fantasy / total_movies)*100, 2) as Fantasy_percentage,
    round((Adventure / total_movies)*100, 2) as Adventure_percentage
from inter_movies_genre_per_year