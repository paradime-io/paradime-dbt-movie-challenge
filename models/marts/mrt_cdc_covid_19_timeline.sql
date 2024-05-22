with int_cdc_covid_19_timeline as (
    select * from {{ref('int_cdc_covid_19_timeline') }}
),

final as (
    select * from int_cdc_covid_19_timeline
)

select * from final

