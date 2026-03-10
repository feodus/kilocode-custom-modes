---
name: sql-development
description: Writing complex SQL queries: JOINs, Subqueries, UNION, CTEs, Window Functions (ROW_NUMBER, RANK, LAG, LEAD), Stored Procedures, query optimization with EXPLAIN ANALYZE
---

# SQL Development

> **Meta:** v1.0.0 | 23-02-2026

## Purpose

Skill for writing complex SQL queries, covering advanced techniques for working with relational databases. Includes creating complex queries using JOINs and subqueries, Common Table Expressions (CTE), window functions, stored procedures and functions, as well as query optimization for maximum performance.

This skill is a logical continuation of the `data-modeling` skill and provides ready-to-use SQL queries for implementation in universal-coding-agent.

## When to Use

Use this skill:

- When writing complex queries with multiple JOINs
- For working with hierarchical data through recursive CTEs
- When using analytical functions (ranking, trends, moving averages)
- For creating stored procedures and functions with business logic
- When optimizing slow queries
- For generating reports with aggregations
- During the development phase after data model design

## Functions

### Complex Queries

Complex queries using various data joining techniques:

**JOIN Types:**

| JOIN Type | Description | Example Usage |
|----------|-------------|---------------|
| **INNER JOIN** | Intersection of two tables | Get orders with customer info |
| **LEFT JOIN** | All records from left table | All customers, including those without orders |
| **RIGHT JOIN** | All records from right table | All orders, including those without customers |
| **FULL OUTER JOIN** | Union of both tables | All customers and all orders |
| **CROSS JOIN** | Cartesian product | All combinations of products and categories |
| **SELF JOIN** | Join table to itself | Hierarchical data (employee-manager) |

**Subqueries:**

| Type | Description | Example |
|-----|-------------|---------|
| **Non-correlated** | Independent subquery | `SELECT * FROM users WHERE id IN (SELECT user_id FROM orders)` |
| **Correlated** | Depends on outer query | `SELECT * FROM orders o WHERE total > (SELECT AVG(total) FROM orders WHERE customer_id = o.customer_id)` |
| **Scalar** | Returns single value | `SELECT name, (SELECT COUNT(*) FROM orders WHERE user_id = users.id) as order_count` |
| **Table** | Returns table | `WITH regional_sales AS (...) SELECT * FROM regional_sales` |

**Set Operations:**

| Operator | Description |
|----------|-------------|
| **UNION** | Union without duplicates |
| **UNION ALL** | Union with duplicates |
| **INTERSEC** | Intersection |
| **EXCEPT** | Difference |

### CTEs (Common Table Expressions)

Common table expressions for improving query readability and structure:

**Simple CTEs:**

```sql
-- Selection with CTE for statistics calculation
WITH customer_orders AS (
    SELECT 
        customer_id,
        COUNT(*) as order_count,
        SUM(total_amount) as total_spent,
        AVG(total_amount) as avg_order_value
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
)
SELECT 
    c.name,
    co.order_count,
    co.total_spent,
    co.avg_order_value
FROM customers c
JOIN customer_orders co ON c.id = co.customer_id
WHERE co.total_spent > 1000;
```

**Multiple CTEs:**

```sql
-- Multiple CTEs in one query
WITH 
    active_customers AS (
        SELECT id, name, email
        FROM customers
        WHERE status = 'active'
    ),
    recent_orders AS (
        SELECT customer_id, MAX(order_date) as last_order_date
        FROM orders
        WHERE order_date > '2025-01-01'
        GROUP BY customer_id
    ),
    high_value_orders AS (
        SELECT customer_id, COUNT(*) as high_value_count
        FROM orders
        WHERE total_amount > 1000
        GROUP BY customer_id
    )
SELECT 
    ac.name,
    ac.email,
    ro.last_order_date,
    hvo.high_value_count
FROM active_customers ac
LEFT JOIN recent_orders ro ON ac.id = ro.customer_id
LEFT JOIN high_value_orders hvo ON ac.id = hvo.customer_id;
```

