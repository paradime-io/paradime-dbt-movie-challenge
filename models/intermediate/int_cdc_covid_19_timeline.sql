with src as (
    select * from {{ ref('stg_cdc_covid_19_timeline') }}
)

select 
  to_date(replace(trim(event_date),'January1','January 1'), 'MMMM dd, yyyy') as event_date,
  event
from
  ROBERTEHRQ3_ANALYTICS.DBT_ROBERT.CDC_COVID_TIMELINE_OF_EVENTS
where true
    and lower(event_date) not like 'date'
order by 1