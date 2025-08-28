
# ============================================================================
# SOURCE VIEWS
# ============================================================================

CREATE OR REFRESH STREAMING TABLE v_orders_africa_raw
COMMENT "Load orders Africa table from raw schema"
AS SELECT
*  , F.current_timestamp() AS _processing_timestampFROM
STREAM(LIVE.acme_edw_dev.edw_raw.orders_africa_raw);

CREATE OR REFRESH STREAMING TABLE v_orders_america_raw
COMMENT "Load orders America table from raw schema"
AS SELECT
*  , F.current_timestamp() AS _processing_timestampFROM
STREAM(LIVE.acme_edw_dev.edw_raw.orders_america_raw);

CREATE OR REFRESH STREAMING TABLE v_orders_asia_raw
COMMENT "Load orders Asia table from raw schema"
AS SELECT
*  , F.current_timestamp() AS _processing_timestampFROM
STREAM(LIVE.acme_edw_dev.edw_raw.orders_asia_raw);

CREATE OR REFRESH STREAMING TABLE v_orders_europe_raw
COMMENT "Load orders Europe table from raw schema"
AS SELECT
*  , F.current_timestamp() AS _processing_timestampFROM
STREAM(LIVE.acme_edw_dev.edw_raw.orders_europe_raw);

CREATE OR REFRESH STREAMING TABLE v_orders_middle_east_raw
COMMENT "Load orders Middle East table from raw schema"
AS SELECT
*  , F.current_timestamp() AS _processing_timestampFROM
STREAM(LIVE.acme_edw_dev.edw_raw.orders_middle_east_raw);

CREATE OR REFRESH MATERIALIZED VIEW v_orders_migration
COMMENT "Load orders table from migration schema"
AS SELECT
*  , F.current_timestamp() AS _processing_timestampFROM
LIVE.acme_edw_dev.edw_old.orders;


# ============================================================================
# TRANSFORMATION VIEWS
# ============================================================================

CREATE OR REFRESH VIEW v_orders_africa_bronze_cleaned
COMMENT "SQL transform: orders_africa_bronze_cleanse"AS
SELECT
  o_orderkey as order_id,
  o_custkey as customer_id,
  o_orderstatus as order_status,
  o_totalprice as total_price,
  o_orderdate as order_date,
  o_orderpriority as order_priority,
  o_clerk as clerk,
  o_shippriority as ship_priority,
  o_comment as comment,
  cast(last_modified_dt as TIMESTAMP) as last_modified_dt,
  * EXCEPT(o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority, o_clerk, o_shippriority, o_comment, last_modified_dt,_rescued_data)
FROM stream(v_orders_africa_raw);


CREATE OR REFRESH VIEW v_orders_america_bronze_cleaned
COMMENT "SQL transform: orders_america_bronze_cleanse"AS
SELECT
  o_orderkey as order_id,
  o_custkey as customer_id,
  o_orderstatus as order_status,
  o_totalprice as total_price,
  o_orderdate as order_date,
  o_orderpriority as order_priority,
  o_clerk as clerk,
  o_shippriority as ship_priority,
  o_comment as comment,
  cast(last_modified_dt as TIMESTAMP) as last_modified_dt,
  * EXCEPT(o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority, o_clerk, o_shippriority, o_comment, last_modified_dt,_rescued_data)
FROM stream(v_orders_america_raw);


CREATE OR REFRESH VIEW v_orders_asia_bronze_cleaned
COMMENT "SQL transform: orders_asia_bronze_cleanse"AS
SELECT
  o_orderkey as order_id,
  o_custkey as customer_id,
  o_orderstatus as order_status,
  o_totalprice as total_price,
  o_orderdate as order_date,
  o_orderpriority as order_priority,
  o_clerk as clerk,
  o_shippriority as ship_priority,
  o_comment as comment,
  cast(last_modified_dt as TIMESTAMP) as last_modified_dt,
  * EXCEPT(o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority, o_clerk, o_shippriority, o_comment, last_modified_dt,_rescued_data)
FROM stream(v_orders_asia_raw);


CREATE OR REFRESH VIEW v_orders_europe_bronze_cleaned
COMMENT "SQL transform: orders_europe_bronze_cleanse"AS
SELECT
  o_orderkey as order_id,
  o_custkey as customer_id,
  o_orderstatus as order_status,
  o_totalprice as total_price,
  o_orderdate as order_date,
  o_orderpriority as order_priority,
  o_clerk as clerk,
  o_shippriority as ship_priority,
  o_comment as comment,
  cast(last_modified_dt as TIMESTAMP) as last_modified_dt,
  * EXCEPT(o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority, o_clerk, o_shippriority, o_comment, last_modified_dt,_rescued_data)
