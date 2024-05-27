with joined as 
    (select *,
        case
            WHEN genre LIKE '%Fantasy%' AND genre LIKE '%Sci-Fi%' THEN 'Fantasy'
            WHEN genre LIKE '%Fantasy%' THEN 'Fantasy'
            WHEN genre LIKE '%Sci-Fi%' THEN 'Sci-Fi'
            ELSE 'None'
        end as genre2
    FROM {{ ref('joined_movies') }}
)

select *
FROM joined
where genre2 <> 'None'