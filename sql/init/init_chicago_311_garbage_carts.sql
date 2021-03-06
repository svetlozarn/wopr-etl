DROP TABLE IF EXISTS SRC_chicago_311_garbage_carts;

CREATE TABLE IF NOT EXISTS SRC_chicago_311_garbage_carts(
creation_date DATE,
status VARCHAR(20),
completion_date DATE,
service_request_number VARCHAR(20),
type_of_service_request VARCHAR(100),
number_of_black_carts_delivered INTEGER,
current_activity VARCHAR(100),
most_recent_action VARCHAR(100),
street_address VARCHAR(100),
zip_code CHAR(5),
x_coordinate FLOAT8,
y_coordinate FLOAT8,
ward INTEGER,
police_district INTEGER,
community_area INTEGER,
ssa VARCHAR(10),
latitude FLOAT8,
longitude FLOAT8,
location POINT
);

\copy SRC_chicago_311_garbage_carts FROM '/project/evtimov/wopr/dedup_data/chicago_311_garbage_carts_2014-03-23.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',')

DROP TABLE IF EXISTS DAT_chicago_311_garbage_carts;

CREATE TABLE IF NOT EXISTS DAT_chicago_311_garbage_carts(
chicago_311_garbage_carts_row_id SERIAL,
start_date DATE,
end_date DATE DEFAULT NULL,
current_flag BOOLEAN DEFAULT true,
creation_date DATE,
status VARCHAR(20),
completion_date DATE,
service_request_number VARCHAR(20),
type_of_service_request VARCHAR(100),
number_of_black_carts_delivered INTEGER,
current_activity VARCHAR(100),
most_recent_action VARCHAR(100),
street_address VARCHAR(100),
zip_code CHAR(5),
x_coordinate FLOAT8,
y_coordinate FLOAT8,
ward INTEGER,
police_district INTEGER,
community_area INTEGER,
ssa VARCHAR(10),
latitude FLOAT8,
longitude FLOAT8,
location POINT,
PRIMARY KEY(chicago_311_garbage_carts_row_id));

INSERT INTO DAT_chicago_311_garbage_carts(
start_date,
creation_date,
status,
completion_date,
service_request_number,
type_of_service_request,
number_of_black_carts_delivered,
current_activity,
most_recent_action,
street_address,
zip_code,
x_coordinate,
y_coordinate,
ward,
police_district,
community_area,
ssa,
latitude,
longitude,
location
)
SELECT 
'2014-03-23' AS start_date,
creation_date,
status,
completion_date,
service_request_number,
type_of_service_request,
number_of_black_carts_delivered,
current_activity,
most_recent_action,
street_address,
zip_code,
x_coordinate,
y_coordinate,
ward,
police_district,
community_area,
ssa,
latitude,
longitude,
location
FROM SRC_chicago_311_garbage_carts;

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
  dataset_row_id,
  location_geom)
SELECT
  start_date,
  end_date,
  current_flag,
  Location,
  LATITUDE, 
  LONGITUDE,
  creation_DATE AS obs_date,
  NULL AS obs_ts,
  'chicago_311_garbage_carts' AS dataset_name,
  chicago_311_garbage_carts_row_id AS dataset_row_id,
  ST_SetSRID(ST_MakePoint(Longitude, Latitude), 4326)
FROM
  DAT_chicago_311_garbage_carts;
