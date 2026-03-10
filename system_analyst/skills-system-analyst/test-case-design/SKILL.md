---
name: test-case-design
description: Creating test cases and test scenarios based on requirements. Use when designing testing, creating test documentation, defining boundary conditions.
---

# Test Case Design

> **Meta:** v1.0.0 | 23-02-2026

## Purpose

Skill for creating test cases and test scenarios based on requirements. Includes designing test cases, defining boundary conditions, creating test data, forming traceability matrix, and grouping tests into scenarios. Designed for software quality assurance through systematic testing of all requirements.

## When to Use

Use this skill:
- When transitioning to the testing phase in SDLC
- For creating test documentation based on SRS
- When test coverage of requirements is needed
- For defining boundary conditions and edge cases
- When planning test data
- For creating traceability matrix
- When handing off data to QA team

## Functions

### Test Case Design

Test case structure:

```markdown
## TC-{ID}: {Test Case Title}

**Requirement:** {Reference to requirement FR-ID}
**Priority:** {High|Medium|Low}
**Type:** {Functional|Non-Functional|Regression|Smoke}

### Pre-conditions
- Condition 1
- Condition 2

### Test Steps
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Action 1 | Expected result 1 |
| 2 | Action 2 | Expected result 2 |

### Test Data
- {test data}

### Post-conditions
- Expected state after execution

### Priority
- {Critical|High|Medium|Low}

### Test Type
- Positive — testing expected behavior
- Negative — testing error handling
- Boundary — testing boundary conditions
```

**Test Case Attributes:**
| Attribute | Description | Example |
|-----------|-------------|---------|
| TC ID | Unique identifier | TC-001 |
| Title | Test case name | Successful User Login |
| Requirement | Reference to requirement | FR-001 |
| Priority | Priority | High |
| Type | Test type | Functional |
| Pre-conditions | Preconditions | User exists in system |
| Steps | Execution steps | 5 steps |
| Expected Result | Expected result | Dashboard displayed |
| Status | Status | Ready/In Progress |

### Test Scenarios

Grouping test cases by logical scenarios:

```markdown
## TS-{ID}: {Test Scenario Name}

**Description:** {Scenario description}
**Related Requirements:** {List of FR-ID}

### Test Cases
| TC ID | Test Case Name | Priority |
|-------|----------------|----------|
| TC-001 | ... | High |
| TC-002 | ... | Medium |

### Test Flow
1. {Flow description}
2. {Flow description}
```

**Scenario Types:**
- **Happy Path** — successful execution of main scenario
- **Alternative Flow** — alternative options
- **Error Handling** — error handling
- **Boundary Testing** — boundary conditions

### Edge Cases

Defining boundary conditions:

**Edge Cases Categories:**
| Category | Description | Examples |
|-----------|-------------|----------|
| Boundary Values | Boundary values | min/max, first/last |
| Empty Values | Empty values | null, "", [] |
| Invalid Data | Invalid data | wrong format, overflow |
| Concurrency | Parallel access | race conditions |
| Performance | Load | large data, timeout |
| Security | Security | SQL injection, XSS |

**Definition Methods:**
- Equivalence Partitioning — partitioning into equivalence classes
- Boundary Value Analysis — boundary value analysis
- Decision Table Testing — decision tables
- State Transition Testing — state transitions

### Test Data Requirements

Defining test data:

```markdown
## Test Data Requirements

### Required Test Data
| Data | Type | Source | Purpose |
|------|------|--------|---------|
| Username | String | Generated | Login tests |
| Email | Email | Generated | Registration |
| Credit Card | Card | Mock data | Payment tests |

### Test Data Categories
- **Valid Data** — valid data for positive tests
- **Invalid Data** — invalid data for negative tests
- **Boundary Data** — boundary values
- **Large Data** — data for performance tests

### Data Preparation
- Test data creation scripts
- Test data cleanup procedures
- Data masking for sensitive information
```

### Traceability Matrix

Requirements traceability matrix:

```markdown
## Traceability Matrix

| Requirement | TC ID | TC Name | Priority | Status |
|-------------|-------|---------|----------|--------|
| FR-001 | TC-001, TC-002, TC-003 | Login tests | High | Ready |
| FR-002 | TC-004, TC-005 | Registration | High | Ready |
| NFR-001 | TC-010 | Performance | Medium | In Progress |

### Coverage Metrics
- Total Requirements: {N}
- Covered by Tests: {N}
- Coverage: {X}%

### Critical Path Testing
| Requirement | Priority | Test Coverage |
|-------------|----------|---------------|
| FR-001 | Critical | 100% |
| FR-002 | Critical | 100% |
```

## Integration with Project Manager

### Data for Project Manager

Provides the following data for PM:

**For QA Estimation:**
- Total number of test cases
- Number by priority (Critical/High/Medium/Low)
- Preliminary testing time estimation
- Test data requirements

**For Planning:**
- Requirements test coverage (%)
- Critical test cases (blocking)
- Requirements dependencies
- Risks of incomplete coverage

**For Reporting:**
- Requirements coverage status
- Test cases by categories
- UAT readiness

### Interaction

- PM requests test cases for QA work planning
- PM receives coverage metrics for reporting
- PM uses data for coordination with QA team
- SA clarifies boundary conditions with developers

## Usage Examples

### Example 1: Test Case for Authorization

