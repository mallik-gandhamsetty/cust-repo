-n CREATE TABLE IF NOT EXISTS {{catalog}}.gold.customers_demo_1757248703 (
    id INT,
    name STRING,
    email STRING,
    updated_at TIMESTAMP
)
USING DELTA
COMMENT 'A new demo table created by the interactive demo script.';
