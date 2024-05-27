select *
from {{ ref('stg_netflix_weekly_rankings') }}
