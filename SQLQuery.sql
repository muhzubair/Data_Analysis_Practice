SELECT * 
FROM PortfolioProject..['covid deaths']

SELECT * 
FROM PortfolioProject..['covid vaccinations']

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..['covid deaths']
order by 1,2 

-- Total cases vs total deaths 
-- Shows the likelihood of dying when getting infected by covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM PortfolioProject..['covid deaths']
WHERE location = 'United States'
order by 1,2 

-- Total cases vs population
-- Shows the percentage of population that got diagnosed by covid
SELECT location, date, population, total_cases, (total_cases/population)*100 AS Percentage_Population_Infected
FROM PortfolioProject..['covid deaths']
WHERE location = 'United States'
order by 1,2

-- Countries with highest covid infection rate compared to population
SELECT location, population, MAX(total_cases) AS Highest_Infected_Count, (MAX(total_cases/population))*100 
AS Percentage_Population_Infected
FROM PortfolioProject..['covid deaths']
GROUP BY location, population
order by Percentage_Population_Infected desc

-- Countries with highest death count per population
SELECT location, MAX(cast(total_deaths AS int)) AS Total_Death_Count
FROM PortfolioProject..['covid deaths']
WHERE continent IS NOT NULL 
GROUP BY location
order by Total_Death_Count desc