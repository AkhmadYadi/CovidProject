-- #Cek keseluruhan data terlebih dahulu
	Select *
	From CovidProject.dbo.CovidDeath
	order by 2,3

-- #Cek data secara lebih spesifik
	Select Location, date, total_cases, new_cases, total_deaths, population
	From CovidProject.dbo.CovidDeath
	Where continent is not null 
	order by 1,2

-- #Cek presentase kematian berdasarkan keseluruhan kasus masing-masing negara perharinya
	Select Location, date, total_cases, total_deaths, cast(total_deaths as float)/cast(total_cases as float)*100 as DeathPercentage
	From CovidProject.dbo.CovidDeath
	Where continent is not null 
	order by 1,2

-- #Cek presentase kasus berdasarkan populasi masing-masing negara perharinya
	Select Location, date, Population, total_cases,  cast(total_cases as float)/cast(population as float)*100 as PercentPopulationInfected
	From CovidProject.dbo.CovidDeath
	Where continent is not null 
	order by 1,2

-- #Cek negara dengan presentase kasus berdasarkan populasi tertinggi
	Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
	From CovidProject.dbo.CovidDeath
	Where continent is not null 
	Group by Location, Population
	order by PercentPopulationInfected desc

-- #Cek negara dengan kasus kematian tertinggi
	Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
	From CovidProject.dbo.CovidDeath
	Where continent is not null 
	Group by Location
	order by TotalDeathCount desc

-- #Cek Benua dengan kasus kematian tertinggi
	Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
	From CovidProject.dbo.CovidDeath
	Where continent is not null 
	Group by continent
	order by TotalDeathCount desc

-- #Cek persentase kematian akibat covid sedunia
	Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
	From CovidProject.dbo.CovidDeath
	where continent is not null 

-- #Cek presentase dari populasi yang telah atau pernah menerima vaksinasi
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
	From CovidProject.dbo.CovidDeath as dea 
	Join CovidProject.dbo.CovidVaccination as vac
		On dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null 
	order by 2,3

-- # Membuat visualisasi
	Create View PercentPopulationVaccinated as
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
	From CovidProject.dbo.CovidDeath as dea 
	Join CovidProject.dbo.CovidVaccination as vac
		On dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null