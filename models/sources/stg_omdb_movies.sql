with 

source as (
    select *
    from {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}
),

basic_cleanup as (
    select 
        -- ids
        imdb_id,
        tmdb_id,
        -- dimensions
        title,
        iff(director != 'N/A', director, null) as director,
        iff(writer != 'N/A', writer, null) as writer,
        iff(actors != 'N/A', actors, null) as actors,
        genre,
        language,
        country,
        type,
        rated,
        ratings,
        metascore,
        iff(dvd != 'N/A', dvd, null) as dvd,
        iff(production != 'N/A', production, null) as production,
        iff(awards != 'N/A', awards, null) as awards,
        -- metrics
        imdb_rating,
        imdb_votes,
        iff(runtime != 0, runtime, null) as runtime,
        iff(box_office != 0, box_office, null) as box_office,
        -- datetime
        released_date as o_release_date,
        release_year as o_release_year
    FROM source
    -- bad data when imdb_id != imdbid. All of them have title = '#DUPE#'
    where imdb_id = imdbid
)

SELECT * 
FROM basic_cleanup
