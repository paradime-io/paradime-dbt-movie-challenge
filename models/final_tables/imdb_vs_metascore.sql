select 
    imdb_id,
    title,
    metascore / 10 as metascore_divided,
    imdb_rating,
    imdb_votes,
    imdb_rating - (metascore / 10) as imdb_metascore_difference
    case 
        when imdb_rating - (metascore / 10) > 0 then 'User favored'
        when imdb_rating - (metascore / 10) < 0 then 'Critic favored'
        else 'Even'
    end as favored_by

from {{ ref('joined_movies') }}
where imdb_votes >= 10000
and metascore is not null