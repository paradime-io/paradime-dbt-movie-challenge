with genre_unnest as (
select title,
RUNTIME,
IMDB_RATING,
adj_box_office as BOX_OFFICE,
release_year,
TRIM(g.value::string) AS genre
FROM 
{{ source('PARADIME_MOVIE_CHALLENGE_FINAL', 'OMDB_INFLATION_ADJUSTED') }} a
,LATERAL FLATTEN(INPUT => SPLIT(a.genre, ',')) g
)

select genre,
release_year,
avg(RUNTIME) as avg_runtime,
ROUND(avg(IMDB_RATING),1) AS AVG_RATING,
ROUND(AVG(BOX_OFFICE),0) AS AVG_BOX_OFFICE
FROM genre_unnest
where release_year between 1990 and 2023
AND BOX_OFFICE IS NOT NULL
group by genre,
release_year
order by genre,
release_year