-- Bronze Customers Pipeline - Raw customer data ingestion from landing volume

-- Read customers from landing volume into bronze schema
CREATE STREAMING TABLE dev.bronze.customer
COMMENT "Raw customers data from volume to bronze table"
AS
SELECT * FROM
cloud_files(
  "/Volumes/dev/landing/retail_sales/customer/",
  "csv",
  map("header", "true")
);