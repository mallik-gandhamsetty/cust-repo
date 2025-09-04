-- Silver Regions Pipeline - Data quality and transformation for region data

-- Regions Silver with data quality checks
CREATE STREAMING TABLE dev.silver.region
(
  CONSTRAINT region_name_check EXPECT(region_name IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT country_check EXPECT(country IS NOT NULL) ON VIOLATION DROP ROW  
)
COMMENT "Region data from bronze to Silver"
AS
SELECT 
  CAST(region_id AS INT) AS region_id,
  CAST(region_name AS STRING) AS region_name,
  CAST(country AS STRING) AS country
FROM
  STREAM(dev.bronze.region);