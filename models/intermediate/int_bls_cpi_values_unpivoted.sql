with 

source as (
    {{ dbt_utils.unpivot(ref('stg_bls__cpi_values'), cast_to='varchar', exclude=['cpi_year']) }}
),

formatted as (
    select 
        cpi_year,
        {{ get_month_number('field_name') }} as cpi_month,
        value::float as cpi_value
    from source
),

filtered as (
    select *
    from formatted
    where cpi_value is not null
)

SELECT *
FROM filtered
