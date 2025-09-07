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
## CORE Layer
- Purpose: Transform staged data into **fact** and **dimension** tables (star schema).  
- Example tables:
  - `DIM_CUSTOMERS`, `DIM_PRODUCTS`, `DIM_DATES` (dimensions)  
  - `FACT_ORDERS` (fact table joining orders, items, and payments)  
- Why: Business-ready model that is easy to query and connects across entities.

---
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
