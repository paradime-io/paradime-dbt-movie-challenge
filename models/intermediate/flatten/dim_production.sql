with dim_production as(
    select
        tmdb_id,
        trim(my_split.value) as production
    from  {{ ref('clean_combined_movies') }},
    lateral split_to_table(production,',') as my_split
    where production != 'N/A'
)
select * from dim_production

