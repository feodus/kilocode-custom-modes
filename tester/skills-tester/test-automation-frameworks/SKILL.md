---
name: test-automation-frameworks
description: Setting up and using test automation frameworks (Selenium, Cypress, Playwright). Use when implementing automation, selecting tools, designing framework architecture.
---

# Test Automation Frameworks

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for setting up and using test automation frameworks including Selenium WebDriver, Cypress, and Playwright. Designed for implementing automated testing strategies, building reusable test frameworks, and integrating automation into CI/CD pipelines.

## When to Use

Use this skill:
- When implementing test automation from scratch
- For selecting appropriate automation tools
- When building a test automation framework
- For migrating from manual to automated testing
- When integrating tests into CI/CD pipelines
- For maintaining and scaling existing automation

## Functions

### Framework Selection

Choosing the right automation tool:

```markdown
## Tool Comparison Matrix

| Tool | Best For | Languages | Browser Support | Learning Curve |
|------|----------|-----------|-----------------|----------------|
| Selenium | Cross-browser Web | Java, Python, C#, JS | All | Medium-High |
| Cypress | Modern Web Apps | JavaScript | Chrome, Firefox, Edge | Low |
| Playwright | Complex Web Apps | JS, Python, C# | All | Medium |
| Puppeteer | Chrome Automation | JavaScript | Chrome | Low |

### Selection Criteria
- Application type (web, mobile, API)
- Team expertise
- Browser coverage requirements
- CI/CD integration needs
- Maintenance capabilities
```

### Selenium WebDriver

Setting up and using Selenium:

```markdown
## Selenium Project Structure

```
src/
├── tests/
│   ├── smoke/
│   ├── regression/
│   └── e2e/
├── pages/
│   ├── BasePage.py
│   ├── LoginPage.py
│   └── DashboardPage.py
├── utils/
│   ├── Config.py
│   ├── Logger.py
│   └── DataReader.py
├── drivers/
│   └── chromedriver.exe
├── config/
│   └── config.yaml
├── requirements.txt
└── pytest.ini
```

### Selenium Test Example (Python)

```python
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class TestLogin:
    @pytest.fixture(autouse=True)
    def setup(self):
        self.driver = webdriver.Chrome()
        self.driver.implicitly_wait(10)
        self.driver.get("https://example.com")
    
    def test_successful_login(self):
        login_page = LoginPage(self.driver)
        login_page.enter_username("testuser")
        login_page.enter_password("password123")
        login_page.click_login()
        
        assert "dashboard" in self.driver.current_url
    
    def test_invalid_login(self):
        login_page = LoginPage(self.driver)
        login_page.enter_username("invalid")
        login_page.enter_password("wrong")
        login_page.click_login()
        
        error_msg = login_page.get_error_message()
        assert "Invalid credentials" in error_msg
    
    def teardown(self):
        self.driver.quit()

class LoginPage:
    def __init__(self, driver):
        self.driver = driver
    
    def enter_username(self, username):
        self.driver.find_element(By.ID, "username").send_keys(username)
    
    def enter_password(self, password):
        self.driver.find_element(By.ID, "password").send_keys(password)
    
    def click_login(self):
        self.driver.find_element(By.ID, "login-btn").click()
    
    def get_error_message(self):
        return self.driver.find_element(By.CLASS_NAME, "error").text
```

### Cypress

Modern JavaScript testing framework:

```markdown
## Cypress Configuration

```javascript
// cypress.config.js
const { defineConfig } = require("cypress")

module.exports = defineConfig({
  e2e: {
    baseUrl: "https://example.com",
    viewportWidth: 1280,
    viewportHeight: 720,
    video: false,
    screenshotOnRunFailure: true,
    defaultCommandTimeout: 10000,
    retries: {
      runMode: 2,
      openMode: 0
    },
    env: {
      apiUrl: "https://api.example.com"
    }
  }
})
```

### Cypress Test Example

