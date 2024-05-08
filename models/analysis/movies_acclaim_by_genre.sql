WITH
    movie_critical_acclaim AS
    (
        SELECT
            mca.IMDB_ID,
            mca.TITLE,
            mca.DIRECTOR,
            mca.WRITER,
            mca.nominations,
            mca.wins,
            mca.BUDGET,
            mca.revenue,
            mca.ROI,
            mca.IMDB_RATING,
            mca.IMDB_VOTES
        FROM
        {{ ref('movie_critical_acclaim') }} AS mca
    ),
    movie_main_genres AS
    (
        SELECT
            mg.MOVIE_ID,
            SPLIT_PART(mg.GENRE, ',', 1) AS main_genre
        FROM {{ source('EXTRA_DATASETS', 'MOVIE_GENRES') }} AS mg
    ),
    movies_acclaim_by_genre AS 
    (
        SELECT 
            mca.IMDB_ID,
            mca.TITLE,
            mg.main_genre AS genre,
            mca.DIRECTOR,
            mca.WRITER,
            mca.nominations,
            mca.wins,
            mca.BUDGET,
            mca.revenue,
            mca.ROI,
            mca.IMDB_RATING,
            mca.IMDB_VOTES
        FROM 
            movie_critical_acclaim AS mca
        INNER JOIN
            movie_main_genres AS mg 
        ON
            mg.MOVIE_ID = mca.IMDB_ID
    )

SELECT * FROM movies_acclaim_by_genre
