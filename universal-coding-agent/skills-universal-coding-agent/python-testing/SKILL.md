---
name: python-testing
description: Writing and organizing tests for Python projects using pytest. Use this skill when creating unit tests, integration tests, mocking dependencies, and setting up CI/CD for testing.
---

# Python Application Testing Guide

## Installation and Setup

### Installing pytest

```bash
poetry add --group dev pytest pytest-cov pytest-asyncio httpx
```

### pytest Configuration

```toml
# pyproject.toml
[tool.pytest.ini_options]
minversion = "7.0"
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = [
    "--strict-markers",
    "--strict-config",
    "--cov=src",
    "--cov-report=html",
    "--cov-report=term-missing",
    "--cov-fail-under=80",
]
asyncio_mode = "auto"

[tool.coverage.run]
source = ["src"]
omit = ["*/tests/*", "*/migrations/*"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
    "if TYPE_CHECKING:",
]
```

## Test Structure

### Test Organization

```
tests/
├── __init__.py
├── conftest.py              # Common fixtures
├── conftest_auth.py         # Authentication fixtures
├── conftest_db.py           # Database fixtures
├── unit/
│   ├── __init__.py
│   ├── test_users.py
│   └── test_items.py
├── integration/
│   ├── __init__.py
│   ├── test_api.py
│   └── test_database.py
└── e2e/
    ├── __init__.py
    └── test_workflows.py
```

## pytest Basics

### Simple Tests

```python
# tests/unit/test_calculator.py
import pytest
from src.calculator import Calculator

class TestCalculator:
    def test_add(self):
        calc = Calculator()
        result = calc.add(2, 3)
        assert result == 5
    
    def test_subtract(self):
        calc = Calculator()
        result = calc.subtract(10, 4)
        assert result == 6
    
    def test_multiply(self):
        calc = Calculator()
        result = calc.multiply(3, 4)
        assert result == 12
    
    def test_divide(self):
        calc = Calculator()
        result = calc.divide(10, 2)
        assert result == 5
    
    def test_divide_by_zero(self):
        calc = Calculator()
        with pytest.raises(ZeroDivisionError):
            calc.divide(10, 0)
```

### Exception Testing

```python
def test_invalid_email():
    with pytest.raises(ValueError, match="Invalid email format"):
        validate_email("invalid-email")

def test_not_found():
    with pytest.raises(NotFoundException) as exc_info:
        get_user(999)
    assert "User not found" in str(exc_info.value)
```

## Fixtures

### Basic Fixture

```python
# tests/conftest.py
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from src.database import Base
from src.main import app
from fastapi.testclient import TestClient

# Test database
SQLALCHEMY_TEST_DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(SQLALCHEMY_TEST_DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture(scope="function")
def db_session():
    """Creates a new DB session for each test"""
    Base.metadata.create_all(bind=engine)
    session = TestingSessionLocal()
    try:
        yield session
    finally:
        session.close()
        Base.metadata.drop_all(bind=engine)

@pytest.fixture(scope="function")
def client(db_session):
    """Creates a FastAPI test client"""
    def override_get_db():
        try:
            yield db_session
        finally:
            pass
    
    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()
```

### Mock Fixtures

```python
# tests/conftest.py
import pytest
from unittest.mock import Mock, MagicMock

@pytest.fixture
def mock_user_repository():
    """Mock of user repository"""
    mock = Mock()
    mock.get_user_by_email.return_value = None
    mock.create_user.return_value = User(
        id=1,
        email="test@example.com",
        username="testuser"
    )
    return mock

@pytest.fixture
def sample_user():
    """Sample user data"""
    return {
        "email": "test@example.com",
        "username": "testuser",
        "password": "hashed_password"
    }
```

### Authentication Fixtures

```python
# tests/conftest_auth.py
import pytest
from fastapi.testclient import TestClient
from jose import jwt
from src.core.config import settings

@pytest.fixture
def auth_token(client: TestClient, sample_user):
    """Creates authentication token"""
    response = client.post("/api/v1/auth/register", json=sample_user)
    user_id = response.json()["id"]
    
    token = jwt.encode(
        {"sub": user_id},
        settings.SECRET_KEY,
        algorithm=settings.ALGORITHM
    )
    return token

@pytest.fixture
def auth_headers(auth_token):
    """Headers with authorization token"""
    return {"Authorization": f"Bearer {auth_token}"}

@pytest.fixture
def authenticated_client(client: TestClient, auth_headers):
    """Test client with authentication"""
    client.headers.update(auth_headers)
    return client
```

