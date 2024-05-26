WITH all_nominations AS (
    SELECT
        nominee
        , award
        , category
        , COUNT(*) AS total_nominations
    FROM
        {{ ref('int_awards_categories_normalize') }}
    GROUP BY
        nominee
        , category
        , award
),

total_wins AS (
    SELECT
        nominee
        , award
        , category
        , COUNT(*) AS total_wins
    FROM
        {{ ref('int_awards_categories_normalize') }}
    WHERE 
        winner = TRUE
    GROUP BY
        nominee
        , category
        , award
)

SELECT 
    an.nominee
    , an.award
    , an.category
    , an.total_nominations
    , COALESCE(tw.total_wins, 0) AS total_wins
    , COALESCE(tw.total_wins, 0) / an.total_nominations AS win_rate
FROM 
    all_nominations an
LEFT JOIN 
    total_wins tw ON tw.nominee = an.nominee AND tw.category = an.category