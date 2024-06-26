--Chapter I : Exploring the Olympics Dataset
/*Before you can start building out reports to answer specific questions, 
you should get familiar with the data. In this chapter, 
you will learn how to use E:R diagrams and data exploration techniques 
to get a solid understanding of the data to better answer business-related questions.

Building the base report
Now, build the base report for this visualization:

Most Athletes Represented
Top 3 Sports 

	Sport A |----------------------
	Sport B |------------------
	Sport C |------------

This should be built by querying the summer_games table, 
found in the explorer on the bottom right.

Instructions :
    -Using the console on the right, select the sport field from 
		the summer_games table.
    -Create athletes by counting the distinct occurrences of athlete_id.
    -Group by the sport field.
    -Make the report only show 3 rows, with the highest athletes at the top.
*/

SELECT 
	sport, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport
-- Only include the 3 sports with the most athletes
ORDER BY athletes
LIMIT 3;

/*
Athletes vs events by sport
Now consider the following visualization:

		|
		|
	  	|            x
     Events	|   x      x    
		| x   x  x
		|       x          x
	 	 ---------------------
			Athletes
Using the summer_games table. run a query that creates the base report that sources
this visualization.

Insctructions:
    -Pull a report that shows each sport, 
		the number of unique events, 
		and the number of unique athletes from the summer_games table.
    -Group by the non-aggregated field, which is sport.
*/

SELECT 
	sport, 
    COUNT(DISTINCT event) AS events, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport;

/*
Age of the oldest athlete by region

In the previous exercise, 
you identified which tables are needed to create a report that shows Age of 
Oldest Athlete by Region. Now, set up the query to create this report.

Instructions

    -Create a report that shows region and age_of_oldest_athlete.
    -Include all three tables by running two separate JOIN statements.
    -Group by the non-aggregated field.
    -Alias each table AS the first letter in the table (in lower case).
*/
SELECT 
	region, 
    MAX(a.age) AS age_of_oldest_athlete
FROM athletes a
-- First JOIN statement
JOIN summer_games sg
ON a.id = sg.athlete_id
-- Second JOIN statement
JOIN countries c
ON c.id= sg.country_id
GROUP BY region;
/*
Number of events in each sport

Since the company will be involved in both summer sports and winter sports, 
it is beneficial to look at all sports in one centralized report.
Your task is to create a query that shows the unique number of events 
held for each sport. Note that since no relationships 
exist between these two tables, you will need to use a UNION instead of a JOIN.

Instructions

    -Create a report that shows unique events by sport for both summer and winter events.
    -Use a UNION to combine the relevant tables.
    -Use two GROUP BY statements as needed.
    -Order the final query to show the highest number of events first.
*/
SELECT 
	sport, 
    COUNT(DISTINCT event) AS events
FROM summer_games
GROUP BY sport
UNION
-- Select sport and events for winter sports
SELECT 
	sport, 
    COUNT(DISTINCT event) AS events
FROM winter_games
GROUP BY sport
-- Show the most events at the top of the report
ORDER BY events DESC;

/*
Exploring summer_games

Exploring the data in a table can provide further insights into the database 
as a whole. In this exercise, you will try out a series of different techniques 
to explore the summer_games table.

Insctructions
	-Select bronze from the summer_games table, but do not use DISTINCT or GROUP BY.
*/
-- Update the query to explore the bronze field
SELECT bronze
FROM summer_games;
/*
The results do not provide much insight as we mostly see NULL.
Add a DISTINCT to only show unique bronze values.
*/
SELECT DISTINCT bronze
FROM summer_games;
/*
GROUP BY is an alternative to using DISTINCT. 
Remove the DISTINCT and add a GROUP BY statement.
*/
SELECT  bronze
FROM summer_games
GROUP BY bronze;
/*
Let's see how much of our dataset is NULL.
Add a field that shows number of rows to your query.
*/
SELECT 
	bronze, 
	COUNT(*) AS rows
FROM summer_games
GROUP BY bronze;
/*
Validating our query

The same techniques we use to explore the data can be used to validate queries. By using the query as a subquery, 
you can run exploratory techniques to confirm the query results are as expected.
In this exercise, you will create a query that shows Bronze Medals by Country 
and then validate it using the subquery technique.
Feel free to reference the E:R Diagram as needed.

Instrcutions
Create a query that outputs total bronze medals from the summer_games table.
*/
SELECT COUNT(bronze) AS total_bronze_medals
FROM summer_games;
/*
The value for total_bronze_medals is commented out for reference. 
Setup a query that shows bronze_medals for summer_games by country.
*/

/* Pull total_bronze_medals from summer_games below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games; 
>> OUTPUT = 141 total_bronze_medals */

-- Setup a query that shows bronze_medal by country
SELECT 
	country, 
    SUM(bronze) AS bronze_medals
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
GROUP BY country;

/*
Add parenthesis to your query you just created and alias as subquery.
Select the total number of bronze_medals and compare to the total bronze medals in summer_games.
*/

/* Pull total_bronze_medals below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games; 
>> OUTPUT = 141 total_bronze_medals */

-- Select the total bronze_medals from your query
SELECT SUM(bronze_medals)
FROM( 
-- Previous query is shown below.  Alias this AS subquery
  SELECT 
      country, 
      SUM(bronze) AS bronze_medals
  FROM summer_games AS s
  JOIN countries AS c
  ON s.country_id = c.id
  GROUP BY country
) AS subquery;

/*
Report 1: Most decorated summer athletes

Now that you have a good understanding of the data, 
let's get back to our case study and build out the first element for the dashboard, 
Most Decorated Summer Athletes:
			
				|
				|	|
              Gold Medals	|	|	|	|
				|	|	|	|	|
			        -----------------------------------
				A	B	C	D	E
				           Athlete Name
Your job is to create the base report for this element. Base report details:
    -Column 1 should be athlete_name.
    -Column 2 should be gold_medals.
	-The report should only include athletes with at least 3 medals.
	-The report should be ordered by gold medals won, 
		with the most medals at the top.

Instructions :

    -Select athlete_name and gold_medals by joining summer_games and athletes.
    -Only include athlete_name with at least 3 gold medals.
    -Sort the table so that the most gold_medals appears at the top.
*/
SELECT 
	a.name AS athlete_name, 
    COUNT(s.gold) AS gold_medals
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
GROUP BY name
-- Filter for only athletes with 3 gold medals or more
HAVING COUNT(s.gold) > 2 
-- Sort to show the most gold medals at the top
ORDER BY gold_medals DESC;

