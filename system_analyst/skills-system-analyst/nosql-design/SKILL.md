---
name: nosql-design
description: Проектирование NoSQL схем данных: Document Design (MongoDB, CouchDB), Key-Value Patterns (Redis, DynamoDB), Access Patterns Analysis, Consistency Models (CAP theorem, eventual vs strong consistency), выбор типа NoSQL базы данных
---

# NoSQL Design

> **Meta:** v1.0.0 | 23-02-2026

## Назначение

Навык для проектирования NoSQL схем данных и выбора оптимальной NoSQL базы данных под конкретные требования. Включает анализ паттернов доступа к данным, проектирование документных моделей, key-value структур, понимание моделей согласованности (CAP theorem), и выбор между различными типами NoSQL баз данных.

Этот навык является альтернативой реляционному проектированию (`data-modeling`) и предоставляет схемы NoSQL для реализации в universal-coding-agent при работе с нереляционными хранилищами.

## Когда использовать

Используйте этот навык:

- При проектировании системы с высокой нагрузкой на чтение
- Для данных с гибкой или меняющейся структурой
- При необходимости горизонтального масштабирования
- Для географически распределённых систем
- При работе с полуструктурированными данными (логи, события, JSON)
- При выборе NoSQL базы данных между Document, Key-Value, Column-family или Graph
- Для проектирования под конкретные паттерны доступа
- При оценке компромиссов между согласованностью и доступностью

## Функции

### Document Design

Проектирование схем для документных баз данных (MongoDB, CouchDB):

**Принципы проектирования документов:**

| Принцип | Описание | Пример |
|---------|----------|--------|
| **Embedding (вложение)** | Хранение связанных данных в одном документе | Заказ с позициями |
| **Referencing (ссылки)** | Хранение ссылок между документами | Пользователь и заказы |
| **Denormalization** | Дублирование данных для оптимизации чтения | Имя пользователя в заказе |

**Когда использовать вложение:**

- Данные "всегда загружаются вместе"
- Отношения "one-to-few" или "one-to-many" с небольшим количеством
- Данные не обновляются независимо друг от друга

**Когда использовать ссылки:**

- Отношения "many-to-many"
- Большие массивы данных
- Данные часто обновляются независимо

**Schema Design Patterns:**

```javascript
// Pattern: Attribute Pattern (для опциональных полей)
{
  "_id": "product_001",
  "name": "Ноутбук",
  "attributes": {
    "color": "black",
    "weight": "2kg",
    "warranty": "2 года"
  }
}

// Pattern: Extended Reference Pattern (денormalized ссылки)
{
  "_id": "order_12345",
  "customer_name": "Иван Иванов",  // Денормализовано
  "customer_email": "ivan@example.com",  // Денормализовано
  "items": [...],
  "total": 50000
}

// Pattern: Subset Pattern (хранение часто используемых данных)
{
  "_id": "user_001",
  "name": "Иван Иванов",
  "recent_orders": [  // Только последние 5 заказов
    {"id": "order_1", "date": "2026-01-15", "total": 5000},
    {"id": "order_2", "date": "2026-02-01", "total": 7500}
  ]
}

// Pattern: Bucket Pattern (агрегация данных)
{
  "_id": "stats_2026_02",
  "date": "2026-02",
  "daily_stats": [
    {"day": 1, "views": 1500, "clicks": 45},
    {"day": 2, "views": 1800, "clicks": 52}
  ]
}
```

**MongoDB Collection Design:**

```javascript
// Users коллекция - вложенные данные для one-to-few
db.users.insertOne({
  "_id": ObjectId("..."),
  "email": "user@example.com",
  "profile": {
    "first_name": "Иван",
    "last_name": "Иванов",
    "phones": ["+7-999-123-45-67"],
    "addresses": [
      {"type": "billing", "city": "Москва", "street": "Ленина 1"},
      {"type": "shipping", "city": "Москва", "street": "Пушкина 10"}
    ]
  },
  "created_at": ISODate("2026-01-01"),
  "updated_at": ISODate("2026-02-01")
});

// Orders коллекция - ссылки для one-to-many
db.orders.insertOne({
  "_id": ObjectId("..."),
  "customer_id": ObjectId("user_id_ref"),
  "order_number": "ORD-2026-001",
  "items": [
    {"product_id": "prod_001", "quantity": 2, "price": 50000},
    {"product_id": "prod_002", "quantity": 1, "price": 15000}
  ],
  "total": 115000,
  "status": "completed"
});
```

