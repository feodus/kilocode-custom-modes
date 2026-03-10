---
name: test-management-tools
description: Using test management tools (TestRail, Zephyr, Xray). Use when organizing test cases, tracking test execution, managing test cycles.
---

# Test Management Tools

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for using test management tools including TestRail, Zephyr (Jira), and Xray (Jira). Designed for organizing test cases, tracking test execution, managing test cycles, and generating test reports.

## When to Use

Use this skill:
- When setting up test management processes
- For organizing test case repositories
- When tracking test execution progress
- For managing test cycles and milestones
- During test reporting and analytics
- When integrating with defect tracking
- For test requirements traceability

## Functions

### TestRail

TestRail configuration and usage:

```markdown
## TestRail Structure

### Projects and Sections
```
Project: E-Commerce Platform
├── Functional Tests
│   ├── User Management
│   │   ├── Login
│   │   ├── Registration
│   │   └── Password Reset
│   ├── Product Catalog
│   │   ├── Search
│   │   └── Filters
│   └── Checkout
│       ├── Cart
│       └── Payment
├── Integration Tests
├── Performance Tests
└── Regression Tests
```

### TestRail API

```python
import requests

# TestRail API Configuration
BASE_URL = "https://example.testrail.io"
EMAIL = "tester@example.com"
API_KEY = "your_api_key"

def get_headers():
    return {
        "Content-Type": "application/json",
        "Authorization": f"Basic {requests.auth._basic_auth_str(EMAIL, API_KEY)}"
    }

# Get all test cases
def get_test_cases(project_id, suite_id):
    response = requests.get(
        f"{BASE_URL}/api/v2/get_cases/{project_id}/{suite_id}",
        headers=get_headers()
    )
    return response.json()

# Add test result
def add_test_result(run_id, case_id, status_id, comment):
    data = {
        "status_id": status_id,  # 1=Passed, 2=Blocked, 3=Untested, 4=Retest, 5=Failed
        "comment": comment
    }
    response = requests.post(
        f"{BASE_URL}/api/v2/add_result/{run_id}/{case_id}",
        headers=get_headers(),
        json=data
    )
    return response.json()

# Create test run
def create_test_run(project_id, suite_id, name):
    data = {
        "suite_id": suite_id,
        "name": name,
        "description": "Automated test run",
        "include_all": True
    }
    response = requests.post(
        f"{BASE_URL}/api/v2/add_run/{project_id}",
        headers=get_headers(),
        json=data
    )
    return response.json()
```

### TestRail Test Case Template

```markdown
## Test Case: TC-001

**Title:** Successful User Login
**Type:** Functional
**Priority:** High
**Estimate:** 5 minutes
**References:** REQ-001, REQ-002

### Preconditions
- User account exists in system
- User is not logged in
- Login page is accessible

### Test Steps
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to login page | Login form is displayed |
| 2 | Enter valid username | Username is accepted |
| 3 | Enter valid password | Password is masked |
| 4 | Click Login button | User is authenticated |
| 5 | Verify redirect | Dashboard is displayed |

### Expected Result
User successfully logs in and is redirected to the dashboard.

### Related Requirements
- REQ-001: User Authentication
- REQ-002: Secure Login

### Attachments
- Screenshot: login_form.png
```

### Zephyr (Jira)

Zephyr for Jira test management:

```markdown
## Zephyr Test Management

### Test Issue Types
- **Test** — Individual test case
- **Test Cycle** — Group of tests
- **Test Execution** — Test run result

### Creating Test in Jira
```markdown
## Issue: TEST-101
**Type:** Test
**Project:** E-Commerce
**Summary:** Verify successful login

### Description
h3. Preconditions
- User account exists

h3. Test Steps
| # | Step | Expected Result |
|---|------|-----------------|
| 1 | Navigate to login | Form displayed |
| 2 | Enter credentials | Data entered |
| 3 | Click Login | Dashboard shown |

h3. Test Data
- Username: testuser@example.com
- Password: TestPass123!

### Labels
- functional
- login
- smoke

### Component
- Authentication
```

### Zephyr Test Cycle

```markdown
## Test Cycle: Sprint 25 Regression

**Start Date:** 2026-03-09
**End Date:** 2026-03-15
**Status:** In Progress
**Environment:** Staging

### Test Summary
| Metric | Value |
|--------|-------|
| Total Tests | 150 |
| Executed | 100 |
| Passed | 85 |
| Failed | 10 |
| Blocked | 5 |
| Not Executed | 50 |

### Test Execution Progress
- Day 1: 20%
- Day 2: 45%
- Day 3: 67%
- Day 4: 75% (current)
```

### Xray (Jira)

Xray test management:

```markdown
## Xray Configuration

### Test Types in Xray
- **Cucumber Tests** — BDD scenarios
- **Generic Tests** — Manual tests
- **Robot Tests** — Robot Framework
- **JUnit Tests** — Java unit tests
- **PyTest Tests** — Python tests
- **Behave Tests** — Python BDD

### Xray Test Import
```python
# Xray REST API - Import results
import requests

BASE_URL = "https://xray.xpand-it.com"
AUTH = ("user", "api_token")

