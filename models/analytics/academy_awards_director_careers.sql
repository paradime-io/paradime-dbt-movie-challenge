WITH academy_awards AS (
	SELECT 
		director_name,
		director_person_identifier,
		imdb_id,
		movie_title,
		award_date,
		award_title
	FROM {{ref('dwh_academy_awards')}}
	WHERE WON = TRUE
),
director_works AS (
	SELECT 
		person_identifier,
		person_name AS director_name,
		imdb_id,
		release_year, 
		ROW_NUMBER() OVER (PARTITION BY person_identifier ORDER BY release_year) AS movie_number_for_director
	FROM {{ref('dwh_movie_people')}}
	WHERE person_role = 'DIRECTOR'
	ORDER BY PERSON_NAME, movie_number_for_director
)
SELECT 
	aa.director_name,
	aa.director_person_identifier,
	aa.imdb_id,
	aa.movie_title,
	aa.award_date,
	aa.award_title,
	dw.movie_number_for_director
FROM 
    academy_awards AS aa
JOIN 
    director_works AS dw 
	    ON dw.person_identifier = aa.director_person_identifier
            AND dw.imdb_id = aa.imdb_id