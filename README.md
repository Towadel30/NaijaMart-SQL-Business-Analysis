# NaijaMart-SQL-Business-Analysis
SQL business analysis of NaijaMart's products, customers, orders, payments, sales performance, and revenue trends.
# NaijaMart SQL Business Analysis

## Project Overview

NaijaMart SQL Business Analysis is an end-to-end SQL business analytics project focused on analyzing an e-commerce dataset to uncover insights into products, customers, orders, payments, sales representatives, regional performance, profitability, and revenue trends.

The analysis was performed using **Microsoft SQL Server (SSMS)** and covers completed-order activity from **2023 to 2024** for realized revenue analysis.

The project demonstrates how SQL can be used to transform transactional data into meaningful business insights that support decision-making.

---

## Business Objectives

The analysis was designed to:

* Identify high-performing products and product categories
* Analyze customer purchasing behavior and spending
* Evaluate sales representative performance
* Compare revenue across customer states
* Analyze successful payment methods
* Identify discontinued and unsold products
* Analyze monthly order and revenue trends
* Calculate cumulative revenue
* Measure month-over-month revenue growth
* Compare customer spending against segment averages
* Identify profitable product categories
* Support business recommendations using data-driven findings

---

## Dataset

The NaijaMart database contains interconnected tables representing different areas of the e-commerce business.

### Main Tables

* `customers`
* `categories`
* `products`
* `orders`
* `order_items`
* `payments`
* `employees`

These tables were connected using primary and foreign key relationships to perform relational analysis.

---

## Tools & Technologies

* **Microsoft SQL Server**
* **SQL Server Management Studio (SSMS)**
* **T-SQL**
* GitHub

---

## SQL Skills Demonstrated

### Basic SQL

* `SELECT`
* `WHERE`
* `DISTINCT`
* `ORDER BY`
* `TOP`
* `CONCAT`

### Joins

* `INNER JOIN`
* `LEFT JOIN`
* Self-joins

### Aggregations

* `COUNT()`
* `SUM()`
* `AVG()`
* `GROUP BY`
* `HAVING`

### Advanced SQL

* Subqueries
* Correlated subqueries
* Common Table Expressions (CTEs)
* Conditional logic
* `COALESCE()`
* `CAST()`
* `ROUND()`

### Window Functions

* `RANK()`
* `ROW_NUMBER()`
* `LAG()`
* `SUM() OVER()`
* `AVG() OVER()`
* `PARTITION BY`

### Date Analysis

* `YEAR()`
* `MONTH()`
* `DATENAME()`
* `DATEFROMPARTS()`

---

# Analysis Structure

The SQL analysis is divided into five sections.

## A — Basic Queries

This section focuses on retrieving and filtering business data.

### Questions answered:

* Which Phones & Tablets products are priced above ₦100,000?
* Which customers are based in Lagos?
* What are the 10 most recently placed orders?
* How many products have been discontinued?
* What order statuses exist in the database?

### SQL concepts demonstrated:

`SELECT`, `INNER JOIN`, `WHERE`, `DISTINCT`, `TOP`, `ORDER BY`, `COUNT()`

---

## B — Aggregations & Group Analysis

This section analyzes business activity at an aggregated level.

### Questions answered:

* How many orders exist under each order status?
* What are the total shipping fees by status?
* How many products are in each category?
* What is the average product price by category?
* What is the monthly order volume for 2024?
* Which payment methods generated the highest successful payment values?
* Which categories contain more than five products?

### SQL concepts demonstrated:

`COUNT()`, `SUM()`, `AVG()`, `GROUP BY`, `HAVING`, date functions, joins

---

## C — Joins & Revenue Analysis

This section combines multiple tables to analyze revenue, customers, sales representatives, and product activity.

### Questions answered:

* What are the top 10 products by completed-order revenue?
* How much has each customer spent on completed orders?
* Which sales representatives report to which managers?
* Which customer states generate the highest completed-order revenue?
* Which products have never appeared in an order?

### Revenue Calculation

Completed-order revenue was calculated as:

```text
Quantity × Unit Price × (1 − Discount)
```

Cancelled, pending, and returned orders were excluded from realized sales calculations.

### SQL concepts demonstrated:

`INNER JOIN`, `LEFT JOIN`, multiple-table joins, aggregation, revenue calculations

---

## D — Subqueries & CTEs

This section applies more advanced SQL techniques to answer comparative business questions.

### Questions answered:

* Which customers spend more than the average customer?
* What is the highest-value completed order?
* Which categories have gross profit above the average category profit?
* Which products are priced above the average price of their own category?

### SQL concepts demonstrated:

* Subqueries
* Correlated subqueries
* Common Table Expressions (CTEs)
* `HAVING`
* Category-level benchmarking
* Profit calculations

### Gross Profit Calculation

```text
Gross Profit =
Quantity × ((Unit Price × (1 − Discount)) − Cost Price)
```

