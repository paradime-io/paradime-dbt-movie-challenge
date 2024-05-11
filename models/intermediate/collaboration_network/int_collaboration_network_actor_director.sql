-- int_collaboration_network_actor_director.sql

-- Creating a director-actor pair
with collaborations as (
    select
        {{ dbt_utils.generate_surrogate_key(['d.value', 'a.value']) }} as director_actor_key,
        trim(d.value) as director, -- Cleaning up any extra spaces around actor names
        trim(a.value) as actor,  -- Cleaning up any extra spaces around actor names
        m.imdb_id,
        m.title,
        m.original_title,
        m.genre,
        m.keywords,
        m.runtime,

        -- Features
        m.imdb_rating,
        round(m.imdb_votes, 0) as imdb_votes,
        m.omdb_rt_rating,
        round(m.audience_score, 0) as audience_score,
        round(m.tomato_meter, 0) as tomato_meter,
        m.number_of_awards_won,
        m.viewer_vote_average,
        m.viewer_vote_count,
        m.revenue
    from
        {{ ref('int_movies_mapping') }} as m,
        lateral flatten(input => split(director, ',')) as d, -- Splitting and flattening the director list
        lateral flatten(input => split(actors, ',')) as a  -- Splitting and flattening the actor list
    where
        -- Adding filters to get rid of bad data
        m.director is not null and m.director != 'N/A'
        and m.actors is not null and m.actors != 'N/A'
        and m.imdb_rating between 0 and 10
        and m.imdb_id is not null
        and m.runtime > 30 -- we don't want small video snippets in this dataset
        and a.index = 1 -- we only want the main actor
        and d.index = 1 -- we only want the main director
        and trim(d.value) != trim(a.value) -- actor and director should be different than each other
    group by all
)

select *
from collaborations
