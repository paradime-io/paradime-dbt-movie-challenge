select production_company,
MOVIES_MADE
FROM {{ source('PRODUCTION_COMPANIES_OVERALL', 'production_companies') }}
order by MOVIES_MADE desc
limit 50