### Key-Value Patterns

Проектирование схем для key-value хранилищ (Redis, DynamoDB):

**Key Design Strategies:**

| Стратегия | Описание | Пример |
|-----------|----------|--------|
| **Namespace prefix** | Группировка по типу | `user:123:profile` |
| **Composite keys** | Составные ключи | `order:user:123:date:2026-02` |
| **Hash-based** | Хэширование для распределения | `shard:hash(key):data` |
| **Time-based** | Временная организация | `logs:2026:02:23` |

**Redis Data Structures:**

```redis
# String - простые значения
SET user:123:profile "{\"name\":\"Иван\",\"email\":\"ivan@example.com\"}"
GET user:123:profile

# Hash - объекты
HSET user:123:name "Иван Иванов"
HSET user:123:email "ivan@example.com"
HSET user:123:created "2026-01-01"
HGETALL user:123

# List - упорядоченные списки
RPUSH user:123:activity "login"
RPUSH user:123:activity "view_product"
RPUSH user:123:activity "add_to_cart"
LRANGE user:123:activity 0 -1

# Sorted Set - ранжированные списки
ZADD leaderboard:global 1500 "player_001"
ZADD leaderboard:global 2300 "player_002"
ZREVRANGE leaderboard:global 0 9 WITHSCORES

# Set - уникальные значения
SADD user:123:tokens "token_abc"
SADD user:123:tokens "token_xyz"
SMEMBERS user:123:tokens
```

**TTL и Expiration:**

```redis
# Кэш сессии с TTL 30 минут
SET session:abc123 "{\"user_id\":123,\"expires\":\"2026-02-23T15:30:00Z\"}"
EXPIRE session:abc123 1800

# Кэш товара с TTL 1 час
SET product:456:cache "{\"name\":\"Ноутбук\",\"price\":50000}"
EXPIRE product:456:cache 3600

# Проверка TTL
TTL session:abc123
```

**DynamoDB Design:**

```json
{
  "TableName": "Orders",
  "KeySchema": [
    {"AttributeName": "customer_id", "KeyType": "HASH"},
    {"AttributeName": "order_date", "KeyType": "RANGE"}
  ],
  "AttributeDefinitions": [
    {"AttributeName": "customer_id", "AttributeType": "N"},
    {"AttributeName": "order_date", "AttributeType": "S"},
    {"AttributeName": "status", "AttributeType": "S"}
  ],
  "GlobalSecondaryIndexes": [
    {
      "IndexName": "StatusDateIndex",
      "KeySchema": [
        {"AttributeName": "status", "KeyType": "HASH"},
        {"AttributeName": "order_date", "KeyType": "RANGE"}
      ],
      "Projection": {"ProjectionType": "ALL"}
    }
  ],
  "BillingMode": "PAY_PER_REQUEST"
}
```

### Access Patterns

Проектирование под паттерны доступа к данным:

**Query-Driven Design:**

| Паттерн доступа | Решение в NoSQL |
|-----------------|-----------------|
| **Find by ID** | Primary Key |
| **Find by user** | Partition Key = user_id |
| **Find by date range** | Sort Key = date |
| **Full text search** | Elasticsearch integration |
| **Geospatial** | Geohash indexes |
| **Aggregation** | Materialized views / ETL |

**Analysis Process:**

```
1. Сбор паттернов доступа:
   - Какие запросы выполняются?
   - Частота каждого запроса?
   - Требования к latency?

2. Определение Partition Key:
   - Высококардинальные поля
   - Равномерное распределение
   - Избегать hot partitions

3. Определение Sort Key:
   - Упорядочение результатов
   - Range queries
   - Составные индексы

4. Denormalization:
   - Дублирование для read-heavy
   - Write-heavy = нормализация
```

**Пример анализа паттернов:**

```
Система заказов - паттерны доступа:

1. "Получить заказ по ID" → Primary Key
2. "Получить все заказы пользователя" → partition key = customer_id
3. "Получить заказы за период" → sort key = order_date
4. "Получить заказы по статусу" → GSI status + order_date
5. "Получить популярные товары" → отдельная таблица/кеш

Решение:
- Primary Key: customer_id#order_id
- Sort Key: order_date
- GSI: status#order_date
```

