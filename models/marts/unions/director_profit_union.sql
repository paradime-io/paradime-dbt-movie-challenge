select * from {{ ref('director_profit_cold')}}
union all
select * from {{ ref('director_profit_hot')}}