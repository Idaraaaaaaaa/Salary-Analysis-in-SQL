-- Q1. Write a code to check NULL values
SELECT *
FROM mentorness.covid19
WHERE 
    Province IS NULL OR `Country/Region` IS NULL
    OR Latitude IS NULL OR Longitude IS NULL
    OR `Date` IS NULL OR Confirmed IS NULL
    OR Deaths IS NULL OR Recovered IS NULL;
    
-- Q2. If NULL values are present, update them with zeros for all columns. 
SET SQL_SAFE_UPDATES = 0;
UPDATE mentorness.covid19
SET 
    Province = COALESCE(Province, 0),
    `Country/Region` = COALESCE(`Country/Region`, 0),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    `Date` = COALESCE(`Date`, 0),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);
    
-- Q3. check total number of rows

SELECT COUNT(*) AS Total_Rows
FROM mentorness.covid19;
-- Q4. Check what is start_date and end_date
SELECT 
	MIN(DATE(Date)) AS Start_Date,
    MAX(DATE(Date)) AS End_Date
FROM mentorness.covid19;
-- Q5. Number of month present in dataset
SELECT 
	COUNT(DISTINCT CONCAT(YEAR(`Date`), '-', MONTH(`Date`))) 
    AS "Number of Months"
FROM mentorness.covid19;

-- Q6. Find monthly average for confirmed, deaths, recovered

SELECT
    YEAR(Date) AS Year,
    ROUND(MONTH(Date)) AS Month,
    ROUND(AVG(Confirmed)) AS Average_Confirmed,
    ROUND(AVG(Deaths)) AS Average_Deaths,
    ROUND(AVG(Recovered)) AS Average_Recovered
FROM mentorness.covid19
GROUP BY Year, Month
ORDER BY Year, Month;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) as Month,
    MAX(Confirmed) AS Frequent_Confirmed,
    MAX(Deaths) AS Frequent_Deaths,
    MAX(Recovered) AS Frequent_Recovered
FROM mentorness.covid19
GROUP BY Year,Month;
-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT 
    YEAR(Date) AS Year,
    MIN(Confirmed) AS Min_Confirmed,
    MIN(Deaths) AS Min_Deaths,
    MIN(Recovered) AS Min_Recovered
FROM mentorness.covid19
GROUP BY Year;
-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT 
    YEAR(Date) AS Year,
    MAX(Confirmed) AS Max_Confirmed,
    MAX(Deaths) AS Max_Deaths,
    MAX(Recovered) AS Max_Recovered
FROM mentorness.covid19
GROUP BY Year;

-- Q10. The total number of case of confirmed, deaths, recovered each month

SELECT 
    YEAR(`Date`) AS Year,
    MONTH(`Date`) AS Month,
    SUM(Confirmed) AS Total_Confirmed,
    SUM(Deaths) AS Total_Deaths,
    SUM(Recovered) AS Total_Recovered
FROM mentorness.covid19
GROUP BY Year, Month;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    SUM(Confirmed) AS Total_Confirmed,
    ROUND(AVG(Confirmed)) AS Avg_Confirmed,
    ROUND(VARIANCE(Confirmed)) AS Var_Confirmed,
    ROUND(STDDEV(Confirmed)) AS Stdev_Confirmed
FROM mentorness.covid19
GROUP BY Year, Month
ORDER BY Year, Month;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    SUM(Deaths) AS Total_Deaths,
    ROUND(AVG(Deaths)) AS Avg_Deaths,
    ROUND(VARIANCE(Deaths)) AS Var_Deaths,
    ROUND(STDDEV(Deaths)) AS Stdev_Deaths
FROM mentorness.covid19
GROUP BY Year, Month
ORDER BY Year, Month;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    SUM(Recovered) AS Total_Recovered,
    ROUND(AVG(Recovered)) AS Avg_Recovered,
    ROUND(VARIANCE(Recovered)) AS Var_Recovered,
    ROUND(STDDEV(Recovered)) AS Stdev_Recovered
FROM mentorness.covid19
GROUP BY Year, Month
ORDER BY Year, Month;

-- Q14. Find Country having highest number of the Confirmed case
SELECT
    `Country/Region` AS Country,
    MAX(Confirmed) AS Highest_Confirmed_Cases
FROM mentorness.covid19
GROUP BY `Country/Region`
ORDER BY MAX(Confirmed) DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
SELECT
    Country,
    MIN(Total_Deaths) AS Deaths
FROM (
    SELECT
        `Country/Region` AS Country,
        SUM(Deaths) AS Total_Deaths
    FROM
        mentorness.covid19
    GROUP BY
        `Country/Region`
) AS all_deaths
GROUP BY Country
ORDER BY Total_Deaths asc
LIMIT 1;
-- Q16. Find top 5 countries having highest recovered case
SELECT
    Country,
    Total_Recovered
FROM (
    SELECT
        `Country/Region` AS Country,
        SUM(Recovered) AS Total_Recovered,
        RANK() OVER (ORDER BY SUM(Recovered) DESC) AS ranking
    FROM
        mentorness.covid19
    GROUP BY
        `Country/Region`
) AS ranked
WHERE ranking <= 5;