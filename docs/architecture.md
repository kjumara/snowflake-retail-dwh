# 🏗️ Data Architecture

This project follows a **layered data warehouse design** in Snowflake to ensure clean, reliable, and business-ready data.  

---
## RAW Layer
- Purpose: Store data exactly as loaded from source (CSV files).  
- Why: Acts as an immutable backup for traceability and reproducibility.  
- Example: `RAW.ORDERS` is a direct load of `df_Orders.csv` with no changes.

---
## STAGE Layer
- Purpose: Apply light cleaning and conformance.  
- Tasks include:
  - Casting strings to correct data types (e.g., `DATE`, `NUMBER`).  
  - Deduplicating rows.  
  - Standardizing column names.  
- Why: Creates a clean, consistent foundation for transformations.  

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