### Consistency Models

Понимание и применение моделей согласованности:

**CAP Theorem:**

```
        /\
       /  \
      /    \
     /      \
    /   CA   \
   /          \
  /     P      \
 /              \
/________________\
   C = Consistency (Согласованность)
   A = Availability (Доступность)
   P = Partition Tolerance (Устойчивость к разделению)

Вывод: При сетевом разделении необходимо выбрать между C и A
```

**Модели согласованности:**

| Модель | Описание | Пример БД | Применение |
|--------|----------|-----------|------------|
| **Strong Consistency** | Все читают последнюю запись | MongoDB (по умолчанию), DynamoDB (настроеваемо) | Банковские операции |
| **Eventual Consistency** | Чтение может вернуть старые данные | Cassandra, DynamoDB (по умолчанию), Riak | Лайки, комментарии |
| **Causal Consistency** | Учитывается причинность | Cosmos DB | Чат, уведомления |
| **Read Your Writes** | Чтение увидит свои записи | MongoDB (session) | Профили пользователей |

**Eventual Consistency Patterns:**

```javascript
// Optimistic updates - последняя запись побеждает
async function updateUserProfile(userId, updates) {
  const current = await db.get(userId);
  const updated = { ...current, ...updates, version: current.version + 1 };
  await db.put(userId, updated);
}

// Vector clocks - отслеживание версий
{
  "user:123": {
    "data": { "name": "Иван" },
    "vector_clock": {
      "node1": 3,
      "node2": 1
    }
  }
}

// Tombstones - мягкое удаление
{
  "_id": "order_001",
  "status": "cancelled",
  "_deleted": true,
  "deleted_at": ISODate("2026-02-23")
}
```

**Multi-Region Considerations:**

| Сценарий | Решение |
|----------|---------|
| Глобальное чтение | Репликация в несколько регионов |
| Локальная запись | Conflict resolution на запись |
| Compliance (GDPR) | Изоляция данных по регионам |
| Disaster Recovery | Async между реги replicationонами |

### NoSQL Types Comparison

Сравнение типов NoSQL баз данных:

| Тип | Представители | Сильные стороны | Слабые стороны | Применение |
|-----|---------------|-----------------|----------------|------------|
| **Document** | MongoDB, CouchDB | Гибкая схема, JSON | Ограниченные JOIN | Каталоги, контент, профили |
| **Key-Value** | Redis, DynamoDB | Высокая скорость, простоту | Ограниченные запросы | Кэш, сессии, очереди |
| **Column-family** | Cassandra, HBase | Масштабируемость | Сложность | Analytics, time-series |
| **Graph** | Neo4j, Amazon Neptune | Сложные связи | Специализация | Соцсети, рекомендации |
| **Wide-column** | ScyllaDB, Bigtable | Петabyte масштаб | Сложность запросов | IoT, логи |

## Интеграция с Project Manager

### Данные для Project Manager

Предоставляет следующие данные для PM:

**Выбор типа NoSQL:**

| Критерий | Рекомендация |
|----------|--------------|
| Гибкая схема | Document (MongoDB) |
| Высокая скорость чтения | Key-Value (Redis) |
| Максимальное масштабирование | Column-family (Cassandra) |
| Сложные связи | Graph (Neo4j) |
| Глобальное распределение | DynamoDB, Cosmos DB |

**Оценка сложности:**

| Сложность | Критерии | Оценка времени |
|-----------|----------|----------------|
| **Простая** | 2-3 коллекции, простые ключи | 8-16 часов |
| **Средняя** | 5-10 коллекций, индексы, 2-3 GSI | 16-40 часов |
| **Сложная** | 10+ коллекций, сложные агрегации, multi-region | 40-80 часов |

**Требования к инфраструктуре:**

| Тип NoSQL | Требования |
|-----------|------------|
| MongoDB | 3+ nodes replica set, 8GB RAM minimum |
| Redis | Sentinel/Cluster, memory sizing по данным |
| Cassandra | 3+ nodes, SSD recommended |
| DynamoDB | Serverless или provisioned capacity |