```markdown
## TC-001: Successful User Login

**Requirement:** FR-001 User Authentication
**Priority:** High
**Type:** Functional

### Pre-conditions
- User exists in system with credentials:
  - Username: "test_user"
  - Password: "TestPass123!"
- User is not logged in
- Login page is accessible

### Test Steps
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to login page | Login form is displayed |
| 2 | Enter valid username "test_user" | Username is accepted and displayed |
| 3 | Enter valid password "TestPass123!" | Password is masked with asterisks |
| 4 | Click "Login" button | System processes authentication |
| 5 | Verify redirect | User is redirected to dashboard |

### Test Data
- Username: test_user
- Password: TestPass123!

### Post-conditions
- User session is created in database
- User is authenticated
- Dashboard page is displayed
- Session cookie is set

### Priority: Critical
### Test Type: Positive
```

### Example 2: Test Case for Boundary Conditions

```markdown
## TC-015: Password Length Validation

**Requirement:** FR-001 User Authentication
**Priority:** High
**Type:** Boundary

### Pre-conditions
- User is on registration page

### Test Steps
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter password with 5 characters | Error: "Password too short" |
| 2 | Enter password with 6 characters | Password accepted |
| 3 | Enter password with 50 characters | Password accepted |
| 4 | Enter password with 51 characters | Error: "Password too long" |

### Boundary Values Tested
- Min length: 6 characters
- Max length: 50 characters

### Priority: High
### Test Type: Boundary
```

### Example 3: Test Scenario

```markdown
## TS-001: User Authentication

**Description:** Complete user authentication flow
**Related Requirements:** FR-001, FR-002, FR-003

### Test Cases
| TC ID | Test Case Name | Priority |
|-------|----------------|----------|
| TC-001 | Successful Login | Critical |
| TC-002 | Invalid Username | High |
| TC-003 | Invalid Password | High |
| TC-004 | Account Locked | High |
| TC-005 | Session Timeout | Medium |
| TC-006 | Remember Me Function | Medium |
| TC-007 | Logout | High |

### Test Flow
1. Start with TC-001 (baseline)
2. Execute TC-002, TC-003 (negative scenarios)
3. Execute TC-004 (account security)
4. Execute TC-005, TC-006 (session management)
5. End with TC-007 (cleanup)

### Estimated Duration: 30 minutes
```

### Example 4: Traceability Matrix

```markdown
## Traceability Matrix: User Management Module

| Requirement | Description | TC IDs | Coverage | Status |
|-------------|-------------|--------|----------|--------|
| FR-001 | User Login | TC-001, TC-002, TC-003, TC-004 | 100% | Ready |
| FR-002 | User Registration | TC-010, TC-011, TC-012, TC-013 | 100% | Ready |
| FR-003 | Password Reset | TC-020, TC-021, TC-022 | 75% | In Progress |
| FR-004 | Profile Edit | TC-030, TC-031 | 50% | Pending |
| NFR-001 | Response Time < 2s | TC-040 | 100% | Ready |
| NFR-002 | Concurrent Users 1000+ | TC-041, TC-042 | 100% | Ready |

### Summary
- Total Requirements: 6
- Fully Covered: 3 (50%)
- Partially Covered: 2 (33%)
- Not Covered: 1 (17%)
- Critical Requirements Coverage: 100%
```

## Document Templates

### Test Case Template

```markdown
## TC-{ID}: {Title}

**Requirement:** {FR-ID}
**Priority:** {Critical|High|Medium|Low}
**Type:** {Functional|Non-Functional|Regression|Smoke}

### Pre-conditions
- Condition 1
- Condition 2

### Test Steps
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | | |
| 2 | | |

### Test Data
- {data}

### Post-conditions
- {expected state}

### Notes
- {additional notes}
```

### Test Scenario Template

```markdown
## TS-{ID}: {Scenario Name}

**Description:** {Description}
**Module:** {Module name}
**Related Requirements:** {FR-001, FR-002}

### Test Cases
| TC ID | Name | Priority |
|-------|------|----------|
| TC-XXX | | |

### Prerequisites
- {what is required before running}

### Expected Duration
- {execution time}
```

### Traceability Matrix Template

```markdown
## Traceability Matrix: {Module/System}

| Requirement | Description | TC IDs | Coverage % | Status |
|-------------|-------------|--------|------------|--------|
| FR-001 | | | | |
| FR-002 | | | | |

### Coverage Summary
- Total: N
- Critical Coverage: N%
- High Priority Coverage: N%
```

## Best Practices

### Test Case Design

1. **One test case — one check** — avoid complex checks
2. **Test independence** — each test can run separately
3. **Repeatability** — tests give same result with same data
4. **Clear names** — name should describe what is being tested
5. **Complete steps** — each step should be executable

### Boundary Condition Definition

1. **Requirements analysis** — look for numeric limits, formats, sizes
2. **Equivalence classes** — group similar values
3. **Boundary values** — test values before, at, and after boundary
4. **Negative testing** — test invalid input data

### Traceability

1. **One-to-many** — one requirement can be covered by multiple tests
2. **Completeness** — all requirements should have test coverage
3. **Prioritization** — critical requirements need more coverage

## Related Skills

- requirements-analysis — requirements analysis
- user-stories — user stories with acceptance criteria
- srs-specification — requirements specification
- use-case-modeling — use cases
- quality-metrics (PM) — quality metrics

---

*Test Case Design — quality assurance through systematic testing*
