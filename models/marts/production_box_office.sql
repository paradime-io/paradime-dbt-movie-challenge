select production_company,
MOVIES_MADE,
round(total_revenue,0) as total_revenue
FROM {{ source('PRODUCTION_COMPANIES_OVERALL', 'production_companies') }}
order by total_revenue desc
limit 50
