-- actor_director_success.sql

with final as (
    select
        *
    from {{ ref('int_collaboration_network_actor_director') }}

)

select * from final
