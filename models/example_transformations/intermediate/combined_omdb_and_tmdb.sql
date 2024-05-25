{{
    config(
        materialized='table'
    )
}}

with tmdb as (
    select
        imdb_id,
        tmdb_id,
        title,
        released_date,
        keywords,
        genre_names,
        spoken_languages,
        production_companies,
        production_countries,
        runtime,
        vote_average,
        vote_count,
        revenue,
        budget
    from {{ ref('stg_tmdb_movies') }}
), 

omdb as (
    select 
        imdb_id,
        tmdb_id,
        title,
        directors,
        writers,
        actors,
        genres,
        languages,
        countries,
        awards,
        production,
        released_date,
        runtime,
        ratings,
        box_office
    FROM {{ ref('stg_omdb_movies') }}
), 

joined AS (
    select
        coalesce(tmdb.imdb_id, omdb.imdb_id) as imdb_id,
        coalesce(tmdb.tmdb_id, omdb.tmdb_id) as tmdb_id,
        
        coalesce(tmdb.title, omdb.title) as title,
        coalesce(tmdb.released_date, omdb.released_date) as released_date,
        coalesce(tmdb.runtime, omdb.runtime) as runtime,

        -- arrays
        directors,
        writers,
        actors,
        array_distinct(array_cat(tmdb.genre_names, omdb.genres)) as genres,
        array_distinct(array_cat(tmdb.spoken_languages, omdb.languages)) as languages,
        array_distinct(array_cat(tmdb.production_countries, omdb.countries)) as production_countries,
        production_companies,
        
        
        awards,

        tmdb.budget,
        coalesce(tmdb.revenue, omdb.box_office) as revenue,

        keywords,

        vote_average,
        vote_count
    from
        tmdb
    join
        omdb
    where
        tmdb.imdb_id = omdb.imdb_id or tmdb.tmdb_id = omdb.tmdb_id
)

SELECT
    *,
    CASE
        WHEN released_date >= '1890-01-01' AND released_date < '1927-01-01' THEN 'Silent Era (1890s-1920s)'
        WHEN released_date >= '1927-01-01' AND released_date < '1949-01-01' THEN 'Classical Hollywood (1927-1948)'
        WHEN released_date >= '1949-01-01' AND released_date < '1970-01-01' THEN 'Post-War Era (1949-1969)'
        WHEN released_date >= '1970-01-01' AND released_date < '1981-01-01' THEN 'New Hollywood (1970-1980)'
        WHEN released_date >= '1981-01-01' AND released_date < '2000-01-01' THEN 'Modern Era (1981-1999)'
        WHEN released_date >= '2000-01-01' THEN 'Digital Age (2000-present)'
        ELSE 'Unknown Era'
    END AS epoch,
    -- extract(year from released_date) as released_year,

    -- inflation adjusted budget and revenue
    budget / (rate / 100) as budget_adj,
    revenue / (rate / 100) as revenue_adj

FROM joined
left join {{ ref('inflation') }} as inflation
    on extract(year from released_date) = inflation.year
where
    -- filter movies between 45 minutes and 5 hours
    runtime between 45 and 300
    -- and extract(year from released_date) <= 2023
