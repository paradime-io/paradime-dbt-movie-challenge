select * from {{ ref('director_imdb_cold')}}
union all
select * from {{ ref('director_imdb_hot')}} 