**Recursive CTEs:**

```sql
-- Employee hierarchy (organizational structure)
WITH RECURSIVE org_chart AS (
    -- Base case: top managers
    SELECT 
        id,
        name,
        manager_id,
        1 as level,
        name as path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: subordinates
    SELECT 
        e.id,
        e.name,
        e.manager_id,
        oc.level + 1,
        oc.path || ' > ' || e.name
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT * FROM org_chart ORDER BY level, name;

-- Product category hierarchy
WITH RECURSIVE category_tree AS (
    SELECT 
        id,
        name,
        parent_id,
        0 as depth,
        ARRAY[name] as path
    FROM categories
    WHERE parent_id IS NULL
    
    UNION ALL
    
    SELECT 
        c.id,
        c.name,
        c.parent_id,
        ct.depth + 1,
        ct.path || c.name
    FROM categories c
    JOIN category_tree ct ON c.parent_id = ct.id
)
SELECT * FROM category_tree ORDER BY path;
```

**CTE vs Subquery:**

| Criteria | CTE | Subquery |
|----------|-----|----------|
| Readability | High | Low |
| Reuse | Yes (within query) | No |
| Debugging | Simpler | More complex |
| Performance | Optimizer sees entire | Similar |

### Window Functions

Window functions for analyzing data without grouping rows:

**Ranking Functions:**

```sql
-- ROW_NUMBER: unique numbering
SELECT 
    product_name,
    category,
    sales_amount,
    ROW_NUMBER() OVER (ORDER BY sales_amount DESC) as rank
FROM product_sales;

-- RANK: numbering with gaps for equal values
SELECT 
    employee_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank
FROM employees;

-- DENSE_RANK: numbering without gaps
SELECT 
    employee_name,
    department,
    salary,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_dense_rank
FROM employees;

-- NTILE: distribution into groups
SELECT 
    customer_name,
    total_purchases,
    NTILE(4) OVER (ORDER BY total_purchases DESC) as quartile
FROM customer_stats;
```

**Analytic Functions:**

```sql
-- LAG: previous value
SELECT 
    month,
    revenue,
    LAG(revenue, 1) OVER (ORDER BY month) as prev_month_revenue,
    revenue - LAG(revenue, 1) OVER (ORDER BY month) as revenue_growth
FROM monthly_revenue;

-- LEAD: next value
SELECT 
    employee_name,
    hire_date,
    LEAD(hire_date, 1) OVER (ORDER BY hire_date) as next_hire_date
FROM employees;

-- FIRST_VALUE / LAST_VALUE
SELECT 
    department,
    employee_name,
    salary,
    FIRST_VALUE(employee_name) OVER (PARTITION BY department ORDER BY salary DESC) as highest_paid,
    LAST_VALUE(employee_name) OVER (PARTITION BY department ORDER BY salary DESC) as lowest_paid
FROM employees;

-- NTH_VALUE
SELECT 
    product_name,
    sales_amount,
    NTH_VALUE(sales_amount, 3) OVER (ORDER BY sales_amount DESC) as third_highest
FROM product_sales;
```

**Aggregate Window Functions:**

```sql
-- SUM OVER: cumulative sum
SELECT 
    order_date,
    daily_sales,
    SUM(daily_sales) OVER (ORDER BY order_date) as cumulative_sales,
    SUM(daily_sales) OVER (PARTITION BY EXTRACT(MONTH FROM order_date)) as monthly_total
FROM daily_sales;

-- AVG OVER: moving average
SELECT 
    date,
    stock_price,
    AVG(stock_price) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as moving_avg_7
FROM stock_prices;

-- COUNT OVER
SELECT 
    customer_name,
    order_date,
    COUNT(*) OVER (PARTITION BY customer_name) as total_orders
FROM orders;

-- Frame clauses (ROWS vs RANGE)
SELECT 
    date,
    value,
    SUM(value) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumulative,
    SUM(value) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) as moving_sum_5
FROM metrics;
```