--Chapter II : Creating Reports
/*
Queries can get large, 
fast. It's important to take a logical approach when building more complicated queries.
In this chapter, you will take a step-by-step approach to plan and build a complex query 
that requires you to combine tables in multiple ways and create different types of fields.

Planning the filter
Your boss is looking to see which winter events include athletes over the age of 40. 
To answer this, you need a report that lists out all events that satisfy this condition.
In order to have a correct list, you will need to leverage a filter. 
In this exercise, you will decide which filter option to use.

Instructions : 
	-Create a query that shows all unique event names in the winter_games table.
*/
SELECT DISTINCT event
FROM winter_games;
/*
Question
Which of the following approaches will not work to filter this list for events 
that have athletes over the age of 40?

Possible answers
	-JOIN to athletes and add a WHERE age > 40 clause.
	-Add a WHERE clause that references the following subquery: 
		SELECT id FROM athletes WHERE age > 40
	-JOIN to athletes and add a HAVING AVG(age) > 40.(X)

JOIN then UNION query
Your goal is to create a report with the following fields:

    season, which outputs either summer or winter
    country
    events, which shows the unique number of events

There are multiple ways to create this report. In this exercise, 
create the report by using the JOIN first, 
UNION second approach.
As always, feel free to reference your E:R Diagram to identify relevant fields and tables.

Instructions :

    -Setup a query that shows unique events by country and season for summer events.
    -Setup a similar query that shows unique events by country and season for winter events.
    -Combine the two queries using a UNION ALL.
    -Sort the report by events in descending order.
*/
-- Query season, country, and events for all summer events
SELECT 
	'summer' AS season, 
    country, 
    COUNT(DISTINCT event) AS events
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
GROUP BY season,country
-- Combine the queries
UNION ALL
-- Query season, country, and events for all winter events
SELECT 
	'winter' AS season, 
    country, 
    COUNT(DISTINCT event) AS events
FROM winter_games AS w
JOIN countries AS c
ON w.country_id = c.id
GROUP BY season,country
-- Sort the results to show most events at the top
ORDER BY events DESC;
/*
UNION then JOIN query
Your goal is to create the same report as before, which contains with the following fields:
    season, which outputs either summer or winter
    country
    events, which shows the unique number of events
In this exercise, create the query by using the UNION first, 
JOIN second approach. When taking this approach, 
you will need to use the initial UNION query as a subquery. 
The subquery will need to include all relevant fields, including those used in a join.
As always, feel free to reference the E:R Diagram.

Instructions :

    -In the subquery, construct a query that outputs season, 
		country_id and event by combining summer and winter games with a UNION ALL.
    -Leverage a JOIN and another SELECT statement to show the fields season, 
		country and unique events.
    -GROUP BY any unaggregated fields.
    -Sort the report by events in descending order.
*/
-- Add outer layer to pull season, country and unique events
SELECT 
	season, 
    country, 
    COUNT(DISTINCT event) AS events
FROM
    -- Pull season, country_id, and event for both seasons
    (SELECT 
     	'summer' AS season, 
     	country_id, 
     	event
    FROM summer_games
    UNION ALL
    SELECT 
     	'winter' AS season, 
     	country_id, 
     	event
    FROM winter_games) AS subquery
JOIN countries AS c
ON subquery.country_id = c.id
-- Group by any unaggregated fields
GROUP BY season,country
-- Order to show most events at the top
ORDER BY events DESC;
/*
CASE statement refresher
CASE statements are useful for grouping values into different buckets based on 
conditions you specify. Any row that fails to satisfy any condition will fall to 
the ELSE statement (or show as null if no ELSE statement exists).
In this exercise, your goal is to create the segment field that buckets an athlete 
into one of three segments:
    -Tall Female, which represents a female that is at least 175 centimeters tall.
    -Tall Male, which represents a male that is at least 190 centimeters tall.
    -Other
Each segment will need to reference the fields height and gender from the athletes table. 
Leverage CASE statements and conditional logic (such as AND/OR) to build this.
Remember that each line of a case statement looks like this: CASE WHEN {condition} 
THEN {output}
Instructions :
	-Update the CASE statement to output three values: Tall Female, Tall Male, and Other.
*/
SELECT 
	name,
    -- Output 'Tall Female', 'Tall Male', or 'Other'
	CASE 
    WHEN  gender = 'F' AND height >= 175 THEN 'Tall Female'
    WHEN gender = 'M' AND height >= 190 THEN 'Tall Male'
    ELSE 'Other' END AS segment
