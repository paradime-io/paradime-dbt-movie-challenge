SELECT 
    -- Basic Counts
    COUNT(*) AS total_rows,
    
    -- Counts of non-null entries for each column
    COUNT(IMDB_ID) AS imdb_id_count,
    COUNT(TITLE) AS title_count,
    COUNT(DIRECTOR) AS director_count,
    COUNT(WRITER) AS writer_count,
    COUNT(ACTORS) AS actors_count,
    COUNT(GENRE) AS genre_count,
    COUNT(LANGUAGE) AS language_count,
    COUNT(COUNTRY) AS country_count,
    COUNT(TYPE) AS type_count,
    COUNT(PLOT) AS plot_count,
    COUNT(RATED) AS rated_count,
    COUNT(RATINGS) AS ratings_count,
    COUNT(METASCORE) AS metascore_count,
    COUNT(IMDB_RATING) AS imdb_rating_count,
    COUNT(IMDB_VOTES) AS imdb_votes_count,
    COUNT(RELEASED_DATE) AS released_date_count,
    COUNT(RELEASE_YEAR) AS release_year_count,
    COUNT(RUNTIME) AS runtime_count,
    COUNT(DVD) AS dvd_count,
    COUNT(BOX_OFFICE) AS box_office_count,
    COUNT(POSTER) AS poster_count,
    COUNT(PRODUCTION) AS production_count,
    COUNT(WEBSITE) AS website_count,
    COUNT(AWARDS) AS awards_count,
    COUNT(TMDB_ID) AS tmdb_id_count,
    
    -- Descriptive Statistics for numerical columns
    AVG(IMDB_RATING) AS average_imdb_rating,
    MIN(IMDB_RATING) AS min_imdb_rating,
    MAX(IMDB_RATING) AS max_imdb_rating,
    AVG(IMDB_VOTES) AS average_imdb_votes,
    MIN(IMDB_VOTES) AS min_imdb_votes,
    MAX(IMDB_VOTES) AS max_imdb_votes,
    AVG(RUNTIME) AS average_runtime,
    MIN(RUNTIME) AS min_runtime,
    MAX(RUNTIME) AS max_runtime,
    
    -- Distribution Insights for categorical data (counts of unique values)
    COUNT(DISTINCT DIRECTOR) AS unique_directors,
    COUNT(DISTINCT WRITER) AS unique_writers,
    COUNT(DISTINCT ACTORS) AS unique_actors,
    COUNT(DISTINCT GENRE) AS unique_genres,
    COUNT(DISTINCT LANGUAGE) AS unique_languages,
    COUNT(DISTINCT COUNTRY) AS unique_countries,
    COUNT(DISTINCT TYPE) AS unique_types,
    COUNT(DISTINCT RATED) AS unique_ratings,
    COUNT(DISTINCT AWARDS) AS unique_awards_sets
FROM {{ ref('stg_omdb_movies') }}