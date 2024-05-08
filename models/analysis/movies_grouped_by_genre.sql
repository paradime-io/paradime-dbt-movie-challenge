SELECT
    GENRE,
    COUNT(IMDB_ID) as movie_count,
    AVG(IMDB_RATING) AS rating_avg,
    SUM(wins) AS wins_count,
    SUM(nominations) AS nominations_count,
    SUM(wins)/SUM(nominations)*100 AS wins_nominations_ratio_percent
FROM   
    {{ ref('join_tmbd_ombd_genre') }}
WHERE NOMINATIONS > WINS
GROUP BY 
    GENRE

