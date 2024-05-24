/*
In the model int_omdb_ratings, we are using hardcoded explicit logic to extract the ratings from each rating source.
If a new score source is added, we will need to make sure that we are aware of it and that we have a transformation logic for it.
*/


  SELECT
    O.IMDB_ID,
    FLATTENED_RATINGS.VALUE:Source::STRING AS SOURCE,
    FLATTENED_RATINGS.VALUE:Value::STRING AS RATING_VALUE
  FROM
    {{ ref('stg_omdb_movies') }} AS O,
    LATERAL FLATTEN(input => O.RATINGS) AS FLATTENED_RATINGS
  WHERE FLATTENED_RATINGS.VALUE:Source::STRING NOT IN ('Internet Movie Database', 'Rotten Tomatoes', 'Metacritic')
