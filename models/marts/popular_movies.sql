SELECT
    ID,
    POPULARITY,
    RELEASE_DATE,
    TITLE,
    VOTE_AVERAGE,
    VOTE_COUNT
FROM
    {{ ref('stg_tmdb_popular_movies') }}