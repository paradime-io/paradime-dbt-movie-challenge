select * from {{ ref('writer_profit_cold')}}
union all
select * from {{ ref('writer_profit_hot')}}