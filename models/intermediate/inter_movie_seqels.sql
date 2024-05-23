with movie_sequels AS (
    select
        const as sequel_id,
        title
    from
        {{ref ('movie_seqels')}}
),
cleaned_movies as (
    select *
    from
        {{ref('cleaned_movies')}}
)

