with 

movies as (
    select *
    from {{ ref('join_omdb_and_tmdb_by_imdb_id') }}
),

released as (
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
        t_released_date
    from movies
    where status = 'Released' 
        -- movies cannot be released in the future
        and release_year <= year(current_date())
)

SELECT *
FROM released