---

## E — Window Functions & Advanced Analysis

This section demonstrates advanced SQL analytical techniques.

### Questions answered:

* How do sales representatives rank by completed sales?
* What is the cumulative monthly revenue across 2023–2024?
* What is the top-selling product by revenue in each category?
* What is the month-over-month completed revenue growth?
* How does each customer's spending compare with the average spending in their segment?

### Window functions demonstrated:

* `RANK()`
* `ROW_NUMBER()`
* `LAG()`
* `SUM() OVER()`
* `AVG() OVER()`
* `PARTITION BY`

---

# Key Business Findings

## 1. Product Performance

**iPhone 13 (128GB)** was the highest-revenue product, generating:

**₦61,468,500**

in completed-order revenue.

This suggests that high-performing products should receive close attention in inventory planning to reduce the risk of stockouts.

---

## 2. Customer Value

**Chukwuemeka Ojo** was the highest-value customer, spending:

**₦9,430,560**

across **9 completed orders**.

Customers whose spending exceeds the overall or segment average represent potential targets for loyalty programs, personalized promotions, and early access to new products.

---

## 3. Regional Performance

**FCT Abuja** generated the highest completed-order revenue at:

**₦29,176,675**

while **Delta** recorded the lowest among the states highlighted in the analysis at:

**₦5,125,700**.

The concentration of revenue in stronger-performing regions may represent an opportunity for expansion, but it may also create regional dependency risk.

---

## 4. Sales Representative Performance

**Adaeze Iheanacho** ranked first in completed sales with:

**₦28,913,070**

The difference between the highest- and lowest-ranked representatives was:

**₦10,570,855**

This performance gap may be influenced by territory allocation, customer portfolios, experience, or sales activity.

---

## 5. Revenue Trends

Completed-order revenue experienced substantial fluctuations across the 2023–2024 period.

The largest increase occurred in **April 2023**, when revenue increased by:

**523.33%**

from ₦3,308,420 in March 2023 to ₦20,622,530 in April 2023.

The largest decline occurred in **August 2024**, when revenue decreased by:

**78.54%**

from ₦13,907,460 in July 2024 to ₦2,984,225 in August 2024.

These fluctuations may be associated with seasonal demand, promotions, stock availability, or changes in completed-order activity.

---

## 6. Payment Performance

**Card payments** generated the highest successful payment value:

**₦62,535,855**

This provides an indication of the payment method contributing the greatest value among successful transactions.

---

## 7. Unsold Products

The analysis identified **8 products** that had never appeared in the `order_items` table.

These products may require:

* Repricing
* Additional promotion
* Product bundling
* Improved product descriptions
* Better positioning
* Inventory review
* Possible discontinuation

---

# Business Recommendations

### 1. Improve Inventory Planning

Maintain sufficient stock for high-revenue products and categories identified through the revenue analysis.

### 2. Target High-Value Customers

Develop loyalty campaigns and personalized offers for customers whose spending exceeds the overall or segment average.

### 3. Strengthen Regional Strategies

Investigate the reasons behind differences in state-level revenue and identify successful strategies that can be replicated in weaker-performing regions.

### 4. Evaluate Sales Representative Performance

Investigate differences in representative performance by considering territory allocation, customer portfolios, experience, and sales activity.

### 5. Monitor Revenue Volatility

Investigate major month-over-month changes to determine whether they are caused by seasonality, promotions, stock availability, or changes in order completion.

### 6. Review Payment Performance

Continue supporting reliable and widely used payment methods while investigating unsuccessful or pending payment patterns.

### 7. Review Unsold Products

Evaluate products with no recorded orders and consider repricing, promotion, bundling, improved product descriptions, or discontinuation.

---

# Project Structure

```text
NaijaMart-SQL-Business-Analysis/
│
├── README.md
│
├── sql/
│   ├── 01_basic_queries.sql
│   ├── 02_aggregations.sql
│   ├── 03_joins_and_revenue.sql
│   ├── 04_subqueries_and_ctes.sql
│   └── 05_window_functions.sql
│
├── insights/
│   └── business_insights.md
│
└── screenshots/
```

---

# Conclusion

The analysis demonstrates how SQL can be used to investigate real-world e-commerce business questions and convert transactional data into actionable insights.

The findings highlight opportunities around **product performance, customer retention, regional growth, sales representative effectiveness, payment methods, inventory planning, and revenue monitoring**.

All revenue conclusions are based on **completed orders only**. Cancelled, pending, and returned orders were excluded from realized revenue calculations.

Overall, the project demonstrates practical application of SQL for **business analysis, performance evaluation, customer analysis, revenue analysis, and data-driven decision-making**.

---

## Author

**Esther Ayodele**

**Data Analyst | SQL | Power BI | Excel | Python**

GitHub: **Towadel30**

LinkedIn: **Esther Ayodele**
