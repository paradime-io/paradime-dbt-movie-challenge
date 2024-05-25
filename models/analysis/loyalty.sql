with
    source as (
        select
            replace(pc.value, '"', '') as production_company,
            replace(d.value, '"', '') as director,
            count(distinct tmdb_id) as num_movies
        from {{ ref('combined_omdb_and_tmdb') }},
            table(flatten(production_companies)) pc,
            table(flatten(directors)) d
        group by 1, 2
    ),

    final as (
        select
            production_company,
            director,
            sum(num_movies) over (partition by production_company, director) as director_movies_in_company,
            sum(num_movies) over (partition by director) as movies_director,
            sum(num_movies) over (partition by production_company) as movies_company,

            sum(num_movies) over (partition by production_company, director)
                / sum(num_movies) over (partition by director) as loyalty_director,

            sum(num_movies) over (partition by production_company, director)
                / sum(num_movies) over (partition by production_company) as loyalty_company
        from source
        qualify
            --filter directors who produced more than 10 movies
            -- it will help reduce number of low occurancies
            sum(num_movies) over (partition by director) > 10
    )

select * from final