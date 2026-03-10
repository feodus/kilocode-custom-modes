---
name: api-testing
description: Comprehensive API testing strategies, tools, and techniques. Use when testing REST/SOAP APIs, validating endpoints, checking authentication, and verifying data integrity.
---

# API Testing

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for comprehensive API testing, covering all aspects of API quality assurance including functional testing, security testing, performance testing, and reliability verification. This skill encompasses testing strategies for REST, SOAP, GraphQL, and other API types.

## When to Use

Use this skill:
- When testing REST/SOAP/GraphQL APIs
- For validating API endpoints and responses
- When checking authentication and authorization mechanisms
- For verifying data integrity and transformation
- During integration testing between services
- When validating API contracts and schemas
- For performance and load testing of APIs

## API Testing Types

### Functional Testing

Testing the core functionality of APIs:

**GET Requests:**
- Verify correct data retrieval
- Check filtering and sorting capabilities
- Validate pagination parameters
- Test query parameters

**POST Requests:**
- Verify successful creation of resources
- Test required field validation
- Check data format validation
- Validate error responses

**PUT/PATCH Requests:**
- Verify successful updates
- Test partial update capabilities
- Check data validation on updates
- Validate optimistic locking if applicable

**DELETE Requests:**
- Verify successful deletion
- Check soft vs hard delete behavior
- Validate permission restrictions
- Test cascade delete effects

### Security Testing

API security validation:

**Authentication Testing:**
- Verify token-based authentication
- Test API key validation
- Check OAuth implementations
- Validate JWT tokens

**Authorization Testing:**
- Test role-based access control
- Verify permission boundaries
- Check privilege escalation
- Validate resource ownership

**Input Validation:**
- Test SQL injection attacks
- Check XSS prevention
- Validate parameter sanitization
- Test buffer overflow protection

### Performance Testing

API performance validation:

**Load Testing:**
- Test concurrent request handling
- Measure response times under load
- Validate resource utilization
- Check system stability

**Stress Testing:**
- Push beyond normal capacity
- Identify breaking points
- Test recovery mechanisms
- Validate error handling under stress

**Endurance Testing:**
- Long-term stability testing
- Memory leak detection
- Resource consumption monitoring
- Performance degradation analysis

## API Testing Tools and Frameworks

### Popular Testing Tools

**Postman:**
- Collection and environment management
- Automated test scripts
- Mock server creation
- Team collaboration features

**Insomnia:**
- Intuitive interface
- Plugin support
- Code generation
- Real-time collaboration

**Swagger/OpenAPI Tools:**
- Contract-first development
- Automated documentation
- Validation against schema
- Code generation

**Programming Libraries:**
- RestAssured (Java)
- Requests (Python)
- SuperTest (Node.js)
- HTTParty (Ruby)

## API Testing Best Practices

### Test Design

1. **Base URL Management:** Use environment variables for different environments
2. **Authentication Handling:** Centralize authentication logic
3. **Response Validation:** Check status codes, headers, and body content
4. **Schema Validation:** Use JSON Schema or similar for response validation
5. **Data Parameterization:** Use test data sets for different scenarios

### Test Execution

1. **Order Independence:** Tests should not depend on execution order
2. **Data Isolation:** Each test should use isolated data
3. **Setup/Teardown:** Proper initialization and cleanup
4. **Parallel Execution:** Design tests to run in parallel when possible
5. **Retry Mechanisms:** Handle transient failures appropriately

### Test Maintenance

1. **Version Control:** Store tests with API definitions
2. **Documentation:** Maintain clear test documentation
3. **Monitoring:** Track test results and performance trends
4. **Refactoring:** Regularly update tests for API changes
5. **Reporting:** Generate comprehensive test reports

## API Testing Checklist

### Pre-Testing Checklist
- [ ] API documentation reviewed
- [ ] Authentication method understood
- [ ] Test environment prepared
- [ ] Test data created
- [ ] Dependencies identified

### Functional Testing Checklist
- [ ] Valid requests return expected responses
- [ ] Invalid requests return appropriate errors
- [ ] Required fields validation works
- [ ] Optional fields handled correctly
- [ ] Data types validated properly
- [ ] Business logic implemented correctly
- [ ] Error messages are informative

### Security Testing Checklist
- [ ] Authentication enforced on protected endpoints
- [ ] Authorization checked for sensitive operations
- [ ] Input validation prevents injection attacks
- [ ] Sensitive data properly encrypted
- [ ] Rate limiting implemented
- [ ] CORS policies configured correctly

### Performance Testing Checklist
- [ ] Response times meet requirements
- [ ] API handles expected load
- [ ] Memory usage remains stable
- [ ] No resource leaks detected
- [ ] Error rate remains acceptable

## Common API Test Scenarios

### Authentication Scenarios
```gherkin
Scenario: Valid token allows access to protected endpoint
  Given I have a valid authentication token
  When I make a GET request to "/api/users/profile"
  And I include the token in the Authorization header
  Then I should receive a 200 OK response
  And the response should contain user profile data

Scenario: Invalid token returns unauthorized error
  Given I have an invalid authentication token
  When I make a GET request to "/api/users/profile"
  And I include the invalid token in the Authorization header
  Then I should receive a 401 Unauthorized response
```

### CRUD Operation Scenarios
```gherkin
Scenario: Successfully create a new user
  Given I have valid user data
  When I make a POST request to "/api/users" with the user data
  Then I should receive a 201 Created response
  And the response should contain the created user with an ID
  And the user should be retrievable by the returned ID

Scenario: Successfully retrieve a user
  Given a user exists with ID "123"
  When I make a GET request to "/api/users/123"
  Then I should receive a 200 OK response
  And the response should match the expected user data
```

### Error Handling Scenarios
```gherkin
Scenario: Missing required field returns validation error
  Given I have user data without an email address
  When I make a POST request to "/api/users" with the incomplete data
  Then I should receive a 400 Bad Request response
  And the response should contain validation error details

Scenario: Duplicate email returns conflict error
  Given a user already exists with email "test@example.com"
  When I make a POST request to "/api/users" with the same email
  Then I should receive a 409 Conflict response
  And the response should indicate the email already exists
```

## API Contract Testing

### Consumer-Driven Contract Testing
- Verify API meets consumer expectations
- Prevent breaking changes
- Enable parallel development
- Build confidence in refactoring

### Schema Validation
- Validate request/response schemas
- Use JSON Schema or OpenAPI specifications
- Automate schema validation in tests
- Maintain backward compatibility

## Reporting and Monitoring

### Test Results Reporting
- Execution summary
- Pass/fail statistics
- Performance metrics
- Error details and logs

### API Monitoring
- Availability monitoring
- Response time tracking
- Error rate monitoring
- Alerting for failures

## Related Skills

- test-case-design — test case design principles
- gherkin-specifications — behavior-driven testing
- performance-testing — performance testing techniques
- security-testing — security testing fundamentals
- test-automation-frameworks — automation frameworks

---
*API Testing — ensuring quality and reliability of application interfaces*
