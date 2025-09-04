-- Gold Customer Sales Pipeline - Business-ready analytics tables

-- Customer Sales Analysis - Main gold table
CREATE OR REFRESH MATERIALIZED VIEW dev.gold.customer_sales
COMMENT "Cleaned sales data post constraint checks with full customer, product, and region details"
AS
SELECT 
  FS.sale_id,
  FS.order_date,
  FS.customer_id,
  FS.product_id,
  FS.quantity,
  FS.discount,
  FS.region_id,
  FS.channel,
  FS.promo_code,
  C.first_name,
  C.last_name,
  C.email,
  C.join_date,
  C.vip,
  P.product_name,
  P.category,
  P.price,
  P.in_stock,
  R.region_name,
  R.country,
  FS.quantity * P.price AS revenue,
  CASE 
    WHEN FS.discount > 0 THEN (FS.quantity * P.price) - FS.discount
    ELSE FS.quantity * P.price
  END AS net_revenue
FROM 
  dev.silver.sales FS
LEFT JOIN dev.silver.customer C
  ON FS.customer_id = C.customer_id
LEFT JOIN dev.silver.product P
  ON FS.product_id = P.product_id
LEFT JOIN dev.silver.region R
  ON FS.region_id = R.region_id;