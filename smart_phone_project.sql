CREATE TABLE smart_phone (
    brand_name VARCHAR(15),
    model VARCHAR(100),
    price INT,
    rating INT,
    has_5g BOOLEAN,
    has_nfc BOOLEAN,
    has_ir_blaster BOOLEAN,
    processor_brand VARCHAR(50),
    num_cores INT,
    processor_speed FLOAT,
	battery_capacity FLOAT,
	fast_charging_available INT,
	fast_charging FLOAT,
	ram_capacity INT,
	internal_memory INT,
	screen_size FLOAT,
	refresh_rate INT,
	num_rear_cameras INT,
	num_front_cameras FLOAT,
	os VARCHAR,
	primary_camera_rear FLOAT,
	primary_camera_front FLOAT,
	extended_memory_available INT,
	extended_upto FLOAT,
	resolution_width INT,
	resolution_height INT	
);

select * from smart_phone

-- -------------------------------------------------------------------
-- QUESTION:

-- Data Cleaning Questions

-- 1.How many total records (smartphones) are there in the table?

-- 2.How many records have NULL values in any column?

-- ---

-- Data Exploration Questions

-- 3.How many brand names are present (including duplicates)?

-- 4.How many unique brand names are there?

-- 5.What are the unique brand names?

-- 6.How many smartphones are priced less than ₹25,000?

-- 7.How many smartphones have NFC, a Snapdragon processor, and 6GB RAM?

-- 8.How many smartphone models are there for the brand "Asus"?

-- 9.Which brands provide fast charging?

-- 10.What is the minimum fast-charging time and average price for each brand (with fast charging)?

-- 11.What is the average processor speed for each processor brand?

-- 12.Which smartphones cost more than ₹14,000, ranked by price per processor brand?

-- 13.What is the speed ranking of each processor within its brand (Method 1)?

-- 14.What is the speed ranking of each processor within its brand (Method 2)?

-- 15.What is the total number of models for each brand-processor combination?

-- 16.What are the top 5 most expensive phones that have NFC, 5G, and IR blaster features?

-- -----------------------------------------------------------------------------




-- data cleaning

--How many total records (smartphones) are there in the table?
select count(*) from smart_phone

-- How many records have NULL values in any column?
SELECT * FROM smart_phone
WHERE brand_name IS NULL
OR
    model IS NULL
OR
    price IS NULL
OR
    rating IS NULL
OR
    has_5g IS NULL
OR
    has_nfc IS NULL
OR
    has_ir_blaster IS NULL
OR
    processor_brand IS NULL
OR
    num_cores IS NULL
OR
    processor_speed IS NULL
OR
	battery_capacity IS NULL
OR
	fast_charging_available IS NULL
OR
	fast_charging IS NULL
OR
	ram_capacity IS NULL
OR
	internal_memory IS NULL
OR
	screen_size IS NULL
OR
	refresh_rate IS NULL
OR
	num_rear_cameras IS NULL
OR
	num_front_cameras IS NULL
OR
	os IS NULL
OR
	primary_camera_rear IS NULL
OR
	primary_camera_front IS NULL
OR
	extended_memory_available IS NULL
OR
	extended_upto IS NULL
OR
	resolution_width IS NULL
OR
	resolution_height IS NULL;

-- data Exploration
-- how many brand_name we have?
-- How many brand names are present (including duplicates)?
select count(brand_name) from smart_phone -- here i got dulplicate 

-- remove duplicate form brand_name
-- How many unique brand names are there?
select count(DISTINCT brand_name) from smart_phone

-- what are uniqe brand name?
-- What are the unique brand names?
select DISTINCT brand_name from smart_phone 


-- How many smart phone price more than 25000?
-- How many smartphones are priced less than ₹25,000?
SELECT * FROM smart_phone
WHERE price < 25000;

-- how many smar phone having nfc and snapdrogon  with 6gb ram
-- How many smartphones have NFC, a Snapdragon processor, and 6GB RAM?
SELECT brand_name, model, price, rating, has_nfc, processor_brand, ram_capacity FROM smart_phone
WHERE has_nfc = true AND processor_brand = 'snapdragon' AND ram_capacity = 6;

