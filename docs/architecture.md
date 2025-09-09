# 🏗️ Data Architecture

This project follows a **layered data warehouse design** in Snowflake to ensure clean, reliable, and business-ready data.  

---
## RAW Layer
The RAW layer stores data exactly as recieved from the Kaggle e-commerce dataset. 

Each table corresponds 1:1 to a source CSV file, with no transformations applied.

- **CUSTOMERS**   → from `df_Customers.csv`,  customer profile and location details.  
- **ORDERS**      → from `df_Orders.csv`,     high-level order information (ID, customer, timestamps).  
- **ORDER_ITEMS** → from `df_OrderItems.csv`, line-level order details including product, seller, and charges.  
- **PRODUCTS**    → from `df_Products.csv`,   product catalog with dimensions and category.  
- **PAYMENTS**    → from `df_Payments.csv`,   order payment details including type, installments, and value.  

> This layer provides an immutable copy of the source data for traceability and reproducibility.
---
## STAGE Layer - Views
The STAGE layer cleans and standardizes data from the RAW layer while keeping a 1:1 mapping to source entities.  

This layer ensures consistency, prepares numeric/text fields for downstream modeling, and introduces basic derived attributes.


- **CUSTOMERS** → Trimmed IDs and city names, standardized casing, preserved `zip_code_prefix` as STRING.  
- **ORDERS** → Cleaned IDs, converted timestamps, and added `order_date` for easier filtering.  
- **ORDER_ITEMS** → Standardized IDs, cast numeric values, renamed `shipping_charges` → `freight_value`, and added `total_value` (price + freight).  
- **PRODUCTS** → Standardized category names, cast dimensions to numeric, and introduced `volume_cm3` (length * width * height).  
- **PAYMENTS** → Cleaned IDs, normalized `payment_type` to lowercase, and cast numeric fields.  

> This layer acts as a **clean but lightly transformed** foundation for business-ready transformations in the CORE layer.

---
## CORE Layer — Dim & Fact Tables
This layer transformed staged data into **deduplicated dimensions and fact tables** using a **star schema** for business-ready analytics.

### Dim Tables
- **DIM_CUSTOMER** → Deduplicated customer records, surrogate key added for joining facts.
- **DIM_PRODUCT** → Cleaned product attributes, numeric dimensions, calculated `volume_cm3`, surrogate key added. 
- **DIM_SELLER** → Deduplicated seller records (one row per seller), surrogate key added. 
- **DIM_DATE** → Standard date dimension for filtering and aggregations. 
- **DIM_PAYMENT_TYPE** → Normalized payment types, surrogate key added.

### Fact Tables
- **FACT_ORDER** → One row per order, links to customer and order date for traceability.
- **FACT_ORDER_ITEM** → One row per item in an order, links to products and sellers, includes price, freight, and total value.
- **FACT_PAYMENT** → One row per payment, links to orders and payment type, includes installments and payment value.

> This layer provides a business-ready model that is easy to query, supports analytics, and preserves links to original staged data.

## MART Layer
- Purpose: Create **aggregated views/tables** optimized for analysis and dashboards.  
- Example tables:
  - `SALES_BY_REGION`  
  - `TOP_PRODUCTS`  
- Why: Exposes curated data to analysts without requiring complex joins.

---
## Benefits of This Approach
- **Traceability:** Can always trace metrics back to raw source data.  
- **Separation of Concerns:** Each layer has a clear responsibility (landing, cleaning, modeling, reporting).  
- **Scalability:** Easy to extend by adding new sources or marts.  
- **Professional Standard:** Mirrors common warehouse design patterns (Kimball-style).  

---
