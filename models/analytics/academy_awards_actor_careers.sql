WITH academy_awards AS (
	SELECT 
		person_name as actor_name,
		person_identifier as actor_person_identifier,
		imdb_id,
		movie_title,
		award_date,
		award_title
	FROM {{ref('dwh_academy_awards')}}
	WHERE WON = TRUE
),
actor_works AS (
	SELECT 
		person_identifier,
		person_name AS actor_name,
		imdb_id,
		release_year, 
		ROW_NUMBER() OVER (PARTITION BY person_identifier ORDER BY release_year) AS movie_number_for_actor
	FROM {{ref('dwh_movie_people')}}
	WHERE person_role = 'ACTOR'
	ORDER BY PERSON_NAME, movie_number_for_actor
)
SELECT 
	aa.actor_name,
	aa.actor_person_identifier,
	aa.imdb_id,
	aa.movie_title,
	aa.award_date,
	aa.award_title,
	aw.movie_number_for_actor
FROM 
    academy_awards AS aa
JOIN 
    actor_works AS aw 
	    ON aw.person_identifier = aa.actor_person_identifier
            AND aw.imdb_id = aa.imdb_id