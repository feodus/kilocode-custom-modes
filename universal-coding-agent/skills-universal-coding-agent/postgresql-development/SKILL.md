---
name: postgresql-development
description: PostgreSQL database development and optimization. Use this skill when designing schemas, writing complex SQL queries, optimizing performance, and working with advanced PostgreSQL features.
---

# PostgreSQL Development Guide

## PostgreSQL Basics

PostgreSQL is a powerful open-source object-relational database management system.

### Connection

```bash
# Connect to DB
psql -U username -d database_name
psql -h localhost -p 5432 -U user -d mydb

# Create DB
createdb mydb
CREATE DATABASE mydb;

# Drop DB
dropdb mydb
DROP DATABASE IF EXISTS mydb;
```

## Schema Design

### Data Types

```sql
-- Main types
CREATE TABLE users (
    id SERIAL PRIMARY KEY,           -- Auto increment
    uuid UUID DEFAULT gen_random_uuid(), -- UUID
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    bio TEXT,                         -- Text without limit
    age INTEGER,                      -- Integer
    price DECIMAL(10, 2),             -- Exact numbers
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    metadata JSONB,                   -- JSON (optimized)
    tags TEXT[]                       -- Array
);

-- JSONB examples
INSERT INTO users (username, metadata) VALUES 
    ('john', '{"age": 30, "city": "NYC"}'::jsonb);

SELECT metadata->>'age' as age FROM users;
SELECT metadata->'address'->>'city' FROM users WHERE metadata ? 'address';

-- Arrays
ALTER TABLE users ADD COLUMN skills TEXT[];
UPDATE users SET skills = ARRAY['Python', 'Django'] WHERE id = 1;
SELECT * FROM users WHERE skills && ARRAY['Python'];
```

### Table Relationships

```sql
-- One-to-One
CREATE TABLE user_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    bio TEXT,
    avatar_url VARCHAR(500)
);

-- One-to-Many (Categories -> Products)
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id INTEGER REFERENCES categories(id)
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Many-to-Many (Products <-> Orders)
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Junction table for many-to-many
CREATE TABLE product_tags (
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, tag_id)
);
```

### Constraints

```sql
-- Check constraints
CREATE TABLE products (
    price DECIMAL(10, 2) CHECK (price > 0),
    discount DECIMAL(10, 2) CHECK (discount >= 0 AND discount <= 100)
);

-- Partial unique index
CREATE UNIQUE INDEX active_emails 
ON users(email) WHERE is_active = true;

-- Exclusion constraints (prevent overlapping dates)
CREATE TABLE reservations (
    id SERIAL PRIMARY KEY,
    room_id INTEGER REFERENCES rooms(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    EXCLUDE USING gist (
        room_id WITH =,
        tstzrange(start_date, end_date) WITH &&
    )
);
```

## Indexes

### Index Types

```sql
-- B-Tree (default)
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_price ON products(price DESC);
CREATE INDEX idx_users_email ON users(email) UNIQUE;

-- GIN (for JSON, arrays, full-text search)
CREATE INDEX idx_products_metadata ON products USING GIN(metadata);
CREATE INDEX idx_users_skills ON users USING GIN(skills);

-- GiST (for geometric data, text)
CREATE INDEX idx_locations_coords ON locations USING GIST(coordinates);

-- BRIN (for large tables with sequential data)
CREATE INDEX idx_logs_created ON logs USING BRIN(created_at);

-- Composite indexes
CREATE INDEX idx_products_category_price 
ON products(category_id, price DESC);

-- Partial indexes
CREATE INDEX idx_active_products ON products(name) 
WHERE is_available = true;

-- Expression indexes
CREATE INDEX idx_users_lower_email ON users(LOWER(email));
CREATE INDEX idx_products_name_search ON products 
USING GIN(to_tsvector('russian', name));
```

## Complex SQL Queries

### JOINs

```sql
-- Inner Join
SELECT p.name, c.name as category_name, p.price
FROM products p
INNER JOIN categories c ON p.category_id = c.id;

-- Left Join with aggregation
SELECT 
    c.name as category,
    COUNT(p.id) as product_count,
    COALESCE(AVG(p.price), 0) as avg_price
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY product_count DESC;

-- Self Join
SELECT 
    e.name as employee,
    m.name as manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;

-- Multiple joins
SELECT 
    o.id as order_id,
    u.username,
    p.name as product_name,
    oi.quantity,
    oi.price
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.status = 'completed';
```

### Subqueries and CTEs

