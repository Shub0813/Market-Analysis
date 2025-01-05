use project_orders;

SELECT * from aisles;
select * from departments;
select * from order_products_train;
select * from orders;
select * from products;

-- analyze customer purchasing behavior and product performance to optimize marketing strategies and improve customer satisfaction.

-- Customer Purchasing Behavior:

-- Average Order Frequency by Day of the Week
SELECT 
    order_dow, 
    COUNT(order_id) AS num_orders, 
    AVG(order_number) AS avg_order_number
FROM 
    orders
GROUP BY 
    order_dow
ORDER BY 
    order_dow;
    
-- Average Order Size
SELECT 
    order_id,
    COUNT(product_id) AS order_size
FROM 
    order_products_train
GROUP BY 
    order_id;
    
-- Reordered Products
    SELECT 
    p.product_name, 
    COUNT(*) AS reorder_count
FROM 
    order_products_train op
JOIN 
    products p ON op.product_id = p.product_id
WHERE 
    op.reordered = 1
GROUP BY 
    p.product_name
ORDER BY 
    reorder_count DESC;
    
    -- Product Performance Analysis
    
    -- Top-Selling Products
    SELECT 
    p.product_name, 
    COUNT(op.product_id) AS total_sales
FROM 
    order_products_train op
JOIN 
    products p ON op.product_id = p.product_id
GROUP BY 
    p.product_name
ORDER BY 
    total_sales DESC
LIMIT 10;

-- Department Performance
SELECT 
    d.department, 
    COUNT(op.product_id) AS total_sales
FROM 
    order_products_train op
JOIN 
    products p ON op.product_id = p.product_id
JOIN 
    departments d ON p.department_id = d.department_id
GROUP BY 
    d.department
ORDER BY 
    total_sales DESC;

-- Aisle Performance
SELECT 
    a.aisle, 
    COUNT(op.product_id) AS total_sales
FROM 
    order_products_train op
JOIN 
    products p ON op.product_id = p.product_id
JOIN 
    aisles a ON p.aisle_id = a.aisle_id
GROUP BY 
    a.aisle
ORDER BY 
    total_sales DESC;

-- Customer Behavior Segmentation

-- Frequency of Purchases
    SELECT 
    user_id,
    COUNT(order_id) AS total_orders
FROM 
    orders
GROUP BY 
    user_id
HAVING 
    total_orders > 5;

-- Average Spend per Customer
   SELECT 
    user_id, 
    SUM(op.order_amount) AS total_spent
FROM 
    orders o
JOIN 
    order_products_train op ON o.order_id = op.order_id
GROUP BY 
    user_id
ORDER BY 
    total_spent DESC;

-- Order Time Analysis 

-- Average Order Size by Hour of Day
   SELECT 
    order_hour_of_day, 
    AVG(order_size) AS avg_order_size
FROM (
    SELECT 
        o.order_id, 
        COUNT(op.product_id) AS order_size, 
        o.order_hour_of_day
    FROM 
        order_products_train op
    JOIN 
        orders o ON op.order_id = o.order_id
    GROUP BY 
        o.order_id, o.order_hour_of_day
) AS order_data
GROUP BY 
    order_hour_of_day
ORDER BY 
    order_hour_of_day;
 
 


    