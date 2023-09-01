select * 
from PortfolioProject..CovidDeaths
where continent  is not null
order by 3,4

select * 
from PortfolioProject..CovidVaccinations
where continent  is not null

order by 3,4

---Data to use----

select location, date, total_cases, new_cases, total_deaths, population

from PortfolioProject..CovidDeaths
where continent  is not null
order by 1,2

--Total case vs Total Deaths

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from PortfolioProject..CovidDeaths
where continent  is not null

order by 1,2

--Total cases vs population

select Location, date, total_cases, Population, (total_cases/population)*100 as populationpercentage
from PortfolioProject..CovidDeaths
where continent  is not null
order by 1,2


--countries  with highest infection rate


select Location, Population, max (total_cases) as HighestIfection ,max((total_cases/population))*100 as populationpercentage
from PortfolioProject..CovidDeaths 
group by Location, Population
order by  populationpercentage desc




--country with highest death count

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent  is not null
group by continent
order by  TotalDeathCount desc





---global number


select sum(new_cases) as total_cases,  sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum (New_Cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent  is not null
--group by date
order by 1,2



--Total  population vs vaccination

select Death.continent, Death.location, Death.date, Death.population, vaccination.new_vaccinations,
sum(cast(vaccination.new_vaccinations as int)) OVER (Partition by Death.location order by Death.location) as PepleVaccinated
--, (PepleVaccinated/population)*100
from PortfolioProject..CovidDeaths Death
join PortfolioProject..CovidVaccinations vaccination
	On Death.location = vaccination.location
	and Death.date = vaccination.date
where Death.continent is not null
--order by 2,3

 
--- uce cte

with PopvsVac (Continent, Location, Date, Population,New_Vaccination, PepleVaccinated)
as
(
select Death.continent, Death.location, Death.date, Death.population, vaccination.new_vaccinations,
sum(cast(vaccination.new_vaccinations as int)) OVER (Partition by Death.location order by Death.location) as PepleVaccinated
--, (PepleVaccinated/population)*100
from PortfolioProject..CovidDeaths Death
join PortfolioProject..CovidVaccinations vaccination
	On Death.location = vaccination.location
	and Death.date = vaccination.date
where Death.continent is not null
--order by 2,3
)

select *, (PepleVaccinated/Population)*100
from popvsVac


--Temp Table 
Drop Table if exists #PercebtPopulationVaccinated
Create Table #PercebtPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PepleVaccinated numeric,
)



Insert into #PercebtPopulationVaccinated
select Death.continent, Death.location, Death.date, Death.population, vaccination.new_vaccinations,
sum(cast(vaccination.new_vaccinations as int)) OVER (Partition by Death.location order by Death.location) as PepleVaccinated
--, (PepleVaccinated/population)*100
from PortfolioProject..CovidDeaths Death
join PortfolioProject..CovidVaccinations vaccination
	On Death.location = vaccination.location
	and Death.date = vaccination.date
--where Death.continent is not null
--order by 2,3

select *, (PepleVaccinated/Population)*100
from #PercebtPopulationVaccinated

Create View PercebtPopulationVaccinated as
select Death.continent, Death.location, Death.date, Death.population, vaccination.new_vaccinations,
sum(cast(vaccination.new_vaccinations as int)) OVER (Partition by Death.location order by Death.location) as PepleVaccinated
--, (PepleVaccinated/population)*100
from PortfolioProject..CovidDeaths Death
join PortfolioProject..CovidVaccinations vaccination
	On Death.location = vaccination.location
	and Death.date = vaccination.date
where Death.continent is not null
--order by 2,3


Select *
from PercebtPopulationVaccinated

--2

 select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location  not in ('world', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3

select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
Group by location, population
order by PercentPopulationInfected desc

--4

select location, Population, date, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
Group by location, Population, date
order by PercentPopulationInfected desc