FROM athletes;
/*
BMI bucket by sport
You are looking to understand how BMI differs by each summer sport. 
To answer this, set up a report that contains the following:
    -sport, which is the name of the summer sport
    -bmi_bucket, which splits up BMI into three groups: <.25, .25-.30, >.30
    -athletes, or the unique number of athletes
Definition: BMI = 100 * weight / (height squared).
Also note that CASE statements run row-by-row, 
so the second conditional is only applied if the first conditional is false. 
This makes it that you do not need an AND statement excluding 
already-mentioned conditionals.
Feel free to reference the E:R Diagram.

Instructions: 

    -Build a query that pulls from summer_games and athletes to show sport, 
		bmi_bucket, and athletes.
    -Without using AND or ELSE, set up a CASE statement that splits bmi_bucket 
		into three groups: '<.25', '.25-.30', and '>.30'.
    -Group by the non-aggregated fields.
    -Order the report by sport and then athletes in descending order.
*/
-- Pull in sport, bmi_bucket, and athletes
SELECT 
	sport,
    -- Bucket BMI in three groups: <.25, .25-.30, and >.30	
    CASE WHEN (weight/height^2)*100 < .25 THEN '<.25'
    WHEN (weight/height^2)*100 >=.25 AND (weight/height^2)*100 <=.30 THEN '.25-.30'
    WHEN (weight/height^2)*100> .30 THEN '>.30' END AS bmi_bucket,
    COUNT(distinct athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
-- GROUP BY non-aggregated fields
GROUP BY sport,bmi_bucket
-- Sort by sport and then by athletes in descending order
ORDER BY sport,athletes DESC;
/*
Troubleshooting CASE statements

In the previous exercise, you may have noticed several null values in our case statement, 
which can indicate there is an issue with the code.
In these instances, 
it's worth investigating to understand why these null values are appearing. 
In this exercise, 
you will go through a series of steps to identify the issue and make 
changes to the code where necessary.

Instructions :
    -Comment out the query from last exercise (lines 2 - 12).
    -Create a query that pulls height, weight, 
		and bmi from athletes and filters for null bmi values.
*/
-- Query from last exercise shown below.  Comment it out.
/*SELECT 
	sport,
    CASE WHEN weight/height^2*100 <.25 THEN '<.25'
    WHEN weight/height^2*100 <=.30 THEN '.25-.30'
    WHEN weight/height^2*100 >.30 THEN '>.30' END AS bmi_bucket,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;
*/
-- Show height, weight, and bmi for all athletes
SELECT 
	height,
    weight,
    weight/height^2*100 AS bmi
FROM athletes
-- Filter for NULL bmi values
WHERE weight/height^2*100 IS NULL;

/*
Question

What is the reason we have null values in our bmi field?
Possible answers
	-Some athlete_ids found in our original query are not found in the athletes table.
	-There are numerous null height values, which will calculate null bmi values.
	-There are numerous null weight values, which will calculate null bmi values.(X)
	-Our case statement does not include values with a bmi that is extremely high.

Comment out the troubleshooting query, uncomment the original query, 
and add an ELSE line to the CASE statement that outputs 'no weight recorded'.
*/
-- Uncomment the original query
SELECT 
	sport,
    CASE WHEN weight/height^2*100 <.25 THEN '<.25'
    WHEN weight/height^2*100 <=.30 THEN '.25-.30'
    WHEN weight/height^2*100 >.30 THEN '>.30'
    -- Add ELSE statement to output 'no weight recorded'
    ELSE 'no weight recorded' END AS bmi_bucket,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;

-- Comment out the troubleshooting query
/*SELECT 
	sport, 
    weight, 
    weight/height^2*100 AS bmi
FROM athletes
WHERE weight/height^2*100 IS NULL;*/
/*
Filtering with a JOIN

When adding a filter to a query that requires you to reference a separate table, 
there are different approaches you can take. One option is to JOIN to the new table 
and then add a basic WHERE statement.
Your goal is to create a report with the following characteristics:

    First column is bronze_medals, or the total number of bronze.
    Second column is silver_medals, or the total number of silver.
    Third column is gold_medals, or the total number of gold.
    Only summer_games are included.
    Report is filtered to only include athletes age 16 or under.
In this exercise, use the JOIN approach.

Instructions : 

    -Create a query that pulls total bronze_medals, silver_medals, 
		and gold_medals from summer_games.
    -Use a JOIN and a WHERE statement to filter for athletes ages 16 and below.
*/
-- Pull summer bronze_medals, silver_medals, and gold_medals
SELECT 
	SUM(bronze) bronze_medals, 
    SUM(silver) silver_medals, 
    SUM(gold) gold_medals
    FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id 
-- Filter for athletes age 16 or below
WHERE age <= 16;

/*
Filtering with a subquery

Another approach to filter from a separate table is to use a subquery. 
The process is as follows:
    Create a subquery that outputs a list.
    In your main query, add a WHERE statement that references the list.
Your goal is to create the same report as the last exercise, 
which contains the following characteristics:
    First column is bronze_medals, or the total number of bronze.
    Second column is silver_medals, or the total number of silver.
    Third column is gold_medals, or the total number of gold.
    Only summer_games are included.
    Report is filtered to only include athletes age 16 or under.
In this exercise, use the subquery approach.

Instructions : 
    -Create a query that pulls total bronze_medals, silver_medals, 
		and gold_medals from summer_games.
    -Setup a subquery that outputs all athletes age 16 or below.
    -Add a WHERE statement that references the subquery to filter for athletes 
		age 16 or below.
*/
-- Pull summer bronze_medals, silver_medals, and gold_medals
SELECT 
	SUM(bronze) bronze_medals, 
    SUM(silver) silver_medals, 
    SUM(gold) gold_medals
FROM summer_games
-- Add the WHERE statement below
WHERE athlete_id IN
    -- Create subquery list for athlete_ids age 16 or below    
    (SELECT id
     FROM athletes
     WHERE age <= 16);
/*
Report 2: Top athletes in nobel-prized countries

It's time to bring together all the concepts brought up in this chapter to expand
on your dashboard! Your next report to build is 
Report 2: Athletes Representing Nobel-Prize Winning Countries.

Report Details:
    Column 1 should be event, which represents the Olympic event. Both summer and winter events should be included.
    Column 2 should be gender, which represents the gender of athletes in the event.
    Column 3 should be athletes, which represents the unique athletes in the event.
    Athletes from countries that have had no nobel_prize_winners should be excluded.
    The report should contain 10 events, where events with the most athletes show at the top.
Click to view the E:R Diagram.

Instructions :

-Select event from the summer_games table and create the athletes 
field by counting the distinct number of athlete_id.
*/
SELECT 	
	event,
	COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY event;
/*
Explore the event field to determine how to split up events by gender 
(without adding a join), then add the gender field by using a 
CASE statement that specifies a conditional for 'female' events 
(all other events should output as 'male').
*/
SELECT 
	event, 
    -- Add the gender field below
    CASE 
    WHEN event LIKE '%Men%' THEN 'male'
    ELSE 'female' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY event;
/*Filter for Nobel-prize-winning countries by creating a subquery that outputs 
country_id from the country_stats table for any country with more than zero 
nobel_prize_winners.*/
-- Pull event and unique athletes from summer_games 
SELECT 
    event,
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female' 
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
-- Only include countries that won a nobel prize
WHERE country_id IN 
	(SELECT country_id
    FROM country_stats
    WHERE nobel_prize_winners > 0)
GROUP BY event;
/*
Copy your query with summer_games replaced by winter_games, 
UNION the two tables together, and order the final report to show the 10 rows 
with the most athletes.*/
-- Pull event and unique athletes from summer_games 
SELECT 
    event,
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female' 
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
-- Only include countries that won a nobel prize
WHERE country_id IN 
	(SELECT country_id 
    FROM country_stats 
    WHERE nobel_prize_winners > 0)
GROUP BY event
-- Add the second query below and combine with a UNION
UNION ALL
SELECT 
	event,
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female' 
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM winter_games
WHERE country_id IN 
	(SELECT country_id
    FROM country_stats
    WHERE nobel_prize_winners > 0)
GROUP BY event,gender
-- Order and limit the final output
ORDER BY athletes DESC
LIMIT 10;

--Chapter III : Cleaning & Validation
/*
Although it would be nice, data in the real-world is rarely stored in an ideal way.
Simply put: data can get messy. In chapter 3, 
you will learn how to deal with this messy data by fixing data type issues, 
cleaning messy strings, handling nulls, and removing duplication.

Identifying data types

Being able to identify data types before setting up your query can help you plan 
for any potential issues. There is a group of tables, or a schema, 
called the information_schema, 
which provides a wide array of information about the database itself, 
including the structure of tables and columns.

The columns table houses useful details about the columns, including the data type.

Note that the information_schema is not the default schema SQL looks at when querying, 
which means you will need to explicitly tell SQL to pull from this schema. 
To pull a table from a non-default schema, use the syntax schema_name.table_name.

Instructions :
    -Select the fields column_name and data_type from the table columns that 
		resides within the information_schema schema.
    -Filter only for the 'country_stats' table.
*/
-- Pull column_name & data_type from the columns table
SELECT 
	column_name,
    data_type
FROM information_schema.columns
-- Filter for the table 'country_stats'
WHERE table_name = 'country_stats';
/*
Question

What is the data type of the year column?
Possible answers
	date
	character varying(X)
	double precision
	integer

Interpreting error messages

Inevitably, you will run into errors when running SQL queries. 
It is important to understand how to interpret these errors to correctly 
identify what type of error it is.

The console contains two separate queries, 
each which will output an error when ran. 
In this exercise, you will run each query, 
read the error message, and troubleshoot the error.

Instructions : 
    -Run the query in the console.
    -After reading the error, fix it by converting the data type to float.
*/
-- Run the query, then convert a data type to fix the error
SELECT AVG(CAST(pop_in_millions AS FLOAT)) AS avg_population
FROM country_stats;

/*SELECT 
	s.country_id, 
    COUNT(DISTINCT s.athlete_id) AS summer_athletes, 
    COUNT(DISTINCT w.athlete_id) AS winter_athletes
FROM summer_games AS s
JOIN winter_games_str AS w
ON s.country_id = w.country_id
GROUP BY s.country_id;*/

/*
    -Comment the first query and uncomment the second query.
    -Run the code and fix errors by making the join columns int.
*/
-- Comment out the previous query
/*SELECT AVG(CAST(pop_in_millions AS float)) AS avg_population
FROM country_stats;*/

-- Uncomment the following block & run the query
SELECT 
	s.country_id, 
    COUNT(DISTINCT s.athlete_id) AS summer_athletes, 
    COUNT(DISTINCT w.athlete_id) AS winter_athletes
FROM summer_games AS s
JOIN winter_games_str AS w
-- Fix the error by making both columns integers
ON s.country_id = w.country_id::int
GROUP BY s.country_id;

/*
Using date functions on strings
There are several useful functions that act 
specifically on date or datetime fields. For example:
    -DATE_TRUNC('month', date) truncates each date to the first day of the month.
    -DATE_PART('year', date) outputs the year, as an integer, of each date value.
In general, the arguments for both functions are ('period', field), 
where period is a date or time interval, such as 'minute', 'day', or 'decade'.

In this exercise, your goal is to test out these date functions on the country_stats table, 
specifically by outputting the decade of each year using two separate approaches. 
To run these functions, you will need to use CAST() function on the year field.

Instructions : 

    -Pulling from the country_stats table, select the decade using two methods: 
		DATE_PART() and DATE_TRUNC.
    -Convert the data type of the year field to fix errors.
    -Sum up gdp to get world_gdp.
    -Group and order by year (in descending order).
*/
SELECT 
	year,
    -- Pull decade, decade_truncate, and the world's gdp
    DATE_PART('decade',CAST(year AS date)) AS decade,
    DATE_TRUNC('decade',CAST(year AS date)) AS decade_truncated,
    SUM(gdp) AS world_gdp
FROM country_stats
-- Group and order by year in descending order
GROUP BY year
ORDER BY year DESC;
/*
String functions
There are a number of string functions that can be used to alter strings. 
A description of a few of these functions are shown below:
    The LOWER(fieldName) function changes the case of all characters in fieldName 
		to lower case.
    The INITCAP(fieldName) function changes the case of all characters 
		in fieldName to proper case.
    The LEFT(fieldName,N) function returns the left N characters of the string fieldName.
    The SUBSTRING(fieldName from S for N) returns N characters starting from position S 
		of the string fieldName. Note that both from S and for N are optional.

Instruction :
	-Update the field country_altered to output country in all lower-case.
*/
SELECT 
	country, 
    LOWER(country) AS country_altered
FROM countries
GROUP BY country;
--Update the field country_altered to output country in proper-case.
SELECT 
	country, 
    INITCAP(LOWER(country)) AS country_altered
FROM countries
GROUP BY country;
--Update the field country_altered to output the left 3 characters of country.
SELECT 
	country, 
    LEFT(country,3) AS country_altered
FROM countries
GROUP BY country;
--Update the field country_altered to output all characters 
--starting with the 7th character of country.
SELECT 
	country, 
    SUBSTRING(country FROM 7) AS country_altered
FROM countries
GROUP BY country;
/*
Replacing and removing substrings
The REPLACE() function is a versatile function that allows you to replace or 
remove characters from a string. The syntax is as follows:
REPLACE(fieldName, 'searchFor', 'replaceWith')
Where fieldName is the field or string being updated, 
searchFor is the characters to be replaced, and replaceWith is the replacement substring.
In this exercise, you will look at one specific value in the countries 
table and change up the format by using a few REPLACE() functions.

Instructions :

    Create the field character_swap that replaces all '&' characters with 'and' 
		from region.
    Create the field character_remove that removes all periods from region.
*/
SELECT 
	region, 
    -- Replace all '&' characters with the string 'and'
    REPLACE(region,'&','and') AS character_swap,
    -- Remove all periods
    REPLACE(region,'.','') AS character_remove
FROM countries
WHERE region = 'LATIN AMER. & CARIB'
GROUP BY region;
/*
Add a new field called character_swap_and_remove that runs the alterations 
of both character_swap and character_remove in one go.
*/
SELECT 
	region, 
    -- Replace all '&' characters with the string 'and'
    REPLACE(region,'&','and') AS character_swap,
    -- Remove all periods
    REPLACE(region,'.','') AS character_remove,
    -- Combine the functions to run both changes at once
    REPLACE(REPLACE(region,'&','and'),'.','') AS character_swap_and_remove
FROM countries
WHERE region = 'LATIN AMER. & CARIB'
GROUP BY region;
/*
Fixing incorrect groupings
One issues with having strings stored in different formats is that you may 
incorrectly group data. If the same value is represented in multiple ways, 
your report will split the values into different rows, 
which can lead to inaccurate conclusions.
In this exercise, you will query from the summer_games_messy table, 
which is a messy, smaller version of summer_games. You'll notice that the same 
event is stored in multiple ways. Your job is to clean the event field 
to show the correct number of rows.

Instructions :

    -Create a query that pulls the number of distinct athletes by event from the table 
		summer_games_messy.
    -Group by the non-aggregated field.
*/
SELECT 
	event, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games_messy
-- Group by the non-aggregated field
GROUP BY event;
/*
Notice how we see 6 rows that relate to only 2 events. 
Alter the event field by trimming all leading and trailing spaces, 
alias as event_fixed, and update the GROUP BY accordingly.
*/
SELECT
    -- Remove trailing spaces and alias as event_fixed
	TRIM(event) AS event_fixed,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games_messy
-- Update the group by accordingly
GROUP BY event_fixed;
/*
Notice how there are now only 4 rows. 
Alter the event_fixed field further by removing all dashes (-).
*/
SELECT 
    -- Remove dashes from all event values
    REPLACE(TRIM(event),'-','') AS event_fixed, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games_messy
-- Update the group by accordingly
GROUP BY event_fixed;
<<<<<<< HEAD
/*
Filtering out nulls

One way to deal with nulls is to simply filter them out. 
There are two important conditionals related to nulls:
    IS NULL is true for any value that is null.
    IS NOT NULL is true for any value that is not null. 
Note that a zero or a blank cell is not the same as a null.
These conditionals can be leveraged by several clauses, 
such as CASE statements, WHERE statements, and HAVING statements. 
In this exercise, you will learn how to filter out nulls using two separate 
techniques.
Feel free to reference the E:R Diagram.

Instructions :
    -Setup a query that pulls country and total golds as gold_medals for all winter games.
    -Group by the non-aggregated field and order by gold_medals in descending order.
*/
-- Show total gold_medals by country
SELECT 
	country,
    SUM(gold) AS gold_medals
FROM winter_games AS w
JOIN countries AS c
ON w.country_id = c.id
GROUP BY country
-- Order by gold_medals in descending order
ORDER BY gold_medals DESC;
/*
	-Setup a query that pulls country and total golds as gold_medals for all winter games.
    -Group by the non-aggregated field and order by gold_medals in descending order.
*/
-- Show total gold_medals by country
SELECT 
	country, 
    SUM(gold) AS gold_medals
FROM winter_games AS w
JOIN countries AS c
ON w.country_id = c.id
-- Removes any row with no gold medals
WHERE gold IS NOT NULL
GROUP BY country
-- Order by gold_medals in descending order
ORDER BY gold_medals DESC;
/*
We can do a similar filter using HAVING. 
Comment out the WHERE statement and add a HAVING statement that filters out 
countries with no gold medals.
*/
-- Show total gold_medals by country
SELECT 
	country, 
    SUM(gold) AS gold_medals
FROM winter_games AS w
JOIN countries AS c
ON w.country_id = c.id
-- Comment out the WHERE statement
--WHERE gold IS NOT NULL
GROUP BY country
-- Replace WHERE statement with equivalent HAVING statement
HAVING SUM(gold) IS NOT NULL 
-- Order by gold_medals in descending order
ORDER BY gold_medals DESC;
/*
Fixing calculations with coalesce

Null values impact aggregations in a number of ways. 
One issue is related to the AVG() function. By default, 
the AVG() function does not take into account any null values. 
However, there may be times when you want to include these null values 
in the calculation as zeros.
To replace null values with a string or a number, use the COALESCE() function. 
Syntax is COALESCE(fieldName,replacement), where replacement is what should replace 
all null instances of fieldName.
This exercise will walk you through why null values can 
throw off calculations and how to troubleshoot these issues.

Instruction
Build a report that shows total_events and gold_medals by athlete_id for all 
summer events, ordered by total_events descending then athlete_id ascending.
*/
-- Pull events and golds by athlete_id for summer events
SELECT 
    athlete_id,
    COUNT(event) AS total_events, 
    SUM(gold) AS gold_medals
FROM summer_games
GROUP BY athlete_id
-- Order by total_events descending and athlete_id ascending
ORDER BY total_events DESC;
--Create a field called avg_golds that averages the gold field.
-- Pull events and golds by athlete_id for summer events
SELECT 
    athlete_id, 
    -- Add a field that averages the existing gold field
    AVG(gold) AS avg_golds,
    COUNT(event) AS total_events, 
    SUM(gold) AS gold_medals
FROM summer_games
GROUP BY athlete_id
-- Order by total_events descending and athlete_id ascending
ORDER BY total_events DESC, athlete_id;
/*
Question

If the report was accurate, what should the first three values of avg_golds be?
Possible answers
[8, 8, 1]
[0, 0, .125](X)
[0, 0, 1]
[0, 0, 8]
*/
--Fix the avg_golds field by replacing null values with zero.
-- Pull events and golds by athlete_id for summer events
SELECT 
    athlete_id, 
    -- Replace all null gold values with 0
    AVG(COALESCE(gold,0)) AS avg_golds,
    COUNT(event) AS total_events, 
    SUM(gold) AS gold_medals
FROM summer_games
GROUP BY athlete_id
-- Order by total_events descending and athlete_id ascending
ORDER BY total_events DESC, athlete_id;
/*
Identifying duplication
Duplication can happen for a number of reasons, 
often in unexpected ways. Because of this, 
it's important to get in the habit of validating your queries to ensure 
no duplication exists. To validate a query, take the following steps:

    Check the total value of a metric from the original table.
    Compare that with the total value of the same metric in your final report.

If the number from step 2 is larger than step 1, 
then duplication is likely the culprit. In this exercise, 
you will go through these steps to identify if duplication exists.
*/
--Setup a query that pulls total gold_medals from the winter_games table.
SELECT SUM(gold) AS gold_medals
FROM winter_games;
/*
    Comment out the top query after noting the gold_medals value.
    Build a query that shows gold_medals and avg_gdp by country_id, 
	but joins winter_games and country_stats only on the country_id fields.
*/
-- Comment out the query after noting the gold medal count
--SELECT SUM(gold) AS gold_medals
---FROM winter_games;
-- TOTAL GOLD MEDALS: ____  

-- Show gold_medals and avg_gdp by country_id
SELECT 
	w.country_id, 
    SUM(w.gold) AS gold_medals, 
    AVG(c.gdp) AS avg_gdp
FROM winter_games AS w
JOIN country_stats AS c
-- Only join on the country_id fields
ON w.country_id = c.country_id
GROUP BY w.country_id;
/*
Wrap your newest query in a subquery, 
alias as subquery, and calculate the total value for the gold_medals field.
*/
SELECT SUM(gold_medals)
FROM
	(SELECT 
        w.country_id, 
     	   SUM(gold) AS gold_medals, 
        AVG(gdp) AS avg_gdp
    FROM winter_games AS w
    JOIN country_stats AS c
    ON c.country_id = w.country_id
    -- Alias your query as subquery
    GROUP BY w.country_id) AS subquery;
-- Notice how gold_medals is much higher in the query? 
--We'll look at ways to solve this in the next exercise.
/*
Fixing duplication through a JOIN

In the previous exercise, you set up a query that contained duplication. 
This exercise will remove the duplication. One approach to removing duplication 
is to change the JOIN logic by adding another field to the ON statement.
The final query from last exercise is shown in the console. 
Your job is to fix the duplication by updating the ON statement. 
Note that the total gold_medals value should be 47.
Feel free to reference the E:R Diagram.

Instructions
	-Update the ON statement in the subquery by adding a second field to JOIN on.
    -If an error occurs related to the new JOIN field, use a CAST() statement to fix it.
*/
SELECT SUM(gold_medals) AS gold_medals
FROM
	(SELECT 
     	w.country_id, 
     	SUM(gold) AS gold_medals, 
     	AVG(gdp) AS avg_gdp
    FROM winter_games AS w
    JOIN country_stats AS c
    -- Update the subquery to join on a second field
    ON c.country_id = w.country_id AND c.year::date = w.year
    GROUP BY w.country_id) AS subquery;
/*
Report 3: Countries with high medal rates

Great work so far! It is time to use the concepts you learned in this chapter 
to build the next base report for your dashboard.
Details for report 3: medals vs population rate.
    Column 1 should be country_code, which is an altered version of the country field.
    Column 2 should be pop_in_millions, representing the population of the country (in millions).
    Column 3 should be medals, representing the total number of medals.
    Column 4 should be medals_per_million, which equals medals / pop_in_millions

Instruction :
Pull total medals by country for all summer games, 
where the medals field uses one SUM function and several 
null-handling functions on the gold, silver, and bronze fields.
*/
SELECT 
	c.country,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(s.gold,0)+COALESCE(s.silver,0)+COALESCE(s.bronze,0)) AS medals
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
GROUP BY c.country
ORDER BY medals DESC;
/*
Join to country_stats to pull in pop_in_millions, 
then create medals_per_million by dividing total medals by 
pop_in_millions and converting data types as needed.
*/
SELECT 
	c.country,
    -- Pull in pop_in_millions and medals_per_million 
    pop_in_millions,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0))/pop_in_millions::NUMERIC AS medals_per_million
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
-- Add a join
JOIN country_stats AS cs
ON c.id = cs.country_id
GROUP BY c.country, pop_in_millions
ORDER BY medals DESC;
/*
Notice the repeated values in the results. 
Add a column on the newest join statement to remove this duplication, 
and if you run into an error when trying to join, 
update the query so both fields are stored as type date.
*/
SELECT 
	c.country,
    -- Pull in pop_in_millions and medals_per_million 
	pop_in_millions,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c 
