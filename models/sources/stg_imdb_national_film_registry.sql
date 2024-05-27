select *
from {{ source('IMDB', 'RAW_IMDB_NATIONAL_FILM_REGISTRY') }}