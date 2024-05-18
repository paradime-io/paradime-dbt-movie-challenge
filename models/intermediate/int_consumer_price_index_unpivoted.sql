with 

source as (
    {{ dbt_utils.unpivot(ref('stg_consumer_price_index'), cast_to='varchar', exclude=['cpi_year']) }}
),

formatted as (
    select 
        cpi_year,
        {{ get_month_number('field_name') }} as cpi_month,
        value::float as cpi_value
    from source
)

SELECT *
FROM formatted
