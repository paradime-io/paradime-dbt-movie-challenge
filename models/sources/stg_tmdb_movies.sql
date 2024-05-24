WITH source AS (
    SELECT 
TMDB_ID,
        TITLE,
        ORIGINAL_TITLE,
        OVERVIEW,
        TAGLINE,
        KEYWORDS,
        ORIGINAL_LANGUAGE,
        STATUS,
        VIDEO,
        RELEASE_DATE,
        case
            when year(release_date) between 1800 and 1899 then '1800s'
            when year(release_date) between 1900 and 1909 then '1900s'
            when year(release_date) between 1910 and 1919 then '1910s'
            when year(release_date) between 1920 and 1929 then '1920s'
            when year(release_date) between 1930 and 1939 then '1930s'
            when year(release_date) between 1940 and 1949 then '1940s'
            when year(release_date) between 1950 and 1959 then '1950s'
            when year(release_date) between 1960 and 1969 then '1960s'
            when year(release_date) between 1970 and 1979 then '1970s'
            when year(release_date) between 1980 and 1989 then '1980s'
            when year(release_date) between 1990 and 1999 then '1990s'
            when year(release_date) between 2000 and 2009 then '2000s'
            when year(release_date) between 2010 and 2019 then '2010s'
            when year(release_date) between 2020 and 2029 then '2020s'
            when year(release_date) between 2030 and 2039 then '2030s'
        end as release_decade,
        RUNTIME,
        BUDGET,
        REVENUE,
        VOTE_AVERAGE,
        VOTE_COUNT,
        HOMEPAGE,
        POSTER_PATH,
        BACKDROP_PATH,
        BELONGS_TO_COLLECTION,
        IMDB_ID,
        GENRE_NAMES,
        SPOKEN_LANGUAGES,
        PRODUCTION_COMPANY_NAMES,
        PRODUCTION_COUNTRY_NAMES
    FROM 
        {{ source('PARADIME_MOVIE_CHALLENGE', 'TMDB_MOVIES') }}
)

SELECT 
    * 
FROM 
    source

