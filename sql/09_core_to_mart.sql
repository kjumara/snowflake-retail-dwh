-- Create Sales by Product Category
-- Product Category x Month x Year
CREATE OR REPLACE VIEW DEMO_RETAIL.MART.SALES_BY_PRODUCT_CATEGORY AS
SELECT
    p.category_name,
    d.year,
    d.month,
    SUM(oi.total_value) AS total_value,
    COUNT(oi.order_date_sk) AS items_sold,
    AVG(oi.total_value) AS avg_order_value
FROM DEMO_RETAIL.CORE.FACT_ORDER_ITEM oi
JOIN DEMO_RETAIL.CORE.DIM_PRODUCT p
    ON oi.product_sk = p.product_sk
JOIN DEMO_RETAIL.CORE.DIM_DATE d
    ON oi.order_date_sk = d.date_id
GROUP BY p.category_name, d.year, d.month
ORDER BY d.year, d.month, p.category_name;

-- Create Top Sellers
-- Seller x Month x Year, ranked by revenue
CREATE OR REPLACE VIEW DEMO_RETAIL.MART.TOP_SELLERS AS
SELECT
    s.seller_id,
    d.year,
    d.month,
    SUM(oi.total_value)     AS total_revenue,
    COUNT(oi.order_item_sk) AS items_sold,
    AVG(oi.total_value)     AS avg_item_value,
    RANK() OVER (PARTITION BY d.year, d.month ORDER BY SUM(oi.total_value) DESC) AS rank_revenue
FROM DEMO_RETAIL.CORE.FACT_ORDER_ITEM oi
JOIN DEMO_RETAIL.CORE.DIM_SELLER s
    ON oi.seller_sk = s.seller_sk
JOIN DEMO_RETAIL.CORE.DIM_DATE d
    ON oi.order_date_sk = d.date_id
GROUP BY s.seller_id, d.year, d.month
ORDER BY d.year, d.month, rank_revenue;

-- Create Payment Type Usage
-- Payment Type x Month x Year
CREATE OR REPLACE VIEW DEMO_RETAIL.MART.PAYMENT_TYPE_USAGE AS
SELECT
    pt.payment_name,
    d.year,
    d.month,
    COUNT(pay.payment_sk)           AS num_payments,
    COUNT(DISTINCT pay.order_id)    AS num_orders,
    SUM(pay.payment_value)          AS total_payment_value,
    AVG(pay.installments)           AS avg_installments,
    AVG(pay.payment_value)          AS avg_payment_value,
    SUM(pay.payment_value)/
        SUM(SUM(pay.payment_value)) OVER (PARTITION BY d.year, d.month)
                                    AS pct_of_month_value
FROM DEMO_RETAIL.CORE.FACT_PAYMENT pay
JOIN DEMO_RETAIL.CORE.DIM_PAYMENT_TYPE pt
    ON pay.payment_type_sk = pt.payment_type_sk
JOIN DEMO_RETAIL.CORE.DIM_DATE d
    ON pay.order_date_sk = d.date_id
GROUP BY pt.payment_name, d.year, d.month
ORDER BY d.year, d.month, pt.payment_name;

-- Create Customer Lifetime Value
-- This dataset only contains one order per customer
-- So metrics like order frequency and days_active are not meaningful
CREATE OR REPLACE VIEW DEMO_RETAIL.MART.CUSTOMER_LIFETIME_VALUE AS
SELECT
    c.customer_id,
    MIN(d.date)             AS first_order_date,
    MAX(d.date)             AS last_order_date,
    SUM(p.payment_value)    AS total_spent,
    AVG(p.payment_value)    AS avg_order_value,
FROM DEMO_RETAIL.CORE.FACT_ORDER o
JOIN DEMO_RETAIL.CORE.DIM_CUSTOMER c
    ON o.customer_sk = c.customer_sk
JOIN DEMO_RETAIL.CORE.DIM_DATE d
    ON o.order_date_sk = d.date_id
JOIN DEMO_RETAIL.CORE.FACT_PAYMENT p
    ON o.order_id = p.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

-- Revenue Trend by Category and Payment Type
-- Category x Payment Type x Month x Year
CREATE OR REPLACE VIEW DEMO_RETAIL.MART.REVENUE_TREND_BY_CATEGORY_AND_PAYMENT AS
SELECT
    p.category_name,
    pt.payment_name,
    d.year,
    d.month,
    SUM(oi.total_value)     AS total_revenue,
    COUNT(oi.order_item_sk) AS items_sold
FROM DEMO_RETAIL.CORE.FACT_ORDER_ITEM oi
JOIN DEMO_RETAIL.CORE.DIM_PRODUCT p
    ON oi.product_sk = p.product_sk
JOIN DEMO_RETAIL.CORE.FACT_PAYMENT pay
    ON oi.order_id = pay.order_id
JOIN DEMO_RETAIL.CORE.DIM_PAYMENT_TYPE pt
    ON pay.payment_type_sk = pt.payment_type_sk
JOIN DEMO_RETAIL.CORE.DIM_DATE d
    ON oi.order_date_sk = d.date_id
GROUP BY p.category_name, pt.payment_name, d.year, d.month
ORDER BY d.year, d.month, p.category_name, pt.payment_name;

-- Validation Queries

-- Quick sanity checks to confirm tables are working as expected
SELECT *
FROM DEMO_RETAIL.MART.SALES_BY_PRODUCT_CATEGORY
WHERE category_name='toys'
LIMIT 20;

SELECT *
FROM DEMO_RETAIL.MART.TOP_SELLERS
WHERE year = 2017 AND month=3
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.MART.PAYMENT_TYPE_USAGE
WHERE payment_name = 'voucher'
ORDER BY total_payment_value DESC
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.MART.CUSTOMER_LIFETIME_VALUE
LIMIT 5;

SELECT *
FROM DEMO_RETAIL.MART.REVENUE_TREND_BY_CATEGORY_AND_PAYMENT
WHERE category_name = 'toys'
ORDER BY total_revenue DESC
LIMIT 10;