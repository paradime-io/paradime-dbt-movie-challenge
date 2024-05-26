with cpi as (
    select * from {{ ref('seed_enrichments__consumer_price_index') }}
),

year_combinations as (

    select

        price_year.report_year   as price_year,
        target_year.report_year  as target_year,
        price_year.cpi_value     as price_year_cpi,
        target_year.cpi_value    as target_year_cpi

    from cpi as price_year
    cross join cpi as target_year

),

final as (

    select

        {{ dbt_utils.generate_surrogate_key([
            'price_year',
            'target_year'
            ])
        }}                                 as record_key,

        price_year                         as price_year,
        target_year                        as target_year,
        (target_year_cpi / price_year_cpi) as cpi_ratio

    from year_combinations

)

select * from final
