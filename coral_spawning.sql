USE ocean;

-- Check how many rows imported
SELECT COUNT(*)
FROM coral_spawn;
# 4484 rows imported


-- Take a quick look at the data
SELECT *
FROM coral_spawn
LIMIT 5;


-- Find AVG Starting time that coral spawn
SELECT AVG(Start_decimal)
FROM coral_spawn;
# Corals spawn at 20:45 on average

### But with time series I think finding average time does not make sense 
### because the real question is how often does the event occur? And at what time does the event happen most frequently?
### Therefore, we should find mode instead of mean.

-- What time do corals spawn the most frequently?
SELECT Start_decimal, COUNT(*) AS count
FROM coral_spawn
WHERE Start_decimal IS NOT NULL
GROUP BY Start_decimal
ORDER BY count DESC
LIMIT 1;
# Corals spawn the most frequently at 20:50

-- What time do corals spawn the most often? >> use rank in case that 2 occurrences have the same count number
SELECT Start_decimal as mode_time_spawning
FROM
(SELECT Start_decimal, count, 
	DENSE_RANK() OVER(ORDER BY count DESC) AS ranking
FROM (
	SELECT Start_decimal, 
    COUNT(*) AS count
	FROM coral_spawn
    WHERE Start_decimal IS NOT NULL
    GROUP BY Start_decimal
    ) X
) Y
WHERE ranking = 1;
# Corals spawn the most frequently at 20:50


-- How far (how many days) from the full moon date do corals spawn the most frequently?
SELECT DoSRtNFM as mode_days_from_full_moon
FROM
(SELECT DoSRtNFM, count, 
	DENSE_RANK() OVER(ORDER BY count DESC) AS ranking
FROM (
	SELECT DoSRtNFM, 
    COUNT(*) AS count
	FROM coral_spawn
    WHERE DoSRtNFM IS NOT NULL
    GROUP BY DoSRtNFM
    ) X
) Y
WHERE ranking = 1;
# Corals spawn the most frequently 5 days after the full moon


-- Do the different species spawn at different times?
SELECT Taxon, ROUND(AVG(Start_decimal),2) AS time_spawning
FROM coral_spawn
GROUP BY Taxon
ORDER BY time_spawning;
# Different coral specie spawns at a different time


-- Does coral spawning happen at about the same time in every region?
SELECT 
    Taxon,
	Ecoregion,
	ROUND(AVG(Start_decimal),2) AS avg_start_time_spawning
FROM coral_spawn
GROUP BY  Taxon, Ecoregion
ORDER BY Taxon, avg_start_time_spawning;
# It varies by regions

-- Also they spawn at a different time at each site
SELECT 
    Taxon,
	Ecoregion, 
    Site, 
	ROUND(AVG(Start_decimal),2) AS avg_start_time_spawning
FROM coral_spawn
GROUP BY  Taxon, Ecoregion, Site
ORDER BY Taxon, avg_start_time_spawning;




-- How many types of gamete_release are observed?
SELECT DISTINCT Gamete_release, COUNT(*) AS count
FROM coral_spawn
GROUP BY Gamete_release
ORDER BY count DESC;
# 4 types: Bundles, Spern, Eggs, and both (sperm and egg) separately. And bundles happened > 50% of all the records


