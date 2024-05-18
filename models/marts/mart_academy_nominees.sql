with 

source as (
    select 
        imdb_id,  
        nominee_ids
    from {{ ref('stg_academy_awards') }}
),

split_nominees as (
    select 
        imdb_id,
        value as nominee_person_id
    FROM source as s, LATERAL SPLIT_TO_TABLE(s.nominee_ids, ',')
)

SELECT * 
FROM split_nominees