## Mock Objects

### Mocking Functions

```python
from unittest.mock import Mock, patch, MagicMock

# Mocking one function
@patch('src.utils.send_email')
def test_send_welcome_email(mock_send_email):
    send_welcome_email("user@example.com")
    mock_send_email.assert_called_once_with(
        to="user@example.com",
        subject="Welcome!",
        body=expect.any(str)
    )

# Mocking class
@patch('src.services.NotificationService')
def test_notify_user(mock_notification_service):
    mock_instance = Mock()
    mock_notification_service.return_value = mock_instance
    
    notify_user("test@example.com", "Hello!")
    
    mock_instance.send.assert_called_once()

# Mocking property
@patch('src.config.settings.API_KEY', 'test-key')
def test_api_key():
    assert get_api_key() == 'test-key'
```

### Mocking Database

```python
from unittest.mock import Mock, patch

def test_get_user_from_db():
    mock_db = Mock()
    mock_user = User(id=1, email="test@example.com")
    mock_db.query.return_value.filter.return_value.first.return_value = mock_user
    
    result = get_user(mock_db, 1)
    
    assert result.email == "test@example.com"
    mock_db.query.assert_called_once()
```

## Integration Tests

### API Testing

```python
# tests/integration/test_users.py
import pytest
from fastapi.testclient import TestClient

def test_create_user(client: TestClient):
    """Test user creation"""
    response = client.post(
        "/api/v1/users/",
        json={
            "email": "newuser@example.com",
            "username": "newuser",
            "password": "password123"
        }
    )
    
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "newuser@example.com"
    assert data["username"] == "newuser"
    assert "id" in data

def test_get_user(client: TestClient, sample_user):
    """Test getting user"""
    # Create user
    create_response = client.post("/api/v1/users/", json=sample_user)
    user_id = create_response.json()["id"]
    
    # Get user
    response = client.get(f"/api/v1/users/{user_id}")
    
    assert response.status_code == 200
    data = response.json()
    assert data["email"] == sample_user["email"]

def test_get_nonexistent_user(client: TestClient):
    """Test getting non-existent user"""
    response = client.get("/api/v1/users/99999")
    assert response.status_code == 404

def test_create_user_duplicate_email(client: TestClient, sample_user):
    """Test creating user with duplicate email"""
    # Create first user
    client.post("/api/v1/users/", json=sample_user)
    
    # Try to create second with same email
    response = client.post("/api/v1/users/", json=sample_user)
    
    assert response.status_code == 400
    assert "already registered" in response.json()["detail"]
```

### Database Testing

```python
# tests/integration/test_database.py
import pytest
from sqlalchemy.orm import Session
from src.models.user import User
from src.services.user_service import UserService

def test_user_service_create(db_session: Session):
    """Test user creation through service"""
    service = UserService(db_session)
    
    user_data = UserCreate(
        email="test@example.com",
        username="testuser",
        password="password123"
    )
    
    user = service.create_user(user_data)
    
    assert user.id is not None
    assert user.email == "test@example.com"
    assert user.is_active is True

def test_user_service_get_by_email(db_session: Session):
    """Test finding user by email"""
    # Create user
    service = UserService(db_session)
    user_data = UserCreate(
        email="findme@example.com",
        username="findme",
        password="password123"
    )
    service.create_user(user_data)
    
    # Find user
    found_user = service.get_user_by_email("findme@example.com")
    
    assert found_user is not None
    assert found_user.username == "findme"
```

## Async Testing

### Testing Async Functions

```python
import pytest
import asyncio

# conftest.py
@pytest.fixture(scope="session")
def event_loop():
    """Creates event loop for tests"""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()

# tests/test_async.py
import pytest

@pytest.mark.asyncio
async def test_async_fetch():
    """Test async function"""
    result = await fetch_data()
    assert result is not None

@pytest.mark.asyncio
async def test_async_with_db():
    """Test async DB operations"""
    user = await get_user_async(1)
    assert user.id == 1
```

## Parametrized Tests

```python
import pytest

@pytest.mark.parametrize("input,expected", [
    (2, 4),
    (3, 9),
    (4, 16),
    (5, 25),
])
def test_square(input, expected):
    """Test squaring"""
    assert input ** 2 == expected

@pytest.mark.parametrize("a,b,operation,expected", [
    (2, 3, "add", 5),
    (10, 5, "subtract", 5),
    (4, 3, "multiply", 12),
    (20, 4, "divide", 5),
])
def test_calculator_operations(a, b, operation, expected):
    """Test calculator with different operations"""
    calc = Calculator()
    
    operations = {
        "add": calc.add,
        "subtract": calc.subtract,
        "multiply": calc.multiply,
        "divide": calc.divide
    }
    
    result = operations[operation](a, b)
    assert result == expected
```

