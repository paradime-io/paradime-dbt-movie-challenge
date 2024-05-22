select 
    *
from {{ source('ROBERTEHRQ3_ANALYTICS', 'CDC_COVID_TIMELINE_OF_EVENTS') }}