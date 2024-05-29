WITH source AS (
    SELECT 
        TCONST as imdb_episode_id,
        PARENTTCONST as imdb_id,
        SEASONNUMBER as season_num,
        EPISODENUMBER as episode_num
    FROM 
        {{ source('ADDITIONAL_DATA', 'IMDB_TITLE_EPISODE') }}
)

SELECT 
    * 
FROM 
    source