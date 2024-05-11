-- stg_imdb_akas.sql
with source as (
    select
        titleId as imdb_title_id,
        ordering,
        title,
        region,
        language,
        types,
        attributes,
        isOriginalTile as is_original_title
    from {{ ref('imdb_akas') }}
)

select *
from source