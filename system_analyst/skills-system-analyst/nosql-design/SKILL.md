---
name: nosql-design
description: Designing NoSQL data schemas: Document Design (MongoDB, CouchDB), Key-Value Patterns (Redis, DynamoDB), Access Patterns Analysis, Consistency Models (CAP theorem, eventual vs strong consistency), choosing NoSQL database type
---

# NoSQL Design

> **Meta:** v1.0.0 | 23-02-2026

## Purpose

Skill for designing NoSQL data schemas and selecting the optimal NoSQL database for specific requirements. Includes analyzing data access patterns, designing document models, key-value structures, understanding consistency models (CAP theorem), and choosing between different types of NoSQL databases.

This skill is an alternative to relational design (`data-modeling`) and provides NoSQL schemas for implementation in universal-coding-agent when working with non-relational stores.

## When to Use

Use this skill:

- When designing a system with high read load
- For data with flexible or changing structure
- When horizontal scaling is needed
- For geographically distributed systems
- When working with semi-structured data (logs, events, JSON)
- When choosing between Document, Key-Value, Column-family, or Graph NoSQL databases
- For designing for specific access patterns
- When evaluating consistency vs availability trade-offs

## Functions

### Document Design

Schema design for document databases (MongoDB, CouchDB):

**Document Design Principles:**

| Principle | Description | Example |
|-----------|-------------|---------|
| **Embedding** | Storing related data in one document | Order with line items |
| **Referencing** | Storing references between documents | User and orders |
| **Denormalization** | Duplicating data for read optimization | User name in order |

**When to Use Embedding:**

- Data "always loaded together"
- "One-to-few" or "one-to-many" relationships with small quantities
- Data not updated independently from each other

**When to Use References:**

- "Many-to-many" relationships
- Large data arrays
- Data frequently updated independently

**Schema Design Patterns:**

```javascript
// Pattern: Attribute Pattern (for optional fields)
{
  "_id": "product_001",
  "name": "Laptop",
  "attributes": {
    "color": "black",
    "weight": "2kg",
    "warranty": "2 years"
  }
}

// Pattern: Extended Reference Pattern (denormalized references)
{
  "_id": "order_12345",
  "customer_name": "John Doe",  // Denormalized
  "customer_email": "john@example.com",  // Denormalized
  "items": [...],
  "total": 50000
}

// Pattern: Subset Pattern (storing frequently used data)
{
  "_id": "user_001",
  "name": "John Doe",
  "recent_orders": [  // Only last 5 orders
    {"id": "order_1", "date": "2026-01-15", "total": 5000},
    {"id": "order_2", "date": "2026-02-01", "total": 7500}
  ]
}

// Pattern: Bucket Pattern (data aggregation)
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
// Users collection - embedded data for one-to-few
db.users.insertOne({
  "_id": ObjectId("..."),
  "email": "user@example.com",
  "profile": {
    "first_name": "John",
    "last_name": "Doe",
    "phones": ["+1-555-123-4567"],
    "addresses": [
      {"type": "billing", "city": "New York", "street": "Main St 1"},
      {"type": "shipping", "city": "New York", "street": "Oak Ave 10"}
    ]
  },
  "created_at": ISODate("2026-01-01"),
  "updated_at": ISODate("2026-02-01")
});

// Orders collection - references for one-to-many
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

Schema design for key-value stores (Redis, DynamoDB):

**Key Design Strategies:**

| Strategy | Description | Example |
|----------|-------------|---------|
| **Namespace prefix** | Grouping by type | `user:123:profile` |
| **Composite keys** | Composite keys | `order:user:123:date:2026-02` |
| **Hash-based** | Hashing for distribution | `shard:hash(key):data` |
| **Time-based** | Time-based organization | `logs:2026:02:23` |

**Redis Data Structures:**

```redis
# String - simple values
SET user:123:profile "{\"name\":\"John\",\"email\":\"john@example.com\"}"
GET user:123:profile

