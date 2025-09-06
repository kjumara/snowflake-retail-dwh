-- Customers Table
CREATE OR REPLACE TABLE DEMO_RETAIL.RAW.CUSTOMERS (
    customer_id                 STRING,
    customer_zip_code_prefix    STRING,
    customer_city               STRING,
    customer_state              STRING
);

-- Orders Table
CREATE OR REPLACE TABLE DEMO_RETAIL.RAW.ORDERS (
    order_id                    STRING,
    customer_id                 STRING,
    order_purchase_timestamp    TIMESTAMP_NTZ,
    order_approved_at           TIMESTAMP_NTZ
);

-- Order Items Table
CREATE OR REPLACE TABLE DEMO_RETAIL.RAW.ORDER_ITEMS (
    order_id            STRING,
    product_id          STRING,
    seller_id           STRING,
    price               NUMBER(10,2),
    shipping_charges    NUMBER(10,2)
);

-- Products Table
CREATE OR REPLACE TABLE DEMO_RETAIL.RAW.PRODUCTS (
    product_id              STRING,
    product_category_name   STRING,
    product_weight_g        NUMBER,
    product_length_cm       NUMBER,
    product_height_cm       NUMBER,
    product_width_cm        NUMBER
);

-- Payments Table
CREATE OR REPLACE TABLE DEMO_RETAIL.RAW.PAYMENTS (
    order_id                STRING,
    payment_sequential      NUMBER,
    payment_type            STRING,
    payment_installments    NUMBER,
    payment_value           NUMBER(10,2)
);