### Stored Procedures

Stored procedures, functions, and triggers for encapsulating business logic at the database level:

**Stored Procedures:**

```sql
-- Simple stored procedure (PostgreSQL)
CREATE OR REPLACE PROCEDURE create_order(
    p_customer_id INT,
    p_total DECIMAL(10,2),
    OUT p_order_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO orders (customer_id, total_amount, status, order_date)
    VALUES (p_customer_id, p_total, 'pending', CURRENT_TIMESTAMP)
    RETURNING id INTO p_order_id;
END;
$$;

-- Procedure call
CALL create_order(123, 99.99, NULL);

-- Procedure with transaction
CREATE OR REPLACE PROCEDURE process_order(
    p_order_id INT,
    p_action VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(20);
BEGIN
    -- Get current status
    SELECT status INTO v_status FROM orders WHERE id = p_order_id;
    
    IF v_status IS NULL THEN
        RAISE EXCEPTION 'Order not found: %', p_order_id;
    END IF;
    
    CASE p_action
        WHEN 'confirm' THEN
            IF v_status != 'pending' THEN
                RAISE EXCEPTION 'Cannot confirm order with status: %', v_status;
            END IF;
            UPDATE orders SET status = 'confirmed', updated_at = NOW() WHERE id = p_order_id;
            
        WHEN 'cancel' THEN
            IF v_status IN ('shipped', 'delivered') THEN
                RAISE EXCEPTION 'Cannot cancel shipped/delivered order';
            END IF;
            UPDATE orders SET status = 'cancelled', updated_at = NOW() WHERE id = p_order_id;
            
        ELSE
            RAISE EXCEPTION 'Unknown action: %', p_action;
    END CASE;
    
    COMMIT;
END;
$$;
```

**User-Defined Functions:**

```sql
-- Function for discount calculation (PostgreSQL)
CREATE OR REPLACE FUNCTION calculate_discount(
    p_amount DECIMAL(10,2),
    p_customer_type VARCHAR(20)
)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_discount_rate DECIMAL(5,2);
    v_discount DECIMAL(10,2);
BEGIN
    -- Determine discount percentage
    CASE p_customer_type
        WHEN 'gold' THEN v_discount_rate := 0.20;
        WHEN 'silver' THEN v_discount_rate := 0.10;
        WHEN 'bronze' THEN v_discount_rate := 0.05;
        ELSE v_discount_rate := 0.00;
    END CASE;
    
    -- Calculate discount
    v_discount := p_amount * v_discount_rate;
    
    RETURN v_discount;
END;
$$;

-- Function usage
SELECT 
    order_id,
    total_amount,
    customer_type,
    calculate_discount(total_amount, customer_type) as discount,
    total_amount - calculate_discount(total_amount, customer_type) as final_amount
FROM orders;

-- Scalar function with table (MySQL)
DELIMITER //
CREATE FUNCTION get_customer_total(p_customer_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(10,2);
    
    SELECT COALESCE(SUM(total_amount), 0)
    INTO v_total
    FROM orders
    WHERE customer_id = p_customer_id;
    
    RETURN v_total;
END //
DELIMITER ;
```

**Triggers:**

```sql
-- Trigger for automatic update (PostgreSQL)
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE TRIGGER tr_orders_updated
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Trigger for audit changes
CREATE TABLE order_audit (
    id SERIAL PRIMARY KEY,
    order_id INT,
    action VARCHAR(10),
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION audit_order_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO order_audit (order_id, action, old_status, new_status, changed_by)
        VALUES (NEW.id, 'UPDATE', OLD.status, NEW.status, CURRENT_USER);
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER tr_order_audit
    AFTER UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION audit_order_changes();
```

**PL/pgSQL Basics:**

| Construct | Description |
|-----------|-------------|
| `DECLARE` | Variable declaration |
| `BEGIN/END` | Code block |
| `IF/THEN/ELSE` | Conditional execution |
| `CASE` | Multiple condition |
| `FOR` | Loop over query results |
| `WHILE` | Loop with condition |
| `RETURN` | Return value |
| `RAISE` | Output message/error |