-- how many asus brand model phone
-- How many smartphone models are there for the brand "Asus"?
SELECT * FROM smart_phone
WHERE brand_name = 'asus';


-- which brand provide fast charging ?
-- What is the minimum fast-charging time and average price for each brand (with fast charging)?

-- methord 1--------------------------------------------
SELECT brand_name, AVG(price) AS avg_price, MIN(fast_charging) AS min_fast_charging
FROM smart_phone
WHERE fast_charging_available = 1
GROUP BY brand_name
ORDER BY 3 ASC;
-- methord 2--------------------------------------------
WITH ChargingStats AS (
    SELECT brand_name, AVG(price) AS avg_price, MIN(fast_charging) AS min_fast_charging
    FROM smart_phone
    WHERE fast_charging_available = 1
    GROUP BY brand_name
)
SELECT * 
FROM ChargingStats
ORDER BY avg_price ASC;

-- query for each processor avrage speed. 
-- What is the average processor speed for each processor brand?

WITH processors_speed AS (
    SELECT processor_brand, avg(processor_speed) AS processor_speed
    FROM smart_phone
    GROUP BY processor_brand
)
SELECT * 
FROM processors_speed 
ORDER BY processor_speed DESC;

-- under phone 14k
-- Which smartphones cost more than ₹14,000, ranked by price per processor brand?
WITH under_14k AS (
    SELECT 
        *, 
        ROW_NUMBER() OVER (
            PARTITION BY processor_brand 
            ORDER BY price DESC
        ) AS rn
    FROM smart_phone
)
SELECT * 
FROM under_14k
WHERE price > 14000
ORDER BY price DESC;

-- ranking processor speed
-- What is the speed ranking of each processor within its brand (Method 1)?
-- methord 1 -------------------------------
WITH ranking_speed as 
(
	SELECT 
	processor_brand, processor_speed,  
	DENSE_RANK() OVER(
		PARTITION BY processor_brand
		ORDER BY processor_speed DESC )
		as pbs
		FROM smart_phone
)
SELECT * 
FROM ranking_speed
ORDER BY pbs;

-- methord 2 -------------------------------
WITH with_ranks AS (
	SELECT 
		processor_brand,
		processor_speed,
		CASE 
			WHEN processor_speed IS NOT NULL THEN 
				DENSE_RANK() OVER (
					PARTITION BY processor_brand 
					ORDER BY processor_speed DESC
				)
			ELSE NULL
		END AS pbs
	FROM smart_phone
)
SELECT * 
FROM with_ranks
ORDER BY pbs NULLS LAST;

-- find total no. of model of each brand with each processor
-- What is the total number of models for each brand-processor combination?
WITH models AS (
	SELECT 
		brand_name,
		processor_brand, 
		model,
		count(processor_brand) OVER (
			PARTITION BY brand_name, processor_brand
		) AS model_count
	FROM smart_phone
)
SELECT * 
FROM models;

-- top 5 height price of which brand and model with processor and 
-- nfc and 5g blaster should be true.
-- What are the top 5 most expensive phones that have NFC, 5G, and IR blaster features?
WITH height_5 AS (
    SELECT 
        brand_name,
        model,
        processor_brand,
        price,
        CASE
            WHEN has_nfc = true AND has_5g = true AND has_ir_blaster = true THEN 'All Features'
            WHEN has_nfc = true AND has_5g = true THEN 'NFC and 5G only'
            WHEN has_nfc = true THEN 'Only NFC'
            ELSE 'Missing Key Features'
        END AS feature_status,
        ROW_NUMBER() OVER (ORDER BY price DESC) AS price_rank
    FROM smart_phone
)
SELECT brand_name, model, processor_brand, price, feature_status
FROM height_5
WHERE feature_status = 'All Features'
  AND price_rank <= 5;


select * from smart_phone





