with genre_unnest as (
select title,
adj_box_office as BOX_OFFICE,
release_year,
TRIM(g.value::string) AS genre
FROM 
{{ source('PARADIME_MOVIE_CHALLENGE_FINAL', 'OMDB_INFLATION_ADJUSTED') }} a
,LATERAL FLATTEN(INPUT => SPLIT(a.genre, ',')) g
where release_year between 1990 and 2023
and box_office is not null
),

CT_PRODUCED as (
select RELEASE_YEAR,
GENRE,
COUNT(*) AS MOVIES_MADE
FROM genre_unnest
GROUP BY RELEASE_YEAR,
GENRE
),



ranked_by_year as (select 
CT_PRODUCED.release_year,
CT_PRODUCED.GENRE,
RANK() OVER (partition by CT_PRODUCED.RELEASE_YEAR ORDER BY CT_PRODUCED.MOVIES_MADE DESC) AS RNK
FROM CT_PRODUCED
)


select * from CT_PRODUCED
--  select DISTINCT release_year,
--  genre,
--  RNK
--  FROM ranked_by_year
--  where RNK<=5
--  order by release_year,RNK asc
