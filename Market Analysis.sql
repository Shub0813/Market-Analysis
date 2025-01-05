use project_orders;

SELECT * from aisles;
select * from departments;
select * from order_products_train;
select * from orders;
select * from products;


  -- 1 What are the top 10 aisles with the highest number of products?
  
  SELECT 
    aisle,
    COUNT(product_id) AS product_count
FROM 
    aisles a
JOIN 
    products p ON a.aisle_id = p.aisle_id
GROUP BY 
    a.aisle
ORDER BY 
    product_count DESC
LIMIT 10;



-- 2 How many unique departments are there in the dataset?

SELECT 
    COUNT(DISTINCT department_id) AS unique_departments
FROM
    departments;
    
    
    -- 3 What is the distribution of products across departments?
    
    SELECT
    d.department,
    COUNT(p.product_id) AS product_count
FROM
    products p
JOIN
    departments d ON p.department_id = d.department_id
GROUP BY
    d.department
ORDER BY
    product_count DESC;
    
    
    
    -- 4. What are the top 10 products with the highest reorder rates?
    
    SELECT
    p.product_name,
    COUNT(CASE WHEN opt.reordered = 1 THEN 1 END) / COUNT(opt.product_id) AS reorder_rate
FROM
    order_products_train opt
JOIN
    products p ON opt.product_id = p.product_id
GROUP BY
    p.product_id, p.product_name
ORDER BY
    reorder_rate DESC
LIMIT 10;



-- 5 How many unique users have placed orders in the dataset?

SELECT
    COUNT(DISTINCT user_id) AS unique_user_count
FROM
    orders;
    
    
    
   --  6. What is the average number of days between orders for each user?
   
   SELECT user_id,
       ROUND(AVG(days_since_prior_order)) AS avg_days_between_orders
FROM orders
WHERE days_since_prior_order IS NOT NULL
GROUP BY user_id;
   
   
  -- 7 What are the peak hours of order placement during the day?
  
  SELECT
    order_hour_of_day,
    COUNT(order_id) AS order_count
FROM
    orders
GROUP BY
    order_hour_of_day
ORDER BY
    order_count DESC;
    
    
    
    
    -- 8 How does order volume vary by day of the week?
    
    SELECT
    order_dow,
    COUNT(order_id) AS order_count
FROM
    orders
GROUP BY
    order_dow
ORDER BY
    order_dow;
    
    
    
    -- 9 What are the top 10 most ordered products?
    
    SELECT
    p.product_name,
    COUNT(opt.product_id) AS order_count
FROM
    order_products_train opt
JOIN
    products p ON opt.product_id = p.product_id
GROUP BY
    p.product_name
ORDER BY
    order_count DESC
LIMIT 10;



-- 10 How many users have placed orders in each department?

SELECT
    d.department_id,
    COUNT(DISTINCT o.user_id) AS num_users
FROM
    orders o
JOIN
    order_products_train opt ON o.order_id = opt.order_id
JOIN
    products p ON opt.product_id = p.product_id
JOIN
    departments d ON p.department_id = d.department_id
GROUP BY
    d.department_id
ORDER BY
    num_users DESC;
    
    
    -- 11 What is the average number of products per order?
    
    SELECT
    AVG(product_count) AS avg_products_per_order
FROM (
    SELECT
        o.order_id,
        COUNT(opt.product_id) AS product_count
    FROM
        orders o
    JOIN
        order_products_train opt ON o.order_id = opt.order_id
    GROUP BY
        o.order_id
) AS product_counts;

-- 12  What are the most reordered products in each department?

SELECT
    d.department_id,
    p.product_name,
    COUNT(opt.product_id) AS reorder_count
FROM
    order_products_train opt
JOIN
    products p ON opt.product_id = p.product_id
JOIN
    departments d ON p.department_id = d.department_id
WHERE
    opt.reordered = 1
GROUP BY
    d.department_id, p.product_name
ORDER BY
    d.department_id, reorder_count DESC;
    
    
    -- 13 How many products have been reordered more than once?
    
    SELECT
    COUNT(DISTINCT opt.product_id) AS products_reordered_more_than_once
FROM
    order_products_train opt
WHERE
    opt.reordered = 1
GROUP BY
    opt.product_id
HAVING
    COUNT(opt.product_id) > 1;
    
    -- 14 What is the average number of products added to the cart per order?
    
    SELECT
    AVG(product_count) AS avg_products_per_order
FROM (
    SELECT
        o.order_id,
        COUNT(opt.product_id) AS product_count
    FROM
        orders o
    JOIN
        order_products_train opt ON o.order_id = opt.order_id
    GROUP BY
        o.order_id
) AS product_counts;

-- 15 How does the number of orders vary by hour of the day?

SELECT
    o.order_hour_of_day,
    COUNT(o.order_id) AS order_count
FROM
    orders o
GROUP BY
    o.order_hour_of_day
ORDER BY
    o.order_hour_of_day;
    
    
    
    -- 16 What is the distribution of order sizes (number of products per order)?
    
    SELECT
    product_count,
    COUNT(*) AS order_count
FROM (
    SELECT
        o.order_id,
        COUNT(opt.product_id) AS product_count
    FROM
        order_products_train opt
    JOIN
        orders o ON o.order_id = opt.order_id
    GROUP BY
        o.order_id
) AS order_sizes
GROUP BY
    product_count
ORDER BY
    product_count;
    
    
    
    -- 17 What is the average reorder rate for products in each aisle?
    
    SELECT
    a.aisle,
    AVG(CASE WHEN opt.reordered = 1 THEN 1 ELSE 0 END) AS avg_reorder_rate
FROM
    order_products_train opt
JOIN
    products p ON opt.product_id = p.product_id
JOIN
    aisles a ON p.aisle_id = a.aisle_id
GROUP BY
    a.aisle
ORDER BY
    avg_reorder_rate DESC;
    
    -- 18 How does the average order size vary by day of the week?
    
    select
    order_dow,
    COUNT(order_id) as total_orders,
    FLOOR(COUNT(order_id) / count(distinct order_id)) as avg_order_size
    from
    orders
    group by
    order_dow
    order by
    order_dow;
    
    -- 19 What are the top 10 users with the highest number of orders?
    
    SELECT
    o.user_id,
    COUNT(o.order_id) AS order_count
FROM
    orders o
GROUP BY
    o.user_id
ORDER BY
    order_count DESC
LIMIT 10;



-- 20 How many products belong to each aisle and department?

SELECT
    a.aisle,
    d.department,
    COUNT(p.product_id) AS product_count
FROM
    products p
JOIN
    aisles a ON p.aisle_id = a.aisle_id
JOIN
    departments d ON p.department_id = d.department_id
GROUP BY
    a.aisle, d.department
ORDER BY
    d.department, a.aisle;