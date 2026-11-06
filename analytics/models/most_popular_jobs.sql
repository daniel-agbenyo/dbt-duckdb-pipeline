select 
    count(*) as number_of_postings,
    search_term as role
from {{ ref('job_postings') }}
where search_term is not null
group by 2
order by 1 desc