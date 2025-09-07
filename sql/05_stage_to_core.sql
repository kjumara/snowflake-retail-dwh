// Create STAGE views for each table

-- Customers Table
-- Standardize casing + ensure zip_code_prefix stored as STRING
CREATE OR REPLACE VIEW DEMO_RETAIL.STAGE.CUSTOMERS AS
SELECT
    TRIM(CUSTOMER_ID)                           AS customer_id,
    CAST(CUSTOMER_ZIP_CODE_PREFIX AS STRING)    AS zip_code_prefix,
    INITCAP(TRIM(CUSTOMER_CITY))                AS city,
    UPPER(TRIM(CUSTOMER_STATE))                 AS state
FROM DEMO_RETAIL.RAW.CUSTOMERS;

-- Orders Table
-- Trim whitespace + cast timestamps + add derived order_date for easy filtering
CREATE OR REPLACE VIEW DEMO_RETAIL.STAGE.ORDERS AS
SELECT
    TRIM(ORDER_ID)                              AS order_id,
    TRIM(CUSTOMER_ID)                           AS customer_id,
    TO_TIMESTAMP_NTZ(order_purchase_timestamp)  AS order_purchase_ts,
    TO_TIMESTAMP_NTZ(order_approved_at)         AS order_approved_ts,
    TO_DATE(order_purchase_timestamp)           AS order_date
FROM DEMO_RETAIL.RAW.ORDERS;

-- Order Items Table
-- Trim whitespace + cast numeric columns + rename freight_value + derive total_value
CREATE OR REPLACE VIEW DEMO_RETAIL.STAGE.ORDER_ITEMS AS
SELECT
    TRIM(ORDER_ID)                                                          AS order_id,
    TRIM(PRODUCT_ID)                                                        AS product_id,
    TRIM(SELLER_ID)                                                         AS seller_id,
    CAST(PRICE AS NUMBER(10,2))                                             AS price,
    CAST(SHIPPING_CHARGES AS NUMBER(10,2))                                  AS freight_value,
    (CAST(PRICE AS NUMBER(10,2)) + CAST(SHIPPING_CHARGES AS NUMBER(10,2)))  AS total_value
FROM DEMO_RETAIL.RAW.ORDER_ITEMS;

-- Products Table
-- Trim whitespace + cast numeric columns + derive product volume
CREATE OR REPLACE VIEW DEMO_RETAIL.STAGE.PRODUCTS AS
SELECT
    TRIM(PRODUCT_ID)                                        AS product_id,
    LOWER(TRIM(PRODUCT_CATEGORY_NAME))                      AS category_name,
    CAST(PRODUCT_WEIGHT_G AS NUMBER)                        AS weight_g,
    CAST(PRODUCT_LENGTH_CM AS NUMBER)                       AS length_cm,
    CAST(PRODUCT_HEIGHT_CM AS NUMBER)                       AS height_cm,
    CAST(PRODUCT_WIDTH_CM AS NUMBER)                        AS width_cm,
    (CAST(PRODUCT_LENGTH_CM AS NUMBER) *
     CAST(PRODUCT_HEIGHT_CM AS NUMBER) *
     CAST(PRODUCT_WIDTH_CM AS NUMBER))                      AS volume_cm3
FROM DEMO_RETAIL.RAW.PRODUCTS;

-- Payments Table
-- Trim whitespace + cast numeric columns + normalize payment_type
CREATE OR REPLACE VIEW DEMO_RETAIL.STAGE.PAYMENTS AS
SELECT
    TRIM(ORDER_ID)                      AS order_id,
    CAST(payment_sequential AS INT)     AS payment_seq,
    LOWER(TRIM(payment_type))           AS payment_type,
    CAST(payment_installments AS INT)   AS installments,
    CAST(payment_value AS NUMBER(10,2)) AS payment_value
FROM DEMO_RETAIL.RAW.PAYMENTS;

-- Validation Queries
-- Quick sanity checks to confirm views are working as expected

SELECT *
FROM DEMO_RETAIL.STAGE.CUSTOMERS
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.STAGE.ORDERS
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.STAGE.ORDER_ITEMS
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.STAGE.PRODUCTS
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.STAGE.PAYMENTS
LIMIT 5;