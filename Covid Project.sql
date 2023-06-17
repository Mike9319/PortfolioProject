Select *
From PortfolioProject.dbo.CovidDeaths

Select *
From PortfolioProject.dbo.CovidVaccinations


Select *
From PortfolioProject.dbo.CovidDeaths dea
Inner Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject.dbo.CovidDeaths dea
Inner Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date)
as RollingTotalVacc
From PortfolioProject.dbo.CovidDeaths dea
Inner Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

Create table #PerPopVacc
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingTotalVacc numeric
)

Insert into #PerPopVacc
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date)
as RollingTotalVacc
From PortfolioProject.dbo.CovidDeaths dea
Inner Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

Select *, (RollingTotalVacc/Population)*100
From #PerPopVacc

Drop table if exists #PerPopVacc
Create table #PerPopVacc
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingTotalVacc numeric
)

Insert into #PerPopVacc
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date)
as RollingTotalVacc
From PortfolioProject.dbo.CovidDeaths dea
Inner Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.location like '%state%'

Select *, (RollingTotalVacc/Population)*100
From #PerPopVacc

With PoppsVsVacc (continent, location, date, Population, new_vaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date)
as RollingTotalVacc
From PortfolioProject.dbo.CovidDeaths dea
Inner Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
Select *
From PoppsVsVacc

Create View PercentPopulationVaccinated
as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
From PortfolioProject.dbo.CovidDeaths dea
Inner Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

Select *
From PercentPopulationVaccinated