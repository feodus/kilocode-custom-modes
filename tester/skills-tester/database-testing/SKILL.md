---
name: database-testing
description: Database testing including SQL query validation, data integrity checks, transaction testing, and schema verification. Use when testing database operations, migrations, and data consistency.
---

# Database Testing

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for comprehensive database testing covering SQL query validation, data integrity verification, transaction testing, schema validation, and database performance testing. Essential for ensuring data quality and reliability in applications with database dependencies.

## When to Use

Use this skill:
- When testing database CRUD operations
- For verifying data integrity and constraints
- When testing database migrations
- During schema validation
- For testing stored procedures and triggers
- When validating data transformations
- For database security testing

## Database Testing Types

### Data Integrity Testing

Verifying data accuracy and consistency:

**Constraint Testing:**
- Primary key uniqueness
- Foreign key referential integrity
- NOT NULL constraints
- CHECK constraints
- UNIQUE constraints
- DEFAULT values

**Data Validation:**
- Data type correctness
- Data format validation
- Range validation
- Cross-field validation

### Schema Testing

Database structure verification:

**Table Structure:**
- Column data types
- Column constraints
- Indexes and keys
- Table relationships

**Database Objects:**
- Stored procedures
- Functions
- Triggers
- Views
- Sequences

### SQL Query Testing

Verifying query correctness and performance:

**Query Validation:**
- Expected result set
- Query logic correctness
- Edge cases handling
- NULL handling
- Date/time handling

**Query Performance:**
- Execution time
- Index usage
- Query plan analysis
- Join optimization

### Transaction Testing

Testing database transaction behavior:

**ACID Properties:**
- Atomicity - all or nothing
- Consistency - valid state
- Isolation - concurrent transaction handling
- Durability - data persistence

## Database Testing Tools

### SQL Testing Frameworks

**Python SQL Testing:**
```python
# Database Testing with pytest
import pytest
import sqlite3
from database import DatabaseHandler

class TestDatabase:
    @pytest.fixture
    def db_connection(self):
        """Create test database connection"""
        conn = sqlite3.connect(':memory:')
        yield conn
        conn.close()
    
    @pytest.fixture
    def sample_data(self, db_connection):
        """Insert sample test data"""
        cursor = db_connection.cursor()
        cursor.execute('''
            CREATE TABLE users (
                id INTEGER PRIMARY KEY,
                username TEXT NOT NULL UNIQUE,
                email TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        
        # Insert test data
        cursor.execute('''
            INSERT INTO users (username, email) VALUES 
            ('testuser1', 'user1@example.com'),
            ('testuser2', 'user2@example.com')
        ''')
        db_connection.commit()
        yield cursor
    
    def test_unique_constraint(self, db_connection, sample_data):
        """Test unique constraint violation"""
        with pytest.raises(sqlite3.IntegrityError) as exc_info:
            sample_data.execute('''
                INSERT INTO users (username, email) 
                VALUES ('testuser1', 'duplicate@example.com')
            ''')
            db_connection.commit()
        
        assert 'UNIQUE constraint failed' in str(exc_info.value)
    
    def test_foreign_key_integrity(self, db_connection):
        """Test foreign key constraint"""
        cursor = db_connection.cursor()
        
        # Create tables with foreign key
        cursor.execute('PRAGMA foreign_keys = ON')
        cursor.execute('''
            CREATE TABLE orders (
                id INTEGER PRIMARY KEY,
                user_id INTEGER NOT NULL,
                amount DECIMAL(10,2),
                FOREIGN KEY (user_id) REFERENCES users(id)
            )
        ''')
        
        # Insert valid order
        cursor.execute('INSERT INTO users VALUES (1, "test", "test@test.com")')
        cursor.execute('INSERT INTO orders (user_id, amount) VALUES (1, 100.00)')
        
        # Try invalid foreign key
        with pytest.raises(sqlite3.IntegrityError):
            cursor.execute('INSERT INTO orders (user_id, amount) VALUES (999, 100.00)')
    
    def test_query_results(self, db_connection, sample_data):
        """Test query returns expected results"""
        sample_data.execute('SELECT * FROM users WHERE username = ?', ('testuser1',))
        result = sample_data.fetchone()
        
        assert result is not None
        assert result[1] == 'testuser1'
        assert result[2] == 'user1@example.com'
```

### Data Compare Tools

**Data Validation:**
```python
# Data comparison testing
class TestDataIntegrity:
    def test_record_counts(self, db_connection):
        """Verify record counts match expected"""
        cursor = db_connection.cursor()
        cursor.execute('SELECT COUNT(*) FROM users')
        user_count = cursor.fetchone()[0]
        
        assert user_count == 100  # Expected count
    
    def test_data_aggregation(self, db_connection):
        """Test aggregation queries"""
        cursor = db_connection.cursor()
        cursor.execute('''
            SELECT status, COUNT(*) as count, SUM(amount) as total
            FROM orders
            GROUP BY status
        ''')
        results = cursor.fetchall()
        
        for status, count, total in results:
            assert count > 0
            assert total >= 0
    
    def test_date_range_data(self, db_connection):
        """Test data within date ranges"""
        cursor = db_connection.cursor()
        cursor.execute('''
            SELECT * FROM orders 
            WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31'
        ''')
        results = cursor.fetchall()
        
        assert len(results) > 0
```

