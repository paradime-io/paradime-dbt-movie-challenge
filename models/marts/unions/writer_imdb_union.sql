select * from {{ ref('writer_imdb_cold')}}
union all
select * from {{ ref('writer_imdb_hot')}}