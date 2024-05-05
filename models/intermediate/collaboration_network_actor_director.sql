with collaborations as(
SELECT
    DIRECTOR,
    TRIM(f.value) AS ACTOR
FROM
    {{ ref('movies_mapping') }},
    LATERAL FLATTEN(input => SPLIT(ACTORS, ',')) f
WHERE
    DIRECTOR IS NOT NULL AND ACTORS IS NOT NULL
GROUP BY
    DIRECTOR, TRIM(f.value)
ORDER BY
    DIRECTOR, TRIM(f.value)

)

select * from collaborations