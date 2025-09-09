-- Create Dim_Date
-- Synthetic date dimension for joining facts to calendar

-- Find date range

SELECT
    MIN(order_date) AS min_date,
    MAX(order_date) AS max_date
FROM DEMO_RETAIL.STAGE.ORDERS;

-- Build date dimension
CREATE OR REPLACE TABLE DEMO_RETAIL.CORE.DIM_DATE AS
WITH bounds AS (
    SELECT
        MIN(order_date) AS min_date,
        MAX(order_date) AS max_date
    FROM DEMO_RETAIL.STAGE.ORDERS
),
date_spine AS (
    SELECT
        DATEADD(DAY, SEQ4(), (SELECT min_date FROM bounds)) AS full_date
    FROM TABLE(GENERATOR(ROWCOUNT => 5000)) -- overshoot rowcount
)
SELECT
    TO_NUMBER(TO_CHAR(full_date,'YYYYMMDD')) AS date_id,
    full_date                               AS date,
    YEAR(full_date)                         AS year,
    QUARTER(full_date)                      AS quarter,
    MONTH(full_date)                        AS month,
    TO_CHAR(full_date,'Mon')                AS month_name,
    DAY(full_date)                          AS day_of_month,
    DAYOFWEEK(full_date)                    AS day_of_week,
    TO_CHAR(full_date, 'DY')                AS day_name,
    CASE
        WHEN DAYOFWEEK(full_date)
        IN (0,6)
        THEN TRUE
        ELSE FALSE
    END                                     AS is_weekend
FROM date_spine, bounds
WHERE full_date BETWEEN bounds.min_date AND bounds.max_date
ORDER BY full_date;

-- Create Dim_Customer
-- Clean, deduped customer dimension with surrogate key
CREATE OR REPLACE TABLE DEMO_RETAIL.CORE.DIM_CUSTOMER AS
WITH deduped AS (
    SELECT
        customer_id,
        zip_code_prefix,
        city,
        state,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_id) as rn
    FROM DEMO_RETAIL.STAGE.CUSTOMERS
)
SELECT
    SEQ8() AS customer_sk, -- surrogate key
    customer_id,
    zip_code_prefix,
    city,
    state
FROM deduped
WHERE rn = 1
ORDER BY customer_id;

-- Create Dim_Seller
-- Clean, deduped seller dimension
CREATE OR REPLACE TABLE DEMO_RETAIL.CORE.DIM_SELLER AS
WITH deduped AS (
    SELECT seller_id,
    ROW_NUMBER() OVER (PARTITION BY seller_id ORDER BY seller_id) AS rn
    FROM DEMO_RETAIL.STAGE.ORDER_ITEMS
)
SELECT
    SEQ8() AS seller_sk, -- surrogate key
    seller_id
FROM deduped
WHERE rn = 1
ORDER BY seller_id;

-- Create Dim_Product
-- Clean, deduped product dimension with surrogate key
CREATE OR REPLACE TABLE DEMO_RETAIL.CORE.DIM_PRODUCT AS
WITH deduped AS (
    SELECT
        product_id,
        category_name,
        weight_g,
        length_cm,
        height_cm,
        width_cm,
        volume_cm3,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY product_id) AS rn
    FROM DEMO_RETAIL.STAGE.PRODUCTS
)
SELECT
    SEQ8() AS product_sk,      -- surrogate key
    product_id,
    category_name,
    weight_g,
    length_cm,
    height_cm,
    width_cm,
    volume_cm3
FROM deduped
WHERE rn = 1
ORDER BY product_id;

-- Create Dim_Payment_Type
-- Simple payment type dimension with surrogate key
CREATE OR REPLACE TABLE DEMO_RETAIL.CORE.DIM_PAYMENT_TYPE AS
WITH deduped AS (
    SELECT DISTINCT
        payment_type
    FROM DEMO_RETAIL.STAGE.PAYMENTS
)
SELECT
    SEQ8() AS payment_type_sk,   -- surrogate key
    payment_type AS payment_name
FROM deduped
ORDER BY payment_type;

-- Validation Queries
-- Quick sanity checks to confirm tables are working as expected

SELECT *
FROM DEMO_RETAIL.CORE.DIM_DATE
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.CORE.DIM_CUSTOMER
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.CORE.DIM_SELLER
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.CORE.DIM_PRODUCT
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.CORE.DIM_PAYMENT_TYPE
LIMIT 5;