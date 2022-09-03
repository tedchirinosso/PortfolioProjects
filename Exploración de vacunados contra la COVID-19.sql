SELECT * FROM PROJECT..CovidVACCINATION

--Viendo al total de la población vs vacunaciones
SELECT * 
FROM PROJECT..CovidDEATHS dea
JOIN PROJECT..CovidVACCINATION vac
	ON dea.location=vac.location
	AND dea.date=vac.date;

SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
FROM PROJECT..CovidDEATHS dea
JOIN PROJECT..CovidVACCINATION vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent is not null
ORDER BY 2,3

SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS 'Cantidad de vacunas aplicadas'
FROM PROJECT..CovidDEATHS dea
JOIN PROJECT..CovidVACCINATION vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent is not null
ORDER BY 2,3

With PopvsVac (continent,location,date,population,new_vaccinations,Personasvacunadas) as
(
SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS Personasvacunadas
FROM PROJECT..CovidDEATHS dea
JOIN PROJECT..CovidVACCINATION vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent is not null
--ORDER BY location ,date
)

SELECT *,(Personasvacunadas/population)*100 as 'Porcentaje de vacunados' 
FROM PopvsVac



--TEMP TABLE

DROP TABLE if exists #PorcentajePersonasVacunadas
CREATE TABLE #PorcentajePersonasVacunadas
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	PersonasVacunadas numeric
)

INSERT INTO #PorcentajePersonasVacunadas
SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS PersonasVacunadas
FROM PROJECT..CovidDEATHS dea
JOIN PROJECT..CovidVACCINATION vac
	ON dea.location=vac.location
	AND dea.date=vac.date
--WHERE dea.continent is not null
--ORDER BY location ,date

SELECT * ,(PersonasVacunadas/population)*100
FROM #PorcentajePersonasVacunadas
ORDER BY 2,3

CREATE VIEW PorcentajePersonasVacunadas as
SELECT dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS PersonasVacunadas
FROM PROJECT..CovidDEATHS dea
JOIN PROJECT..CovidVACCINATION vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent is not null
--ORDER BY location ,date

SELECT * FROM PorcentajePersonasVacunadas