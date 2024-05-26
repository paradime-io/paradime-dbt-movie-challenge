with omdb_cte as (
    select 
        nullif(trim(imdb_id), '') as imdb_id,
        title,
        director,
        nullif(trim(writer), 'N/A') as writer,
        nullif(trim(actors), 'N/A') as actors,
        --replace(replace(genre,' ',''),'Sci-Fi', 'Science Fiction') as genre,
        split(replace(replace(genre,' ',''),'Sci-Fi', 'Science Fiction'), ',') as genre_list,
        split(nullif(trim(language),'N/A'), ',') as language_list,
        split(nullif(trim(country),'N/A'), ',') as country_list,
        nullif(trim(plot), 'N/A') as plot,
        nullif(trim(rated), 'N/A') as rated,
        case 
            when array_size(ratings) < 1 
            then null
            else ratings
        end as ratings,
        metascore,
        imdb_rating,
        imdb_votes,
        released_date,
        release_year,
        runtime,
        nullif(trim(dvd), 'N/A') as dvd,
        box_office,
        nullif(trim(production), 'N/A') as production, 
        nullif(trim(website), 'N/A') as website,
        nullif(trim(awards), 'N/A') as awards,
        tmdb_id
    from {{ref('stg_omdb_movies')}}
    where genre ilike '%Sci-Fi%'
),
tmdb_cte as (
    select 
        tmdb_id,
        title,
        nullif(trim(overview), '') as overview,
        nullif(trim(tagline), '') as tagline,
        keywords,
        original_language,
        status,
        release_date,
        runtime,
        budget,
        revenue,
        vote_average,
        vote_count,
        nullif(trim(belongs_to_collection),'null') as belongs_to_collection,
        nullif(trim(imdb_id),'') as imdb_id,
        --replace(genre_names,' ','') as genre_names,
        split(replace(replace(genre_names,' ',''),'ScienceFiction', 'Science Fiction'),',') as genre_names_list,
        split(spoken_languages,',') as spoken_languages_list,
        split(production_company_names,',') as production_company_names_list,
        split(production_country_names,',') as production_country_names_list
    from {{ref('stg_tmdb_movies')}}
    where genre_names ilike '%Science Fiction%'
),
joined as (
    SELECT 
        coalesce(o.imdb_id,t.imdb_id) as imdb_id,
        coalesce(o.title, t.title) as title,
        o.title as o_title, 
        t.title as t_title,
        o.director,
        o.writer,
        o.actors,
        --o.genre,
        o.genre_list,
        o.language_list,
        o.country_list,
        o.plot,
        o.rated,
        o.ratings,
        o.metascore,
        o.imdb_rating,
        o.imdb_votes,
        coalesce(o.released_date,t.release_date) as release_date,
        o.release_year,
        o.runtime as o_runtime,
        o.dvd,
        o.box_office,
        o.production,
        o.website,
        o.awards,
        o.tmdb_id,
        --t.title,
        t.overview,
        t.tagline,
        t.keywords,
        t.original_language,
        t.status,
        t.runtime as t_runtime,
        t.budget,
        t.revenue,
        t.vote_average,
        t.vote_count,
        t.belongs_to_collection,
        --t.imdb_id,
        --t.genre_names,
        t.genre_names_list,
        t.spoken_languages_list,
        t.production_company_names_list,
        t.production_country_names_list,
        array_distinct(
            array_cat(
                coalesce(o.genre_list, array_construct()),
                coalesce(t.genre_names_list, array_construct())
            ) 
        ) as merged_genres,
        coalesce(t_runtime, o_runtime) as merged_runtime
    FROM tmdb_cte as t
    full JOIN omdb_cte as o
    on t.imdb_id = o.imdb_id
    --where lower(o.title) <> lower(t.title)
)
select
    *
from joined