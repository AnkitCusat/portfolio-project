select location, date, total_cases, total_deaths, population
 FROM coviddeaths;
 
 -- total deaths vs total cases
 SELECT location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as deathpercentage
FROM coviddeaths;

-- total case vs population
SELECT location, date, total_cases, total_deaths, population, ((total_cases/population)*100) as casepercentage
FROM coviddeaths
WHERE location LIKE "%Africa%";

-- looking at countries having higher infection rate compared to population
 SELECT location, MAX(total_cases) AS highestinfected, population, MAX((total_cases/population))*100 as percentagepopulationinfected
FROM coviddeaths
GROUP BY location, population
ORDER BY percentagepopulationinfected desc;

-- countries with highest death count per population
 SELECT location, MAX(total_deaths) as totaldeathcount
FROM coviddeaths
GROUP BY location
ORDER BY totaldeathcount desc;

-- continents with highest death count per ppulation
 SELECT continent, MAX(total_deaths) as totaldeathcount
FROM coviddeaths
WHERE continent is not null
GROUP BY continent
ORDER BY totaldeathcount desc;

-- total new cases , total new deaths , death percentage
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,( SUM(new_deaths)/SUM(new_cases))*100 as death_percentage
FROM coviddeaths;


-- total vaccination vs total population
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(new_vaccinations)/population as vaccinationper,
SUM(new_vaccinations) OVER (partition by dea.location ORDER BY dea.location, dea.date) as countvaccination FROM 
coviddeaths as dea JOIN covidvaccinations as vac ON dea.location = vac.location AND dea.date = vac.date;

-- temperoray table
create temporary table temp
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(new_vaccinations)/population as vaccinationper,
SUM(new_vaccinations) OVER (partition by dea.location ORDER BY dea.location, dea.date) as countvaccination FROM 
coviddeaths as dea JOIN covidvaccinations as vac ON dea.location = vac.location AND dea.date = vac.date;







