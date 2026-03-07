---
name: sql-development
description: Написание сложных SQL-запросов: JOINs, Subqueries, UNION, CTEs, Window Functions (ROW_NUMBER, RANK, LAG, LEAD), Stored Procedures, оптимизация запросов с EXPLAIN ANALYZE
---

# SQL Development

> **Meta:** v1.0.0 | 23-02-2026

## Назначение

Навык для написания сложных SQL-запросов, охватывающий продвинутые техники работы с реляционными базами данных. Включает создание сложных запросов с использованием JOINов и подзапросов, Common Table Expressions (CTE), оконных функций, хранимых процедур и функций, а также оптимизацию запросов для достижения максимальной производительности.

Этот навык является логическим продолжением навыка `data-modeling` и предоставляет готовые SQL-запросы для реализации в universal-coding-agent.

## Когда использовать

Используйте этот навык:

- При необходимости написания сложных запросов с множественными JOINами
- Для работы с иерархическими данными через рекурсивные CTE
- При использовании аналитических функций (ранжирование, тренды, скользящие средние)
- Для создания хранимых процедур и функций с бизнес-логикой
- При оптимизации медленных запросов
- Для генерации отчётов с агрегациями
- На этапе разработки после проектирования модели данных

## Функции

### Complex Queries

Сложные запросы с использованием различных техник объединения данных:

**JOIN Types:**

| Тип JOIN | Описание | Пример использования |
|----------|----------|---------------------|
| **INNER JOIN** | Пересечение двух таблиц | Получить заказы с информацией о клиентах |
| **LEFT JOIN** | Все записи из левой таблицы | Все клиенты, включая без заказов |
| **RIGHT JOIN** | Все записи из правой таблицы | Все заказы, включая без клиентов |
| **FULL OUTER JOIN** | Объединение обеих таблиц | Все клиенты и все заказы |
| **CROSS JOIN** | Декартово произведение | Все комбинации товаров и категорий |
| **SELF JOIN** | Соединение таблицы с собой | Иерархические данные ( сотрудник-менеджер) |

**Subqueries:**

| Тип | Описание | Пример |
|-----|----------|--------|
| **Non-correlated** | Независимый подзапрос | `SELECT * FROM users WHERE id IN (SELECT user_id FROM orders)` |
| **Correlated** | Зависит от внешнего запроса | `SELECT * FROM orders o WHERE total > (SELECT AVG(total) FROM orders WHERE customer_id = o.customer_id)` |
| **Scalar** | Возвращает одно значение | `SELECT name, (SELECT COUNT(*) FROM orders WHERE user_id = users.id) as order_count` |
| **Table** | Возвращает таблицу | `WITH regional_sales AS (...) SELECT * FROM regional_sales` |

**Set Operations:**

| Оператор | Описание |
|----------|----------|
| **UNION** | Объединение без дубликатов |
| **UNION ALL** | Объединение с дубликатами |
| **INTERSEC** | Пересечение |
| **EXCEPT** | Разность |

### CTEs (Common Table Expressions)

Общие табличные выражения для улучшения читаемости и структуры запросов:

**Простые CTE:**

```sql
-- Выборка с CTE для расчёта статистики
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
-- Несколько CTE в одном запросе
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
-- Иерархия сотрудников (организационная структура)
WITH RECURSIVE org_chart AS (
    -- Base case: топ-менеджеры
    SELECT 
        id,
        name,
        manager_id,
        1 as level,
        name as path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: подчинённые
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

-- Иерархия категорий товаров
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

| Критерий | CTE | Subquery |
|----------|-----|----------|
| Читаемость | Высокая | Низкая |
| Повторное использование | Да (в пределах запроса) | Нет |
| Отладка | Проще | Сложнее |
| Производительность | Оптимизатор видит целиком | Аналогичная |

### Window Functions

Оконные функции для анализа данных без группировки строк:

**Ranking Functions:**

```sql
-- ROW_NUMBER: уникальная нумерация
SELECT 
    product_name,
    category,
    sales_amount,
    ROW_NUMBER() OVER (ORDER BY sales_amount DESC) as rank
FROM product_sales;

