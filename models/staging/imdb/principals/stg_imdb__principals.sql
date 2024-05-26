with source as (
    select * from {{ source('imdb', 'principals') }}
),

final as (

    select

        -- KEYS

        {{ dbt_utils.generate_surrogate_key([
            'source.tconst',
            'source.nconst',
            'source.category',
            'source.ordering',
            'source.characters',
            ])
        }}                                              as record_key,

        source.tconst                                   as imdb_id,
        source.nconst                                   as name_id,


        -- DETAILS
        initcap(replace(source.category, '_', ' '))     as role,
        source.job                                      as job,
        source.ordering::int                            as order_in_title,
        parse_json(source.characters)                   as played_characters,


        -- METADATA
        source.ingested_at                              as ingested_at

    from source

)

select * from final
where imdb_id = 'tt0120338'
