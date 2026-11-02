SELECT 
    DATE_TRUNC('month', search_date) AS month,
    search_term as ROLE,
    COUNT(*) as POSTINGS
    FROM {{ ref('job_postings') }}
    GROUP BY 1,2
    ORDER BY 1,2
