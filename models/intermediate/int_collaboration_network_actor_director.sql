with collaborations as(
SELECT
    {{ dbt_utils.generate_surrogate_key(['d.value', 'a.value']) }} as director_actor_key,
    TRIM(d.value) AS DIRECTOR,
    TRIM(a.value) AS ACTOR,  -- Cleaning up any extra spaces around actor names
    IMDB_ID,
    imdb_rating
FROM
    {{ ref('int_movies_mapping') }},
    LATERAL FLATTEN(input => SPLIT(DIRECTOR, ',')) AS d,
    LATERAL FLATTEN(input => SPLIT(ACTORS, ',')) AS a  -- Splitting and flattening the actor list
WHERE
    DIRECTOR IS NOT NULL AND ACTORS IS NOT NULL AND IMDB_ID IS NOT NULL  -- Ensuring non-null values for processing
GROUP BY
    TRIM(d.value), TRIM(a.value), IMDB_ID, imdb_rating, director_actor_key
),

avg_ratings as(
    select
    director_actor_key,
    director,
    actor,
    avg(imdb_rating) as avg_imdb_rating,
    --count(distinct imdb_id) as movie_occurence_count
    from collaborations
    group by 1,2,3
    order by 4 desc
)



select * from avg_ratings