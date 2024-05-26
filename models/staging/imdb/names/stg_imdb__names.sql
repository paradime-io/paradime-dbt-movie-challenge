with source as (
    select * from {{ source('imdb', 'names') }}
),

final as (

    select

        -- KEYS
        source.const                            as name_id,

        -- DETAILS
        source.primaryname                     as full_name,
        source.birthyear                       as birth_year,
        source.deathyear                       as death_year,
        split(source.primaryprofession, ',')   as roles,
        split(source.knownfortitles, ',')      as known_for_imdb_ids,

        -- METADATA
        source.ingested_at                     as ingested_at

    from source

)

select * from final