**Риски масштабирования:**

| Риск | Вероятность | Влияние | Митигация |
|------|-------------|---------|------------|
| Hot partitions | Средняя | Высокое | Равномерное распределение ключей |
| Large documents | Средняя | Среднее | Разбиение на chunks |
| Memory pressure | Высокая | Высокое | Правильный sizing |
| Consistency issues | Средняя | Высокое | Transaction support |
| Cross-region latency | Средняя | Среднее | Репликация на запись |

### Взаимодействие

- PM запрашивает выбор NoSQL технологии для проекта
- PM получает данные для оценки времени разработки
- PM использует метрики для планирования инфраструктуры
- SA валидирует решение с PM перед передачей в universal-coding-agent
- SA предоставляет рекомендации по partition key и индексам

## Примеры использования

### Пример 1: Document Schema для E-commerce (MongoDB)

**Коллекция Products:**

```javascript
// Products - гибкая схема для разных категорий товаров
db.products.insertMany([
  {
    "_id": ObjectId("..."),
    "sku": "LAPTOP-001",
    "name": "Ноутбук ProBook 15",
    "category": "electronics",
    "price": 50000,
    "stock": 25,
    "attributes": {
      "processor": "Intel i7",
      "ram": "16GB",
      "storage": "512GB SSD",
      "display": "15.6 IPS"
    },
    "tags": ["laptop", "windows", "gaming"],
    "variants": [
      {"color": "black", "sku": "LAPTOP-001-BLK"},
      {"color": "silver", "sku": "LAPTOP-001-SLV"}
    ],
    "created_at": ISODate("2026-01-15"),
    "updated_at": ISODate("2026-02-01")
  },
  {
    "_id": ObjectId("..."),
    "sku": "TSHIRT-001",
    "name": "Фирменная футболка",
    "category": "clothing",
    "price": 2500,
    "stock": 100,
    "attributes": {
      "size": "M",
      "color": "white",
      "material": "cotton"
    },
    "sizes": ["S", "M", "L", "XL"],
    "colors": ["white", "black", "gray"],
    "created_at": ISODate("2026-01-20")
  }
]);

// Индексы
db.products.createIndex({ "sku": 1 }, { unique: true });
db.products.createIndex({ "category": 1, "price": 1 });
db.products.createIndex({ "tags": 1 });
db.products.createIndex({ "name": "text", "description": "text" });
```

**Коллекция Orders с вложенными items:**

```javascript
db.orders.insertOne({
  "_id": ObjectId("..."),
  "order_number": "ORD-2026-00001",
  "customer_id": ObjectId("customer_ref"),
  "customer_name": "Иван Иванов",  // Денормализовано
  "status": "processing",
  "items": [
    {
      "product_id": ObjectId("product_ref"),
      "sku": "LAPTOP-001",
      "name": "Ноутбук ProBook 15",
      "quantity": 1,
      "unit_price": 50000,
      "discount": 5000,
      "line_total": 45000
    }
  ],
  "subtotal": 45000,
  "tax": 4500,
  "shipping": 500,
  "total": 50000,
  "shipping_address": {
    "street": "Ленина 1",
    "city": "Москва",
    "postal_code": "123456"
  },
  "created_at": ISODate("2026-02-23T10:00:00Z"),
  "updated_at": ISODate("2026-02-23T10:00:00Z")
});

// Индексы для частых запросов
db.orders.createIndex({ "customer_id": 1, "created_at": -1 });
db.orders.createIndex({ "status": 1, "created_at": -1 });
db.orders.createIndex({ "order_number": 1 }, { unique: true });
```

### Пример 2: Key-Value Schema для кэширования (Redis)

**User Session Cache:**

```javascript
// Кэш сессии пользователя - структура Hash
HMSET session:user_123:abc456 
  user_id 123
  username "ivan_ivanov"
  email "ivan@example.com"
  created_at "2026-02-23T10:00:00Z"
  expires_at "2026-02-23T11:30:00Z"
  permissions "read,write,delete"

EXPIRE session:user_123:abc456 5400  // 90 минут

// Профиль пользователя - JSON в String
SET user:123:profile 
  '{"name":"Иван Иванов","avatar":"https://cdn.example.com/avatars/123.jpg","bio":"Full-stack разработчик"}'
  
GET user:123:profile
```