ON s.country_id = c.id
-- Update the newest join statement to remove duplication
JOIN country_stats AS cs 
ON s.country_id = cs.country_id
AND s.year = cs.year::date
GROUP BY c.country, pop_in_millions
ORDER BY medals DESC;
/*
Update country to country_code by trimming leading spaces, 
converting to upper case, removing . 
characters, and keeping only the left 3 characters, 
then filter out null populations and keep only the 25 rows with the 
most medals_per_million.
*/
SELECT 
	-- Clean the country field to only show country_code
    UPPER(LEFT(TRIM(REPLACE(c.country,'.','')),3)) AS country_code,
    -- Pull in pop_in_millions and medals_per_million 
	pop_in_millions,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c 
ON s.country_id = c.id
-- Update the newest join statement to remove duplication
JOIN country_stats AS cs 
ON s.country_id = cs.country_id AND s.year = CAST(cs.year AS date)
-- Filter out null populations
WHERE pop_in_millions IS NOT NULL
GROUP BY c.country, pop_in_millions
-- Keep only the top 25 medals_per_million rows
ORDER BY medals_per_million DESC
LIMIT 25;
=======
>>>>>>> 18901666c8a50d35b59397f3724d64472309e4f6

--Chapter IV: Complex Calculations
/*
Testing out window functions
Window functions reference other rows within the report. 
There are a variety of window-specific functions to use, 
but all basic aggregation functions can be used as a window function. 
These include:
    SUM()
    AVG()
    MAX()
    MIN()
The syntax of a window function is 
FUNCTION(value) OVER (PARTITION BY field ORDER BY field). 
Note that the PARTITION BY and ORDER BY clauses are optional. 
The FUNCTION should be replaced with the function of your choice.
In this exercise, you will run a few different window functions on the 
country_stats table.

Instructions:
Add the field country_avg_gdp that outputs the average gdp for each country.
*/
SELECT 
	country_id,
    year,
    gdp,
    -- Show the average gdp across all years per country
	AVG(gdp) OVER (PARTITION BY country_id) AS country_avg_gdp
