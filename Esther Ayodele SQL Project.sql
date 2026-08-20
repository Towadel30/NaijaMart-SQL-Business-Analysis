SELECT TOP (5) *
FROM categories;

SELECT TOP (5) *
FROM products;

SELECT TOP (5) *
FROM customers;

SELECT TOP (5) *
FROM orders;

SELECT TOP (5) *
FROM order_items;

-- A1: Products in Phones & Tablets above ₦100,000


SELECT
    p.product_name,
    p.unit_price
FROM products AS p
INNER JOIN categories AS c
    ON p.category_id = c.category_id
WHERE c.category_name = 'Phones & Tablets'
  AND p.unit_price > 100000
ORDER BY p.unit_price DESC;

-- A2: Customers based in Lagos State

SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    city,
    signup_date
FROM customers
WHERE state = 'Lagos'
ORDER BY signup_date;

-- A3: Ten most recently placed orders

SELECT TOP (10)
    order_id,
    order_date,
    status
FROM orders
ORDER BY order_date DESC, order_id DESC;

-- A4: Count discontinued products

SELECT
    COUNT(*) AS discontinued_products
FROM products
WHERE is_active = 0;

-- A5: Distinct order statuses

SELECT DISTINCT
    status
FROM orders
ORDER BY status;

-- B1: Number of orders and total shipping fees by order status

SELECT
    status,
    COUNT(*) AS order_count,
    SUM(shipping_fee) AS total_shipping_fees
FROM orders
GROUP BY status
ORDER BY total_shipping_fees DESC;


-- B2: Number of products and average unit price by category

SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count,
    CAST(ROUND(AVG(p.unit_price), 0) AS INT) AS average_unit_price
FROM categories AS c
INNER JOIN products AS p
    ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY average_unit_price DESC;

-- B3: Monthly order volume for 2024

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS month_number,
    DATENAME(MONTH, order_date) AS month_name,
    COUNT(*) AS order_volume
FROM orders
WHERE order_date >= '2024-01-01'
  AND order_date < '2025-01-01'
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    DATENAME(MONTH, order_date)
ORDER BY
    order_year,
    month_number;

	-- B4: Successful payment breakdown by payment method

SELECT
    payment_method,
    COUNT(*) AS payment_count,
    CAST(SUM(amount) AS DECIMAL(18, 2)) AS total_amount_received
FROM payments
WHERE status = 'Successful'
GROUP BY payment_method
ORDER BY total_amount_received DESC;

-- B5: Categories containing more than five products

SELECT
    c.category_name,
    COUNT(p.product_id) AS number_of_products
FROM categories AS c
INNER JOIN products AS p
    ON c.category_id = p.category_id
GROUP BY
    c.category_id,
    c.category_name
HAVING COUNT(p.product_id) > 5
ORDER BY
    number_of_products DESC;

	-- C1: Top 10 products by total revenue from completed orders

SELECT TOP (10)
    p.product_name,
    CAST(
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount)
        ) AS DECIMAL(18, 2)
    ) AS total_revenue
FROM products AS p
INNER JOIN order_items AS oi
    ON p.product_id = oi.product_id
INNER JOIN orders AS o
    ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    total_revenue DESC;

	-- C2: Completed orders and total spending by customer

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    CAST(
        COALESCE(
            SUM(
                oi.quantity
                * oi.unit_price
                * (1 - oi.discount)
            ),
            0
        ) AS DECIMAL(18, 2)
    ) AS total_amount_spent
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
   AND o.status = 'Completed'
LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY
    total_amount_spent DESC;

	-- C3: Sales representatives and their managers

SELECT
    CONCAT(rep.first_name, ' ', rep.last_name) AS sales_representative_name,
    rep.job_title,
    CONCAT(manager.first_name, ' ', manager.last_name) AS manager_name
FROM employees AS rep
LEFT JOIN employees AS manager
    ON rep.manager_id = manager.employee_id
WHERE rep.job_title LIKE '%Sales%'
ORDER BY
    sales_representative_name;

	-- C4: Total completed-order revenue for each customer state

SELECT
    c.state,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_revenue
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.state
ORDER BY total_revenue DESC;

-- C5: Products that have never appeared in any order

SELECT
    p.product_id,
    p.product_name
FROM products AS p
LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL
ORDER BY p.product_id;

-- D1: Customers whose completed spend is above the average customer spend

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_spend
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) >
(
    SELECT AVG(customer_total)
    FROM
    (
        SELECT
            o2.customer_id,
            SUM(oi2.quantity * oi2.unit_price * (1 - oi2.discount)) AS customer_total
        FROM orders AS o2
        INNER JOIN order_items AS oi2
            ON o2.order_id = oi2.order_id
        WHERE o2.status = 'Completed'
        GROUP BY o2.customer_id
    ) AS customer_spend
)
ORDER BY total_spend DESC;

-- D2: Highest-value completed order

SELECT TOP (1)
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_order_value
FROM orders AS o
INNER JOIN customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY
    o.order_id,
    c.first_name,
    c.last_name
ORDER BY total_order_value DESC;

-- D3: Categories with gross profit above the average category profit

