with production_unnest as (
select title,
adj_box_office as BOX_OFFICE,
release_year,
TRIM(g.value::string) AS production_company
FROM 
{{ source('PARADIME_MOVIE_CHALLENGE_FINAL', 'OMDB_INFLATION_ADJUSTED') }} a
,LATERAL FLATTEN(INPUT => SPLIT(a.production_companies, ',')) g
where release_year between 1990 and 2023
and box_office is not null
),

stats_by_production as (
select production_company,
COUNT(*) AS MOVIES_MADE,
sum(BOX_OFFICE) as total_revenue,
sum(BOX_OFFICE)/COUNT(*) as box_office_per_film,
rank() OVER (ORDER BY COUNT(*) DESC) AS film_ct_score,
rank() OVER (ORDER BY sum(BOX_OFFICE)/COUNT(*) DESC) AS film_rev_score
FROM production_unnest
GROUP BY production_company
having count(*) > 10
)

select * from stats_by_production