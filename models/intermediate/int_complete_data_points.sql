with 

released as (
    select *
    from {{ ref('int_released_movies') }}
),

complete_data as (
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
        revenue,
        budget,
        -- date/datetime
        o_release_date,
        o_release_year,
        t_release_date
    from released
    where budget is not null and (revenue is not null or box_office is not null)
        and runtime is not null and genre_names is not null and o_release_date is not null
        and keywords is not null and director is not null and writer is not null
        and country is not null
)

SELECT *
FROM complete_data
