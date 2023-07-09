
--SELECT TOP 10 *
/*SELECT * 
FROM PortfolioProject1..[covid-deaths]
ORDER BY location, date;

SELECT * 
FROM PortfolioProject1..[covid-vaccinations]
ORDER BY location, date;
*/


-- Select columns that are gonna be using for analysis from covid-deaths table 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject1..[covid-deaths]
ORDER BY location, date;


-- Total Cases vs Total Deaths worldwide 
-- Shows likelihood of dying if you contract Covid 19 
SELECT location, date, total_cases, total_deaths, CAST(total_deaths AS float)/CAST(total_cases AS float)*100 AS DeathPercentage
FROM PortfolioProject1..[covid-deaths]
ORDER BY location, date;

-- Total Cases vs Total Deaths in Myanmar
SELECT location, date, total_cases, total_deaths, CAST(total_deaths AS float)/CAST(total_cases AS float)*100 AS DeathPercentage
FROM PortfolioProject1..[covid-deaths]
WHERE location LIKE '%anmar%'
--WHERE location = 'Myanmar'
ORDER BY location, date;


-- Total Cases vs Population Worldwide 
-- Shows what percentage of population got Covid 
SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectionRate
FROM PortfolioProject1..[covid-deaths]
ORDER BY location, date;

-- Shows what population percentage contract covid in Myanmar 
SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectionRate
FROM PortfolioProject1..[covid-deaths]
WHERE location = 'Myanmar'
ORDER BY location, date;


-- Looking at Countries with Highest Infection Rate Compared to Population 
SELECT location, population, MAX(total_cases) AS HighestInfectionCount,
MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject1..[covid-deaths]
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

-- Overall Highest Infection Rate in Myanmar 
SELECT location, population, MAX(total_cases) AS HighestInfectionCount,
MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject1..[covid-deaths]
WHERE location = 'Myanmar'
GROUP BY location, population;
--ORDER BY PercentPopulationInfected DESC;


-- Showing Countries with Highest Death Count per Population
SELECT location, population, 
MAX(CAST(total_deaths AS INT)) AS HighestDeathCount,
--MAX(CAST(total_deaths AS INT)/population)*100 AS PercentDeathPopulation
ROUND(MAX(CAST(total_deaths AS INT)/population)*100, 2) AS PercentDeathPopulation
FROM PortfolioProject1..[covid-deaths]
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentDeathPopulation DESC;

/*SELECT location,
MAX(CAST(total_deaths AS INT)) AS HighestDeathCount
--MAX(CAST(total_deaths AS INT)/population)*100 AS PercentDeathPopulation
FROM PortfolioProject1..[covid-deaths]
WHERE continent IS NULL
GROUP BY location
ORDER BY HighestDeathCount DESC; */

-- Overall Highest Death Count and Death Rate in Myanmar 
SELECT location, population, 
MAX(CAST(total_deaths AS INT)) AS HighestDeathCount,
--MAX(CAST(total_deaths AS INT)/population)*100 AS PercentDeathPopulation
ROUND(MAX(CAST(total_deaths AS INT)/population)*100, 2) AS PercentDeathPopulation
FROM PortfolioProject1..[covid-deaths]
WHERE location = 'Myanmar'
GROUP BY location, population;



-- Looking at Global Numbers 
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, 
ROUND(SUM(new_deaths)/SUM(new_cases)*100, 2) AS total_death_percentage
FROM PortfolioProject1..[covid-deaths]
WHERE continent IS NOT NULL;



-- Analysis by Continent 
-- Total Death Count & Death Percentage in each Continent
/*
NB: Casting total_cases and total_deaths columns to either INT or FLOAT 
	columns are necessary for data validation
*/
--Display all continents + extra records from location column 
SELECT DISTINCT location 
FROM PortfolioProject1..[covid-deaths]
WHERE continent IS NULL;        --shows the continent related date from 'location' column

------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx------------------------
SELECT location, population, --MAX(total_cases) AS TotalCovidCases,  
MAX(CAST(total_cases AS float)) AS TotalCovidCases,
ROUND(MAX(CAST(total_cases AS float)/population)*100, 2) AS PercentCovidCases,
MAX(CAST(total_deaths AS float)) AS TotalCovidDeaths,
ROUND(MAX(CAST(total_deaths AS float)/population)*100, 2) AS PercentCovidDeaths
FROM PortfolioProject1..[covid-deaths]
WHERE continent IS NULL AND 
      location NOT IN ('Lower middle income', 
						 'World', 
						 'Low income',
						 'European Union', 
						 'Upper middle income', 
						 'High income')
