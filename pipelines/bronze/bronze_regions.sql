-- Bronze Regions Pipeline - Raw region data ingestion from landing volume

-- Read regions from landing volume into bronze schema
CREATE STREAMING TABLE dev.bronze.region
COMMENT "Raw region data from volume to bronze table"
AS
SELECT * FROM
cloud_files(
  "/Volumes/dev/landing/retail_sales/region/",
  "csv",
  map("header", "true")
);