-- RANK: нумерация с пропусками при одинаковых значениях
SELECT 
    employee_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank
FROM employees;

-- DENSE_RANK: нумерация без пропусков
SELECT 
    employee_name,
    department,
    salary,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_dense_rank
FROM employees;

-- NTILE: распределение по группам
SELECT 
    customer_name,
    total_purchases,
    NTILE(4) OVER (ORDER BY total_purchases DESC) as quartile
FROM customer_stats;
```

**Analytic Functions:**

```sql
-- LAG: предыдущее значение
SELECT 
    month,
    revenue,
    LAG(revenue, 1) OVER (ORDER BY month) as prev_month_revenue,
    revenue - LAG(revenue, 1) OVER (ORDER BY month) as revenue_growth
FROM monthly_revenue;

-- LEAD: следующее значение
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
-- SUM OVER: накопленная сумма
SELECT 
    order_date,
    daily_sales,
    SUM(daily_sales) OVER (ORDER BY order_date) as cumulative_sales,
    SUM(daily_sales) OVER (PARTITION BY EXTRACT(MONTH FROM order_date)) as monthly_total
FROM daily_sales;

-- AVG OVER: скользящее среднее
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

Хранимые процедуры, функции и триггеры для инкапсуляции бизнес-логики на уровне БД:

**Stored Procedures:**

```sql
-- Простая хранимая процедура (PostgreSQL)
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

-- Вызов процедуры
CALL create_order(123, 99.99, NULL);

-- Процедура с транзакцией
CREATE OR REPLACE PROCEDURE process_order(
    p_order_id INT,
    p_action VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(20);
BEGIN
    -- Получить текущий статус
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
-- Функция для расчёта скидки (PostgreSQL)
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
    -- Определить процент скидки
    CASE p_customer_type
        WHEN 'gold' THEN v_discount_rate := 0.20;
        WHEN 'silver' THEN v_discount_rate := 0.10;
        WHEN 'bronze' THEN v_discount_rate := 0.05;
        ELSE v_discount_rate := 0.00;
    END CASE;
    
    -- Рассчитать скидку
    v_discount := p_amount * v_discount_rate;
    
    RETURN v_discount;
END;
$$;

-- Использование функции
SELECT 
    order_id,
    total_amount,
    customer_type,
    calculate_discount(total_amount, customer_type) as discount,
    total_amount - calculate_discount(total_amount, customer_type) as final_amount
FROM orders;

-- Scalar function с таблицей (MySQL)
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
-- Триггер для автоматического обновления (PostgreSQL)
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

-- Триггер для аудита изменений
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

| Конструкция | Описание |
|-------------|----------|
| `DECLARE` | Объявление переменных |
| `BEGIN/END` | Блок кода |
| `IF/THEN/ELSE` | Условное выполнение |
| `CASE` | Множественное условие |
| `FOR` | Цикл по результату запроса |
| `WHILE` | Цикл с условием |
| `RETURN` | Возврат значения |
| `RAISE` | Вывод сообщения/ошибки |

### Query Optimization

Оптимизация производительности запросов:

**EXPLAIN ANALYZE:**

```sql
-- Анализ плана выполнения
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT 
    u.name,
    COUNT(o.id) as order_count,
    SUM(o.total_amount) as total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.created_at > '2025-01-01'
GROUP BY u.id, u.name;

-- Интерпретация результатов:
-- Seq Scan - последовательное сканирование (обычно плохо для больших таблиц)
-- Index Scan - использование индекса (хорошо)
-- Index Only Scan - идеально (не нужно читать таблицу)
-- Nested Loop - хорошо для маленьких таблиц
-- Hash Join - хорошо для больших таблиц
-- Merge Join - хорошо для отсортированных данных
```

**Index Optimization:**

```sql
-- Создание оптимальных индексов
-- B-tree индекс (по умолчанию)
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status_date ON orders(status, order_date DESC);

-- Composite index для покрывающего запроса
CREATE INDEX idx_orders_covering 
ON orders(customer_id, status, order_date DESC)
INCLUDE (total_amount);

-- Partial index для активных данных
CREATE INDEX idx_products_active 
ON products(product_id) 
WHERE status = 'active';

