SELECT
    CASE
        WHEN gender = 1
            then 'Female'
        WHEN gender = 2
            then 'Male'
        ELSE 'unknown'
    end as gender,
    known_for_department,
    name,
    popularity
FROM
    {{ ref('stg_tmdb_popular_people') }}