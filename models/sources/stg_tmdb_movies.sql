with
    source as (
        select
            tmdb_id,
            iff(imdb_id='', NULL, imdb_id) as imdb_id,

            title,
            original_title,
            keywords,
            iff(original_language='xx', NULL, original_language) as original_language,
            release_date as released_date,
            runtime,
            budget,
            revenue,
            vote_average,
            vote_count,
            split(genre_names, ', ') as genre_names,
            split(spoken_languages, ', ') as spoken_languages,
            split(production_company_names, ', ') as production_companies,
            split(production_country_names, ', ') as production_countries
        from {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_MOVIES') }}
    )

select * from source
