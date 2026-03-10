---
name: test-data-management
description: Strategies for creating, maintaining, and protecting test data. Use when preparing test data, managing data privacy, ensuring data availability.
---

# Test Data Management

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for creating, maintaining, and protecting test data. Designed for effective test data strategies, data privacy compliance, data generation techniques, and test environment management.

## When to Use

Use this skill:
- When preparing test data for test execution
- For managing sensitive data in tests
- When creating test data strategies
- For data generation and automation
- During test environment setup
- When ensuring data privacy compliance
- For test data refresh procedures

## Functions

### Test Data Strategy

Developing test data approaches:

```markdown
## Test Data Strategy Components

### Data Requirements Analysis
| Phase | Data Needs | Sources |
|-------|-----------|---------|
| Unit Testing | Mock data | Code-generated |
| Integration | Sample data | Test DB |
| System Testing | Full dataset | Production-like |
| Performance | Large dataset | Generated |
| UAT | Realistic data | Anonymized production |

### Test Data Types
- **Positive Data** — valid, expected values
- **Negative Data** — invalid, boundary values
- **Boundary Data** — edge case values
- **Large Data** — performance testing
- **Complex Data** — nested relationships

### Data Management Principles
1. **Availability** — data ready when needed
2. **Quality** — accurate and consistent
3. **Security** — protected and compliant
4. **Reusability** — can be used multiple times
5. **Traceability** — known source and purpose
```

### Test Data Generation

Creating test data programmatically:

```markdown
## Test Data Generation Methods

### Faker Library (Python)
```python
from faker import Faker
import random

fake = Faker()

# Generate user data
def generate_user():
    return {
        "id": fake.uuid4(),
        "username": fake.user_name(),
        "email": fake.email(),
        "first_name": fake.first_name(),
        "last_name": fake.last_name(),
        "phone": fake.phone_number(),
        "address": fake.address(),
        "date_of_birth": fake.date_of_birth(minimum_age=18, maximum_age=65),
        "created_at": fake.iso8601()
    }

# Generate multiple users
users = [generate_user() for _ in range(100)]

# Generate company data
def generate_company():
    return {
        "name": fake.company(),
        "catch_phrase": fake.catch_phrase(),
        "address": fake.street_address(),
        "city": fake.city(),
        "country": fake.country(),
        "phone": fake.phone_number(),
        "email": fake.company_email(),
        "website": fake.domain_name()
    }
```

### SQL Test Data

```sql
-- Generate test users
INSERT INTO users (username, email, password_hash, created_at)
SELECT 
    'test_user_' || generate_series,
    'test' || generate_series || '@example.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYqKx8pKv6y',
    NOW() - (random() * INTERVAL '30 days')
FROM generate_series(1, 1000);

-- Generate test orders
INSERT INTO orders (user_id, product_id, quantity, total, status, created_at)
SELECT 
    (random() * 999 + 1)::integer,
    (random() * 99 + 1)::integer,
    (random() * 5 + 1)::integer,
    (random() * 500 + 10)::decimal(10,2),
    (ARRAY['pending', 'processing', 'shipped', 'delivered'])[floor(random() * 4 + 1)],
    NOW() - (random() * INTERVAL '60 days')
FROM generate_series(1, 5000);
```

### Test Data Templates

```markdown
## Test Data Templates

### User Registration Template
```json
{
  "valid_user": {
    "username": "testuser001",
    "email": "testuser@example.com",
    "password": "TestPass123!",
    "firstName": "Test",
    "lastName": "User",
    "phone": "+1234567890",
    "country": "US",
    "dateOfBirth": "1990-01-15"
  },
  "invalid_email": {
    "email": "invalid-email"
  },
  "weak_password": {
    "password": "123"
  },
  "empty_fields": {}
}
```

### Product Template
```json
{
  "valid_product": {
    "name": "Test Product",
    "price": 99.99,
    "category": "Electronics",
    "stock": 100,
    "description": "Test product description"
  },
  "negative_price": {
    "price": -10
  },
  "zero_stock": {
    "stock": 0
  },
  "missing_fields": {
    "name": "Test"
  }
}
```

