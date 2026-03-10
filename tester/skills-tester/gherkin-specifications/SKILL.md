---
name: gherkin-specifications
description: Writing Gherkin specifications for BDD testing. Use when creating feature files, describing system behavior scenarios, preparing for automated testing.
---

# Gherkin Specifications for BDD Testing

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for creating Gherkin specifications — a formal language for describing system behavior in BDD (Behavior-Driven Development) style. Gherkin allows recording requirements as executable scenarios understandable to all team members: analysts, developers, testers, and business stakeholders.

Gherkin is the foundation for automation BDD frameworks such as Cucumber, Behave, SpecFlow, and similar. This skill covers all Gherkin language elements, scenario writing rules, and their integration with the testing process.

## When to Use

Use this skill:

- When creating executable specifications for testing
- When describing system behavior in business language
- For preparing data for automated BDD testing
- When creating feature files for Cucumber/Behave/SpecFlow
- For improving communication between technical and non-technical team members
- When writing user stories with acceptance criteria in Gherkin format
- When validating requirements through executable scenarios

## Gherkin Structure

### Feature

`Feature` block is the main Gherkin element describing a function or system capability:

```gherkin
Feature: {Feature name}
  As a {role}
  I want {capability}
  So that {benefit/value}
```

**Feature Elements:**

| Element | Description | Required |
|---------|-------------|----------|
| Feature | Feature name | Yes |
| As a | User role | Recommended |
| I want | Desired action | Recommended |
| So that | Business value | Recommended |

**Example:**

```gherkin
Feature: User Authentication
  As a registered user
  I want to log into the system
  So that I can access my personal dashboard
```

### Scenario

`Scenario` is an individual test scenario within Feature:

```gherkin
Scenario: {Scenario name}
  Given {precondition}
  When {action}
  Then {expected result}
```

### Steps (Given/When/Then/And/But)

Main Gherkin keywords:

| Keyword | Purpose | Recommendation |
|---------|---------|----------------|
| Given | Precondition, initial state | Use for preconditions |
| When | User or system action | Main action of scenario |
| Then | Expected result | Verify result |
| And | Add condition/action/result | Use with Given/When/Then |
| But | Opposite condition/result | Use for negative cases |

**Steps Usage Rules:**

1. **Given** — describes context/system state
2. **When** — describes the action being tested
3. **Then** — describes expected result

**Example:**

```gherkin
Scenario: Successful login
  Given I am on the login page
  When I enter username "admin"
  And I enter password "password123"
  And I click the "Login" button
  Then I should see the dashboard
  And I should see "Welcome" message
```

### Scenario Outline

`Scenario Outline` is a parameterized scenario for testing with different input data:

```gherkin
Scenario Outline: {Description}
  Given {condition with <variable>}
  When {action with <variable>}
  Then {expected result}

  Examples:
    | variable |
    | value1   |
    | value2   |
```

**Example:**

```gherkin
Scenario Outline: Login validation
  Given I am on the login page
  When I enter username "<username>"
  And I enter password "<password>"
  Then I should see error message "<error>"

  Examples:
    | username | password  | error                  |
    | empty   | anypass   | Username is required   |
    | user1   | empty     | Password is required   |
    | invalid | wrong     | Invalid credentials    |
```

### Background

`Background` is common preconditions for all scenarios in Feature:

```gherkin
Background:
  Given the system is running
  And the database is accessible
  And I am an authenticated user
```

**Background Usage Rules:**

1. Use only for common preconditions (more than 2 scenarios)
2. Avoid long chains in Background
3. Don't use Background for scenario-specific data

### Tags

`Tags` are metadata for categorizing scenarios:

```gherkin
@authentication @smoke
Feature: User Authentication
  ...
  
  @happy-path
  Scenario: Successful login
  ...
  
  @negative @validation
  Scenario: Invalid login
  ...
```

**Standard Tags:**

| Tag | Purpose |
|-----|---------|
| @smoke | Smoke tests (critical functionality) |
| @regression | Regression tests |
| @negative | Negative scenarios |
| @security | Security tests |
| @performance | Load tests |
| @wip | Work in progress (not ready) |

## Integration with Test Automation

### Data for Test Automation Frameworks

When passing Gherkin specifications to automation frameworks:

**BDD Project Structure:**

```
project/
├── features/
│   ├── authentication.feature
│   ├── user_management.feature
│   └── ...
├── steps/
│   ├── authentication_steps.py
│   └── ...
├── environment.py
└── requirements.txt
```

**Step Definitions Requirements:**

| Element | Description |
|---------|-------------|
| Step Definitions | Code linking Gherkin to actual implementation |
| Hooks | Setup/teardown logic (Before, After, etc.) |
| Data Tables | Working with tables in Gherkin |
| Scenario Outline | Test parameterization |

