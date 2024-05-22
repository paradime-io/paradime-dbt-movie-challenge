select 
    event_date,
    event
from {{ source('PARADIME_MOVIE_CHALLENGE', 'CDC_COVID_TIMELINE_OF_EVENTS') }}