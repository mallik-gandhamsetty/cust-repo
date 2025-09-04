-- Bronze Sales Pipeline - Raw sales data ingestion from landing volume

-- Read sales from landing volume into bronze schema
CREATE STREAMING TABLE dev.bronze.sales
COMMENT "Raw sales data from volume to bronze table"
AS
SELECT * FROM
cloud_files(
  "/Volumes/dev/landing/retail_sales/sales/",
  "csv",
  map("header", "true")
);