# Hash - objects
HSET user:123:name "John Doe"
HSET user:123:email "john@example.com"
HSET user:123:created "2026-01-01"
HGETALL user:123

# List - ordered lists
RPUSH user:123:activity "login"
RPUSH user:123:activity "view_product"
RPUSH user:123:activity "add_to_cart"
LRANGE user:123:activity 0 -1

# Sorted Set - ranked lists
ZADD leaderboard:global 1500 "player_001"
ZADD leaderboard:global 2300 "player_002"
ZREVRANGE leaderboard:global 0 9 WITHSCORES

# Set - unique values
SADD user:123:tokens "token_abc"
SADD user:123:tokens "token_xyz"
SMEMBERS user:123:tokens
```

**TTL and Expiration:**

```redis
# Session cache with 30 minute TTL
SET session:abc123 "{\"user_id\":123,\"expires\":\"2026-02-23T15:30:00Z\"}"
EXPIRE session:abc123 1800

# Product cache with 1 hour TTL
SET product:456:cache "{\"name\":\"Laptop\",\"price\":50000}"
EXPIRE product:456:cache 3600

# Check TTL
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

Designing for data access patterns:

**Query-Driven Design:**

| Access Pattern | NoSQL Solution |
|---------------|----------------|
| **Find by ID** | Primary Key |
| **Find by user** | Partition Key = user_id |
| **Find by date range** | Sort Key = date |
| **Full text search** | Elasticsearch integration |
| **Geospatial** | Geohash indexes |
| **Aggregation** | Materialized views / ETL |

**Analysis Process:**

```
1. Collect access patterns:
   - What queries are executed?
   - Frequency of each query?
   - Latency requirements?

2. Determine Partition Key:
   - High-cardinality fields
   - Even distribution
   - Avoid hot partitions

3. Determine Sort Key:
   - Result ordering
   - Range queries
   - Composite indexes

4. Denormalization:
   - Duplication for read-heavy
   - Write-heavy = normalization
```

**Pattern Analysis Example:**

```
Order System - Access Patterns:

1. "Get order by ID" → Primary Key
2. "Get all user orders" → partition key = customer_id
3. "Get orders for period" → sort key = order_date
4. "Get orders by status" → GSI status + order_date
5. "Get popular products" → separate table/cache

Solution:
- Primary Key: customer_id#order_id
- Sort Key: order_date
- GSI: status#order_date
```

### Consistency Models

Understanding and applying consistency models:

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
   C = Consistency
   A = Availability
   P = Partition Tolerance

Conclusion: During network partition, must choose between C and A
```

**Consistency Models:**

| Model | Description | DB Example | Use Case |
|-------|-------------|------------|----------|
| **Strong Consistency** | All reads see latest write | MongoDB (default), DynamoDB (configurable) | Banking operations |
| **Eventual Consistency** | Reads may return stale data | Cassandra, DynamoDB (default), Riak | Likes, comments |
| **Causal Consistency** | Causality considered | Cosmos DB | Chat, notifications |
| **Read Your Writes** | Reads will see own writes | MongoDB (session) | User profiles |

**Eventual Consistency Patterns:**

```javascript
// Optimistic updates - last write wins
async function updateUserProfile(userId, updates) {
  const current = await db.get(userId);
  const updated = { ...current, ...updates, version: current.version + 1 };
  await db.put(userId, updated);
}

// Vector clocks - version tracking
{
  "user:123": {
    "data": { "name": "John" },
    "vector_clock": {
      "node1": 3,
      "node2": 1
    }
  }
}

