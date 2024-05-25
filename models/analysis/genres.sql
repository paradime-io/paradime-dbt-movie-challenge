with
    source as (
        select distinct
            tmdb_id,
            released_date,
            replace(g.value, '"', '') as genre,
            replace(d.value, '"', '') as director
        from {{ ref('combined_omdb_and_tmdb')}},
            table(flatten(genres)) as g,
            table(flatten(directors)) as d
    )

select * from source