```javascript
// cypress/e2e/login.cy.js

describe('Login Functionality', () => {
  beforeEach(() => {
    cy.visit('/login')
  })

  it('should login with valid credentials', () => {
    cy.get('[data-testid="username"]').type('testuser')
    cy.get('[data-testid="password"]').type('password123')
    cy.get('[data-testid="login-btn"]').click()
    
    cy.url().should('include', '/dashboard')
    cy.contains('Welcome').should('be.visible')
  })

  it('should show error with invalid credentials', () => {
    cy.get('[data-testid="username"]').type('invalid')
    cy.get('[data-testid="password"]').type('wrong')
    cy.get('[data-testid="login-btn"]').click()
    
    cy.get('[data-testid="error-message"]')
      .should('be.visible')
      .and('contain', 'Invalid credentials')
  })

  it('should validate empty fields', () => {
    cy.get('[data-testid="login-btn"]').click()
    
    cy.get('[data-testid="username-error"]')
      .should('be.visible')
      .and('contain', 'Username is required')
  })
})
```

### Playwright

Cross-browser automation:

```markdown
## Playwright Configuration

```javascript
// playwright.config.js
const { defineConfig, devices } = require('@playwright/test')

module.exports = defineConfig({
  testDir: './tests',
  timeout: 30000,
  expect: {
    timeout: 5000
  },
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'https://example.com',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
})
```

### Playwright Test Example

```javascript
// tests/login.spec.js
const { test, expect } = require('@playwright/test')

test.describe('Login Functionality', () => {
  test('should login with valid credentials', async ({ page }) => {
    await page.goto('/login')
    
    await page.fill('[data-testid="username"]', 'testuser')
    await page.fill('[data-testid="password"]', 'password123')
    await page.click('[data-testid="login-btn"]')
    
    await expect(page).toHaveURL(/.*dashboard/)
    await expect(page.locator('text=Welcome')).toBeVisible()
  })

  test('should show error with invalid credentials', async ({ page }) => {
    await page.goto('/login')
    
    await page.fill('[data-testid="username"]', 'invalid')
    await page.fill('[data-testid="password"]', 'wrong')
    await page.click('[data-testid="login-btn"]')
    
    await expect(page.locator('[data-testid="error-message"]'))
      .toBeVisible()
    await expect(page.locator('[data-testid="error-message"]'))
      .toContainText('Invalid credentials')
  })
})
```

### Page Object Model

Implementing POM pattern:

```markdown
## Page Object Model Structure

### Base Page
```python
# pages/base_page.py
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class BasePage:
    def __init__(self, driver):
        self.driver = driver
        self.wait = WebDriverWait(driver, 10)
    
    def click(self, locator):
        element = self.wait.until(EC.element_to_be_clickable(locator))
        element.click()
    
    def type(self, locator, text):
        element = self.wait.until(EC.presence_of_element_located(locator))
        element.clear()
        element.send_keys(text)
    
    def get_text(self, locator):
        element = self.wait.until(EC.presence_of_element_located(locator))
        return element.text
    
    def is_visible(self, locator):
        try:
            element = self.wait.until(EC.presence_of_element_located(locator))
            return element.is_displayed()
        except:
            return False
```

### Page Class Example
```python
# pages/login_page.py
from selenium.webdriver.common.by import By
from base_page import BasePage

class LoginPage(BasePage):
    # Locators
    USERNAME_INPUT = (By.ID, "username")
    PASSWORD_INPUT = (By.ID, "password")
    LOGIN_BUTTON = (By.ID, "login-btn")
    ERROR_MESSAGE = (By.CLASS_NAME, "error-message")
    
    # Actions
    def enter_username(self, username):
        self.type(self.USERNAME_INPUT, username)
    
    def enter_password(self, password):
        self.type(self.PASSWORD_INPUT, password)
    
    def click_login(self):
        self.click(self.LOGIN_BUTTON)
    
    def get_error_message(self):
        return self.get_text(self.ERROR_MESSAGE)
    
    def login(self, username, password):
        self.enter_username(username)
        self.enter_password(password)
        self.click_login()
```

## Usage Examples

### Example 1: Selenium Test Suite