// Tombstones - soft delete
{
  "_id": "order_001",
  "status": "cancelled",
  "_deleted": true,
  "deleted_at": ISODate("2026-02-23")
}
```

**Multi-Region Considerations:**

| Scenario | Solution |
|----------|----------|
| Global reads | Replication to multiple regions |
| Local writes | Conflict resolution on write |
| Compliance (GDPR) | Data isolation by region |
| Disaster Recovery | Async replication between regions |

### NoSQL Types Comparison

Comparison of NoSQL database types:

| Type | Representatives | Strengths | Weaknesses | Use Case |
|-----|-----------------|-----------|------------|----------|
| **Document** | MongoDB, CouchDB | Flexible schema, JSON | Limited JOINs | Catalogs, content, profiles |
| **Key-Value** | Redis, DynamoDB | High speed, simplicity | Limited queries | Cache, sessions, queues |
| **Column-family** | Cassandra, HBase | Scalability | Complexity | Analytics, time-series |
| **Graph** | Neo4j, Amazon Neptune | Complex relationships | Specialization | Social networks, recommendations |
| **Wide-column** | ScyllaDB, Bigtable | Petabyte scale | Query complexity | IoT, logs |

## Integration with Project Manager

### Data for Project Manager

Provides the following data for PM:

**NoSQL Type Selection:**

| Criteria | Recommendation |
|----------|-----------------|
| Flexible schema | Document (MongoDB) |
| High read speed | Key-Value (Redis) |
| Maximum scaling | Column-family (Cassandra) |
| Complex relationships | Graph (Neo4j) |
| Global distribution | DynamoDB, Cosmos DB |

**Complexity Estimation:**

| Complexity | Criteria | Time Estimate |
|------------|----------|---------------|
| **Simple** | 2-3 collections, simple keys | 8-16 hours |
| **Medium** | 5-10 collections, indexes, 2-3 GSI | 16-40 hours |
| **Complex** | 10+ collections, complex aggregations, multi-region | 40-80 hours |

**Infrastructure Requirements:**

| NoSQL Type | Requirements |
|------------|---------------|
| MongoDB | 3+ nodes replica set, 8GB RAM minimum |
| Redis | Sentinel/Cluster, memory sizing by data |
| Cassandra | 3+ nodes, SSD recommended |
| DynamoDB | Serverless or provisioned capacity |

**Scaling Risks:**

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Hot partitions | Medium | High | Even key distribution |
| Large documents | Medium | Medium | Chunking |
| Memory pressure | High | High | Proper sizing |
| Consistency issues | Medium | High | Transaction support |
| Cross-region latency | Medium | Medium | Write-through replication |

### Interaction

- PM requests NoSQL technology selection for the project
- PM receives data for development time estimation
- PM uses metrics for infrastructure planning
- SA validates solution with PM before passing to universal-coding-agent
- SA provides recommendations for partition key and indexes

## Usage Examples

### Example 1: Document Schema for E-commerce (MongoDB)

**Products Collection:**

```javascript
// Products - flexible schema for different product categories
db.products.insertMany([
  {
    "_id": ObjectId("..."),
    "sku": "LAPTOP-001",
    "name": "ProBook 15 Laptop",
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
    "name": "Brand T-Shirt",
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

// Indexes
db.products.createIndex({ "sku": 1 }, { unique: true });
db.products.createIndex({ "category": 1, "price": 1 });
db.products.createIndex({ "tags": 1 });
db.products.createIndex({ "name": "text", "description": "text" });
```

**Orders Collection with embedded items:**

```javascript
db.orders.insertOne({
  "_id": ObjectId("..."),
  "order_number": "ORD-2026-00001",
  "customer_id": ObjectId("customer_ref"),
  "customer_name": "John Doe",  // Denormalized
  "status": "processing",
  "items": [
    {
      "product_id": ObjectId("product_ref"),
      "sku": "LAPTOP-001",
      "name": "ProBook 15 Laptop",
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
    "street": "Main St 1",
    "city": "New York",
    "postal_code": "123456"
  },
  "created_at": ISODate("2026-02-23T10:00:00Z"),
  "updated_at": ISODate("2026-02-23T10:00:00Z")
});

// Indexes for frequent queries
db.orders.createIndex({ "customer_id": 1, "created_at": -1 });
db.orders.createIndex({ "status": 1, "created_at": -1 });
db.orders.createIndex({ "order_number": 1 }, { unique: true });
```

### Example 2: Key-Value Schema for Caching (Redis)

**User Session Cache:**

```javascript
// User session cache - Hash structure
HMSET session:user_123:abc456 
  user_id 123
  username "john_doe"
  email "john@example.com"
  created_at "2026-02-23T10:00:00Z"
  expires_at "2026-02-23T11:30:00Z"
  permissions "read,write,delete"

EXPIRE session:user_123:abc456 5400  // 90 minutes

// User profile - JSON in String
SET user:123:profile 
  '{"name":"John Doe","avatar":"https://cdn.example.com/avatars/123.jpg","bio":"Full-stack developer"}'
  
GET user:123:profile
```

**Shopping Cart:**

```javascript
// User cart - Hash with TTL
HSET cart:123:session_abc
  item_001 "{\"product_id\":1,\"name\":\"Laptop\",\"qty\":1,\"price\":50000}"
  item_002 "{\"product_id\":2,\"name\":\"Mouse\",\"qty\":2,\"price\":1500}"

// Cart metadata
HSET cart:123:session_abc:meta
  total_items 3
  total_price 53000
  updated_at "2026-02-23T14:30:00Z"

EXPIRE cart:123:session_abc 86400  // 24 hours

// Favorites list - Set
SADD favorites:123 1 5 8 15 23
SMEMBERS favorites:123

// View history - List (last 100)
LPUSH view_history:123 "product_001"
LPUSH view_history:123 "product_005"
LPUSH view_history:123 "product_008"
LTRIM view_history:123 0 99  // Limit to 100
```

**Rate Limiting:**

```javascript
// Rate limiting - sliding window
INCR rate_limit:api:user_123:202602231430
EXPIRE rate_limit:api:user_123:202602231430 60

// Check limit
GET rate_limit:api:user_123:202602231430
// If > 100, block access
```

### Example 3: Access Pattern Analysis for High-Load System

**Event Analytics System:**

```
Access Patterns:
1. Write event (WRITE) - 10,000 RPS
2. Get event by ID (READ) - 1,000 RPS
3. User events for period (READ) - 500 RPS
4. Aggregation by event type (READ) - 100 RPS
5. Get latest events (READ) - 5,000 RPS

Solution Design (Cassandra):
- Partition Key: event_type + date (events of one day in one partition)
- Clustering Column: timestamp (sorting by time)
- Materialized Views: for different read patterns

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

## Best Practices

### Document Design

1. **Start with access patterns** — not entities
2. **Use embedding for related data** — avoid extra queries
3. **Denormalize for read-heavy** — but document it
4. **Avoid overly large documents** — MongoDB limit 16MB
5. **Use correct data types** — don't store numbers as strings
6. **Create targeted indexes** — based on actual queries

### Key-Value Design

1. **Choose correct structure** — String vs Hash vs List
2. **Use TTL** — for automatic cleanup
3. **Key naming convention** — consistent naming
4. **Don't store everything in memory** — use Redis persistence
5. **Consider data serialization** — JSON vs MessagePack vs Protobuf
6. **Plan for hot keys** — replica or fanout

### Consistency

1. **Understand requirements** — strong vs eventual
2. **Use transactions** — when atomicity is needed
3. **Handle conflicts** — last-write-wins vs custom resolution
4. **Monitor replication lag** — for eventual consistency
5. **Test failure scenarios** — partition tolerance

### Scalability

1. **Design for partition** — data should distribute evenly
2. **Avoid monotonically increasing keys** — sequential writes problem
3. **Consider read replicas** — for read-heavy workloads
4. **Plan capacity** — provisioning vs on-demand
5. **Monitor hot partitions** — early detection

## Related Skills

- **data-modeling** — relational model design (alternative approach)
- **sql-development** — SQL queries (for integration when needed)
- **api-design** — API design (uses NoSQL for backend)
- **c4-architecture** — system architecture with storage selection
