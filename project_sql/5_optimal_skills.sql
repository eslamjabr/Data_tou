/*
Answer: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
offering strategic insights for career development in data analysis
*/


WITH Skill_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) demand_count
    FROM job_postings_fact 
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where 
        job_title_short = 'Data Analyst' 
    and
        salary_year_avg IS NOT NULL 
    and
        job_work_from_home = 'Yes'
    group by 
        skills_dim.skill_id
) , average_salary as (
    SELECT 
        skills_job_dim.skill_id,
        round(avg(job_postings_fact.salary_year_avg) , 2) avg_salary
    FROM job_postings_fact 
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where job_title_short = 'Data Analyst' 
        and
        salary_year_avg IS NOT NULL 
        and
        job_work_from_home = 'Yes'
    group by 
        skills_job_dim.skill_id
)

SELECT 
    Skill_demand.skill_id,
    Skill_demand.skills,
    demand_count,
    avg_salary
FROM Skill_demand
inner join average_salary on Skill_demand.skill_id = average_salary.skill_id
where demand_count > 10
order by 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;



--rewriting this same query more concisely
SELECT
    skills_dim.skill_id, 
    skills_dim.skills,
    COUNT (skills_job_dim.job_id) AS demand_count,
    ROUND(AVG (job_postings_fact.salary_year_avg) , 0)
AS avg_salary
FROM company_dim
job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
job_title_short = 'Data Analyst'
AND
salary_year_avg IS NOT NULL
AND
job_work_from_home = 'Yes'
GROUP BY skills_dim.skill_id
HAVING
COUNT (skills_job_dim.job_id) > 10
ORDER BY
avg_salary DESC,
demand_count DESC
LIMIT 25;