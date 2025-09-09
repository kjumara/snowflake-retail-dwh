-- Join facts to dimensions to check data consistency

-- Order Item -> Product -> Seller
SELECT
    oi.order_id,
    p.category_name as product_category,
    s.seller_id,
    oi.price,
    oi.freight_value
FROM DEMO_RETAIL.CORE.FACT_ORDER_ITEM oi
INNER JOIN DEMO_RETAIL.CORE.DIM_PRODUCT p
    ON oi.product_sk = p.product_sk
INNER JOIN DEMO_RETAIL.CORE.DIM_SELLER s
    ON oi.seller_sk = s.seller_sk
LIMIT 20;

-- Order -> Customer -> Date
SELECT
    o.order_id,
    c.customer_sk,
    c.customer_id,
    o.order_purchase_ts,
    dd.date_id as order_date_sk,
    dd.date as order_date
FROM DEMO_RETAIL.CORE.FACT_ORDER o
INNER JOIN DEMO_RETAIL.CORE.DIM_CUSTOMER c
    ON o.customer_sk = c.customer_sk
INNER JOIN DEMO_RETAIL.CORE.DIM_DATE dd
    ON o.order_date_sk = dd.date_id
LIMIT 20;

-- Payment -> Order -> Customer -> Payment_Type -> Date
SELECT
    pay.payment_sk,
    pay.order_id,
    o.customer_sk,
    c.customer_id,
    pt.payment_type_sk,
    pt.payment_name,
    dd.date_id          AS order_date_sk,
    dd.date             AS order_date,
    pay.installments    AS payment_installments,
    pay.payment_value
FROM DEMO_RETAIL.CORE.FACT_PAYMENT pay
INNER JOIN DEMO_RETAIL.CORE.FACT_ORDER o
    ON pay.order_id = o.order_id
INNER JOIN DEMO_RETAIL.CORE.DIM_CUSTOMER c
    ON o.customer_sk = c.customer_sk
INNER JOIN DEMO_RETAIL.CORE.DIM_PAYMENT_TYPE pt
    ON pay.payment_type_sk = pt.payment_type_sk
INNER JOIN DEMO_RETAIL.CORE.DIM_DATE dd
    ON pay.order_date_sk = dd.date_id
LIMIT 20;

-- Multi-Dimensional Aggregation (Revenue by Product Category & Payment Type)
SELECT
    p.category_name,
    pt.payment_name,
    SUM(oi.total_value) AS revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM DEMO_RETAIL.CORE.FACT_ORDER_ITEM oi
INNER JOIN DEMO_RETAIL.CORE.DIM_PRODUCT p
    ON oi.product_sk = p.product_sk
INNER JOIN DEMO_RETAIL.CORE.FACT_PAYMENT pay
    ON oi.order_id = pay.order_id
INNER JOIN DEMO_RETAIL.CORE.DIM_PAYMENT_TYPE pt
    ON pay.payment_type_sk = pt.payment_type_sk
INNER JOIN DEMO_RETAIL.CORE.FACT_ORDER o
    ON oi.order_id = o.order_id
GROUP BY p.category_name, pt.payment_name
ORDER BY revenue DESC
LIMIT 20;