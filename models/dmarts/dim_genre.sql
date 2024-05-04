WITH inter_dim_genre AS (
    SELECT * FROM {{ ref('inter_dim_genre') }}
)
select * from inter_dim_genre