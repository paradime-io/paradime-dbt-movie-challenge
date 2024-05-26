-- Want to visualize the cumulative total movie count by country to better understand 
-- the proportional dominance of the countries that have made the most movies in the 
-- dataset

WITH country_counts AS (
	SELECT 
		PRODUCTION_COUNTRY,
		count(DISTINCT imdb_id) AS count_movies
	FROM analytics.COUNTRY_SUMMARY
	GROUP BY PRODUCTION_COUNTRY
)
SELECT 
	production_country,
	sum(count_movies) OVER (ORDER BY count_movies DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM 
	country_counts