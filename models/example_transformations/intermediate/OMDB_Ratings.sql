select *
FROM   
    {{ref('cleaned_omdb_movies')}}
where 
    IMDB_ID = 'tt0499335'