### Test Data Hierarchy
```
TestData/
├── Users/
│   ├── valid_users.json
│   ├── users_with_orders.json
│   ├── suspended_users.json
│   └── users_for_auth.json
├── Products/
│   ├── all_products.json
│   ├── out_of_stock.json
│   └── discounted_products.json
├── Orders/
│   ├── pending_orders.json
│   ├── completed_orders.json
│   └── cancelled_orders.json
└── Fixtures/
    ├── load_data.sql
    └── setup.py
```

### Data Masking

Protecting sensitive data:

```markdown
## Data Masking Techniques

### PII Categories
| Category | Examples | Masking Method |
|----------|----------|----------------|
| Personal | Name, DOB | Pseudonymization |
| Contact | Email, Phone | Partial masking |
| Financial | Card, Account | Tokenization |
| Medical | Health data | Encryption |
| Auth | Password, SSN | Hashing |

### Data Masking Examples
```python
import hashlib
import re

def mask_email(email):
    """Mask email address"""
    parts = email.split('@')
    if len(parts) == 2:
        return f"{parts[0][:2]}***@{parts[1]}"
    return "***@***.***"

def mask_phone(phone):
    """Mask phone number"""
    digits = re.sub(r'\D', '', phone)
    return f"+***-***-**{digits[-2:]}"

def mask_card(card_number):
    """Mask credit card"""
    return f"****-****-****-{card_number[-4:]}"

def hash_password(password):
    """Hash password"""
    return hashlib.sha256(password.encode()).hexdigest()

def tokenize(value, token_map):
    """Tokenize sensitive value"""
    if value not in token_map:
        token_map[value] = f"TOKEN_{len(token_map) + 1}"
    return token_map[value]
```

### Test Data Environment

Managing test environments:

```markdown
## Test Data Environments

### Environment Types
| Environment | Data Source | Refresh | Privacy |
|-------------|-------------|---------|---------|
| Development | Subset | Daily | Masked |
| QA | Sample | Weekly | Masked |
| Staging | Production-like | Monthly | Anonymized |
| UAT | Sanitized | Per cycle | Realistic |

### Data Refresh Strategy
```
Production → Extraction → Sanitization → Loading → Verification
    ↓              ↓            ↓            ↓          ↓
  Source     Filter PII     Transform   Target DB   Validate
```

### Data Subset Strategies
1. **Size-based** — reduce data volume
2. **Coverage-based** — cover all scenarios
3. **Time-based** — recent data only
4. **Coverage-based** — critical paths only
```

## Usage Examples

### Example 1: Test Data Generation Script

```python
# test_data_generator.py
import json
import random
from datetime import datetime, timedelta
from faker import Faker

fake = Faker()

def generate_test_data(scenarios):
    """Generate test data based on scenarios"""
    data = {}
    
    if "user_registration" in scenarios:
        data["registration"] = {
            "valid": generate_valid_user(),
            "invalid_email": generate_user(email="invalid"),
            "weak_password": generate_user(password="123"),
            "duplicate_email": generate_user(email="existing@example.com")
        }
    
    if "ecommerce" in scenarios:
        data["ecommerce"] = {
            "cart": generate_cart(),
            "checkout": generate_checkout_data()
        }
    
    return data

def generate_valid_user():
    return {
        "username": fake.user_name() + str(random.randint(1, 999)),
        "email": fake.email(),
        "password": "TestPass123!",
        "first_name": fake.first_name(),
        "last_name": fake.last_name(),
        "phone": fake.phone_number(),
        "address": {
            "street": fake.street_address(),
            "city": fake.city(),
            "state": fake.state_abbr(),
            "zip": fake.zipcode(),
            "country": "US"
        }
    }

# Save to file
with open("test_data.json", "w") as f:
    json.dump(generate_test_data(["user_registration", "ecommerce"]), f, indent=2)
```

### Example 2: Database Test Data Setup

```sql
-- test_data_setup.sql

-- Clean existing test data
TRUNCATE TABLE users, orders, products CASCADE;