### Query Optimization

Query performance optimization:

**EXPLAIN ANALYZE:**

```sql
-- Analyze execution plan
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT 
    u.name,
    COUNT(o.id) as order_count,
    SUM(o.total_amount) as total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.created_at > '2025-01-01'
GROUP BY u.id, u.name;

-- Interpreting results:
-- Seq Scan - sequential scan (usually bad for large tables)
-- Index Scan - index usage (good)
-- Index Only Scan - ideal (no table read needed)
-- Nested Loop - good for small tables
-- Hash Join - good for large tables
-- Merge Join - good for sorted data
```

**Index Optimization:**

```sql
-- Creating optimal indexes
-- B-tree index (default)
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status_date ON orders(status, order_date DESC);

-- Composite index for covering query
CREATE INDEX idx_orders_covering 
ON orders(customer_id, status, order_date DESC)
INCLUDE (total_amount);

-- Partial index for active data
CREATE INDEX idx_products_active 
ON products(product_id) 
WHERE status = 'active';

-- Expression index
CREATE INDEX idx_orders_year 
ON orders(EXTRACT(YEAR FROM order_date));

-- GIN index for JSON
CREATE INDEX idx_orders_data ON orders USING GIN(data jsonb_path_ops);
```

**Common Optimization Patterns:**

| Problem | Solution |
|---------|----------|
| Full table scan | Add index on WHERE column |
| Slow JOIN | Check indexes on JOIN columns |
| Repeated calculations | Use MATERIALIZED views |
| Large OFFSET | Use cursor pagination |
| N+1 problem | Combine queries with JOIN |
| Slow aggregations | Use covering indexes |

**Query Refactoring Examples:**

```sql
-- BAD: Subquery in SELECT
SELECT 
    name,
    (SELECT COUNT(*) FROM orders WHERE user_id = users.id) as order_count
FROM users;

-- GOOD: JOIN instead of subquery
SELECT 
    u.name,
    COALESCE(o.order_count, 0) as order_count
FROM users u
LEFT JOIN (
    SELECT user_id, COUNT(*) as order_count
    FROM orders
    GROUP BY user_id
) o ON u.id = o.user_id;

-- BAD: Multiple subqueries
SELECT * FROM orders 
WHERE customer_id IN (SELECT id FROM customers WHERE country = 'USA')
AND status IN (SELECT status FROM order_statuses WHERE active = true);

-- GOOD: CTE for readability and performance
WITH 
    us_customers AS (SELECT id FROM customers WHERE country = 'USA'),
    active_statuses AS (SELECT status FROM order_statuses WHERE active = true)
SELECT * FROM orders 
WHERE customer_id IN (SELECT id FROM us_customers)
AND status IN (SELECT status FROM active_statuses);

-- Avoid: SELECT * (always specify columns)
-- GOOD:
SELECT id, name, email FROM users WHERE active = true;
```

## Integration with Project Manager

### Data for Project Manager

Provides the following data for PM:

**Quantitative Metrics:**

| Metric | Description |
|--------|-------------|
| Number of SQL queries | Total number of queries for implementation |
| Query complexity | Simple/medium/complex |
| Number of stored procedures | Procedures and functions |
| Triggers | Audit, validation, automation |

**Query Complexity Estimation:**

| Complexity | Criteria | Examples |
|------------|----------|----------|
| **Simple** | 1-2 tables, simple WHERE | SELECT with 1 JOIN |
| **Medium** | 3-5 tables, aggregations, subqueries | JOIN + GROUP BY + HAVING |
| **Complex** | 6+ tables, CTEs, window functions | Recursive CTEs, analytics |
| **Expert** | Stored procedures, triggers, optimization | Business logic in DB |

**Performance Requirements:**

- Expected query execution time
- Data volume for testing
- Index requirements
- Expected load (RPS)

