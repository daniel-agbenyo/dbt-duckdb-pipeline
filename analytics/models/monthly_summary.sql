WITH total_posts AS (
    SELECT 
        MONTH,
        SUM(POSTINGS) AS TOTAL_POSTINGS
    FROM {{ ref('jobs_per_month') }}
    GROUP BY 1
),
remote_posts AS(
    SELECT
        DATE_TRUNC('month',search_date) AS MONTH,
        COUNT(job_work_from_home) AS REMOTE_POSTINGS
    FROM {{ ref('job_postings') }}
    WHERE job_work_from_home = true
    GROUP BY 1
)
SELECT 
    tp.MONTH as MONTH,
    tp.TOTAL_POSTINGS as TOTAL_JOB_POSTS,
    rp.REMOTE_POSTINGS as REMOTE_JOB_POSTS,
    ROUND((rp.REMOTE_POSTINGS / tp.TOTAL_POSTINGS)  * 100, 2) AS REMOTE_JOB_POSTS_PCT 
FROM total_posts tp
JOIN remote_posts rp USING (MONTH)
GROUP BY 1,2,3
ORDER BY 1