### Migration Testing

**Database Migration Verification:**
```python
# Migration testing
class TestDatabaseMigrations:
    def test_migration_up(self, db_connection):
        """Test migration applies correctly"""
        cursor = db_connection.cursor()
        
        # Verify new table exists
        cursor.execute('''
            SELECT name FROM sqlite_master 
            WHERE type='table' AND name='new_feature_table'
        ''')
        result = cursor.fetchone()
        
        assert result is not None
    
    def test_migration_down(self, db_connection):
        """Test rollback capability"""
        cursor = db_connection.cursor()
        
        # Verify table can be dropped
        cursor.execute('DROP TABLE IF EXISTS temporary_table')
        
        cursor.execute('''
            SELECT name FROM sqlite_master 
            WHERE type='table' AND name='temporary_table'
        ''')
        result = cursor.fetchone()
        
        assert result is None
    
    def test_data_preserved_after_migration(self, db_connection):
        """Test data survives migration"""
        # Get data before migration
        cursor = db_connection.cursor()
        cursor.execute('SELECT COUNT(*) FROM users')
        before_count = cursor.fetchone()[0]
        
        # Simulate migration (add column)
        cursor.execute('ALTER TABLE users ADD COLUMN new_column TEXT')
        
        # Verify data preserved
        cursor.execute('SELECT COUNT(*) FROM users')
        after_count = cursor.fetchone()[0]
        
        assert before_count == after_count
```

## Database Testing Best Practices

### Test Data Management

```markdown
## Test Data Strategy

### Data Setup
- Use test databases separate from production
- Create minimal test datasets
- Use realistic but anonymized data
- Maintain data consistency across tests

### Data Categories
| Category | Description | Examples |
|----------|-------------|----------|
| Static Data | Reference data | Countries, currencies |
| Dynamic Data | Transactional data | Orders, payments |
| Edge Cases | Boundary conditions | Empty, max values |

### Data Cleanup
- Use transactions with rollback
- Clean up after each test
- Use database snapshots
- Implement test isolation
```

### SQL Injection Testing

Security validation:

```python
def test_sql_injection_prevention(self, db_connection):
    """Test application is protected against SQL injection"""
    cursor = db_connection.cursor()
    
    malicious_inputs = [
        "' OR '1'='1",
        "' UNION SELECT * FROM users--",
        "'; DROP TABLE users;--",
        "'<script>alert('xss')</script>'"
    ]
    
    for malicious_input in malicious_inputs:
        # Test with parameterized queries
        cursor.execute(
            'SELECT * FROM users WHERE username = ?',
            (malicious_input,)
        )
        # Should not expose data or cause errors
        result = cursor.fetchone()
        assert result is None or isinstance(result, tuple)
```

### Performance Testing

```sql
-- Query performance tests
EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE user_id = 123;

-- Test index usage
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Measure query time
.timer on
SELECT * FROM orders 
JOIN users ON orders.user_id = users.id 
WHERE orders.created_at > '2024-01-01';
```

## Database Testing Checklist

### Pre-Testing
- [ ] Test database created
- [ ] Test data loaded
- [ ] Schema verified
- [ ] Backup available

### Schema Testing
- [ ] All tables exist
- [ ] Columns have correct types
- [ ] Constraints enforced
- [ ] Indexes created
- [ ] Foreign keys valid

### Data Testing
- [ ] CRUD operations work
- [ ] Constraints enforced
- [ ] Data integrity maintained
- [ ] Transactions atomic
- [ ] NULL handling correct

### Performance Testing
- [ ] Queries execute within limits
- [ ] Indexes used properly
- [ ] No deadlocks
- [ ] Connection pooling works

### Security Testing
- [ ] SQL injection prevented
- [ ] Sensitive data encrypted
- [ ] Access controls enforced
- [ ] Audit logging works

## Common Database Test Scenarios

### CRUD Operations
```gherkin
Scenario: Create new user record
  Given the users table is empty
  When I insert a new user with username "newuser"
  And email "newuser@example.com"
  Then the user should be created
  And the user should be retrievable by username

Scenario: Update existing record
  Given a user exists with email "old@example.com"
  When I update the email to "new@example.com"
  Then the user's email should be updated
  And other fields should remain unchanged

Scenario: Delete record
  Given a user exists in the database
  When I delete the user
  Then the user should no longer exist
  And related records should be handled (cascade/set null)
```

### Transaction Testing
```gherkin
Scenario: Successful transaction
  Given I start a transaction
  When I insert an order for user 123
  And I insert order items for the order
  And I commit the transaction
  Then all data should be saved
  And the order should have associated items

Scenario: Failed transaction rollback
  Given I start a transaction
  When I insert an order
  And I attempt to insert invalid data
  Then an error should occur
  And the transaction should be rolled back
  And no data should be saved
```

## Related Skills

- test-case-design — database test case design
- test-data-management — test data creation
- security-testing — database security
- performance-testing — query performance
- api-testing — API with database validation

---

*Database Testing — ensuring data integrity and reliability*
