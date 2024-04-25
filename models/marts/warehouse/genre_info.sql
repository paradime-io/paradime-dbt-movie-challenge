WITH movies AS (
    SELECT 
        imdb_id,
        title,
        overview,
        status,
        type,
        release_date,
        original_language,
        genre,
        duration_minutes,
        worldwide_box_office,
        domestic_box_office,
        budget,
        director,
        writer,
        actors,
        rated,
        awards,
        production_companies,
        production_countries,
        metascore,
        imdb_rating,
        imdb_votes,
        tmdb_vote_average,
        tmdb_vote_count
    FROM {{ ref('movies_info') }}
),

final AS (
    SELECT *
    FROM movies
)

SELECT *
FROM final