```sql
-- CTE (Common Table Expressions)
WITH category_stats AS (
    SELECT 
        category_id,
        COUNT(*) as product_count,
        MAX(price) as max_price,
        AVG(price) as avg_price
    FROM products
    GROUP BY category_id
),
top_categories AS (
    SELECT category_id
    FROM category_stats
    WHERE product_count > 10
)
SELECT 
    c.name,
    cs.product_count,
    cs.avg_price
FROM categories c
JOIN category_stats cs ON c.id = cs.category_id
WHERE c.id IN (SELECT category_id FROM top_categories);

-- Subquery in SELECT
SELECT 
    name,
    price,
    (SELECT AVG(price) FROM products) as avg_price,
    price - (SELECT AVG(price) FROM products) as diff
FROM products;

-- Subquery in FROM
SELECT category_name, total_products
FROM (
    SELECT 
        c.name as category_name,
        COUNT(p.id) as total_products
    FROM categories c
    LEFT JOIN products p ON c.id = p.category_id
    GROUP BY c.id
) subq
WHERE total_products > 5;

-- EXISTS
SELECT * FROM users u
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.user_id = u.id
);

-- ALL/ANY
SELECT * FROM products
WHERE price > ALL (SELECT price FROM products WHERE category_id = 1);
```

### Window Functions

```sql
-- ROW_NUMBER - row numbering
SELECT 
    name,
    price,
    category_id,
    ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) as rank
FROM products;

-- RANK and DENSE_RANK
SELECT 
    name,
    price,
    RANK() OVER (ORDER BY price DESC) as rank,
    DENSE_RANK() OVER (ORDER BY price DESC) as dense_rank
FROM products;

-- LAG and LEAD
SELECT 
    name,
    price,
    LAG(price, 1) OVER (ORDER BY created_at) as prev_price,
    price - LAG(price, 1) OVER (ORDER BY created_at) as price_change
FROM products;

-- SUM, AVG, COUNT OVER
SELECT 
    name,
    price,
    SUM(price) OVER (PARTITION BY category_id) as category_total,
    AVG(price) OVER (PARTITION BY category_id) as category_avg,
    COUNT(*) OVER (PARTITION BY category_id) as category_count
FROM products;

-- FIRST_VALUE, LAST_VALUE
SELECT 
    name,
    price,
    FIRST_VALUE(name) OVER (PARTITION BY category_id ORDER BY price) as cheapest,
    LAST_VALUE(name) OVER (PARTITION BY category_id ORDER BY price) as most_expensive
FROM products;

-- NTILE (split into groups)
SELECT 
    name,
    price,
    NTILE(4) OVER (ORDER BY price) as quartile
FROM products;
```

### Aggregations

```sql
-- String aggregation
SELECT 
    category_id,
    STRING_AGG(name, ', ' ORDER BY price DESC) as products
FROM products
GROUP BY category_id;

-- Array aggregation
SELECT 
    category_id,
    ARRAY_AGG(id ORDER BY created_at) as product_ids
FROM products
GROUP BY category_id;

-- JSON aggregation
SELECT 
    category_id,
    JSON_AGG(JSON_BUILD_OBJECT('name', name, 'price', price)) as products
FROM products
GROUP BY category_id;

-- Filter aggregation
SELECT 
    COUNT(*) as total,
    COUNT(*) FILTER (WHERE is_active) as active,
    AVG(price) FILTER (WHERE price > 100) as avg_expensive
FROM products;
```

## Transactions

```sql
-- Basic transaction
BEGIN;
    UPDATE accounts SET balance = balance - 100 WHERE user_id = 1;
    UPDATE accounts SET balance = balance + 100 WHERE user_id = 2;
COMMIT;

-- Rollback
BEGIN;
    INSERT INTO orders (user_id, total) VALUES (1, 500);
    ROLLBACK;

-- Isolation levels
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Savepoints
BEGIN;
    INSERT INTO users (name) VALUES ('John');
    SAVEPOINT sp1;
    INSERT INTO users (name) VALUES ('Jane');
    ROLLBACK TO SAVEPOINT sp1;
    COMMIT;
```

## Functions and Procedures

### Functions

```sql
-- Simple function
CREATE OR REPLACE FUNCTION get_user_count()
RETURNS INTEGER AS $$
BEGIN
    RETURN COUNT(*)::INTEGER FROM users;
END;
$$ LANGUAGE plpgsql;

-- Function with parameters
CREATE OR REPLACE FUNCTION calculate_discount(
    price DECIMAL, 
    discount_percent INTEGER
)
RETURNS DECIMAL AS $$
BEGIN
    RETURN price * (100 - discount_percent) / 100;
END;
$$ LANGUAGE plpgsql;

-- Function returning table
CREATE OR REPLACE FUNCTION get_products_by_category(
    p_category_id INTEGER
)
RETURNS TABLE (
    id INTEGER,
    name VARCHAR(200),
    price DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.name, p.price
    FROM products p
    WHERE p.category_id = p_category_id;
END;
$$ LANGUAGE plpgsql;

-- Usage
SELECT get_user_count();
SELECT calculate_discount(100, 20);
SELECT * FROM get_products_by_category(1);
```

