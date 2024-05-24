-- genre_success.sql

-- Creating a genre list
with genres as (
    select
        trim(g.value) as main_genre, -- Cleaning up any extra spaces around genre names
        m.imdb_id,
        m.title,
        m.original_title,
        m.runtime,
        m.release_date,

        -- Success Metrics
        m.imdb_rating,
        m.imdb_votes,
        m.imdb_votes_normalized,
        m.combined_rotten_tomato_rating,
        m.number_of_awards_won,
        m.number_of_awards_won_normalized,
        m.viewer_vote_average,
        m.viewer_vote_count,
        m.viewer_vote_count_normalized,
        m.revenue,
        m.inflation_corrected_revenue,
        m.revenue_normalized,
        m.combined_success_rating,

        
    from
        {{ ref('int_combined_movie_success') }} as m,
        lateral flatten(input => split(genre, ',')) as g  -- Splitting and flattening the genre list
    where
        g.index = 0 -- we only want the main genre
    group by all
)

select * from genres