**Step Definition Example (Python/Behave):**

```python
from behave import given, when, then

@given('I am on the login page')
def step_login_page(context):
    context.page.navigate_to("/login")

@when('I enter username "{username}"')
def step_enter_username(context, username):
    context.page.enter_username(username)

@when('I click the "{button}" button')
def step_click_button(context, button):
    context.page.click_button(button)

@then('I should see the dashboard')
def step_verify_dashboard(context):
    assert context.page.is_dashboard_visible()
```

### Automation Recommendations

1. **File naming:** `*.feature` for Gherkin, `*_steps.py` for step definitions
2. **Steps structure:** Group by functionality
3. **Page Objects:** Use Page Object pattern for UI interactions
4. **Hooks:** Define common logic in `environment.py` (Behave)

## Usage Examples

### Example 1: User Authentication

```gherkin
@authentication @smoke
Feature: User Authentication
  As a registered user
  I want to log into the system
  So that I can access my personal dashboard

  Background:
    Given the authentication system is running
    And the database is accessible

  @happy-path
  Scenario: Successful login with valid credentials
    Given I am on the login page
    When I enter valid username "john_doe"
    And I enter valid password "SecurePass123!"
    And I click the "Login" button
    Then I should be redirected to the dashboard
    And I should see "Welcome, John!" message

  @negative @validation
  Scenario: Login fails with invalid credentials
    Given I am on the login page
    When I enter username "invalid_user"
    And I enter password "wrong_password"
    And I click the "Login" button
    Then I should see error message "Invalid credentials"
    And I should remain on the login page

  @security
  Scenario: Account locked after multiple failed attempts
    Given a user "john_doe" exists in the system
    And the maximum login attempts is 3
    When I fail to login 3 times with username "john_doe"
    Then the account "john_doe" should be locked
    And I should see "Account locked. Contact support." message
```

### Example 2: User Management (Scenario Outline)

```gherkin
@user-management @crud
Feature: User Profile Management
  As a user
  I want to manage my profile
  So that I can keep my information up to date

  @positive
  Scenario Outline: Update user profile fields
    Given I am logged in as "test_user"
    And I am on the profile edit page
    When I update the field "<field>" to "<value>"
    And I click "Save" button
    Then the profile should be updated
    And I should see success message "Profile updated"

    Examples:
      | field      | value              |
      | first_name | John               |
      | last_name  | Doe                |
      | email      | john@example.com   |
      | phone      | +7-999-123-45-67   |

  @negative
  Scenario Outline: Validation errors on profile update
    Given I am logged in as "test_user"
    And I am on the profile edit page
    When I update the field "<field>" to "<invalid_value>"
    And I click "Save" button
    Then I should see validation error "<error>"

    Examples:
      | field | invalid_value     | error                        |
      | email | not-an-email      | Invalid email format         |
      | phone | 123               | Phone must be 10+ digits    |
      | name  | (empty)           | Name is required             |
```

### Example 3: Working with Data (Data Tables)

```gherkin
@admin @users
Feature: Bulk User Operations
  As an administrator
  I want to perform bulk operations on users
  So that I can efficiently manage multiple accounts

  Scenario: Add multiple users from table
    Given I am on the admin users page
    When I add the following users:
      | username  | email              | role    |
      | user1     | user1@example.com  | editor  |
      | user2     | user2@example.com  | viewer  |
      | user3     | user3@example.com  | editor  |
    Then 3 new users should be created
    And I should see success message "3 users added"

  Scenario: Filter users by role
    Given the following users exist:
      | username | role   |
      | alice    | admin  |
      | bob      | editor |
      | charlie  | viewer |
    When I filter by role "editor"
    Then I should see only:
      | username |
      | bob      |
```

## Best Practices

### Writing Scenarios

1. **One scenario — one behavior** — avoid complex scenarios
2. **Naming format:** `Scenario: {action} with {condition}`
3. **Use business language** — avoid technical details in Gherkin
4. **Minimize Steps** — recommend up to 10 steps
5. **Avoid conditional logic** — Gherkin doesn't support if/else

### Feature File Structure

1. **One Feature — one file** — for easier navigation
2. **Group by functionality** — directories by modules
3. **Tags for categorization** — @smoke, @regression, @module-name
4. **Background — only common** — no more than 3-4 steps

### Maintaining Quality

1. **Traceability** — link scenarios to requirements (FR-ID)
2. **Independence** — scenarios should not depend on each other
3. **Repeatability** — same result on multiple runs
4. **Atomicity** — each scenario checks one behavior

## Related Skills

- test-case-design — test case design
- user-stories — user stories with acceptance criteria
- requirements-analysis — requirements analysis
- srs-specification — software requirements specification
- use-case-modeling — use cases

---
*Gherkin Specifications — executable documentation for BDD testing*
