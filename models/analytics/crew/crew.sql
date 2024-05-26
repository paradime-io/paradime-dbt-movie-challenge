{{ config(tags=['lightdash']) }}

with principals as (
    select * from {{ ref('stg_imdb__principals') }}
),

names as (
    select * from {{ ref('stg_imdb__names') }}
),


final as (


    /*
        The same individual can play multiple characters in the same movie. 
        Since the garin is being rolled-up to the Individual X Role level, 
        the 'distinct' statement is necessary to keep records unique across 
        the model.
    */

    select distinct

        -- KEYS
        {{ dbt_utils.generate_surrogate_key([
            'principals.imdb_id',
            'principals.name_id',
            'principals.role'
            ])
        }}                      as record_key,

        principals.imdb_id      as imdb_id,
        principals.name_id      as name_id,


        -- CREW MEMBER DETAILS
        names.full_name         as full_name,
        principals.role         as role

    from principals

    left join names
        on principals.name_id = names.name_id

)

select * from final
