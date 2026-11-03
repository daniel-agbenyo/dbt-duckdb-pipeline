SELECT 
    DATE_TRUNC('month', search_date) AS MONTH,
    search_term AS ROLE,
    COUNT(*) AS POSTINGS
    FROM {{ ref('job_postings') }}
    GROUP BY 1,2
    ORDER BY 1,2
