select * from {{ ref('actor_imdb_cold')}}
union all
select * from {{ ref('actor_imdb_hot')}}