FROM country_stats;
--Change country_avg_gdp to country_sum_gdp that shows the total 
--gdp for each country across all years.
SELECT 
	country_id,
    year,
    gdp,
    -- Show total gdp per country and alias accordingly
	SUM(gdp) OVER (PARTITION BY country_id) AS country_sum_gdp
FROM country_stats;
--Change country_sum_gdp to country_max_gdp that shows 
--the highest GDP for each country.
SELECT 
	country_id,
    year,
    gdp,
    -- Show max gdp per country and alias accordingly
	MAX(gdp) OVER (PARTITION BY country_id) AS country_max_gdp
FROM country_stats;
--Change country_max_gdp to global_max_gdp that shows the 
--highest GDP value for the entire world.
SELECT 
	country_id,
    year,
    gdp,
    -- Show max gdp for the table and alias accordingly
	MAX(gdp) OVER () AS global_max_gdp
FROM country_stats;
/*
Average total country medals by region
Layered calculations are when you create a basic query with an aggregation, 
then reference that query as a subquery to run an additional calculation. 
This approach allows you to run aggregations on aggregations, 
such as a MAX() of a COUNT() or an AVG() of a SUM().
In this exercise, your task is to pull the average total_golds for all 
countries within each region. This report will apply only for summer events.
To avoid having to deal with null handling, 
we have created a summer_games_clean table. 
Please use this when building the report.

Instructions:
    -Set up a query that pulls total_golds by region and country_id from 
		the summer_games_clean and countries tables.
    -GROUP BY the unaggregated fields.
*/
-- Query total_golds by region and country_id
SELECT 
	c.region, 
    s.country_id, 
    SUM(gold) AS total_golds
