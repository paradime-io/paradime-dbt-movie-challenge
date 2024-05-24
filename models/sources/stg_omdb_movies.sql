WITH source AS (
    SELECT 
        IMDB_ID,
        TITLE,
        DIRECTOR,
        WRITER,
        ACTORS,
        GENRE,
        LANGUAGE,
        COUNTRY,
        TYPE,
        PLOT,
        RATED,
        RATINGS,
        METASCORE,
        IMDB_RATING,
        IMDB_VOTES,
        RELEASED_DATE,
        RELEASE_YEAR,
        case
            when release_year < 1900 then '1800s'
            when release_year >= 1900 and release_year <= 1909 then '1900s'
            when release_year >= 1910 and release_year <= 1919 then '1910s'
            when release_year >= 1920 and release_year <= 1929 then '1920s'
            when release_year >= 1930 and release_year <= 1939 then '1930s'
            when release_year >= 1940 and release_year <= 1949 then '1940s'
            when release_year >= 1950 and release_year <= 1959 then '1950s'
            when release_year >= 1960 and release_year <= 1969 then '1960s'
            when release_year >= 1970 and release_year <= 1979 then '1970s'
            when release_year >= 1980 and release_year <= 1989 then '1980s'
            when release_year >= 1990 and release_year <= 1999 then '1990s'
            when release_year >= 2000 and release_year <= 2009 then '2000s'
            when release_year >= 2010 and release_year <= 2019 then '2010s'
            when release_year >= 2020 and release_year <= 2029 then '2020s'
        end as release_decade,
        RUNTIME,
        DVD,
        BOX_OFFICE,
        POSTER,
        PRODUCTION,
        WEBSITE,
        AWARDS,
        TMDB_ID
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'OMDB_MOVIES') }}
)

SELECT 
    * 
FROM 
    source
