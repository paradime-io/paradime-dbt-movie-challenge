/*
This model groups the number of occurrences of each genre by decade to calculate the market share and the growth rate.

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
  - name: GENRE_OCCURRENCES_PREVIOUS_10_YEARS
    description: The number of occurences of the genre in the previous 10 years (2004-2013).
    meta:
      dimension:
        hidden: true
      metrics:
        number_of_movies_previous_10_years:
          type: sum
  - name: GENRE_OCCURRENCES_LAST_10_YEARS
    description: The number of occurences of the genre in the last 10 years (2014-2023).
    meta:
      dimension:
        hidden: true
      metrics:
        number_of_movies_last_10_years:
          type: sum
  - name: GROWTH_RATE
    description: The growth rate of the genre in the last 10 years (2014-2023) compared to the previous 10 years (2004-2013).
    meta:
      dimension:
        hidden: true
      metrics:
        growth_rate:
          type: sum
          format: percent
  - name: PERCENTAGE_LAST_10_YEARS
    description: The percentage of movies in the last 10 years (2014-2023) that are of the given genre.
    meta:
      dimension:
        hidden: true
      metrics:
        percent_of_movies_last_10_years:
          type: sum
          format: percent
*/

WITH CTE_FILTERED_GENRES AS (
  SELECT
    GENRE,
    GENRE_OCCURRENCES,
    RELEASE_YEAR
  FROM {{ ref('genre_by_year') }}
),

CTE_PREVIOUS_10_YEARS AS (
  SELECT
    GENRE,
    SUM(GENRE_OCCURRENCES) AS GENRE_OCCURRENCES
  FROM CTE_FILTERED_GENRES
  WHERE
    1 = 1
    AND RELEASE_YEAR >= 2004
    AND RELEASE_YEAR < 2014
  GROUP BY 1

),

CTE_LAST_10_YEARS AS (
  SELECT
    GENRE,
    SUM(GENRE_OCCURRENCES) AS GENRE_OCCURRENCES
  FROM CTE_FILTERED_GENRES
  WHERE
    1 = 1
    AND RELEASE_YEAR >= 2014
    AND RELEASE_YEAR < 2024
  GROUP BY 1

),

CTE_GROWTH_RATE AS (
  SELECT
    COALESCE(P.GENRE, L.GENRE) AS GENRE,
    P.GENRE_OCCURRENCES AS GENRE_OCCURRENCES_PREVIOUS_10_YEARS,
    L.GENRE_OCCURRENCES AS GENRE_OCCURRENCES_LAST_10_YEARS,
    ROUND((L.GENRE_OCCURRENCES - P.GENRE_OCCURRENCES) / P.GENRE_OCCURRENCES, 4) AS GROWTH_RATE,
    ROUND(L.GENRE_OCCURRENCES / SUM(L.GENRE_OCCURRENCES) OVER (), 4) AS PERCENTAGE_LAST_10_YEARS

  FROM CTE_PREVIOUS_10_YEARS AS P
  FULL OUTER JOIN CTE_LAST_10_YEARS AS L ON P.GENRE = L.GENRE
)

SELECT *
FROM CTE_GROWTH_RATE