-- Expression index
CREATE INDEX idx_orders_year 
ON orders(EXTRACT(YEAR FROM order_date));

-- GIN индекс для JSON
CREATE INDEX idx_orders_data ON orders USING GIN(data jsonb_path_ops);
```

**Common Optimization Patterns:**

| Проблема | Решение |
|----------|---------|
| Полное сканирование таблицы | Добавить индекс на WHERE колонку |
| Медленный JOIN | Проверить индексы на JOIN колонках |
| Повторные вычисления | Использовать MATERIALIZED представления |
| Большой OFFSET | Использовать курсорную пагинацию |
| N+1 проблема | Объединить запросы с JOIN |
| Медленные агрегации | Использовать покрывающие индексы |

**Query Refactoring Examples:**

```sql
-- ПЛОХО: Подзапрос в SELECT
SELECT 
    name,
    (SELECT COUNT(*) FROM orders WHERE user_id = users.id) as order_count
FROM users;

-- ХОРОШО: JOIN вместо подзапроса
SELECT 
    u.name,
    COALESCE(o.order_count, 0) as order_count
FROM users u
LEFT JOIN (
    SELECT user_id, COUNT(*) as order_count
    FROM orders
    GROUP BY user_id
) o ON u.id = o.user_id;

-- ПЛОХО: Множественные подзапросы
SELECT * FROM orders 
WHERE customer_id IN (SELECT id FROM customers WHERE country = 'USA')
AND status IN (SELECT status FROM order_statuses WHERE active = true);

-- ХОРОШО: CTE для читаемости и производительности
WITH 
    us_customers AS (SELECT id FROM customers WHERE country = 'USA'),
    active_statuses AS (SELECT status FROM order_statuses WHERE active = true)
SELECT * FROM orders 
WHERE customer_id IN (SELECT id FROM us_customers)
AND status IN (SELECT status FROM active_statuses);