**Optimization Risks:**

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Slow JOINs | Medium | High | Index checking |
| Deadlocks | Medium | High | Transaction logic |
| Large data volume | High | Medium | Pagination, cursors |
| Complex subqueries | Medium | Medium | CTE, materialization |

### Interaction

- PM requests SQL queries for development time estimation
- PM receives data for optimization planning
- PM uses metrics for resource allocation
- SA validates queries with PM before passing to universal-coding-agent

## Usage Examples

### Example 1: Complex Report with CTE and Window Functions

**Task:** Create sales report with manager ranking and trends

```sql
WITH 
    monthly_sales AS (
        SELECT 
            EXTRACT(YEAR FROM order_date) as year,
            EXTRACT(MONTH FROM order_date) as month,
            sales_person_id,
            SUM(total_amount) as monthly_total
        FROM orders
        WHERE status = 'completed'
        GROUP BY 1, 2, 3
    ),
    sales_with_ranking AS (
        SELECT 
            year,
            month,
            sales_person_id,
            monthly_total,
            SUM(monthly_total) OVER (PARTITION BY sales_person_id ORDER BY year, month) as cumulative_sales,
            AVG(monthly_total) OVER (PARTITION BY sales_person_id ORDER BY year, month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg_3,
            ROW_NUMBER() OVER (PARTITION BY year, month ORDER BY monthly_total DESC) as month_rank
        FROM monthly_sales
    )
SELECT 
    s.year,
    s.month,
    e.name as sales_person,
    s.monthly_total,
    s.cumulative_sales,
    s.moving_avg_3,
    s.month_rank,
    d.department_name
FROM sales_with_ranking s
JOIN employees e ON s.sales_person_id = e.id
JOIN departments d ON e.department_id = d.id
WHERE s.year = 2025
ORDER BY s.year, s.month, s.month_rank;
```

### Example 2: Recursive CTE for Organizational Hierarchy

```sql
-- Full organizational structure with levels
WITH RECURSIVE org_structure AS (
    -- Initial level: CEO and directors
    SELECT 
        e.id,
        e.name,
        e.title,
        e.manager_id,
        1 as level,
        e.name as hierarchy_path,
        ARRAY[e.id] as ancestor_path
    FROM employees e
    WHERE e.manager_id IS NULL
    
    UNION ALL
    
    -- Recursive part: all levels down
    SELECT 
        e.id,
        e.name,
        e.title,
        e.manager_id,
        os.level + 1,
        os.hierarchy_path || ' > ' || e.name,
        os.ancestor_path || e.id
    FROM employees e
    JOIN org_structure os ON e.manager_id = os.id
    WHERE array_length(os.ancestor_path, 1) < 10  -- infinite recursion protection
)
SELECT 
    level,
    name as employee,
    title,
    hierarchy_path,
    (
        SELECT name 
        FROM employees 
        WHERE id = (SELECT manager_id FROM employees WHERE id = org_structure.id)
    ) as manager_name
FROM org_structure
WHERE level <= 4
ORDER BY level, hierarchy_path;
```

### Example 3: Stored Procedure for Business Logic

