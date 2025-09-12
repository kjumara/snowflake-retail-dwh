-- Example Queries to Demonstrate the Usage of MART views

-- Top 5 Product Categories by revenue (latest month)
SELECT *
FROM DEMO_RETAIL.MART.SALES_BY_PRODUCT_CATEGORY
WHERE YEAR = 2018 AND MONTH = 8
ORDER BY total_value DESC
LIMIT 5;

-- Top 10 Sellers for March 2017
SELECT *
FROM DEMO_RETAIL.MART.TOP_SELLERS
WHERE YEAR = 2017 AND MONTH = 3
ORDER BY rank_revenue
LIMIT 10;

-- Payment type usage trend for vouchers
SELECT *
FROM DEMO_RETAIL.MART.PAYMENT_TYPE_USAGE
WHERE payment_name = 'voucher'
ORDER BY year, month
LIMIT 10;

-- Top 10 Customers by Total Amount Spent
SELECT *
FROM DEMO_RETAIL.MART.CUSTOMER_LIFETIME_VALUE
ORDER BY total_spent DESC
LIMIT 10;

-- Revenue Trend for Toys Paid Via Credit Card
SELECT *
FROM DEMO_RETAIL.MART.REVENUE_TREND_BY_CATEGORY_AND_PAYMENT
WHERE category_name = 'toys' AND payment_name = 'credit_card'
ORDER BY YEAR, MONTH
LIMIT 10;