FROM summer_games_clean AS s
JOIN countries AS c
ON s.country_id = c.id
GROUP BY c.region,s.country_id;
/*
Alias your query as subquery and add a layer that pulls region 
and avg_total_golds that outputs the average gold medal count 
for all countries in the region.
Order by avg_total_golds in descending order.
*/
-- Pull in avg_total_golds by region
SELECT 
	region,
    AVG(total_golds) AS avg_total_golds
FROM
  (SELECT 
      region, 
      country_id, 
      SUM(gold) AS total_golds
  FROM summer_games_clean AS s
  JOIN countries AS c
  ON s.country_id = c.id
  -- Alias the subquery
  GROUP BY region, country_id) AS subquery
GROUP BY region
-- Order by avg_total_golds in descending order
ORDER BY avg_total_golds DESC;
/*
Most decorated athlete per region
Your goal for this exercise is to show the most decorated athlete per region. 
To set up this report, you need to leverage the ROW_NUMBER() window function, 
which numbers each row as an incremental integer, 
where the first row is 1, the second is 2, and so on.
Syntax for this window function is ROW_NUMBER() OVER 
(PARTITION BY field ORDER BY field). 
Notice how there is no argument within the initial function.

When set up correctly, a row_num = 1 represents the most decorated 
athlete within that region. Note that you cannot use a window 
calculation within a HAVING or WHERE statement, 
so you will need to use a subquery to filter.

Feel free to reference the E:R Diagram. 
We will use summer_games_clean to avoid null handling.

Instructions: 
Build a query that pulls region, athlete_name, 
and total_golds by joining summer_games_clean, athletes, and countries.
Add a field called row_num that uses ROW_NUMBER() to assign a regional 
rank to each athlete based on total golds won.
*/
SELECT 
	-- Query region, athlete_name, and total gold medals
	region, 
    name AS athlete_name, 
    SUM(gold) AS total_golds,
    -- Assign a regional rank to each athlete
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(gold) DESC) AS row_num
FROM summer_games_clean AS s
JOIN athletes AS a
ON s.athlete_id = a.id
JOIN countries AS c
ON c.id = s.country_id
GROUP BY c.region,a.name;
/*
Alias the subquery as subquery.
Query region, athlete_name, and total_golds, 
and then filter for only the top athlete per region.
*/
-- Query region, athlete name, and total_golds
SELECT 
	region,
    athlete_name,
    total_golds
