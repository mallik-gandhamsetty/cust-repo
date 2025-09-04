-- Bronze Products Pipeline - Raw product data ingestion from landing volume

-- Read products from landing volume into bronze schema
CREATE STREAMING TABLE dev.bronze.product
COMMENT "Raw products data from volume to bronze table"
AS
SELECT * FROM
cloud_files(
  "/Volumes/dev/landing/retail_sales/product/",
  "csv",
  map("header", "true")
);