# Import execution results
def import_execution(results, testExecKey):
    response = requests.post(
        f"{BASE_URL}/api/v2/import/execution",
        auth=AUTH,
        headers={"Content-Type": "application/json"},
        json={
            "testExecutionKey": testExecKey,
            "results": results
        }
    )
    return response.json()

# Example results
results = {
    "tests": [
        {
            "testKey": "TEST-101",
            "status": "PASSED"
        },
        {
            "testKey": "TEST-102",
            "status": "FAILED",
            "comment": "Assertion error"
        }
    ]
}
```
```

### Test Management Workflows

```markdown
## Test Management Workflow

### Test Case Lifecycle
1. Draft → 2. Review → 3. Approved → 4. Executed → 5. Archived

### Test Execution Workflow
1. Create Test Cycle
2. Add Test Cases
3. Assign to Testers
4. Execute Tests
5. Log Results
6. Report Defects
7. Retest (if needed)
8. Close Cycle

### Test Planning Process
1. Analyze requirements
2. Identify test scenarios
3. Create test cases
4. Review and approve
5. Add to test suite
6. Link to requirements
```

## Usage Examples

### Example 1: TestRail Test Execution

```markdown
## Test Execution Report - Sprint 25

**Project:** E-Commerce Platform
**Test Cycle:** Sprint 25 Regression
**Date:** 09-03-2026

### Test Execution Summary
| Status | Count | Percentage |
|--------|-------|------------|
| Passed | 85 | 57% |
| Failed | 15 | 10% |
| Blocked | 5 | 3% |
| Retest | 10 | 7% |
| Untested | 35 | 23% |

### Failed Tests
| Test Case | Failure Reason | Defect |
|-----------|---------------|--------|
| TC-101 | Login timeout | BUG-234 |
| TC-102 | Payment failed | BUG-235 |
| TC-103 | Cart empty | BUG-236 |

### Risk Assessment
- High Risk: 5 tests failed
- Medium Risk: 10 tests blocked
- Low Risk: All other tests passed
```

### Example 2: Zephyr Test Cycle Management

```markdown
## Zephyr Test Cycle: Release 2.1

### Cycle Details
- **Key:** CYCLE-101
- **Start:** March 1, 2026
- **End:** March 15, 2026
- **Goal:** Full regression for Release 2.1

### Test Coverage
| Module | Tests | Passed | Failed | Coverage |
|--------|-------|--------|--------|----------|
| Login | 20 | 18 | 2 | 100% |
| Products | 35 | 30 | 5 | 100% |
| Cart | 25 | 22 | 3 | 100% |
| Checkout | 30 | 25 | 5 | 100% |
| Profile | 15 | 12 | 3 | 100% |

### Execution Status
- Currently executing: Profile module
- Blocker: BUG-240 preventing checkout tests
- Plan: Complete by EOD March 9
```

## Document Templates

### Test Plan Template

```markdown
## Test Plan: {Project Name}

### Overview
- **Project:** {Name}
- **Version:** {Version}
- **Date:** {Date}
- **Lead:** {Name}

### Scope
- **In Scope:** {Features}
- **Out of Scope:** {Features}

### Test Strategy
| Type | Approach | Tools |
|------|----------|-------|
| Functional | Manual + Automated | TestRail |
| Regression | Automated | Selenium |
| Performance | Automated | JMeter |

### Test Environment
- **Staging:** stg-app.example.com
- **Database:** PostgreSQL 14
- **Browser:** Chrome 120, Firefox 120

### Schedule
| Phase | Dates | Activities |
|-------|-------|------------|
| Unit Testing | Week 1 | Developer tests |
| Integration | Week 2 | API tests |
| System | Week 3 | E2E tests |
| UAT | Week 4 | User testing |

### Entry/Exit Criteria
- Entry: Code complete, environment ready
- Exit: All critical tests pass, <5% defect density
```

### Test Summary Report

```markdown
## Test Summary Report

**Period:** {Date Range}
**Total Test Cases:** {N}
**Executed:** {N}

### Results
| Outcome | Count | % |
|---------|-------|---|
| Passed | {N} | {X}% |
| Failed | {N} | {X}% |
| Blocked | {N} | {X}% |

### Quality Indicators
- Defect Density: {X}/1000 LOC
- Test Coverage: {X}%
- Requirements Coverage: {X}%

### Recommendations
1. {Recommendation 1}
2. {Recommendation 2}
```

## Best Practices

### Test Management

1. **Organize logically** — use sections and milestones
2. **Link to requirements** — maintain traceability
3. **Regular updates** — keep status current
4. **Document deviations** — note any changes
5. **Use templates** — consistent documentation

### Tool Integration

1. **Defect integration** — link to Jira/YouTrack
2. **Automation integration** — connect CI/CD
3. **Requirement links** — trace to specs
4. **Version control** — track test changes
5. **API usage** — automate repetitive tasks

### Reporting

1. **Regular reports** — daily/weekly summaries
2. **Visual dashboards** — easy to understand
3. **Trend analysis** — historical comparisons
4. **Stakeholder updates** — tailored content
5. **Actionable insights** — clear next steps

## Related Skills

- test-case-design — test case creation
- defect-management — defect tracking
- gherkin-specifications — BDD test cases
- test-automation-frameworks — automation integration
- performance-testing — performance test tracking

---
*Test Management Tools — organizing and tracking testing for project success