**Shopping Cart:**

```javascript
// Корзина пользователя - Hash с TTL
HSET cart:123:session_abc
  item_001 "{\"product_id\":1,\"name\":\"Ноутбук\",\"qty\":1,\"price\":50000}"
  item_002 "{\"product_id\":2,\"name\":\"Мышь\",\"qty\":2,\"price\":1500}"

// Метаданные корзины
HSET cart:123:session_abc:meta
  total_items 3
  total_price 53000
  updated_at "2026-02-23T14:30:00Z"

EXPIRE cart:123:session_abc 86400  // 24 часа

// Список избранного - Set
SADD favorites:123 1 5 8 15 23
SMEMBERS favorites:123

// История просмотров - List ( последние 100)
LPUSH view_history:123 "product_001"
LPUSH view_history:123 "product_005"
LPUSH view_history:123 "product_008"
LTRIM view_history:123 0 99  // Ограничить 100
```

**Rate Limiting:**

```javascript
// Лимитирование запросов - sliding window
INCR rate_limit:api:user_123:202602231430
EXPIRE rate_limit:api:user_123:202602231430 60

// Проверка лимита
GET rate_limit:api:user_123:202602231430
// Если > 100, заблокировать доступ
```

### Пример 3: Access Pattern Analysis для high-load системы

**Система аналитики событий:**

```
Паттерны доступа:
1. Записать событие (WRITE) - 10,000 RPS
2. Получить событие по ID (READ) - 1,000 RPS
3. События пользователя за период (READ) - 500 RPS
4. Агрегация по типу события (READ) - 100 RPS
5. Получить последние события (READ) - 5,000 RPS

Проектирование решения (Cassandra):
- Partition Key: event_type + date (события одного дня в одном partition)
- Clustering Column: timestamp (сортировка по времени)
- Materialized Views: для разных паттернов чтения

CREATE TABLE events (
  event_type text,
  date text,
  timestamp timeuuid,
  user_id int,
  payload text,
  PRIMARY KEY ((event_type, date), timestamp)
) WITH CLUSTERING ORDER BY (timestamp DESC);

CREATE MATERIALIZED VIEW events_by_user AS
SELECT * FROM events
WHERE user_id IS NOT NULL AND date IS NOT NULL AND timestamp IS NOT NULL
PRIMARY KEY (user_id, date, timestamp);

CREATE MATERIALIZED VIEW latest_events AS
SELECT * FROM events
WHERE date IS NOT NULL AND timestamp IS NOT NULL
PRIMARY KEY (date, timestamp);
```

## Лучшие практики

### Document Design

1. **Начинайте с паттернов доступа** — не с сущностей
2. **Используйте вложение для related данных** — избегайте лишних запросов
3. **Денормализуйте для read-heavy** — но документируйте
4. **Избегайте слишком больших документов** — MongoDB limit 16MB
5. **Используйте правильные типы данных** — не храните числа как строки
6. **Создавайте индексы точечно** — по реальным запросам

### Key-Value Design

1. **Выбирайте правильную структуру** — String vs Hash vs List
2. **Используйте TTL** — для автоматической очистки
3. **Key naming convention** —一致的 именование
4. **Не храните всё в памяти** — используйте Redis persistence
5. **Consider data serialization** — JSON vs MessagePack vs Protobuf
6. **Plan for hot keys** — replica или fanout

### Consistency

1. **Понимайте требования** — strong vs eventual
2. **Используйте транзакции** — когда нужна атомарность
3. **Handle conflicts** — last-write-wins vs custom resolution
4. **Monitor replication lag** — для eventual consistency
5. **Test failure scenarios** — partition tolerance

### Scalability

1. **Design for partition** — данные должны распределяться
2. **Avoid monotonically increasing keys** — sequential writes problem
3. **Consider read replicas** — для read-heavy workloads
4. **Plan capacity** — provisioning vs on-demand
5. **Monitor hot partitions** — early detection

## Связанные навыки

- **data-modeling** — проектирование реляционных моделей (альтернативный подход)
- **sql-development** — SQL запросы (при необходимости интеграции)
- **api-design** — проектирование API (использует NoSQL для backend)
- **c4-architecture** — архитектура системы с выбором хранилища

---
