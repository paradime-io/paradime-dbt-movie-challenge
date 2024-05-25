with
    source as (
        select
        imdb_id,
        imdbid,
        tmdb_id,
    
        title,
        iff(director = 'N/A', NULL, director) as director,
        iff(writer = 'N/A', NULL, writer) as writer,
        iff(actors='N/A', NULL, actors) as actors,
        iff(genre='N/A', NULL, genre) as genre,
        iff(language='N/A', NULL, language) as language,
        iff(country='N/A', NULL, country) as country,
        iff(awards = 'N/A', NULL, awards) as awards,
        type,
        iff(production='N/A', NULL, production) as production,
        coalesce(
            released_date,
            date_from_parts(release_year, 1, 1)) as released_date,
        runtime,
        ratings,
        box_office
    from {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}
    -- deduplication. keep only the first record
    qualify row_number() over(partition by imdb_id order by tmdb_id) = 1
    )

select
    imdb_id,
    tmdb_id,
    title,
    split(director, ', ') as directors,
    split(writer, ', ') as writers,
    split(actors, ', ') as actors,
    split(genre, ', ') as genres,
    split(language, ', ') as languages,
    split(country, ', ') as countries,
    awards,
    type,
    production,
    released_date,
    runtime,
    ratings,
    box_office,
from source
where
    imdb_id = imdbid