GROUP BY location, population
ORDER BY PercentCovidDeaths DESC;




-- Looking at Total Population vs Fully Vaccinated People
-- How many people in each country have been fully vaccinated to date?
SELECT dea.location, dea.population,
MAX(CONVERT(INT, vac.people_fully_vaccinated)) AS TotalFullyVaccinations, 
ROUND((MAX(CONVERT(INT, vac.people_fully_vaccinated))/population)*100, 2) AS PercentFullyVaccinations
--(RollingPeopleVaccinated/population)*100
FROM PortfolioProject1..[covid-deaths] dea
JOIN PortfolioProject1..[covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
GROUP BY dea.location, dea.population
ORDER BY TotalFullyVaccinations DESC;


-- How many people in Myanmar have been fully vaccinated to date?
SELECT dea.location, dea.population,
MAX(CONVERT(INT, vac.people_fully_vaccinated)) AS TotalFullyVaccinations, 
ROUND((MAX(CONVERT(INT, vac.people_fully_vaccinated))/population)*100, 2) AS PercentFullyVaccinations
FROM PortfolioProject1..[covid-deaths] dea
JOIN PortfolioProject1..[covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.location = 'Myanmar'
GROUP BY dea.location, dea.population;


-- How many people each country have received booster dose?
SELECT dea.location, dea.population, 
MAX(CONVERT(INT, vac.total_boosters)) AS TotalNumBoosters, 
ROUND((MAX(CONVERT(INT, vac.total_boosters))/population)*100, 2) AS PercentBoosters
FROM PortfolioProject1..[covid-deaths] dea
JOIN PortfolioProject1..[covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
GROUP BY dea.location, dea.population
ORDER BY TotalNumBoosters DESC;


-- How many people each Myanmar have received booster doses?
SELECT dea.location, dea.population, 
MAX(CONVERT(INT, vac.total_boosters)) AS TotalNumBoosters, 
ROUND((MAX(CONVERT(INT, vac.total_boosters))/population)*100, 2) AS PercentBoosters
FROM PortfolioProject1..[covid-deaths] dea
JOIN PortfolioProject1..[covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.location = 'Myanmar'
GROUP BY dea.location, dea.population;



-- Rolling Vaccinations and Percentage of Vaccinated Population 
-- USE CTE 
/*
Partition by location and date to ensure that once the rolling sum of new vaccinations 
for a location stops, the rolling sum begins for the another location 
*/
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject1..[covid-deaths] dea
JOIN PortfolioProject1..[covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--ORDER BY dea.location, dea.date
)
SELECT *, (RollingPeopleVaccinated/population)*100 AS PercentageRollingVaccinations
FROM PopvsVac;


/*
-- Rolling Vaccinations by Date > Myanmar 
-- new_vaccinations and total_vaccinations columns for Myanmar do not have proper records. 
*/

-- Rolling boosters and percentage of that per population 
WITH PopvsBooster (continent, location, date, population, total_boosters, RollingBoosters)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.total_boosters, 
SUM(CONVERT(BIGINT, vac.total_boosters)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.date) AS RollingBoosters
FROM PortfolioProject1..[covid-deaths] dea
JOIN PortfolioProject1..[covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.location = 'Myanmar'
--ORDER BY dea.location, dea.date
)
SELECT *, (RollingBoosters/population)*100 AS PercentageRollingBoosters
FROM PopvsBooster;



-- Using Temp Table 
DROP TABLE IF EXISTS #Percent_Population_Vaccinated
CREATE TABLE #Percent_Population_Vaccinated 
(
	Continent				nvarchar(255), 
	Location				nvarchar(255), 
	Date					datetime, 
	Population				numeric,
	New_vaccinations		numeric,
	RollingPeopleVaccinated numeric
)

INSERT INTO #Percent_Population_Vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject1..[covid-deaths] dea
JOIN PortfolioProject1..[covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--ORDER BY dea.location, dea.date

SELECT *, (RollingPeopleVaccinated/population)*100 AS PercentageVaccinations
FROM #Percent_Population_Vaccinated;


-- Create view 
CREATE VIEW Percent_Population_Vaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject1..[covid-deaths] dea
JOIN PortfolioProject1..[covid-vaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--ORDER BY dea.location, dea.date

SELECT * 
FROM Percent_Population_Vaccinated;