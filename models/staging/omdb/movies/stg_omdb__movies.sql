with source as (
    select * from {{ source('omdb', 'movies') }}
),


/*
    Unlike IMDb and Metascore movie ratings, Rotten Tomatoes ratings are nested
    inside the 'ratings' array as a separate object, along with other redundant data.
    To avoid fan-out, the following CTE recursively flattens the 'ratings' array for
    Rotten Tomatoes movie ratings, maintaining a 1:1 relationship, and then joins to
    the downstream 'final' CTE.
*/

rotten_tomatoes_scores as (

    select

        source.imdb_id::string                              as imdb_id,
        regexp_substr(score_object.this:Value, '\\d+')::int as score

    from source
    inner join lateral flatten(input => source.ratings, recursive => true) as score_object
    where score_object.value::string = 'Rotten Tomatoes'

),


final as (


    /*
        There are 100+ instances where the same IMDb ID is linked to multiple TMDb IDs, which
        appears to be a bad data - non-existent or a different movie. There is no reliable way
        to deduplicate or fix this data issue. To ensure the uniqueness of the primary key,
        while retaining all the information, all TMDb IDs associated with the same IMDb ID are
        aggregated into the 'associated_tmdb_ids' array. The 'distinct' statement ensures the
        uniqueness of records across the table.
    */

    select distinct

        -- KEYS
        source.imdb_id                                  as imdb_id,

        array_unique_agg(source.tmdb_id) over (
            partition by source.imdb_id)                as associated_tmdb_ids,


        -- MOVIE DETAILS
        source.title                                    as title,
        nullif(source.plot, 'N/A')                      as description,
        initcap(source.type)                            as media_type,
        split(source.genre, ', ')                       as genres,

        iff(lower(source.rated) in (
                'n/a',
                'not rated',
                'unrated',
                'approved',
                'passed',
                'open'),
            null,
            source.rated)                               as film_rating,

        source.runtime                                  as runtime_minutes,
        source.released_date                            as release_date,
        to_date(source.release_year || '-01-01')        as release_year,

        iff(lower(source.dvd) = 'n/a', null,
            to_date(source.dvd, 'DD MON YYYY'))         as dvd_release_date,

        iff(lower(source.language) = 'n/a', null,
            split(source.language, ', '))               as languages,

        iff(lower(source.country) = 'n/a', null,
            split(source.country, ', '))                as production_countries,

        iff(lower(source.production) = 'n/a', null,
            split(source.production, ', '))             as production_companies,

        regexp_substr(lower(awards),
            'won (\\d+) oscar', 1, 1, 'e', 1)::int      as oscar_win_count,

        regexp_substr(source.awards,
            '(\\d+) nomination', 1, 1, 'e', 1)::int     as award_nomination_count,

        regexp_substr(source.awards,
            '(\\d+) win', 1, 1, 'e', 1)::int            as award_win_count,

        source.box_office::number(38, 2)                as gross_revenue_amount_usd,


        -- CREW DETAILS
        iff(lower(source.director) = 'n/a', null,
            split(source.director, ', '))               as directors,

        iff(lower(source.writer) = 'n/a', null,
            split(source.writer, ', '))                 as writers,

        iff(lower(source.actors) = 'n/a', null,
            split(source.actors, ', '))                 as actors,


        -- SCORE DETAILS
        source.imdb_rating                              as imdb_score,
        source.imdb_votes                               as imdb_vote_count,
        source.metascore                                as metacritic_score_percent,
        rotten_tomatoes_scores.score                    as rotten_tomatoes_percent,


        -- URL LINKS
        nullif(source.website, 'N/A')                   as homepage_url,

        concat('https://www.imdb.com/title/',
            source.imdb_id)                             as imdb_url,

        array_unique_agg(concat(
            'https://www.themoviedb.org/movie/', source.tmdb_id)) over (
                partition by source.imdb_id)            as associated_tmdb_urls,

        nullif(source.poster, 'N/A')                    as poster_url


    from source

    left join rotten_tomatoes_scores
        on source.imdb_id = rotten_tomatoes_scores.imdb_id

)

select * from final
