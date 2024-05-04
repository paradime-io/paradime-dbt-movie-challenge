WITH clean_movies AS (
    SELECT * FROM {{ ref('clean_movies') }}
)
select * from clean_movies