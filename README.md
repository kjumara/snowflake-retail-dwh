# 📌 Snowflake E-commerce Data Warehouse — Multi-Table ETL & Analytics

Load, transform, and analyze real-world e-commerce customer, order, product, and payment data using Snowflake.

# 🛠 Tech Stack

**Languages & Tools:** SQL, Snowflake, Python (optional for preprocessing)
**Platforms & Tools:** Snowsight UI, Git, GitHub

# 🎯 Project Overview

**Problem:**
E-commerce businesses need structured, queryable databases to analyze customer behavior, product performance, and sales trends. Raw CSV files from multiple tables make this difficult without proper integration.

**Solution:**
This project loads real-world e-commerce CSVs into Snowflake, creates relational tables for customers, orders, order items, products, and payments, and demonstrates SQL transformations, joins, and aggregations to generate actionable insights.

> Although the dataset includes training and test splits for ML purposes, this project focuses solely on the test datasets to build a realistic warehouse and showcase data engineering skills.

# 📂 Dataset

- **Source:** [E-commerce Order & Supply Chain Dataset from Kaggle](https://www.kaggle.com/datasets/bytadit/ecommerce-order-dataset)
- CSV Files Used (test datasets only):
  - df_Customers.csv
  - df_Orders.csv
  - df_OrderItems.csv
  - df_Products.csv
  - df_Payments.csv
- Size: ~38k rows per table
- License: [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)

> These separate CSVs allow relational analysis and realistic warehouse modeling.

# 🧰 Data Engineering Approach

- **Tables Created:** customers, orders, order_items, products, payments
- **Key Transformations:**
  - Data type normalization
  - Primary and foreign key creation (customer_id, order_id, product_id)
  - Joins and aggregations for analytics
  - Handling missing values and duplicates
- **Analysis Examples:**
  - Total sales per product and category
  - Customer purchase frequency and trends
  - Monthly order volume and revenue
  - Payment method breakdown

# 💻 How to Run

```bash
# Clone repo
git clone https://github.com/yourusername/snowflake-ecommerce.git
cd snowflake-ecommerce

# Load CSVs into Snowflake using provided SQL scripts
-- Example using Snowsight worksheets:

-- Create tables
CREATE TABLE customers (...);
CREATE TABLE orders (...);
CREATE TABLE order_items (...);
CREATE TABLE products (...);
CREATE TABLE payments (...);

-- Load CSV data
COPY INTO customers FROM '@~/df_Customers_test.csv' FILE_FORMAT=(TYPE=CSV);
COPY INTO orders FROM '@~/df_Orders_test.csv' FILE_FORMAT=(TYPE=CSV);
COPY INTO order_items FROM '@~/df_OrderItems_test.csv' FILE_FORMAT=(TYPE=CSV);
COPY INTO products FROM '@~/df_Products_test.csv' FILE_FORMAT=(TYPE=CSV);
COPY INTO payments FROM '@~/df_Payments_test.csv' FILE_FORMAT=(TYPE=CSV);

# Run provided SQL transformation and analysis queries
```
# 📊 Example Queries / Output

- Total sales by product category
- Top 10 customers by order value
- Monthly order trends
- Payment method distribution
[Add screenshots from Snowsight UI here]

# 📈 Results

- Multi-table e-commerce test dataset successfully loaded into Snowflake
- Demonstrated SQL transformations, joins, and aggregations
- Created analytics-ready views for reporting and insights

# 🔮 Future Improvements

- Build dashboards with BI tools (Power BI, Tableau)
- Automate ETL for continuous data updates
- Incorporate additional datasets (inventory, shipping) for richer analysis

# 📜 License

This project is licensed under the MIT License.

# 🙋‍♀️ Author

Kathryn Jumara
- LinkedIn: https://www.linkedin.com/in/kathrynjumara/
- Portfolio: [Your Portfolio URL]
- Email: kjumara@yahoo.com