### Triggers

```sql
-- Trigger for updating timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

-- Trigger for audit
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(100),
    action VARCHAR(10),
    old_data JSONB,
    new_data JSONB,
    changed_by INTEGER,
    changed_at TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION audit_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, action, new_data, changed_by)
        VALUES (TG_TABLE_NAME, 'INSERT', to_jsonb(NEW), current_user::integer);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (table_name, action, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, 'UPDATE', to_jsonb(OLD), to_jsonb(NEW), current_user::integer);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (table_name, action, old_data, changed_by)
        VALUES (TG_TABLE_NAME, 'DELETE', to_jsonb(OLD), current_user::integer);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

## Optimization

### EXPLAIN ANALYZE

```sql
-- Query analysis
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT * FROM products 
WHERE category_id = 1 
ORDER BY price DESC;

-- Plan analysis
Seq Scan on products  (cost=0.00..25.88 rows=5 width=40) (actual time=0.015..0.025 rows=5 loops=1)
  Filter: (category_id = 1)
  Buffers: shared hit=2
Planning Time: 0.123 ms
Execution Time: 0.045 ms
```

### Query Optimization

```sql
-- Create proper indexes
CREATE INDEX idx_products_category_price 
ON products(category_id, price DESC);

-- Use covering indexes
CREATE INDEX idx_products_cover 
ON products(category_id) INCLUDE (name, price);

-- Rewrite queries
-- Instead of:
SELECT * FROM products WHERE price > 100 AND price < 500;
-- Use:
SELECT * FROM products WHERE price BETWEEN 100 AND 500;

-- Instead of subqueries - JOIN
-- Instead of:
SELECT * FROM users WHERE id IN (SELECT user_id FROM orders);
-- Use:
SELECT DISTINCT u.* FROM users u
JOIN orders o ON u.id = o.user_id;

-- Pagination with cursor
-- Instead of OFFSET (slow for large pages):
SELECT * FROM products ORDER BY id LIMIT 10 OFFSET 10000;
-- Use cursor:
SELECT * FROM products WHERE id > 10000 ORDER BY id LIMIT 10;
```

### VACUUM and ANALYZE

```sql
-- VACUUM (free space)
VACUUM products;
VACUUM FULL products;  -- Requires exclusive lock

-- ANALYZE (update statistics)
ANALYZE products;

-- Automatic vacuum
ALTER TABLE products SET (
    autovacuum_vacuum_threshold = 1000,
    autovacuum_analyze_threshold = 500
);
```

## Full-Text Search

```sql
-- Create text index
ALTER TABLE products ADD COLUMN name_tsv TSVECTOR;

UPDATE products SET name_tsv = to_tsvector('russian', name);

CREATE INDEX idx_products_name_search 
ON products USING GIN(name_tsv);

-- Search
SELECT * FROM products 
WHERE name_tsv @@ to_tsquery('russian', 'laptop & gaming');

-- With highlighting
SELECT 
    name,
    ts_headline('russian', name, to_tsquery('russian', 'laptop')) as highlighted
FROM products
WHERE name_tsv @@ to_tsquery('russian', 'laptop');
```

## Replication

```sql
-- Create replica (on master)
CREATE PUBLICATION mydb_pub FOR ALL TABLES;

-- On replica
CREATE SUBSCRIPTION mydb_sub 
CONNECTION 'host=master port=5432 dbname=mydb user=rep password=pass' 
PUBLICATION mydb_pub;
```

## Backup

```bash
# Backup
pg_dump -U user -Fc mydb > mydb.backup
pg_dump -U user -Fp mydb > mydb.sql

# Restore
pg_restore -U user -d mydb mydb.backup
psql -U user -d mydb < mydb.sql

# Backup with compression
pg_dump -U user -Fc mydb | gzip > mydb.sql.gz
```

## Best Practices

1. **Normalize data** - avoid redundancy
2. **Use correct types** - each data type has its own type
3. **Create indexes** - for frequently filtered columns
4. **Analyze queries** - use EXPLAIN ANALYZE
5. **Partition** - for large tables
6. **Cache** - frequently requested data
7. **Monitor** - track slow queries
8. **Backup** - regularly create backups
9. **Use connection pooling** - pgBouncer, PgPool
10. **Configure parameters** - work_mem, shared_buffers