-- Избегайте: SELECT * (всегда указывайте колонки)
-- ХОРОШО:
SELECT id, name, email FROM users WHERE active = true;
```

## Интеграция с Project Manager

### Данные для Project Manager

Предоставляет следующие данные для PM:

**Количественные метрики:**

| Метрика | Описание |
|---------|----------|
| Количество SQL-запросов | Общее число запросов для реализации |
| Сложность запросов | Простые/средние/сложные |
| Количество хранимых процедур | Процедуры и функции |
| Триггеры | Аудит, валидация, автоматизация |

**Оценка сложности запросов:**

| Сложность | Критерии | Примеры |
|-----------|----------|---------|
| **Простая** | 1-2 таблицы, простые WHERE | SELECT с 1 JOIN |
| **Средняя** | 3-5 таблиц, агрегации, подзапросы | JOIN + GROUP BY + HAVING |
| **Сложная** | 6+ таблиц, CTE, оконные функции | Рекурсивные CTE, аналитика |
| **Экспертная** | Хранимые процедуры, триггеры, оптимизация | Business logic in DB |

**Требования к производительности:**

- Ожидаемое время выполнения запросов
- Объём данных для тестирования
- Требования к индексам
- Ожидаемая нагрузка (RPS)

**Риски оптимизации:**

| Риск | Вероятность | Влияние | Митигация |
|------|-------------|---------|------------|
| Медленные JOINы | Средняя | Высокое | Проверка индексов |
| Deadlocks | Средняя | Высокое | Транзакционная логика |
| Большой объём данных | Высокая | Среднее | Пагинация, курсоры |
| Сложные подзапросы | Средняя | Среднее | CTE, материализация |

### Взаимодействие

- PM запрашивает SQL-запросы для оценки времени разработки
- PM получает данные для планирования оптимизации
- PM использует метрики для распределения ресурсов
- SA валидирует запросы с PM перед передачей в universal-coding-agent

## Примеры использования

### Пример 1: Сложный отчёт с CTE и Window Functions

**Задача:** Создать отчёт по продажам с ранжированием менеджеров и трендами

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

### Пример 2: Рекурсивная CTE для организационной иерархии

```sql
-- Полная организационная структура с уровнями
WITH RECURSIVE org_structure AS (
    -- Начальный уровень: CEO и директора
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
    
    -- Рекурсивная часть: все уровни вниз
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
    WHERE array_length(os.ancestor_path, 1) < 10  -- защита от бесконечной рекурсии
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

### Пример 3: Stored Procedure для бизнес-логики

```sql
-- Процедура для обработки заказа с валидацией и аудитом
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
    -- Валидация клиента
    IF NOT EXISTS (SELECT 1 FROM customers WHERE id = p_customer_id AND status = 'active') THEN
        RAISE EXCEPTION 'Customer not found or inactive: %', p_customer_id;
    END IF;
    
    -- Проверка наличия товаров и расчёт суммы
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
    LOOP
        v_product_id := (v_item->>'product_id')::INT;
        v_quantity := (v_item->>'quantity')::INT;
        
        -- Получить цену
        SELECT price INTO v_price 
        FROM products 
        WHERE id = v_product_id AND is_active = true;
        
        IF v_price IS NULL THEN
            RAISE EXCEPTION 'Product not available: %', v_product_id;
        END IF;
        
        v_total := v_total + (v_price * v_quantity);
    END LOOP;
    
    -- Применение скидки
    DECLARE
        v_customer_type VARCHAR(20);
        v_discount DECIMAL(10,2);
    BEGIN
        SELECT customer_type INTO v_customer_type 
        FROM customers WHERE id = p_customer_id;
        
        v_discount := calculate_discount(v_total, v_customer_type);
        v_total := v_total - v_discount;
    END;
    
    -- Создание заказа
    INSERT INTO orders (customer_id, total_amount, status, items, created_at)
    VALUES (p_customer_id, v_total, 'pending', p_items, CURRENT_TIMESTAMP)
    RETURNING id INTO p_order_id;
    
    -- Аудит
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

### Пример 4: Оптимизация медленного запроса

**Исходный медленный запрос:**

```sql
-- Медленный запрос (5+ секунд на 1М записей)
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

**Оптимизированная версия:**

```sql
-- Шаг 1: Создание индексов
CREATE INDEX idx_orders_date_desc ON orders(order_date DESC);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_customers_id ON customers(id);

-- Шаг 2: Покрывающий индекс для часто используемых колонок
CREATE INDEX idx_order_items_covering 
ON order_items(order_id, product_id, quantity, unit_price);

-- Шаг 3: Оптимизированный запрос
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

-- Шаг 4: Проверка плана выполнения
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

## Лучшие практики

### Написание запросов

1. **Всегда указывайте колонки** — избегайте `SELECT *`
2. **Используйте алиасы** — для читаемости JOINов
3. **CTE предпочтительнее подзапросов** — лучше читаемость и оптимизация
4. **Комментируйте сложную логику** — для будущего сопровождения
5. **Тестируйте на реальных данных** — объём данных влияет на план

### Оптимизация

1. **Начинайте с EXPLAIN ANALYZE** — понимайте план перед оптимизацией
2. **Создавайте индексы точечно** — на основе планов запросов
3. **Избегайте функций в WHERE** — убивают использование индексов
4. **Используйте LIMIT** — для тестирования запросов
5. **Измеряйте до и после** — подтверждайте улучшения

### Безопасность

1. **Используйте параметризованные запросы** — защита от SQL injection
2. **Принцип наименьших привилегий** — отдельные пользователи для разных операций
3. **Валидируйте входные данные** — на уровне приложения и БД
4. **Шифруйте чувствительные данные** — на уровне БД

### Сопровождение

1. **Версионируйте SQL-скрипты** — для миграций
2. **Документируйте сложные запросы** — что делает и почему так
3. **Используйте именованные ограничения** — для понятных ошибок
4. **Тестируйте миграции** — на стейдже перед продакшеном

## Связанные навыки

- **data-modeling** — проектирование моделей данных (предшествующий навык)
- **api-design** — проектирование API (использует SQL для backend)
- **nosql-design** — проектирование NoSQL схем (альтернативный подход)
- **test-case-design** — создание тест-кейсов для SQL-запросов

---
