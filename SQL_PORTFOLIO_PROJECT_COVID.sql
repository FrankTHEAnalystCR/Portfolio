SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3,4;

-SELECT *
-FROM PortfolioProject.dbo.CovidVaccinations
-ORDER BY 3,4;

-- Select the data we are going to use

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
Order by 1,2;

-- Looking at Total Cases vs Total Deaths
SELECT Location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS mortalitypercentage
FROM PortfolioProject.dbo.CovidDeaths
Order by 1,2;

-- Looking at data from my country
SELECT Location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS mortalitypercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE Location like '%Costa%'
Order by 1,2;

--See What percentage of the population got Covid
SELECT Location, date, population, total_cases,  (total_cases/population)*100 AS percentagepopulationinfected
FROM PortfolioProject.dbo.CovidDeaths
Order by 1,2;

--Looking at Countries with Highest Infection Rate compared to Population
SELECT Location, Population, Max(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS percentagepopulationinfected
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY Location, Population
Order by percentagepopulationinfected DESC;

--Showing Countries with Highest Death Count per Population
SELECT Location,  Max(cast(total_deaths as Bigint)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY Location
Order by TotalDeathCount  DESC;


--Showing continents with highest death count per population
SELECT Location,  Max(cast(total_deaths as Bigint)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is  null
GROUP BY Location
Order by TotalDeathCount  DESC;

--GLOBAL NUMBERS

SELECT  SUM(new_cases) as total_cases, SUM(cast(new_deaths as BIGINT)) as total_deaths, SUM(cast(new_deaths as BIGINT))/SUM(new_cases)*100 AS mortalitypercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE CONTINENT IS NOT NULL
--GROUP BY date
Order by 1,2;

--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as BIGINT)) OVER (PARTITION BY dea.location  Order BY dea.location, dea.date ) AS RollingPeopleVaccinated
FROM
PortfolioProject.dbo.CovidDeaths dea Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent IS NOT NULL
order by 2, 3;

--Use CTE to figure out the percentage of the population that's vaccinated
WITH POPVAC (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)  AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as BIGINT)) OVER (PARTITION BY dea.location  Order BY dea.location, dea.date ) AS RollingPeopleVaccinated
FROM
PortfolioProject.dbo.CovidDeaths dea Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT *, (RollingPeopleVaccinated/population) * 100 as percentage
FROM POPVAC

--Creating view to store data for later visualizations

CREATE VIEW percentagepopulationvaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as BIGINT)) OVER (PARTITION BY dea.location  Order BY dea.location, dea.date ) AS RollingPeopleVaccinated
FROM
PortfolioProject.dbo.CovidDeaths dea Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--order by 2, 3;

SELECT *
FROM percentagepopulationvaccinated


