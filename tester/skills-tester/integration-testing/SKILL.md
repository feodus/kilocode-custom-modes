---
name: integration-testing
description: Integration testing for verifying component interactions, API integrations, service communication, and end-to-end workflows. Use when testing multiple modules or services working together.
---

# Integration Testing

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for comprehensive integration testing covering component interactions, API integrations, service-to-service communication, and end-to-end workflow validation. Essential for verifying that different parts of an application work together correctly.

## When to Use

Use this skill:
- When testing interactions between modules
- For verifying API integrations
- When testing service communication
- During end-to-end workflow testing
- For testing data flow between components
- When validating third-party integrations

## Integration Testing Types

### Component Integration

Testing interactions between internal components:

**Module Interactions:**
- Function calls between modules
- Class interactions
- Shared state management
- Event handling
- Dependency injection

**Data Flow:**
- Data passing between layers
- Transformation logic
- Aggregation functions

### API Integration

Testing external API interactions:

**REST API Integration:**
- HTTP request/response handling
- Authentication integration
- Error handling from external APIs
- Rate limiting handling
- Timeout handling

**GraphQL Integration:**
- Query execution
- Mutation handling
- Subscription handling

### Service Integration

Testing microservice communications:

**Synchronous Communication:**
- REST API calls
- gRPC communication
- Service mesh interactions

**Asynchronous Communication:**
- Message queues (RabbitMQ, Kafka)
- Event-driven architecture
- Pub/sub patterns

### Database Integration

Testing database interactions:

**CRUD Operations:**
- Create operations
- Read operations
- Update operations
- Delete operations

**Transaction Handling:**
- Multi-table transactions
- Rollback behavior
- Concurrency handling

## Integration Testing Approaches

### Big Bang Integration

Testing all components together:

```python
# Big Bang Integration Test
class TestCompleteSystem:
    """Test entire system integration"""
    
    def test_complete_order_process(self, app, database):
        """Full order processing workflow"""
        # 1. Create user
        user = api.create_user({
            'username': 'testuser',
            'email': 'test@example.com'
        })
        
        # 2. Add to cart
        cart = api.add_to_cart(user.id, product_id=123, quantity=2)
        
        # 3. Process payment
        payment = api.process_payment(cart.id, {
            'amount': cart.total,
            'method': 'credit_card'
        })
        
        # 4. Create order
        order = api.create_order(user.id, payment.id)
        
        # 5. Verify all components
        assert user.id is not None
        assert len(cart.items) == 2
        assert payment.status == 'completed'
        assert order.status == 'confirmed'
```

### Top-Down Integration

Testing from top layer downward:

```python
# Top-Down Integration Test
class TestOrderFlow:
    """Test order flow from UI to database"""
    
    def test_order_creation(self, order_service, inventory_client):
        """Test order creation flow"""
        # Mock dependent services
        inventory_client.check_availability = Mock(return_value=True)
        
        # Test service layer
        order = order_service.create_order(
            customer_id=1,
            items=[{'product_id': 123, 'quantity': 2}]
        )
        
        assert order.status == 'created'
        inventory_client.check_availability.assert_called_once()
```

### Bottom-Up Integration

Testing from bottom layer upward:

```python
# Bottom-Up Integration Test
class TestRepositoryLayer:
    """Test repository with actual database"""
    
    def test_user_repository(self, db_connection):
        """Test user repository integration"""
        # Test database interaction
        user_repo = UserRepository(db_connection)
        
        # Create
        user = user_repo.create({
            'username': 'testuser',
            'email': 'test@example.com'
        })
        
        # Read
        found = user_repo.get_by_id(user.id)
        
        # Update
        found.email = 'updated@example.com'
        user_repo.update(found)
        
        # Delete
        user_repo.delete(user.id)
        
        assert user_repo.get_by_id(user.id) is None
```

### Sandwich/Hybrid Integration

Combining top-down and bottom-up:

```python
# Sandwich Integration Test
class TestOrderWorkflow:
    """Test order workflow with mocked boundaries"""
    
    @pytest.fixture
    def services(self):
        return {
            'order_service': Mock(),
            'payment_service': Mock(),
            'notification_service': Mock()
        }
    
    def test_order_with_external_services(self, services):
        """Test order with external service integration"""
        # Configure mocks
        services['payment_service'].process.return_value = {
            'status': 'success',
            'transaction_id': 'tx_123'
        }
        
        # Test integration
        order_service = OrderService(
            payment=services['payment_service'],
            notification=services['notification_service']
        )
        
        result = order_service.process_order({
            'items': [{'product_id': 1, 'quantity': 2}],
            'payment': {'method': 'card'}
        })
        
        assert result['status'] == 'completed'
        services['payment_service'].process.assert_called_once()
```

## Integration Testing Tools

### Mocking Frameworks

