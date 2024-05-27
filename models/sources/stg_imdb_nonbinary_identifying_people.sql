select *
from {{ source('IMDB', 'RAW_IMDB_NONBINARY_IDENTIFYING_PEOPLE') }}