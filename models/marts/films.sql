with omdb as (
    SELECT distinct *
    FROM {{ ref('stg_omdb_movies') }}
), 

netflix_titles as (
    select *
    from {{ ref('stg_netflix_titles') }}
    where content_type = 'movie'
),

netflix_top_10_weekly as (
    select *
    from {{ ref('stg_netflix_weekly_rankings') }}
),

national_film_registry as (
    select imdb_title_id
    from {{ ref('stg_imdb_national_film_registry')}}
)

select 
omdb.imdb_id
, netflix_titles.title_id as netflix_title_id
, coalesce(omdb.title, netflix_titles.title) as title
, omdb.director
, omdb.writer
, coalesce(omdb.actors, netflix_titles.cast) as cast
, coalesce(netflix_titles.primary_genre, omdb.genre) as primary_genre
, omdb.language
, omdb.country
, omdb.type
, coalesce(omdb.plot, netflix_titles.synopsis) as synopsis
, coalesce(omdb.rated, netflix_titles.maturity) as maturity_rating
, omdb.metascore
, omdb.imdb_rating
, omdb.imdb_votes
, omdb.rotten_tomatoes_score
, omdb.released_date
, coalesce(omdb.release_year, netflix_titles.year) as released_year
, coalesce(omdb.runtime, netflix_titles.runtime_minutes) as runtime
, omdb.dvd
, omdb.box_office
, omdb.poster
, omdb.production
, omdb.website
, omdb.num_award_wins
, omdb.num_nominations
, omdb.num_oscars
, omdb.num_primetime_emmys
, omdb.num_golden_globes
, omdb.num_baftas
, (omdb.num_award_wins + omdb.num_oscars + omdb.num_primetime_emmys + omdb.num_golden_globes + omdb.num_baftas) > 1 as is_award_winning
, netflix_titles.genre_list as netflix_genre_list
, netflix_titles.moods as netflix_mood_list
, national_film_registry.imdb_title_id is not null as is_in_national_film_registry
, min(netflix_top_10_weekly.netflix_weekly) as highest_netflix_rank
, max(netflix_top_10_weekly.num_weeks_in_top_ten) as highest_num_weeks_in_top_ten
from omdb
left join national_film_registry
on omdb.imdb_id = national_film_registry.imdb_title_id 
full outer join netflix_titles
-- Look for exact matches
on omdb.title = netflix_titles.title and omdb.release_year = netflix_titles.year
left join netflix_top_10_weekly
on netflix_titles.title_id = netflix_top_10_weekly.title_id
group by all