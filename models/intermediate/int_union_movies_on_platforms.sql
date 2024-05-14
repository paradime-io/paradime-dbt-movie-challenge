-- models/union_all_titles.sql
WITH netflix_titles AS (
    SELECT 
        'Netflix' as platform, 
        show_id, 
        type, 
        title, 
        director, 
        country, 
        date_added, 
        release_year, 
        rating, 
        duration, 
        listed_in, 
        description
    FROM 
        {{ ref('stg_netflix_titles') }}
    WHERE
        type LIKE 'Movie'

),

disney_plus_titles AS (
    SELECT 
        'Disney+' as platform, 
        show_id, 
        type, 
        title, 
        director, 
        country, 
        date_added, 
        release_year, 
        rating, 
        duration, 
        listed_in, 
        description
    FROM 
        {{ ref('stg_disney_plus_titles') }}
    WHERE
        type LIKE 'Movie'

)
,

hulu_titles 
AS (
    SELECT
        'Hulu' as platform, 
        show_id, 
        type, 
        title, 
        director, 
        country, 
        date_added, 
        release_year, 
        rating, 
        duration, 
        listed_in, 
        description
    FROM 
        {{ ref('stg_hulu_titles') }}
    WHERE
        type LIKE 'Movie'

)
,

amazon_prime_titles AS (
    SELECT 
        'Amazon Prime' as platform, 
        show_id, 
        type, 
        title, 
        director, 
        country, 
        date_added, 
        release_year, 
        rating, 
        duration, 
        listed_in, 
        description
    FROM 
        {{ ref('stg_amazon_prime_titles') }}
    WHERE
        type LIKE 'Movie'

)
,
combined_titles AS (
    SELECT * FROM netflix_titles
    UNION ALL
    SELECT * FROM disney_plus_titles
    UNION ALL
    SELECT * FROM hulu_titles
    UNION ALL
    SELECT * FROM amazon_prime_titles
)

SELECT
    platform,
    show_id,
    type,
    title,
    director,
    country,
    TO_CHAR(TO_DATE(date_added, 'MMMM DD, YYYY'), 'YYYY-MM-DD') AS date_added,
    release_year,
    rating,
    TO_NUMBER(REGEXP_SUBSTR(duration, '^[0-9]+')) AS duration_mins,
    listed_in,
    description
FROM 
    combined_titles