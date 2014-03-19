\timing

DROP TABLE IF EXISTS SRC_chicago_environmental_complaints;
    
CREATE TABLE IF NOT EXISTS SRC_chicago_environmental_complaints(
COMPLAINT_ID VARCHAR(20),
COMPLAINT_TYPE VARCHAR(50),
MAPPED_LOCATION VARCHAR(100),
STREET_NUMBER_FROM INTEGER,
STREET_NUMBER_TO INTEGER,
DIRECTION CHAR(10),
STREET_NAME VARCHAR(30),
STREET_TYPE VARCHAR(15),
INSPECTOR VARCHAR(10),
COMPLAINT_DATE DATE,
COMPLAINT_DETAIL VARCHAR(3600),
INSPECTION_LOG VARCHAR(3600),
DATA_SOURCE VARCHAR(50),
MODIFIED_DATE DATE,
LOCATION POINT,
LATITUDE FLOAT8,
LONGITUDE FLOAT8,
PRIMARY KEY(COMPLAINT_ID));
    
\copy SRC_chicago_environmental_complaints FROM './processed_data/dedup/dedup_chicago-environmental-complaints_2014-03-06.csv' WITH DELIMITER ',' CSV HEADER;
    
DROP TABLE IF EXISTS DAT_chicago_environmental_complaints;
    
CREATE TABLE IF NOT EXISTS DAT_chicago_environmental_complaints(
chicago_environmental_complaints_row_id SERIAL,
start_date DATE,
end_date DATE DEFAULT NULL,
current_flag BOOLEAN DEFAULT true,
COMPLAINT_ID VARCHAR(20),
COMPLAINT_TYPE VARCHAR(50),
MAPPED_LOCATION VARCHAR(100),
STREET_NUMBER_FROM INTEGER,
STREET_NUMBER_TO INTEGER,
DIRECTION CHAR(10),
STREET_NAME VARCHAR(30),
STREET_TYPE VARCHAR(15),
INSPECTOR VARCHAR(10),
COMPLAINT_DATE DATE,
COMPLAINT_DETAIL VARCHAR(3600),
INSPECTION_LOG VARCHAR(3600),
DATA_SOURCE VARCHAR(50),
MODIFIED_DATE DATE,
LOCATION POINT,
LATITUDE FLOAT8,
LONGITUDE FLOAT8,
PRIMARY KEY(chicago_environmental_complaints_row_id),
UNIQUE(COMPLAINT_ID, start_date));
    
INSERT INTO DAT_chicago_environmental_complaints(
start_date,
COMPLAINT_ID,
COMPLAINT_TYPE,
MAPPED_LOCATION,
STREET_NUMBER_FROM,
STREET_NUMBER_TO,
DIRECTION,
STREET_NAME,
STREET_TYPE,
INSPECTOR,
COMPLAINT_DATE,
COMPLAINT_DETAIL,
INSPECTION_LOG,
DATA_SOURCE,
MODIFIED_DATE,
LOCATION,
LATITUDE,
LONGITUDE)
SELECT
'2014-03-06' AS start_date,
COMPLAINT_ID,
COMPLAINT_TYPE,
MAPPED_LOCATION,
STREET_NUMBER_FROM,
STREET_NUMBER_TO,
DIRECTION,
STREET_NAME,
STREET_TYPE,
INSPECTOR,
COMPLAINT_DATE,
COMPLAINT_DETAIL,
INSPECTION_LOG,
DATA_SOURCE,
MODIFIED_DATE,
LOCATION,
LATITUDE,
LONGITUDE
FROM SRC_chicago_environmental_complaints;
    
INSERT INTO DAT_Master(
start_date,
end_date,
current_flag,
Location,
LATITUDE,
LONGITUDE,
obs_date,
obs_ts,
dataset_name,
dataset_row_id)
SELECT
start_date,
end_date,
current_flag,
LOCATION,
LATITUDE,
LONGITUDE,
COMPLAINT_DATE AS obs_date,
NULL AS obs_ts,
'chicago_environmental_complaints' AS dataset_name,
chicago_environmental_complaints_row_id AS dataset_row_id
FROM
DAT_chicago_environmental_complaints;
