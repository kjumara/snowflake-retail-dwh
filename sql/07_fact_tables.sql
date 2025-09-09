-- Create Fact_Order
-- One row per order to tie order to customer/date
CREATE OR REPLACE TABLE DEMO_RETAIL.CORE.FACT_ORDER AS
SELECT
    SEQ8() AS order_sk,          -- surrogate key
    o.order_id,
    c.customer_sk,               -- FK -> dim_customer
    dd.date_id AS order_date_sk, -- FK -> dim_date (purchase date)
    o.customer_id,
    o.order_purchase_ts,
    o.order_approved_ts
FROM DEMO_RETAIL.STAGE.ORDERS o
JOIN DEMO_RETAIL.CORE.DIM_CUSTOMER c
    ON o.customer_id = c.customer_id
JOIN DEMO_RETAIL.CORE.DIM_DATE dd
    ON o.order_date = dd.date;

-- Create Fact_Order_Item
-- Links orders to products and sellers, and price/freight_value/total_value
CREATE OR REPLACE TABLE DEMO_RETAIL.CORE.FACT_ORDER_ITEM AS
SELECT
    SEQ8() AS order_item_sk,     -- surrogate key
    oi.order_id,                 -- FK -> fact_order
    p.product_sk,                -- FK -> dim_product
    s.seller_sk,                 -- FK -> dim_seller
    dd.date_id AS order_date_sk, -- FK -> dim_date (purchase date from orders)
    oi.price,
    oi.freight_value,
    oi.total_value
FROM DEMO_RETAIL.STAGE.ORDER_ITEMS oi
JOIN DEMO_RETAIL.STAGE.ORDERS o
    ON oi.order_id = o.order_id
JOIN DEMO_RETAIL.CORE.DIM_PRODUCT p
    ON oi.product_id = p.product_id
JOIN DEMO_RETAIL.CORE.DIM_SELLER s
    ON oi.seller_id = s.seller_id
JOIN DEMO_RETAIL.CORE.DIM_DATE dd
    ON o.order_date = dd.date;

-- Create Fact_Payment
-- One row per paymentrecord to track payment to order and method/installments/value
CREATE OR REPLACE TABLE DEMO_RETAIL.CORE.FACT_PAYMENT AS
SELECT
    SEQ8() AS payment_sk,           -- surrogate key
    pay.order_id,                   -- FK -> fact_order
    pt.payment_type_sk,             -- FK -> dim_payment_type
    dd.date_id AS order_date_sk,    -- FK -> dim_date (purchase date from orders)
    pay.payment_seq,
    pay.installments,
    pay.payment_value
FROM DEMO_RETAIL.STAGE.PAYMENTS pay
JOIN DEMO_RETAIL.STAGE.ORDERS o
    ON pay.order_id = o.order_id
JOIN DEMO_RETAIL.CORE.DIM_PAYMENT_TYPE pt
    ON pay.payment_type = pt.payment_name
JOIN DEMO_RETAIL.CORE.DIM_DATE dd
    ON o.order_date = dd.date;

-- Validation Queries
-- Quick sanity checks to confirm tables are working as expected
SELECT *
FROM DEMO_RETAIL.CORE.FACT_ORDER
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.CORE.FACT_ORDER_ITEM
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.CORE.FACT_PAYMENT
LIMIT 5;