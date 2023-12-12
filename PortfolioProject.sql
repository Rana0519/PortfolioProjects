#select data that we want to use
SELECT location , `date` ,total_cases ,new_cases ,total_deaths ,population 
from CovidInfo.CovidDeath cd 
where continent is not NULL 
order by 1,2


#Look ar total cases vs total death
#show likelihood of dying if concract covid in Africa
SELECT location ,`date` ,total_cases ,total_deaths, (total_deaths/total_cases)*100 as death_percentage
from CovidInfo.CovidDeath cd
WHERE location like '%Africa' and  continent is not NULL 



#looking for total cases vs population
#show what percentage of population got covid
SELECT location ,`date` ,total_cases ,population , (total_cases  /population)*100 as PopulationInfacted_percentage
from CovidInfo.CovidDeath cd
WHERE location like '%Africa%' AND  continent is not NULL 



#looking at countries with highest infections compared to populations 
SELECT  location,population , MAX(total_cases)as highest_infections,MAX((total_cases  /population)*100)  as PopulationInfacted_percentage
from CovidInfo.CovidDeath cd
WHERE  continent is not NULL 
group by location,population
ORDER by PopulationInfacted_percentage DESC 



#showing countries with highest death count per population
SELECT  location,population , MAX(total_deaths)as highest_death,MAX((total_deaths  /population)*100)  as PopulationDeath_percentage
from CovidInfo.CovidDeath cd
WHERE  continent is not NULL 
group by location,population
ORDER by PopulationDeath_percentage DESC 


#break things down by continent
SELECT  continent  ,population , MAX(total_deaths)as highest_death,MAX((total_deaths  /population)*100)  as PopulationDeath_percentage
from CovidInfo.CovidDeath cd
WHERE  continent is not NULL 
group by location
ORDER by PopulationDeath_percentage DESC 


#global numbers
SELECT `date`  ,SUM(new_cases)as Total_cases,SUM(new_deaths)as Total_death,(SUM(new_deaths)/SUM(new_cases))*100 as death_percentage
from CovidInfo.CovidDeath cd
WHERE continent is not NULL 
GROUP by `date` 
order by `date` 



#Temp Table
Drop table if exists PercentPopulationVaccinated
Create table PercentPopulationVaccinated
(
continent varchar(50),
Location varchar(50),
Date datetime,
Population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric,
)


#join tables
#looking at total population vs vaccinations
INSERT INTO PercentPopulationVaccinated
SELECT cd.continent ,cd.location ,cd.`date` ,cd.population ,cv.new_vaccinations, SUM(cv.new_vaccinations) over(PARTITION by cd.location order by cd.location,cd.date)as Rollingpeoplevaccinated
from CovidInfo.CovidDeath cd  
join CovidInfo.CovidVaccination cv  on cv.`date` =cd.`date` and cv.location =cd.location 
where cd.continent is not NULL 

#show the new table
SELECT * from PercentPopulationVaccinated



#Creating view to store data for later visualization
Create view PercentPopulationVaccinated as 
SELECT cd.continent ,cd.location ,cd.`date` ,cd.population ,cv.new_vaccinations, SUM(cv.new_vaccinations) over(PARTITION by cd.location order by cd.location,cd.date)as Rollingpeoplevaccinated
from CovidInfo.CovidDeath cd  
join CovidInfo.CovidVaccination cv  on cv.`date` =cd.`date` and cv.location =cd.location 
where cd.continent is not NULL 




