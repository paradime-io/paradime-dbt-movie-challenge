WITH clean_movies AS (
    SELECT * FROM {{ ref('clean_combined_movies') }}
)
select * from clean_movies