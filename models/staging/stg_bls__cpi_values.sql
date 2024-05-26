with 

source as (
    select 
        year as cpi_year, 
        Jan,
        Feb,
        Mar,
        Apr,
        May,
        Jun,
        Jul,
        Aug,
        Sep,
        Oct,
        Nov,
        Dec
    from {{ source('MOVIES_ADDITIONAL', 'CONSUMER_PRICE_INDEX') }}
)

select * 
from source
