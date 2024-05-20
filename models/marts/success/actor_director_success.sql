-- actor_director_success.sql

-- Creating a director-actor pair
with collaborations as (
    select
        {{ dbt_utils.generate_surrogate_key(['d.value', 'a.value']) }} as director_actor_key,
        trim(d.value) as director, -- Cleaning up any extra spaces around director names
        trim(a.value) as actor,  -- Cleaning up any extra spaces around actor names
        m.imdb_id,
        m.title,
        m.original_title,
        m.genre,
        m.runtime,

        -- Metrics raw
        m.imdb_rating,
        m.imdb_votes,
        m.combined_rotten_tomato_rating,
        m.number_of_awards_won,
        m.viewer_vote_average,
        m.viewer_vote_count,
        m.revenue,
        m.inflation_corrected_revenue,
        m.combined_success_rating,
        
        -- Metrics normalized
        m.imdb_votes_normalized,
        m.number_of_awards_won_normalized,
        m.viewer_vote_count_normalized,
        m.revenue_normalized,
        m.combined_rotten_tomato_rating_normalized
        
    from
        {{ ref('int_combined_movie_success') }} as m,
        lateral flatten(input => split(director, ',')) as d, -- Splitting and flattening the director list
        lateral flatten(input => split(actors, ',')) as a  -- Splitting and flattening the actor list
    where
        -- Adding filters to get rid of bad data
        m.director is not null and m.director != 'N/A'
        and m.actors is not null and m.actors != 'N/A'
        and m.runtime > 30 -- we don't want small video snippets in this dataset
        and a.index = 0 -- we only want the main actor
        and d.index = 0 -- we only want the main director 
        and trim(d.value) != trim(a.value) -- actor and director should be different than each other
    group by all
),


most_successfull_movie as (
    select
        director_actor_key,
        title
    from (
        select
            director_actor_key,
            title,
            row_number() over (partition by director_actor_key order by combined_success_rating desc) as rn
        from collaborations
    ) as ranked
    where rn = 1
),



final as (
    select
        c.*,
        sm.title as best_movie_of_director_actor
    from collaborations as c
        left join most_successfull_movie as sm
            on c.director_actor_key = sm.director_actor_key

)

select * from final
