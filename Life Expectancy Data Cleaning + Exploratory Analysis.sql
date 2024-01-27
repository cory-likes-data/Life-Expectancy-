# World Life Expectancy Project - Data Cleaning and Exploratory Data Analysis - 2 parts below 



#World Life Expectancy Project - Data Cleaning - part 1 of 2 

SELECT *
FROM world_life_expectancy
; 


SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1 
;


SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year), 
	ROW_NUMBER () OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1
;


DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
	SELECT Row_ID
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year), 
	ROW_NUMBER () OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
	) AS Row_table
	WHERE Row_Num > 1
)
; 


SELECT *
FROM world_life_expectancy
;


SELECT *
FROM world_life_expectancy
WHERE Status = ''
;


SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;


SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing' 
;


UPDATE world_life_expectancy
SET Status = 'Developing' 
WHERE COUNTRY IN (SELECT DISTINCT(Country)
				 FROM world_life_expectancy
				 WHERE Status = 'Developing') 
;


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = '' 
AND t2.Status <> '' 
AND t2.Status = 'Developing' 
;


SELECT *
FROM world_life_expectancy
WHERE Status = ''
;


SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America' 
;


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = '' 
AND t2.Status <> '' 
AND t2.Status = 'Developed' 
;


SELECT *
FROM world_life_expectancy
WHERE Status = ''
;


SELECT *
FROM world_life_expectancy
;


SELECT *
FROM world_life_expectancy
WHERE Status IS NULL 
;


SELECT *
FROM world_life_expectancy
;


SELECT *
FROM world_life_expectancy
WHERE `Life Expectancy` = ''
;


SELECT Country, Year, `Life Expectancy` 
FROM world_life_expectancy
;

#There is an apparent correlation with Afghanistan in that as each year passes, life expectancy increases slightly.
#So, we'll take the average life expectancy for each year before and after the missing year to fill the missing data. 

SELECT t1.COUNTRY, t1.Year, t1.`Life Expectancy`, 
	   t2.COUNTRY, t2.Year, t2.`Life Expectancy`,
       t3.COUNTRY, t3.Year, t3.`Life Expectancy`,
       ROUND((t2.`Life Expectancy` + t3.`Life Expectancy`) /2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2 
	ON t1.Country = t2.Country 
    AND t1.Year = t2.Year -1 
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year +1
WHERE t1.`Life Expectancy` = ''
;


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2 
	ON t1.Country = t2.Country 
    AND t1.Year = t2.Year -1 
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year +1
SET t1.`Life Expectancy` = ROUND((t2.`Life Expectancy` + t3.`Life Expectancy`) /2,1)
WHERE t1.`Life Expectancy` = ''
;


SELECT Country, Year, `Life Expectancy` 
FROM world_life_expectancy
;


SELECT *
FROM world_life_expectancy
; 


# World Life Expectancy Project - Exploratory Data Analysis - part 2 of 2 

SELECT *
FROM world_life_expectancy
; 


SELECT Country, MIN(`Life expectancy`), MAX(`Life expectancy`)
FROM world_life_expectancy
GROUP BY Country 
ORDER BY Country DESC 
; 


SELECT Country, MIN(`Life expectancy`), MAX(`Life expectancy`)
FROM world_life_expectancy
GROUP BY Country 
HAVING MIN(`Life expectancy`) <> 0 
AND MAX(`Life expectancy`) <> 0 
ORDER BY Country DESC 
; 


SELECT Country, 
	   MIN(`Life expectancy`), 
       MAX(`Life expectancy`),
       ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country 
HAVING MIN(`Life expectancy`) <> 0 
AND MAX(`Life expectancy`) <> 0 
ORDER BY Life_Increase_15_Years DESC 
; 


SELECT Year, ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0 
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year 
;


SELECT *
FROM world_life_expectancy
; 


SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_expectancy, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country 
; 


SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_expectancy, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_expectancy > 0
AND GDP > 0
ORDER BY GDP DESC   
; 


SELECT * 
FROM world_life_expectancy
ORDER BY GDP
;


SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END),2) High_GDP_Life_Expectancy, 
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END),2) Low_GDP_Life_Expectancy
FROM world_life_expectancy
;


SELECT * 
FROM world_life_expectancy
;


SELECT Status, ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;


SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;


SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_expectancy, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_expectancy > 0
AND BMI > 0
ORDER BY BMI DESC   
; 


SELECT *
FROM world_life_expectancy
;


SELECT Country,
	   Year,
       `Life expectancy`,
       `Adult Mortality`,
       SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total 
FROM world_life_expectancy
WHERE Country LIKE  '%United%'
;