FROM
    (SELECT 
		-- Query region, athlete_name, and total gold medals
        region, 
        name AS athlete_name, 
        SUM(gold) AS total_golds,
        -- Assign a regional rank to each athlete
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(gold) DESC) AS row_num
    FROM summer_games_clean AS s
    JOIN athletes AS a
    ON a.id = s.athlete_id
    JOIN countries AS c
    ON s.country_id = c.id
    -- Alias as subquery
    GROUP BY region, athlete_name) AS subquery
-- Filter for only the top athlete per region
WHERE row_num = 1;
/*
Volume vs efficiency metrics
The two types of metrics are volume metrics, 
which scales with size, and efficiency metrics, 
which can compare across groups regardless of the size of each group.
Which of the following is an efficiency metric?

Answers :
Total events
Gold medals+silver medals+bronze medals
Unique athletes
Athletes per event(X)
*/
/*
Percent of gdp per country
A percent of total calculation is a good way to compare volume metrics across groups. 
While simply showing the volume metric in a report provides some insights, 
adding a ratio allows us to easily compare values quickly.

To run a percent of total calculation, take the following steps:
Create a window function that outputs the total volume, 
partitioned by whatever is considered the total. 
If the entire table is considered the total, then no partition clause is needed.
Run a ratio that divides each row's volume metric by the 
total volume in the partition.

In this exercise, you will calculate the percent of gdp for each 
country relative to the entire world and relative to that country's region.

Instructions :
Add the field global_gdp that outputs the total gdp across all countries.
*/
-- Pull country_gdp by region and country
SELECT 
	region,
    country,
	SUM(gdp) AS country_gdp,
    -- Calculate the global gdp
    ____ AS global_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;
--Add the field global_gdp that outputs the total gdp across all countries.
-- Pull country_gdp by region and country
SELECT 
	region,
    country,
	SUM(gdp) AS country_gdp,
    -- Calculate the global gdp
    SUM(SUM(gdp)) OVER () AS global_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;
--Create the field perc_global_gdp that calculates 
--the percent of global gdp for the given country.
-- Pull country_gdp by region and country
SELECT 
	region,
    country,
	SUM(gdp) AS country_gdp,
    -- Calculate the global gdp
    SUM(SUM(gdp)) OVER () AS global_gdp,
    -- Calculate percent of global gdp
    SUM(gdp)/SUM(SUM(gdp)) OVER () AS perc_global_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;
/*Add the field perc_region_gdp, 
which runs the same calculation as perc_global_gdp but relative to each region.*/
-- Pull country_gdp by region and country
SELECT 
	region,
    country,
	SUM(gdp) AS country_gdp,
    -- Calculate the global gdp
    SUM(SUM(gdp)) OVER () AS global_gdp,
    -- Calculate percent of global gdp
    SUM(gdp) / SUM(SUM(gdp)) OVER () AS perc_global_gdp,
    -- Calculate percent of gdp relative to its region
    SUM(gdp)/SUM(SUM(gdp)) OVER (PARTITION BY region) AS perc_region_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;
/*
GDP per capita performance index
A performance index calculation is a good way to compare efficiency 
metrics across groups. A performance index compares each row to a benchmark.
To run a performance index calculation, take the following steps:
Create a window function that outputs the performance for the entire partition.
Run a ratio that divides each row's performance to the performance of 
the entire partition.
In this exercise, you will calculate the gdp_per_million for each country 
relative to the entire world.
    gdp_per_million = gdp / pop_in_millions
You will reference the country_stats_cleaned table, 
which is a copy of country_stats without data type issues.
Instructions :
Add the field gdp_per_million_total that takes 
the total gdp_per_million for the entire world.
*/
-- Bring in region, country, and gdp_per_million
SELECT 
    region,
    country,
    SUM(gdp/pop_in_millions) AS gdp_per_million
-- Pull from country_stats_clean
FROM country_stats_clean AS cs
JOIN countries AS c
ON c.id = cs.country_id
-- Filter for 2016 and remove null gdp values
WHERE gdp IS NOT NULL AND DATE_PART('year',year) = 2016
GROUP BY region,country
-- Show highest gdp_per_million at the top
ORDER BY gdp_per_million DESC;
/*
Add the field gdp_per_million_total that takes 
the total gdp_per_million for the entire world.
*/
-- Bring in region, country, and gdp_per_million
SELECT 
    region,
    country,
    SUM(gdp) / SUM(pop_in_millions) AS gdp_per_million,
    -- Output the worlds gdp_per_million
    SUM(SUM(gdp)) OVER()/ SUM(SUM(pop_in_millions)) OVER() AS gdp_per_million_total
-- Pull from country_stats_clean
FROM country_stats_clean AS cs
JOIN countries AS c 
ON cs.country_id = c.id
-- Filter for 2016 and remove null gdp values
WHERE year = '2016-01-01' AND gdp IS NOT NULL
GROUP BY region, country
-- Show highest gdp_per_million at the top
ORDER BY gdp_per_million DESC;
/*
Add the performance_index that divides the gdp_per_million calculation 
by the gdp_per_million_total calculation.
*/
-- Bring in region, country, and gdp_per_million
SELECT 
    region,
    country,
    SUM(gdp) / SUM(pop_in_millions) AS gdp_per_million,
    -- Output the worlds gdp_per_million
    SUM(SUM(gdp)) OVER () / SUM(SUM(pop_in_millions)) OVER () AS gdp_per_million_total,
    -- Build the performance_index in the 3 lines below
    (SUM(gdp) / SUM(pop_in_millions))
    /
    (SUM(SUM(gdp)) OVER () / SUM(SUM(pop_in_millions)) OVER ()) AS performance_index
