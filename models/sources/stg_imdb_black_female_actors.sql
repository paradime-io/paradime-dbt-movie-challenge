select *
from {{ source('IMDB', 'RAW_IMDB_BLACK_FEMALE_ACTORS') }}