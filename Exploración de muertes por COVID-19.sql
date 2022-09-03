Select *
From PROJECT..CovidDeaths
Where continent is not null 
order by 3,4


--Utilizando la información con la que iniciaremos

Select Location, date, total_cases, new_cases, total_deaths, population
From PROJECT..CovidDeaths
Where continent is not null 
order by 1,2


-- Casos totales vs muertes totales
-- Aquí nos muestra la probabilidad de morir al contraer COVID-19 en Perú en el tiempo

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as 'Porcentaje de muerte'
From PROJECT..CovidDeaths
Where location like '%Peru%'
and continent is not null 
order by 1,2


-- Casos totales vs contagios totales
-- Muestra el porcentaje de personas en el Perú que contrajeron COVID-19

Select Location, date, Population, total_cases,  (total_cases/population)*100 as 'Porcentaje de personas infectadas'
From PROJECT..CovidDeaths
--Where location like '%Peru%'
order by 1,2


-- Países con la el mayor índice de contagios de acuerdo a su población

Select Location, Population, MAX(total_cases) as 'Mayor porcentaje de contagaidos',  Max((total_cases/population))*100 as PercentPopulationInfected
From PROJECT..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


--Países con más altos índices de muertes de acuerdo a su población

Select Location, MAX(cast(Total_deaths as int)) as 'Total de muertes'
From PROJECT..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by 'Total de muertes' desc



-- Ordenandolos por continente

--Mostrando a los continentes con la mayor cantidad de muertos 

Select continent, MAX(cast(Total_deaths as int)) as 'Total de muertos'
From PROJECT..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by 'Total de muertos' desc