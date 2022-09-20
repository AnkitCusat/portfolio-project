-- number of rows in our database
SELECT COUNT(*) FROM dexcel;
SELECT COUNT(*) FROM pexcel;

-- dataset for the Jharkhand and Bihar only
SELECT * FROM dexcel
WHERE state IN ("jharkhand","bihar");

-- to know the total population of India
SELECT sum(population) FROM pexcel;

-- to check the avg growth
SELECT AVG(growth) FROM dexcel;

-- to check the avg growth by states
SELECT state, avg(growth) FROM dexcel
GROUP BY state;

-- to check the avg sex ratio by state in descending order
SELECT state , avg(sex_ratio) as sex_ratio FROM dexcel
GROUP BY state 
ORDER BY sex_ratio desc;


-- to check literacy rate by state in descending
SELECT state, round(avg(literacy),0) as literacy_rate FROM dexcel
GROUP BY state
ORDER BY literacy_rate desc;

-- to check avg literacy rate by state having > 90
SELECT state, round(avg(literacy),0) AS literacy_rate FROM dexcel
GROUP BY state
HAVING round(avg(literacy),0) > 90
ORDER BY literacy_rate desc;

-- top 3 states showing highest growth ratio
SELECT state, avg(growth) as avg_growth FROM dexcel
GROUP BY state
ORDER BY avg_growth desc
limit 3;

-- Bottom 3 states showing lowest growth rate
SELECT state, avg(growth) as avg_growth FROM dexcel
GROUP BY state
ORDER BY avg_growth asc
limit 3;

-- top and bottom 3 states in avg growth(using temporary table and union)
create temporary table top SELECT state, avg(growth) as avg_growth FROM dexcel
GROUP BY state
ORDER BY avg_growth desc
limit 3;

create temporary table bot SELECT state, avg(growth) as avg_growth FROM dexcel
GROUP BY state
ORDER BY avg_growth asc
limit 3;

-- using union to combine
SELECT * FROM top
UNION
SELECT * FROM bot;

-- states starting with letter a and ending with letter m
SELECT DISTINCT state FROM dexcel 
WHERE lower(state) LIKE 'a%' and lower(state) LIKE '%M';

-- INNER JOIN two tables 
SELECT a.district, a.state, a.sex_ratio, b.population FROM dexcel as a
INNER JOIN pexcel as b ON a.district=b.district;

-- to find out total number of males and females 
SELECT district, state, population/(sex_ratio+1) as males, (population*sex_ratio)/(sex_ratio+1) as females FROM
(SELECT a.district, a.state, (a.sex_ratio/100000) as sex_ratio, b.population FROM dexcel as a
INNER JOIN pexcel as b ON a.district=b.district) AS c;


-- to find out total number of males and females in state
SELECT d.state, SUM(d.males) as total_males, SUM(d.females) as total_females FROM
(SELECT district, state, population/(sex_ratio+1) as males, (population*sex_ratio)/(sex_ratio+1) as females FROM
(SELECT a.district, a.state, (a.sex_ratio/100000) as sex_ratio, b.population FROM dexcel as a
INNER JOIN pexcel as b ON a.district=b.district) AS c) d
GROUP BY d.state;

-- total literte and illetrate people
SELECT d.district, d.state, (population*literacy) as literate_pep, ((1-literacy)*population) as illetrate_pep FROM
(SELECT a.district, a.state, (a.literacy/100) as literacy, b.population FROM dexcel as a
INNER JOIN pexcel as b ON a.district=b.district) as d;

-- total literate and illetrate by state
SELECT c.state, sum(literate_pep) as lit_pep, sum(illetrate_pep) as illit_pep FROM 
(SELECT d.district, d.state, (population*literacy) as literate_pep, ((1-literacy)*population) as illetrate_pep FROM
(SELECT a.district, a.state, (a.literacy/100) as literacy, b.population FROM dexcel as a
INNER JOIN pexcel as b ON a.district=b.district) as d) c
GROUP BY state;

-- to find out the previous census population
SELECT d.district, d.state, population/(1+growth) as prev_census, d.population as current_pop FROM
(SELECT a.district, a.state, a.growth, b.population FROM dexcel as a
INNER JOIN pexcel as b ON a.district=b.district) as d;




 