-- Insert test users
INSERT INTO users (username, email, password_hash, role, is_active)
VALUES 
    ('admin', 'admin@test.com', 'hash1', 'admin', true),
    ('testuser1', 'user1@test.com', 'hash2', 'user', true),
    ('testuser2', 'user2@test.com', 'hash3', 'user', true),
    ('suspended', 'suspended@test.com', 'hash4', 'user', false);

-- Insert test products
INSERT INTO products (name, price, stock, category, is_active)
VALUES 
    ('Laptop', 999.99, 50, 'Electronics', true),
    ('Mouse', 29.99, 200, 'Electronics', true),
    ('Keyboard', 79.99, 150, 'Electronics', true),
    ('Out of Stock Item', 49.99, 0, 'Electronics', true);

-- Insert test orders
INSERT INTO orders (user_id, status, total, created_at)
VALUES 
    (2, 'pending', 1029.98, NOW() - INTERVAL '1 day'),
    (2, 'completed', 29.99, NOW() - INTERVAL '3 days'),
    (3, 'shipped', 79.99, NOW() - INTERVAL '2 days');

-- Verify data
SELECT 'Users: ' || COUNT(*) FROM users
UNION ALL
SELECT 'Products: ' || COUNT(*) FROM products
UNION ALL
SELECT 'Orders: ' || COUNT(*) FROM orders;
```

## Document Templates

### Test Data Requirements Document

```markdown
## Test Data Requirements

### Project: {Project Name}
**Date:** {Date}
**Version:** {Version}

### Data Requirements

#### Functional Tests
| Scenario | Data Needed | Source | Volume |
|----------|-------------|--------|--------|
| Login | Valid users | Generated | 10 |
| Login Fail | Invalid users | Generated | 20 |
| Registration | Unique emails | Generated | 50 |

#### Performance Tests
| Scenario | Data Needed | Source | Volume |
|----------|-------------|--------|--------|
| Search | Large product set | Generated | 10,000 |
| Reports | Historical orders | Generated | 100,000 |

#### Security Tests
| Scenario | Data Needed | Source | Volume |
|----------|-------------|--------|--------|
| SQL Injection | Test payloads | Manual | 20 |
| XSS | Test payloads | Manual | 20 |

### Data Privacy
- [ ] PII identified
- [ ] Masking rules defined
- [ ] Access controls in place
- [ ] Compliance verified

### Maintenance
- Data refresh: {frequency}
- Owner: {role}
- Last updated: {date}
```

### Test Data Inventory

```markdown
## Test Data Inventory

### Data Assets
| Dataset | Description | Size | Owner | Last Updated |
|---------|-------------|------|-------|--------------|
| users_100 | Test users | 100 | QA Team | 2026-03-01 |
| products_1k | Product catalog | 1,000 | QA Team | 2026-03-01 |
| orders_10k | Historical orders | 10,000 | DB Admin | 2026-02-15 |

### Data Access
| Dataset | Environment | Access Level | Location |
|---------|-------------|--------------|----------|
| users_100 | Dev/QA | Read/Write | Local |
| products_1k | Dev/QA/Staging | Read | Shared |
| orders_10k | Performance | Read Only | Staging |

### Data Quality Checks
- [ ] Completeness verified
- [ ] Consistency checked
- [ ] Freshness confirmed
- [ ] Privacy compliance
```

## Best Practices

### Test Data Creation

1. **Automate generation** — scripts over manual entry
2. **Use realistic data** — Faker, production-like
3. **Cover edge cases** — boundary values
4. **Version control** — track changes
5. **Document sources** — know where data came from

### Data Privacy

1. **Identify PII** — know what's sensitive
2. **Apply masking** — always in non-prod
3. **Minimize data** — only what's needed
4. **Control access** — limit who can see
5. **Comply with regulations** — GDPR, etc.

### Data Maintenance

1. **Regular refresh** — keep data current
2. **Cleanup routines** — remove stale data
3. **Versioning** — track schema changes
4. **Monitoring** — check data quality
5. **Backup** — protect test data

## Related Skills

- test-case-design — test data requirements
- test-automation-frameworks — data-driven tests
- performance-testing — load test data
- security-testing — sensitive data handling
- test-management-tools — test data tracking

---
*Test Data Management — ensuring the right data is available for testing
