with
    source as (
        select
            replace(value, '"', '') as production_company,
            released_date,
            -- clean monetary data
            iff(budget_adj is null or budget_adj = 0, null, budget_adj) as budget_adj,
            iff(revenue_adj is null or revenue_adj = 0, null, revenue_adj) as revenue_adj,
            tmdb_id
        from {{ ref('combined_omdb_and_tmdb') }},
            table(flatten(production_companies))
    )

select * from source