/*
This model groups the number of occurrences of each genre by decade.
Scaling factor is applied to the current decade to account for the fact that the decade is not yet complete.
This scaling factor is calculated as the number of years remaining in the current decade.
All the frequencies in the current decade are multiplied by that factor.
This assumes that the relative frequency of genres in the remaining years of the current decade will be the same as the relative frequency of genres in the years that have already passed.

```dbt
columns:
  - name: GENRE
    description: the genre of the movie
    meta:
      dimension:
        type: string
        colors:
          "Comedy": "#ffeb3b"      # Yellow: Light, cheerful
          "War": "#9e9e9e"         # Gray: Gritty, somber
          "Drama": "#673ab7"       # Dark Purple: Deep, intense emotions
          "Western": "#8b4513"     # Saddle Brown: Earthy, rugged
          "Animation": "#03a9f4"   # Light Blue: Vibrant, playful
          "Musical": "#e91e63"     # Bright Pink: Lively, expressive
          "Documentary": "#008080" # Teal: Balanced, calming
          "TV Movie": "#607d8b"    # Blue Gray: Versatile, general appeal
          "Thriller": "#cddc39"    # Lime: Electric, suspenseful
          "Romance": "#f06292"     # Soft Pink: Love, tenderness
          "Music": "#ff9800"       # Orange: Energetic, dynamic
          "Horror": "#b71c1c"      # Dark Red: Blood, fear
          "Crime": "#212121"       # Deep Grey: Dark, mysterious
          "Action": "#f44336"      # Red: Bold, exciting
          "Adventure": "#4caf50"   # Green: Growth, journey
          "Biography": "#795548"   # Brown: Earthy, authentic
          "Family": "#ffca28"      # Amber: Warmth, comfort
          "Fantasy": "#9c27b0"     # Deep Purple: Magical, mystical
          "History": "#3f51b5"     # Indigo: Deep, significant
          "Mystery": "#263238"     # Charcoal: Dark, enigmatic
          "Sci-Fi": "#00bcd4"      # Cyan: Futuristic, technologically advanced
          "Sport": "#8bc34a"       # Light Green: Energy, health, vigor
  - name: RELEASE_DECADE
    description: the decade the movie was released
    meta:
      dimension:
        type: string
  - name: SCALED_GENRE_OCCURRENCES
    description: The number of occurences of the genre in the given decade divided by the average number of genres per movie that year. Scaled for the current (unifnished) decade to extrapolate the number of occurrences for the full decade.
    meta:
      dimension:
        hidden: true
      metrics:
        number_of_movies:
          type: sum
  - name: PERCENTAGE_SCALED_GENRE_OCCURRENCES
    description: The percentage of movies that decade that are of the given genre. Scaled for the current (unifnished) decade to extrapolate the number of occurrences for the full decade.
    meta:
      dimension:
        hidden: true
      metrics:
        percent_of_movies:
          type: sum
          format: percent
```
*/

WITH
CTE_CURRENT_DECADE AS (SELECT MAX(DECADE) AS CURRENT_DECADE FROM {{ ref('all_years') }}),

CTE_GROUP_BY_DECADE AS (
  SELECT
    G.GENRE,
    G.RELEASE_DECADE,
    SUM(G.GENRE_OCCURRENCES) AS GENRE_OCCURRENCES
  FROM {{ ref('genre_by_year') }} AS G
  GROUP BY 1, 2
),

CTE_FINISHED_DECADES AS (
  SELECT
    G.GENRE,
    G.RELEASE_DECADE,
    G.GENRE_OCCURRENCES
  FROM CTE_GROUP_BY_DECADE AS G
  CROSS JOIN CTE_CURRENT_DECADE AS D
  WHERE
    1 = 1
    AND G.RELEASE_DECADE < D.CURRENT_DECADE
),

CTE_UNFINISHED_DECADE AS (
  SELECT
    G.GENRE,
    G.RELEASE_DECADE,
    G.GENRE_OCCURRENCES
  FROM CTE_GROUP_BY_DECADE AS G
  CROSS JOIN CTE_CURRENT_DECADE AS D
  WHERE
    1 = 1
    AND G.RELEASE_DECADE = D.CURRENT_DECADE
),

CTE_DECADE_SCALING AS (
  SELECT (10 - MAX(Y.DATE_YEAR) + MIN(Y.DATE_YEAR)) AS SCALING_FACTOR
  FROM {{ ref('all_years') }} AS Y
  CROSS JOIN CTE_CURRENT_DECADE AS D
  WHERE
    1 = 1
    AND Y.DECADE = D.CURRENT_DECADE
),

CTE_SCALE_CURRENT_DECADE AS (
  SELECT
    U.GENRE,
    U.RELEASE_DECADE,
    U.GENRE_OCCURRENCES * S.SCALING_FACTOR AS SCALED_GENRE_OCCURRENCES
  FROM CTE_UNFINISHED_DECADE AS U
  CROSS JOIN CTE_DECADE_SCALING AS S
),

CTE_UNION AS (
  SELECT * FROM CTE_SCALE_CURRENT_DECADE
  UNION ALL
  SELECT * FROM CTE_FINISHED_DECADES
),

CTE_PERCENTAGE AS (
  SELECT
    *,
    ROUND((SCALED_GENRE_OCCURRENCES / SUM(SCALED_GENRE_OCCURRENCES) OVER (PARTITION BY RELEASE_DECADE)), 2) AS PERCENTAGE_SCALED_GENRE_OCCURRENCES
  FROM CTE_UNION
)

SELECT *
FROM CTE_PERCENTAGE
