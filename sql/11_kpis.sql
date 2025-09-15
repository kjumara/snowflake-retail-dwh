-- Total Sales by Month
-- Measures overall sales performance over time

SELECT
    d.year,
    d.month,
    SUM(oi.total_value) AS total_sales
FROM DEMO_RETAIL.CORE.FACT_ORDER_ITEM oi
JOIN DEMO_RETAIL.CORE.DIM_DATE d
    ON oi.order_date_sk = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month
-- LIMIT 12 --(use if you want a quick yearly snapshot)
;

-- Month-over-Month (MoM) Sales Growth
-- Measures percentage change in total sales compared to previous month

WITH monthly_sales AS(
    SELECT
        d.year,
        d.month,
        SUM(oi.total_value) AS total_sales
    FROM DEMO_RETAIL.CORE.FACT_ORDER_ITEM oi
    JOIN DEMO_RETAIL.CORE.DIM_DATE d
        ON oi.order_date_sk = d.date_id
    GROUP BY d.year, d.month
)
SELECT
    year,
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY year, month) AS previous_month_sales,
    CASE
        WHEN LAG(total_sales) OVER (ORDER BY year,month) IS NULL THEN NULL
        ELSE ROUND(
            (total_sales-LAG(total_sales) OVER (ORDER BY year, month))
            / LAG(total_sales) OVER (ORDER BY year, month)*100, 2
        )
    END AS mom_sales_growth_pct
FROM monthly_sales
ORDER BY year, month;

-- Average Order Value (AOV)
-- Measures average revenue per order, by month/year

WITH monthly_orders AS(
    SELECT
        o.order_id,
        d.year,
        d.month,
        SUM(oi.total_value) AS order_total
    FROM DEMO_RETAIL.CORE.FACT_ORDER_ITEM oi
    JOIN DEMO_RETAIL.CORE.FACT_ORDER o
        ON oi.order_id = o.order_id
    JOIN DEMO_RETAIL.CORE.DIM_DATE d
        ON oi.order_date_sk = d.date_id
    GROUP BY o.order_id, d.year, d.month
)
SELECT
    year,
    month,
    ROUND(AVG(order_total),2) AS avg_order_value,
    SUM(order_total) AS total_sales,
    COUNT(order_id) AS total_orders
FROM monthly_orders
GROUP BY year, month
ORDER BY year, month;

-- Top Sellers by Revenue
-- Measures which sellers generate the most revenue, by month/year
SELECT
    s.seller_id,
    d.year,
    d.month,
    SUM(oi.total_value) AS total_revenue,
    COUNT(oi.order_item_sk) AS items_sold,
    ROUND(AVG(oi.total_value),2) AS avg_item_value,
    RANK() OVER (PARTITION BY d.year, d.month ORDER BY SUM(oi.total_value) DESC) AS rank_revenue
FROM DEMO_RETAIL.CORE.FACT_ORDER_ITEM oi
JOIN DEMO_RETAIL.CORE.DIM_SELLER s
    ON oi.seller_sk = s.seller_sk
JOIN DEMO_RETAIL.CORE.DIM_DATE d
    ON oi.order_date_sk = d.date_id
GROUP BY s.seller_id, d.year, d.month
ORDER BY d.year, d.month, rank_revenue
;

-- Payment Type Revenue Share
-- Measures % of revenue by payment type, by month/year

WITH monthly_payment_revenue AS (
    SELECT
        pt.payment_name,
        d.year,
        d.month,
        SUM(pay.payment_value) AS payment_revenue
    FROM DEMO_RETAIL.CORE.FACT_PAYMENT pay
    JOIN DEMO_RETAIL.CORE.DIM_PAYMENT_TYPE pt
        ON pay.payment_type_sk = pt.payment_type_sk
    JOIN DEMO_RETAIL.CORE.DIM_DATE d
        ON pay.order_date_sk = d.date_id
    GROUP BY pt.payment_name, d.year, d.month
),
monthly_total_revenue AS (
    SELECT
        year,
        month,
        SUM(payment_revenue) AS total_revenue
    FROM monthly_payment_revenue
    GROUP BY year, month
)
SELECT
    mpr.year,
    mpr.month,
    mpr.payment_name,
    mpr.payment_revenue,
    ROUND((mpr.payment_revenue / mtr.total_revenue)*100,2) AS revenue_share_pct
FROM monthly_payment_revenue mpr
JOIN monthly_total_revenue mtr
    ON mpr.year = mtr.year AND mpr.month = mtr.month
ORDER BY mpr.year, mpr.month, revenue_share_pct DESC;