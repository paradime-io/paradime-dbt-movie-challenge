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
        m.runtime,

        -- Features
        m.imdb_rating,
        m.imdb_votes,
        m.combined_rotten_tomato_rating,
        m.number_of_awards_won,
        m.viewer_vote_average,
        m.viewer_vote_count,
        m.revenue,
        m.normalized_revenue,
        m.combined_success_rating
    from
        {{ ref('int_combined_movie_success') }} as m,
        lateral flatten(input => split(director, ',')) as d, -- Splitting and flattening the director list
        lateral flatten(input => split(actors, ',')) as a  -- Splitting and flattening the actor list
    where
        -- Adding filters to get rid of bad data
        m.director is not null and m.director != 'N/A'
        and m.actors is not null and m.actors != 'N/A'
        and m.runtime > 30 -- we don't want small video snippets in this dataset
        and a.index = 1 -- we only want the main actor
        and d.index = 1 -- we only want the main director
        and trim(d.value) != trim(a.value) -- actor and director should be different than each other
    group by all
)

select *
from collaborations
