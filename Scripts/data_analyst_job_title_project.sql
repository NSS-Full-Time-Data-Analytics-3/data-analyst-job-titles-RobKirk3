--1. How many rows are in the data_analyst_jobs table?
SELECT COUNT(*)
FROM data_analyst_jobs;
--1793


--2. Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?
SELECT * 
FROM data_analyst_jobs
LIMIT 10;
-- ExxonMobil


--3. How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?
SELECT COUNT(location) AS tn_postings
FROM data_analyst_jobs
WHERE location LIKE 'TN';
--21 in TN
SELECT COUNT(location) AS tn_ky_postings
FROM data_analyst_jobs
WHERE location LIKE 'TN'
OR location LIKE 'KY';
--27 postings for both


--4. How many postings in Tennessee have a star rating above 4?
SELECT COUNT(star_rating)
FROM data_analyst_jobs
WHERE location LIKE 'TN'
AND star_rating > 4;
--3

--5. How many postings in the dataset have a review count between 500 and 1000?
SELECT DISTINCT COUNT(*)
FROM data_analyst_jobs
WHERE review_count BETWEEN 500 AND 1000;
--151


/*6. Show the average star rating for companies in each state. 
The output should show the state as state and the average rating for the state as avg_rating. 
Which state shows the highest average rating?*/
SELECT location AS state, AVG(DISTINCT star_rating)::NUMERIC(10,2) AS avg_rating
FROM data_analyst_jobs
GROUP BY state
ORDER BY avg_rating;
--NE 4.20 


--7. Select unique job titles from the data_analyst_jobs table. How many are there?
SELECT COUNT(DISTINCT(title))
FROM data_analyst_jobs;
--881

--8 How many unique job titles are there for California companies?
SELECT COUNT(DISTINCT(title)), location
FROM data_analyst_jobs
WHERE location ='CA'
GROUP BY location;
-- 230

/*9 Find the name of each company 
and its average star rating 
for all companies that have more than 5000 reviews 
across all locations. 
How many companies are there with more than 5000 reviews across all locations?*/
SELECT company, star_rating, review_count, location
FROM data_analyst_jobs
WHERE review_count > 5000;
/*works, have duplicate company names but they all have different locations/
I think this is what the question is asking? 
according to this there are 185 companies (got by scrolling down)
Is it asking for how many total companies? or how many unique companies? 2 part question?*/
SELECT COUNT(DISTINCT(company))
FROM data_analyst_jobs
WHERE review_count > 5000
GROUP BY company;
/*no idea how to interpret what this is returning. 40 rows return "1", 1 row returns "0".
Perhaps there are 40 unique companies? Moving on...*/



/*10 Add the code to order the query in #9 from highest to lowest average star rating. 
Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? 
What is that rating?*/
SELECT company, star_rating, review_count, location
FROM data_analyst_jobs
WHERE review_count > 5000
ORDER BY star_rating DESC;
/*Several have 4.199999809:
Many instances: Microsoft, Kaiser Permanente, American Express, Nike  
Single instance: Unilever, General Motors*/

--11 Find all the job titles that contain the word ‘Analyst’. How many different job titles are there?
SELECT COUNT(DISTINCT(title))
FROM data_analyst_jobs
WHERE title ILIKE '%analyst%';
--774
-- Take COUNT out to see what the titles are!


/*12 How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? 
What word do these positions have in common?*/
SELECT DISTINCT(title)
FROM data_analyst_jobs
WHERE title NOT ILIKE '%analy%';
--4
--Tableau


/*BONUS: You want to understand which jobs requiring SQL are hard to fill. 
Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks.
	- Disregard any postings where the domain is NULL.
	- Order your results so that the domain with the greatest number of hard to fill jobs is at the top.
	- Which three industries are in the top 4 on this list? 
	  How many jobs have been listed for more than 3 weeks for each of the top 4?*/
SELECT *
FROM data_analyst_jobs
WHERE skill ILIKE '%SQL%'
AND days_since_posting > 21
--made sure this worked first. 619 results. Time to refine!
AND domain IS NOT NULL;
--adding domain took it down to 403. Now that this works its time to tweak further

SELECT COUNT(DISTINCT(title)) AS hard_to_fill_jobs, domain
FROM data_analyst_jobs
WHERE skill ILIKE '%SQL%'
AND days_since_posting > 21
AND domain IS NOT NULL
GROUP BY domain
ORDER BY hard_to_fill_jobs DESC;
/*Which 3 industries in top 4? How many jobs each?
Internet and Software - 42
Health Care - 40
Banks and Financial Services - 38
Consulting and Business Services - 31
*/
