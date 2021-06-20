Select *
from PortfolioProjects..deaths
order by 3,4

Select *
from PortfolioProjects..vaccinations
order by 3,4

Select location, date, total_cases,new_cases, total_deaths, population
from PortfolioProjects..deaths
order by 1,2

-- Looking at Total cases vs Total Deaths
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProjects..deaths
where location like '%India'
order by 1,2


--Looking at total cases vs Population 
Select location, date, total_cases, population,(total_cases/population)*100 as Population_percentage
from PortfolioProjects..deaths
where location like '%India'
order by 1,2

--Looking at countries with highest infection rate compared to population 
Select location, max(total_cases) as HighestInfectionCount, population,max((total_cases/population)*100) as infection_rate
from PortfolioProjects..deaths
--where location like '%India'
Group by location, population
order by infection_rate desc

--Countries with Highest death count per population
Select location, max(cast(total_deaths as int)) as TotalDeaths
from PortfolioProjects..deaths
where continent is not null
group by location
order by TotalDeaths desc

-- Continents with the highest death count

Select location, max(cast(total_deaths as int)) as TotalDeaths
from PortfolioProjects..deaths
where continent is null
and location != 'World'
group by location
order by TotalDeaths desc

-- Global Numbers

Select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases) * 100 as DeathPercentage 
from PortfolioProjects..deaths
where continent is not null
--group by date

select *
from PortfolioProjects..vaccinations

Select * 
from PortfolioProjects..deaths dea
join PortfolioProjects..vaccinations vac
on vac.date = dea.date
and vac.location = dea.location

-- Vaccinations vs Population

with PopvsVac (Continent, location, date,population, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) As PercentagePeopleVaccinated
from PortfolioProjects..deaths dea
join PortfolioProjects..vaccinations vac
on vac.date = dea.date
and vac.location = dea.location
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