WITH category_profit AS
(
    SELECT
        c.category_id,
        c.category_name,
        SUM(
            oi.quantity *
            (
                oi.unit_price * (1 - oi.discount)
                - p.cost_price
            )
        ) AS gross_profit
    FROM categories AS c
    INNER JOIN products AS p
        ON c.category_id = p.category_id
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    INNER JOIN orders AS o
        ON oi.order_id = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY
        c.category_id,
        c.category_name
)
SELECT
    category_name,
    gross_profit
FROM category_profit
WHERE gross_profit >
(
    SELECT AVG(gross_profit)
    FROM category_profit
)
ORDER BY gross_profit DESC;

-- D4: Products priced above the average unit price of their own category

SELECT
    p.product_name,
    p.unit_price,
    c.category_name
FROM products AS p
INNER JOIN categories AS c
    ON p.category_id = c.category_id
WHERE p.unit_price > (
    SELECT AVG(p2.unit_price)
    FROM products AS p2
    WHERE p2.category_id = p.category_id
)
ORDER BY
    c.category_name,
    p.unit_price DESC;


	-- E1: Rank sales representatives by total completed sales

;WITH rep_sales AS (
    SELECT
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name) AS rep_name,
        COALESCE(
            SUM(
                oi.quantity
                * oi.unit_price
                * (1 - oi.discount)
            ),
            0
        ) AS total_sales
    FROM employees AS e
    LEFT JOIN orders AS o
        ON e.employee_id = o.employee_id
       AND o.status = 'Completed'
    LEFT JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE e.job_title LIKE '%Sales%'
    GROUP BY
        e.employee_id,
        e.first_name,
        e.last_name
)
SELECT
    rep_name,
    CAST(total_sales AS DECIMAL(18, 2)) AS total_sales,
    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM rep_sales
ORDER BY
    sales_rank,
    rep_name;

	-- E2: Cumulative monthly revenue across 2023 and 2024

;WITH monthly_revenue AS (
    SELECT
        DATEFROMPARTS(
            YEAR(o.order_date),
            MONTH(o.order_date),
            1
        ) AS order_month,
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount)
        ) AS monthly_revenue
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
      AND o.order_date >= '2023-01-01'
      AND o.order_date < '2025-01-01'
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
)
SELECT
    order_month,
    CAST(monthly_revenue AS DECIMAL(18, 2)) AS monthly_revenue,
    CAST(
        SUM(monthly_revenue) OVER (
            ORDER BY order_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS DECIMAL(18, 2)
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY
    order_month;

	-- E3: Top-selling product by revenue in each category

;WITH product_revenue AS (
    SELECT
        c.category_id,
        c.category_name,
        p.product_id,
        p.product_name,
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount)
        ) AS total_revenue
    FROM categories AS c
    INNER JOIN products AS p
        ON c.category_id = p.category_id
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    INNER JOIN orders AS o
        ON oi.order_id = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY
        c.category_id,
        c.category_name,
        p.product_id,
        p.product_name
),
ranked_products AS (
    SELECT
        category_name,
        product_name,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY category_name
            ORDER BY total_revenue DESC, product_name
        ) AS product_rank
    FROM product_revenue
)
SELECT
    category_name,
    product_name,
    CAST(total_revenue AS DECIMAL(18, 2)) AS total_revenue
FROM ranked_products
WHERE product_rank = 1
ORDER BY
    category_name;

	-- E4: Month-over-month completed revenue growth

;WITH monthly_revenue AS (
    SELECT
        DATEFROMPARTS(
            YEAR(o.order_date),
            MONTH(o.order_date),
            1
        ) AS order_month,
        SUM(
            oi.quantity
            * oi.unit_price
            * (1 - oi.discount)
        ) AS monthly_revenue
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
      AND o.order_date >= '2023-01-01'
      AND o.order_date < '2025-01-01'
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date)
),
revenue_comparison AS (
    SELECT
        order_month,
        monthly_revenue,
        LAG(monthly_revenue, 1) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    order_month,
    CAST(monthly_revenue AS DECIMAL(18, 2)) AS monthly_revenue,
    CAST(previous_month_revenue AS DECIMAL(18, 2))
        AS previous_month_revenue,
    CAST(
        CASE
            WHEN previous_month_revenue IS NULL
              OR previous_month_revenue = 0
            THEN NULL
            ELSE
                (
                    (monthly_revenue - previous_month_revenue)
                    / previous_month_revenue
                ) * 100
        END AS DECIMAL(18, 2)
    ) AS mom_growth_percentage
FROM revenue_comparison
ORDER BY
    order_month;

	-- E5: Customer spending compared with the average spend in their segment

;WITH customer_spend AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.segment,
        COALESCE(
            SUM(
                oi.quantity
                * oi.unit_price
                * (1 - oi.discount)
            ),
            0
        ) AS total_spend
    FROM customers AS c
    LEFT JOIN orders AS o
        ON c.customer_id = o.customer_id
       AND o.status = 'Completed'
    LEFT JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.segment
)
SELECT
    customer_name,
    segment,
    CAST(total_spend AS DECIMAL(18, 2)) AS total_spend,
    CAST(
        AVG(total_spend) OVER (
            PARTITION BY segment
        ) AS DECIMAL(18, 2)
    ) AS segment_average_spend,
    CAST(
        total_spend
        - AVG(total_spend) OVER (
            PARTITION BY segment
        ) AS DECIMAL(18, 2)
    ) AS difference_from_segment_average
FROM customer_spend
ORDER BY
    segment,
    total_spend DESC;