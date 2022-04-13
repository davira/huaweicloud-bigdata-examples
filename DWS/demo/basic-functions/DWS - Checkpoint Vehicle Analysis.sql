/*
	Analysis of Passed Vehicles at Traffic Checkpoints
	
	This practice shows you how to analyze passing vehicles at checkpoints. In this practice, 890 million data records from checkpoints are loaded to a single database table on GaussDB(DWS) for accurate and fuzzy query, demonstrating the ability of GaussDB(DWS) to perform high-performance query for historical data.
	
	For more details, please check: 
	https://support.huaweicloud.com/intl/en-us/qs-dws/dws_01_0110.html
*/


-- STEP 1: Importing Sample Data
-- CREATE DATABASE traffic ENCODING 'utf8' TEMPLATE template0; 
DROP SCHEMA IF EXISTS traffic_data CASCADE;
DROP SCHEMA IF EXISTS tpchobs CASCADE;

CREATE SCHEMA traffic_data;
CREATE SCHEMA tpchobs;



-- Internal Table
DROP TABLE IF EXISTS traffic_data.GCJL;
CREATE TABLE traffic_data.GCJL
(
        kkbh   VARCHAR(20), 
        hphm   VARCHAR(20),
        gcsj   DATE ,
        cplx   VARCHAR(8),
        cllx   VARCHAR(8),
        csys   VARCHAR(8)
)
WITH (orientation = column, COMPRESSION = MIDDLE)
DISTRIBUTE BY HASH(hphm);



-- Foreign Table to read from OBS
DROP FOREIGN TABLE IF EXISTS tpchobs.GCJL_OBS;
CREATE FOREIGN TABLE tpchobs.GCJL_OBS
(
        LIKE traffic_data.GCJL
)
SERVER gsmpp_server 
OPTIONS (
        encoding 'utf8',
        location 'obs://dws-demo-ap-southeast-3/traffic-data/gcxx',
        format 'text',
        delimiter ',',
        access_key 'INSERT_AK',
        secret_access_key 'INSERT_SK',
        chunksize '64',
        IGNORE_EXTRA_DATA 'on'
);


-- Read from OBS, insert into DWS
-- Import 892 M records in 7m 20s
INSERT INTO traffic_data.GCJL 
SELECT * FROM tpchobs.GCJL_OBS;



-- STEP 2: Performing Vehicle Analysis
ANALYZE;  -- ANALYZE collects statistics of tables in a database metadata to improve query execution plan

SELECT COUNT(*) 
FROM traffic_data.gcjl;


-- Accurate vehicle query
SELECT hphm, kkbh, gcsj
FROM traffic_data.gcjl
WHERE hphm =  'YD38641'
AND gcsj BETWEEN '2016-01-06' AND '2016-01-07'
ORDER BY gcsj DESC;


-- Fuzzy vehicle query
SELECT hphm, kkbh, gcsj
FROM traffic_data.gcjl
WHERE hphm LIKE  'YA23F%'
AND kkbh IN('508', '1125', '2120') 
AND gcsj BETWEEN '2016-01-01' AND '2016-01-07'  
ORDER BY hphm,gcsj DESC;


