-- Silver Customers Pipeline - Data quality and transformation for customer data

-- Customer Silver with data quality checks
CREATE STREAMING TABLE dev.silver.customer
(
  CONSTRAINT customer_first_name_check EXPECT(first_name IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT customer_email_check EXPECT(email IS NOT NULL) ON VIOLATION DROP ROW
)
COMMENT "Customer data from bronze to Silver"
AS
SELECT 
  CAST(customer_id AS INT) AS customer_id,
  CAST(first_name AS STRING) AS first_name,
  CAST(last_name AS STRING) AS last_name,
  CAST(email AS STRING) AS email,
  TO_DATE(join_date, 'dd/MM/yyyy') AS join_date,
  CAST(vip AS STRING) AS VIP
FROM
  STREAM(dev.bronze.customer);