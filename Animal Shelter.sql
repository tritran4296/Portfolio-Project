USE DataCamp
GO

With pre_total AS (
SELECT animalid, sub.animaltype, sub.size_id, (ac.costs + lc.costs + sc.costs) as total, sc.size
FROM (
	SELECT animalid, animaltype, location,  CAST((DATEDIFF(YEAR, '2021-12-31', birthdate)) as float) as age,
	CASE WHEN animaltype = 'Dog' AND weight <= 10 THEN 'DS'
	WHEN animaltype = 'Dog' AND weight > 10 AND weight <= 30 THEN 'DM'
	WHEN animaltype = 'Dog' AND weight > 30 THEN 'DL'
	WHEN animaltype = 'Cat' AND  weight <= 5 THEN 'CS'
	WHEN animaltype = 'Cat' AND  weight > 5 AND weight <= 7 THEN 'CM'
	WHEN animaltype = 'Cat' AND weight > 7 THEN 'CL'
	WHEN animaltype = 'Bird' AND  weight <= 0.7 THEN 'BS'
	WHEN animaltype = 'Bird' AND  weight > 0.7 AND weight <= 1.1 THEN 'BM'
	WHEN animaltype = 'Bird' AND weight > 1.1 THEN 'BL' END as size_id
	FROM animals 
	WHERE animalid NOT IN (SELECT sponsorid FROM sponsored_animals) 
	) as sub
LEFT JOIN age_costs as ac ON cast(ac.age as float) = sub.age
LEFT JOIN location_costs as lc ON lc.location = sub.location
JOIN size_costs as sc ON sc.sizeid = sub.size_id ),

percentages as (
SELECT pre_total.animalid, (total/ CAST(overall as float))*100 as percentage
FROM pre_total
LEFT JOIN (
SELECT pre_total.animalid, SUM(total) OVER(PARTITION BY pre_total.animaltype, pre_total.size_id) as overall
FROM pre_total
) as perc
ON pre_total.animalid = perc.animalid)

SELECT animaltype, pre_total.size, total, ROUND(CAST(percentages.percentage as numeric),2) as percentage
FROM pre_total
LEFT JOIN percentages ON pre_total.animalid = percentages.animalid
ORDER BY animaltype, CASE pre_total.size WHEN 'Small' THEN 1 
										 WHEN 'Medium' THEN 2 
										 WHEN 'Large' THEN 3 END