FROM stream(v_orders_europe_raw);


CREATE OR REFRESH VIEW v_orders_middle_east_bronze_cleaned
COMMENT "SQL transform: orders_middle_east_bronze_cleanse"AS
SELECT
  o_orderkey as order_id,
  o_custkey as customer_id,
  o_orderstatus as order_status,
  o_totalprice as total_price,
  o_orderdate as order_date,
  o_orderpriority as order_priority,
  o_clerk as clerk,
  o_shippriority as ship_priority,
  o_comment as comment,
  cast(last_modified_dt as TIMESTAMP) as last_modified_dt,
  * EXCEPT(o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority, o_clerk, o_shippriority, o_comment, last_modified_dt,_rescued_data)
FROM stream(v_orders_middle_east_raw);


CREATE OR REFRESH VIEW v_orders_migration_cleaned
COMMENT "SQL transform: orders_migration_cleanse"AS
SELECT
  o_orderkey as order_id,
  o_custkey as customer_id,
  o_orderstatus as order_status,
  o_totalprice as total_price,
  o_orderdate as order_date,
  o_orderpriority as order_priority,
  o_clerk as clerk,
  o_shippriority as ship_priority,
  o_comment as comment,
  cast(last_modified_dt as TIMESTAMP) as last_modified_dt,
  'MIGRATION' as _source_file_path,
  * EXCEPT(o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, o_orderpriority, o_clerk, o_shippriority, o_comment, last_modified_dt)
FROM v_orders_migration;



# ============================================================================
# TARGET TABLES
# ============================================================================


-- Create the streaming table from the primary source
CREATE OR REFRESH STREAMING TABLE acme_edw_dev.edw_bronze.ordersCOMMENT "Generated by Lakehouse Plumber: write_acme_edw_dev_edw_bronze_orders"
AS SELECT * FROM STREAM(LIVE.v_orders_africa_bronze_cleaned);
CREATE OR REFRESH STREAMING TABLE v_orders_america_bronze_cleaned_to_orders_flow (
  COMMENT "Flow to insert data from v_orders_america_bronze_cleaned into orders"
)
AS SELECT * FROM STREAM(LIVE.v_orders_america_bronze_cleaned);

APPLY CHANGES INTO LIVE.acme_edw_dev.edw_bronze.orders
FROM STREAM(LIVE.v_orders_america_bronze_cleaned_to_orders_flow)
KEYS()
SEQUENCE BY 1
COLUMNS *;
CREATE OR REFRESH STREAMING TABLE v_orders_asia_bronze_cleaned_to_orders_flow (
  COMMENT "Flow to insert data from v_orders_asia_bronze_cleaned into orders"
)
AS SELECT * FROM STREAM(LIVE.v_orders_asia_bronze_cleaned);

APPLY CHANGES INTO LIVE.acme_edw_dev.edw_bronze.orders
FROM STREAM(LIVE.v_orders_asia_bronze_cleaned_to_orders_flow)
KEYS()
SEQUENCE BY 1
COLUMNS *;
CREATE OR REFRESH STREAMING TABLE v_orders_europe_bronze_cleaned_to_orders_flow (
  COMMENT "Flow to insert data from v_orders_europe_bronze_cleaned into orders"
)
AS SELECT * FROM STREAM(LIVE.v_orders_europe_bronze_cleaned);

APPLY CHANGES INTO LIVE.acme_edw_dev.edw_bronze.orders
FROM STREAM(LIVE.v_orders_europe_bronze_cleaned_to_orders_flow)
KEYS()
SEQUENCE BY 1
COLUMNS *;
CREATE OR REFRESH STREAMING TABLE v_orders_middle_east_bronze_cleaned_to_orders_flow (
  COMMENT "Flow to insert data from v_orders_middle_east_bronze_cleaned into orders"
)
AS SELECT * FROM STREAM(LIVE.v_orders_middle_east_bronze_cleaned);

APPLY CHANGES INTO LIVE.acme_edw_dev.edw_bronze.orders
FROM STREAM(LIVE.v_orders_middle_east_bronze_cleaned_to_orders_flow)
KEYS()
SEQUENCE BY 1
COLUMNS *;
CREATE OR REFRESH STREAMING TABLE v_orders_migration_cleaned_to_orders_flow (
  COMMENT "Flow to insert data from v_orders_migration_cleaned into orders"
)
AS SELECT * FROM STREAM(LIVE.v_orders_migration_cleaned);

APPLY CHANGES INTO LIVE.acme_edw_dev.edw_bronze.orders
FROM STREAM(LIVE.v_orders_migration_cleaned_to_orders_flow)
KEYS()
SEQUENCE BY 1
COLUMNS *;