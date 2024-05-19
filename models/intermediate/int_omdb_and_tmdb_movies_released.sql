with 

movies as (
    select *
    from {{ ref('int_omdb_and_tmdb_joined') }}
),

filter_released as (
    select 
        -- ids
        imdb_id,
        tmdb_id,
        -- dimensions
        title,
        genre_names,
        keywords,
        director,
        writer,
        actors,
        awards,
        production,
        dvd,
        metascore,
        country,
        -- metrics
        imdb_rating,
        imdb_votes,
        box_office,
        runtime,
        vote_average,
        revenue_usd,
        budget_usd,
        -- date/datetime
        o_release_date,
        o_release_year,
        t_release_date
    from movies
    where status = 'Released' 
        -- movies cannot be released in the future
        and o_release_year <= year(current_date())
)

SELECT *
FROM filter_released