-- Pull from country_stats_clean
FROM country_stats_clean AS cs
JOIN countries AS c 
ON cs.country_id = c.id
-- Filter for 2016 and remove null gdp values
WHERE year = '2016-01-01' AND gdp IS NOT NULL
GROUP BY region, country
-- Show highest gdp_per_million at the top
ORDER BY gdp_per_million DESC;
/*
Month-over-month comparison

In order to compare months, you need to use one of the following window functions:
LAG(value, offset), which outputs a value from an offset number previous 
to to the current row in the report.
LEAD(value, offset), which outputs a value from a offset number after 
the current row in the report.
Your goal is to build a report that shows each country's month-over-month views.
A few tips:
You will need to bucket dates into months. To do this, you can use 
the DATE_PART() function.
You can calculate the percent change using the following formula: 
(value)/(previous_value) - 1.
If no offset value is included in the LAG() or LEAD() functions, 
it will default to 1.
Since the table stops in the middle of June, 
the query is set up to only include data to the end of May.

Instructions :
From web_data, pull in country_id and use a DATE_PART() function to create month.
Create month_views that pulls the total views within the month.
Create previous_month_views that pulls the total views from last month for the given country.
Create the field perc_change that calculates the percent change of this month relative to last month for the given country, 
where a negative value represents a loss in views and a positive value represents growth.
*/
SELECT
	-- Pull month and country_id
	DATE_PART('month',date) AS month,
	country_id,
    -- Pull in current month views
    SUM(views) AS month_views,
    -- Pull in last month views
    LAG(SUM(views)) OVER(PARTITION BY country_id ORDER BY DATE_PART('month',date)) AS previous_month_views,
    -- Calculate the percent change
    SUM(views)/LAG(SUM(views)) OVER(PARTITION BY country_id ORDER BY DATE_PART('month',date))-1 AS perc_change
FROM web_data
WHERE date <= '2018-05-31'
GROUP BY month,country_id;
/*
Week-over-week comparison
In the previous exercise, 
you leveraged the set window of a month to calculate month-over-month changes. 
But sometimes, you may want to calculate a different time period, 
such as comparing last 7 days to the previous 7 days. 
To calculate a value from the last 7 days, 
you will need to set up a rolling calculation.

In this exercise, 
you will take the rolling 7 day average of views for each date and 
compare it to the previous 7 day average for views. 
This gives a clear week-over-week comparison for every single day.

Syntax for a rolling average is AVG(value) OVER (PARTITION BY field ORDER BY 
field ROWS BETWEEN N PRECEDING AND CURRENT ROW), 
where N is the number of rows to look back when doing the calculation. 
Remember that CURRENT ROW counts as a row.

Instruction :
Show daily_views and weekly_avg by date, 
where weekly_avg is the rolling 7 day average of views.
*/
SELECT
	-- Pull in date and daily_views
	date,
	SUM(views) AS daily_views,
    -- Calculate the rolling 7 day average
	AVG(SUM(views)) OVER(ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg
FROM web_data
GROUP BY date;
/*
Alias the query as subquery, add an outer layer that pulls date and weekly_avg, 
and order by date in descending order.
Create the field weekly_avg_previous that takes the weekly_avg from 7 days
prior to the given date.
*/
SELECT 
	-- Pull in date and weekly_avg
	date,
    weekly_avg,
    -- Output the value of weekly_avg from 7 days prior
    LAG(weekly_avg,7) OVER (ORDER BY date) AS weekly_avg_previous,
    -- Calculate percent change vs previous period
    ____ AS perc_change
FROM
  (SELECT
      -- Pull in date and daily_views
      date,
      SUM(views) AS daily_views,
      -- Calculate the rolling 7 day average
      AVG(SUM(views)) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg
  FROM web_data
  -- Alias as subquery
  GROUP BY date) AS subquery
-- Order by date in descending order
ORDER BY date DESC;
/*
Calculate perc_change where a value of 0 indicates no change, 
a negative value represents a drop in views versus previous period, 
and a positive value represents growth.
*/
SELECT 
	-- Pull in date and weekly_avg
	date,
    weekly_avg,
    -- Output the value of weekly_avg from 7 days prior
    LAG(weekly_avg,7) OVER (ORDER BY date) AS weekly_avg_previous,
    -- Calculate percent change vs previous period
    weekly_avg/LAG(weekly_avg,7) OVER (ORDER BY date)-1 AS perc_change
FROM
  (SELECT
      -- Pull in date and daily_views
      date,
      SUM(views) AS daily_views,
      -- Calculate the rolling 7 day average
      AVG(SUM(views)) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg
  FROM web_data
  -- Alias as subquery
  GROUP BY date) AS subquery
-- Order by date in descending order
ORDER BY date DESC;
/*
Report 4: Tallest athletes and % GDP by region
The final report on the dashboard is Report 4: Avg Tallest Athlete and % 
of world GDP by Region.
Report Details:
    Column 1 should be region found in the countries table.
    Column 2 should be avg_tallest, which averages the tallest athlete from each country within the region.
    Column 3 should be perc_world_gdp, which represents what % of the world's GDP is attributed to the region.
    Only winter_games should be included (no summer events).

Instruction:
Pull country_id and height for winter athletes, 
group by these two fields, and order by country_id and height in descending order.
Use ROW_NUMBER() to create row_num, 
which numbers rows within a country by height where 1 is the tallest.
*/
SELECT 
	-- Pull in country_id and height
	country_id,
    height,
    -- Number the height of each country's athletes
    ROW_NUMBER() OVER(PARTITION BY country_id) AS row_num
FROM winter_games AS w
JOIN athletes AS a
ON w.athlete_id = a.id
GROUP BY country_id, height
-- Order by country_id and then height in descending order
ORDER BY country_id, height DESC;
/*
Alias your query as subquery then use this subquery to join the countries 
table to pull in the region and average_tallest field, 
the last of which averages the tallest height of each country.
*/
SELECT
	-- Pull in region and calculate avg tallest height
	region,
    AVG(height) AS avg_tallest
FROM countries AS c
INNER JOIN
    (SELECT 
   	    -- Pull in country_id and height
        country_id, 
        height, 
        -- Number the height of each country's athletes
        ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY height DESC) AS row_num
    FROM winter_games AS w 
    JOIN athletes AS a 
    ON w.athlete_id = a.id
    GROUP BY country_id, height
    -- Alias as subquery
    ORDER BY country_id, height DESC) AS subquery
ON subquery.country_id = c.id
-- Only include the tallest height for each country
WHERE subquery.row_num = 1
GROUP BY region;
/*
Join to the country_stats table to create the perc_world_gdp field 
that calculates [region's GDP] / [world's GDP].
*/
SELECT
	-- Pull in region and calculate avg tallest height
    region,
    AVG(height) AS avg_tallest,
    -- Calculate region's percent of world gdp
    SUM(gdp)/SUM(SUM(gdp)) OVER () AS perc_world_gdp    
FROM countries AS c
JOIN
    (SELECT 
     	-- Pull in country_id and height
        country_id, 
        height, 
        -- Number the height of each country's athletes
        ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY height DESC) AS row_num
    FROM winter_games AS w 
    JOIN athletes AS a ON w.athlete_id = a.id
    GROUP BY country_id, height
    -- Alias as subquery
    ORDER BY country_id, height DESC) AS subquery
ON c.id = subquery.country_id
-- Join to country_stats
JOIN country_stats AS cs 
ON cs.country_id = c.id
-- Only include the tallest height for each country
WHERE row_num = 1
GROUP BY region;