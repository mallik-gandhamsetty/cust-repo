-- Silver Products Pipeline - Data quality and transformation for product data

-- Products Silver with data quality checks
CREATE STREAMING TABLE dev.silver.product
(
  CONSTRAINT product_name_check EXPECT(product_name IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT category_check EXPECT(category IS NOT NULL) ON VIOLATION DROP ROW
)
COMMENT "Product data from bronze to Silver"
AS
SELECT 
  CAST(product_id AS INT) AS product_id,
  CAST(product_name AS STRING) AS product_name,
  CAST(category AS STRING) AS category,
  CAST(price AS INT) AS price,
  CAST(in_stock AS INT) AS in_stock
FROM
  STREAM(dev.bronze.product);