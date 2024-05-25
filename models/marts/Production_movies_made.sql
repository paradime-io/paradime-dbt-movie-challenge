select production_company,
MOVIES_MADE,
total_revenue,
film_ct_score,
film_rev_score,
film_ct_score*film_rev_score as combo_score
FROM {{ source('PRODUCTION_COMPANIES', 'rev_by_production') }}
order by MOVIES_MADE desc
limit 50