## Fixtures with Scopes

```python
# Scope: function, class, session, module

@pytest.fixture(scope="session")
def test_settings():
    """Fixture created once per test session"""
    return {"debug": True, "test_mode": True}

@pytest.fixture(scope="module")
def db_engine():
    """Fixture created once per test module"""
    engine = create_engine("sqlite:///./test.db")
    yield engine
    engine.dispose()

@pytest.fixture(scope="class")
def test_client():
    """Fixture created for each test class"""
    return TestClient(app)
```

## Coverage and Reports

### Running with Coverage

```bash
# Run tests with coverage
pytest --cov=src --cov-report=html

# Open HTML report
start htmlcov/index.html

# Coverage with function-level detail
pytest --cov=src --cov-report=term-missing --cov-report=term-missing --show-missing

# Minimum coverage
pytest --cov=src --cov-fail-under=80
```

### Skipping Tests

```python
import pytest

@pytest.mark.skip(reason="Not implemented yet")
def test_future_feature():
    pass

@pytest.mark.skipif(sys.version_info < (3, 10), reason="Requires Python 3.10+")
def test_python_feature():
    pass

@pytest.mark.xfail(reason="Known bug")
def test_known_bug():
    assert False
```

## Testing Edge Cases

```python
import pytest
from src.exceptions import ValidationError

def test_validation_error():
    """Test validation error handling"""
    with pytest.raises(ValidationError) as exc_info:
        validate_user_data({"name": ""})
    
    assert "name" in str(exc_info.value).lower()

def test_custom_exception_message():
    """Test custom error message"""
    with pytest.raises(ValidationError, match="Email is required"):
        validate_user_data({})
```

## Best Practices

### Test Organization

1. **Name tests clearly** - names should describe what is being tested
2. **One test - one assertion** - avoid multiple assertions
3. **Use fixtures** - avoid code duplication
4. **Test edge cases** - zero values, empty strings
5. **Mock external dependencies** - APIs, databases, file system
6. **Don't test libraries** - trust third-party tests
7. **Maintain tests** - remove outdated tests
8. **Use meaningful asserts** - add messages

### Example of Well-Organized Test

```python
class TestUserRegistration:
    """User registration tests"""
    
    def test_register_valid_user(self, client: TestClient):
        """Successful registration with valid data"""
        # Arrange
        user_data = {
            "email": "newuser@example.com",
            "username": "newuser",
            "password": "SecurePass123!"
        }
        
        # Act
        response = client.post("/api/v1/auth/register", json=user_data)
        
        # Assert
        assert response.status_code == 201
        data = response.json()
        assert data["email"] == user_data["email"]
        assert data["username"] == user_data["username"]
        assert "id" in data
        assert "password" not in data  # Password should not be returned
    
    def test_register_duplicate_email(self, client: TestClient, existing_user):
        """Error when registering with already used email"""
        # Arrange
        user_data = {
            "email": existing_user.email,
            "username": "different_user",
            "password": "SecurePass123!"
        }
        
        # Act
        response = client.post("/api/v1/auth/register", json=user_data)
        
        # Assert
        assert response.status_code == 400
        assert "already registered" in response.json()["detail"]
    
    def test_register_invalid_email(self, client: TestClient):
        """Error when registering with invalid email"""
        # Arrange
        user_data = {
            "email": "not-an-email",
            "username": "user",
            "password": "SecurePass123!"
        }
        
        # Act
        response = client.post("/api/v1/auth/register", json=user_data)
        
        # Assert
        assert response.status_code == 422
```

## CI/CD for Testing

### GitHub Actions

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.10'
    
    - name: Install Poetry
      run: pip install poetry
    
    - name: Install dependencies
      run: poetry install
    
    - name: Run tests
      run: pytest
    
    - name: Upload coverage
      uses: codecov/codecov-action@v4
```

## Running Tests

```bash
# All tests
pytest

# Specific file
pytest tests/unit/test_users.py

# Specific test
pytest tests/unit/test_users.py::TestUser::test_create_user

# With verbose output
pytest -v

# Stop at first failure
pytest -x

# Show local variables on failure
pytest -l

# Skip slow tests
pytest -m "not slow"

# Run only slow tests
pytest -m "slow"
```
