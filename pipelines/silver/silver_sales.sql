-- Silver Sales Pipeline - Data quality and transformation for sales data

-- Sales Silver with data quality checks
CREATE STREAMING TABLE dev.silver.sales 
(
  CONSTRAINT sales_quantity_check EXPECT(quantity IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT sales_channel_check EXPECT(channel IS NOT NULL) ON VIOLATION DROP ROW
)
COMMENT "Sales data from bronze to Silver"
AS
SELECT 
  CAST(sale_id AS INT) AS sale_id,
  TO_DATE(order_date, 'dd/MM/yyyy') AS order_date,
  CAST(customer_id AS INT) AS customer_id,
  CAST(product_id AS INT) AS product_id,
  CAST(quantity AS INT) AS quantity,
  CAST(discount AS INT) AS discount,
  CAST(region_id AS INT) AS region_id,
  CAST(channel AS STRING) AS channel,
  CAST(promo_code AS STRING) AS promo_code
FROM
  STREAM(dev.bronze.sales);