**Python unittest.mock:**
```python
from unittest.mock import Mock, patch, MagicMock

class TestPaymentIntegration:
    
    @patch('payment_gateway.PaymentGateway')
    def test_payment_integration(self, mock_gateway):
        """Test payment service integration"""
        # Configure mock
        mock_gateway_instance = Mock()
        mock_gateway_instance.process_payment.return_value = {
            'status': 'success',
            'transaction_id': 'tx_123'
        }
        mock_gateway.return_value = mock_gateway_instance
        
        # Test
        result = process_payment({
            'amount': 100,
            'card': '****1234'
        })
        
        assert result['status'] == 'success'
        mock_gateway_instance.process_payment.assert_called_once()
```

**WireMock:**
```yaml
# WireMock stub configuration
- request:
    method: POST
    url: "/api/payments"
  response:
    status: 200
    json:
      status: "success"
      transaction_id: "tx_${random.uuid}"
    headers:
      Content-Type: "application/json"
```

### Test Containers

**Docker-based Integration Testing:**
```python
import testcontainers
from testcontainers.postgres import PostgresContainer
from testcontainers.redis import RedisContainer

class TestWithDatabases:
    """Integration tests with real databases"""
    
    @pytest.fixture
    def postgres_container(self):
        with PostgresContainer("postgres:15") as postgres:
            yield postgres
    
    @pytest.fixture
    def redis_container(self):
        with RedisContainer("redis:7") as redis:
            yield redis
    
    def test_with_postgres(self, postgres_container):
        """Test with actual PostgreSQL"""
        connection = psycopg2.connect(
            postgres_container.get_connection_url()
        )
        # Test database operations
        assert connection.status == psycopg2.extensions.STATUS_READY
```

### Contract Testing

**Pact Testing:**
```python
# Consumer-driven contract testing
import pact

class TestProviderContract:
    """Test API contract compliance"""
    
    @pytest.fixture
    def pact(self):
        return pact.Pact(
            consumer='web-client',
            provider='order-service'
        )
    
    def test_get_orders(self, pact):
        """Test order service contract"""
        pact.given('orders exist')
        pactpon_response_with(200, {
            'orders': [
                {'id': 1, 'status': 'completed'}
            ]
        })
        
        # Verify contract
        pact.verify(lambda: get_orders())
```

## Integration Testing Best Practices

### Test Isolation

```markdown
## Integration Test Isolation

### Database Isolation
- Use transaction rollback
- Create fresh database per test
- Use test database schema

### Service Isolation
- Mock external services
- Use service containers
- Implement circuit breakers

### Data Isolation
- Use unique test data
- Clean up after tests
- Use test data factories
```

### Test Data Management

```python
# Test data factory
class OrderFactory:
    @staticmethod
    def create_order(**kwargs):
        defaults = {
            'status': 'pending',
            'total': 100.00,
            'items': [],
            'created_at': datetime.now()
        }
        defaults.update(kwargs)
        return Order(**defaults)
    
    @staticmethod
    def create_with_items(num_items=3):
        items = [ProductFactory.create_product() for _ in range(num_items)]
        return OrderFactory.create_order(items=items)
```

### Error Handling

```python
def test_integration_error_handling(self, api_client):
    """Test proper error handling in integration"""
    
    # Test timeout handling
    with patch('requests.post', side_effect=Timeout()):
        result = api_client.create_order({})
        assert result.status == 'error'
        assert 'timeout' in result.message.lower()
    
    # Test connection error
    with patch('requests.post', side_effect=ConnectionError()):
        result = api_client.create_order({})
        assert result.status == 'error'
    
    # Test API error response
    with patch('requests.post', return_value=Mock(status_code=500)):
        result = api_client.create_order({})
        assert result.status == 'error'
```

## Integration Testing Checklist

### Pre-Testing
- [ ] Dependencies identified
- [ ] Test environment configured
- [ ] Mock services ready
- [ ] Test data prepared

### Component Testing
- [ ] Module interactions tested
- [ ] Data flow verified
- [ ] Error propagation works
- [ ] State management correct

### API Integration
- [ ] Request/response format correct
- [ ] Authentication works
- [ ] Error handling proper
- [ ] Timeout handling correct

### Service Integration
- [ ] Service communication works
- [ ] Message formats correct
- [ ] Error handling in place
- [ ] Circuit breakers work

### End-to-End Testing
- [ ] Complete workflows work
- [ ] Data consistency maintained
- [ ] Performance acceptable
- [ ] Errors handled gracefully

## Common Integration Test Scenarios

### API Integration
```gherkin
Scenario: Create order through API
  Given the user is authenticated
  And the product is available in inventory
  When I submit a POST request to "/api/orders" with order details
  Then the response should have status 201 Created
  And the response should contain the order ID
  And the order should appear in the database
```

### Service Communication
```gherkin
Scenario: Order triggers notification
  Given a new order is created
  When the order status changes to "confirmed"
  Then a notification should be sent to the customer
  And the notification service should be called with correct data
```

### Database Integration
```gherkin
Scenario: User registration creates database record
  Given the registration form is submitted with valid data
  When the user is created in the system
  Then a user record should exist in the database
  And the user's email should match the submitted data
```

## Related Skills

- api-testing — API integration testing
- test-automation-frameworks — automation frameworks
- database-testing — database integration
- test-case-design — integration test cases
- test-data-management — test data for integration

---

*Integration Testing — ensuring components work together seamlessly*
