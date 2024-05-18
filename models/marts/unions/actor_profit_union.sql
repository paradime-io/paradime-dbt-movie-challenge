select * from {{ ref('actor_profit_cold')}}
union all
select * from {{ ref('actor_profit_hot')}}