```python
# test_suite.py
import pytest
from selenium import webdriver
from pages.login_page import LoginPage
from pages.dashboard_page import DashboardPage

class TestAuthentication:
    @pytest.fixture(scope="class")
    def setup_class(self):
        self.driver = webdriver.Chrome()
        self.driver.maximize_window()
        yield
        self.driver.quit()
    
    def test_tc001_valid_login(self, setup_class):
        login = LoginPage(self.driver)
        login.login("valid@email.com", "Password123!")
        
        dashboard = DashboardPage(self.driver)
        assert dashboard.is_logged_in()
    
    def test_tc002_invalid_email(self, setup_class):
        login = LoginPage(self.driver)
        login.login("invalid", "Password123!")
        
        assert "Invalid email" in login.get_error_message()
    
    def test_tc003_empty_password(self, setup_class):
        login = LoginPage(self.driver)
        login.login("valid@email.com", "")
        
        assert "Password required" in login.get_error_message()
```

### Example 2: Cypress API Testing

```javascript
// cypress/e2e/api.cy.js

describe('API Tests', () => {
  const baseUrl = 'https://api.example.com'
  
  it('should create new user', () => {
    cy.request({
      method: 'POST',
      url: `${baseUrl}/users`,
      body: {
        name: 'Test User',
        email: 'test@example.com'
      }
    }).then((response) => {
      expect(response.status).to.eq(201)
      expect(response.body).to.have.property('id')
      expect(response.body.name).to.eq('Test User')
    })
  })

  it('should get user by id', () => {
    cy.request(`${baseUrl}/users/1`).then((response) => {
      expect(response.status).to.eq(200)
      expect(response.body).to.include.keys('id', 'name', 'email')
    })
  })
})
```

## Document Templates

### Automation Test Report

```markdown
## Automation Test Report

**Date:** {Date}
**Framework:** {Selenium/Cypress/Playwright}
**Total Tests:** {N}
**Passed:** {N}
**Failed:** {N}
**Pass Rate:** {X}%

### Test Results
| Test Suite | Executed | Passed | Failed | Duration |
|------------|----------|--------|--------|----------|
| Smoke | 10 | 10 | 0 | 5m |
| Regression | 50 | 48 | 2 | 25m |

### Failed Tests
| Test | Error | Issue ID |
|------|-------|----------|
| test_login | Timeout | BUG-001 |
| test_search | Element not found | BUG-002 |

### Execution Environment
- Browser: Chrome 120
- OS: Windows 11
- CI: GitHub Actions
```

### Framework Architecture Document

```markdown
## Test Automation Framework Architecture

### Technology Stack
- Language: {Python/JavaScript}
- Framework: {Selenium/Cypress/Playwright}
- Test Runner: {Pytest/Cypress}
- Reporting: {Allure/HTML Report}

### Components
1. **Test Layer** — Test cases and scenarios
2. **Page Object Layer** — Page interactions
3. **Utility Layer** — Helpers and utilities
4. **Configuration Layer** — Settings and configs
5. **Data Layer** — Test data management

### Design Patterns
- Page Object Model (POM)
- Factory Pattern
- Singleton Pattern
- Fluent Interface
```

## Best Practices

### Framework Design

1. **Use Page Object Model** — separate page logic from tests
2. **Implement proper waits** — avoid hard-coded sleeps
3. **Use meaningful locators** — prefer data-testid attributes
4. **Maintain test independence** — no test dependencies
5. **Implement reporting** — detailed failure information

### Test Maintenance

1. **Review regularly** — update for application changes
2. **Monitor flaky tests** — investigate and fix promptly
3. **Clean up code** — refactor when needed
4. **Version control** — track all changes
5. **Document patterns** — share knowledge

### CI/CD Integration

1. **Parallel execution** — run tests in parallel
2. **Screenshots on failure** — capture evidence
3. **Retry logic** — handle transient failures
4. **Environment config** — use environment variables
5. **Artifact retention** — save logs and videos

## Related Skills

- test-case-design — designing automated test cases
- api-testing — API automation testing
- performance-testing — load and performance testing
- defect-management — reporting automation defects
- test-data-management — managing test data

---
*Test Automation — scaling quality through efficient, repeatable testing