```sql
-- Procedure for order processing with validation and audit
CREATE OR REPLACE PROCEDURE process_customer_order(
    p_customer_id INT,
    p_items JSONB,
    OUT p_order_id INT,
    OUT p_status VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total DECIMAL(10,2) := 0;
    v_item JSONB;
    v_product_id INT;
    v_quantity INT;
    v_price DECIMAL(10,2);
BEGIN
    -- Customer validation
    IF NOT EXISTS (SELECT 1 FROM customers WHERE id = p_customer_id AND status = 'active') THEN
        RAISE EXCEPTION 'Customer not found or inactive: %', p_customer_id;
    END IF;
    
    -- Check product availability and calculate total
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
    LOOP
        v_product_id := (v_item->>'product_id')::INT;
        v_quantity := (v_item->>'quantity')::INT;
        
        -- Get price
        SELECT price INTO v_price 
        FROM products 
        WHERE id = v_product_id AND is_active = true;
        
        IF v_price IS NULL THEN
            RAISE EXCEPTION 'Product not available: %', v_product_id;
        END IF;
        
        v_total := v_total + (v_price * v_quantity);
    END LOOP;
    
    -- Apply discount
    DECLARE
        v_customer_type VARCHAR(20);
        v_discount DECIMAL(10,2);
    BEGIN
        SELECT customer_type INTO v_customer_type 
        FROM customers WHERE id = p_customer_id;
        
        v_discount := calculate_discount(v_total, v_customer_type);
        v_total := v_total - v_discount;
    END;
    
    -- Create order
    INSERT INTO orders (customer_id, total_amount, status, items, created_at)
    VALUES (p_customer_id, v_total, 'pending', p_items, CURRENT_TIMESTAMP)
    RETURNING id INTO p_order_id;
    
    -- Audit
    INSERT INTO order_audit (order_id, action, old_status, new_status, changed_by)
    VALUES (p_order_id, 'CREATE', NULL, 'pending', CURRENT_USER);
    
    p_status := 'success';
    
EXCEPTION
    WHEN OTHERS THEN
        p_status := 'error: ' || SQLERRM;
        RAISE;
END;
$$;
```

### Example 4: Slow Query Optimization

**Original slow query:**

```sql
-- Slow query (5+ seconds on 1M records)
SELECT 
    o.id,
    o.order_date,
    c.name as customer_name,
    p.name as product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price as line_total
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.order_date >= '2025-01-01'
ORDER BY o.order_date DESC;
```

**Optimized version:**

```sql
-- Step 1: Create indexes
CREATE INDEX idx_orders_date_desc ON orders(order_date DESC);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_customers_id ON customers(id);

-- Step 2: Covering index for frequently used columns
CREATE INDEX idx_order_items_covering 
ON order_items(order_id, product_id, quantity, unit_price);

-- Step 3: Optimized query
SELECT 
    o.id,
    o.order_date,
    c.name as customer_name,
    p.name as product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price as line_total
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN (
    SELECT order_id, product_id, quantity, unit_price
    FROM order_items
) oi ON o.id = oi.order_id
INNER JOIN products p ON oi.product_id = p.id
WHERE o.order_date >= '2025-01-01'
ORDER BY o.order_date DESC;

-- Step 4: Check execution plan
EXPLAIN (ANALYZE, BUFFERS)
SELECT /*+ Index(o idx_orders_date_desc) */
    o.id,
    o.order_date,
    c.name as customer_name,
    p.name as product_name,
    oi.quantity,
    oi.unit_price
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.order_date >= '2025-01-01'
ORDER BY o.order_date DESC
LIMIT 100;
```

## Best Practices

### Writing Queries

1. **Always specify columns** — avoid `SELECT *`
2. **Use aliases** — for readable JOINs
3. **CTEs preferred over subqueries** — better readability and optimization
4. **Comment complex logic** — for future maintenance
5. **Test on real data** — data volume affects the plan

### Optimization

1. **Start with EXPLAIN ANALYZE** — understand the plan before optimizing
2. **Create targeted indexes** — based on query plans
3. **Avoid functions in WHERE** — they kill index usage
4. **Use LIMIT** — for testing queries
5. **Measure before and after** — confirm improvements

### Security

1. **Use parameterized queries** — protection against SQL injection
2. **Principle of least privilege** — separate users for different operations
3. **Validate input data** — at application and DB level
4. **Encrypt sensitive data** — at DB level

### Maintenance

1. **Version SQL scripts** — for migrations
2. **Document complex queries** — what it does and why
3. **Use named constraints** — for clear errors
4. **Test migrations** — on stage before production

## Related Skills

- **data-modeling** — data model design (preceding skill)
- **api-design** — API design (uses SQL for backend)
- **nosql-design** — NoSQL schema design (alternative approach)
- **test-case-design** — creating test cases for SQL queries
