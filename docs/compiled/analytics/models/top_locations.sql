SELECT 
job_location AS  LOCATION,
COUNT(*) AS POSTINGS
FROM "dev"."main"."job_postings"
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10