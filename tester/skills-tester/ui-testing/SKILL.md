---
name: ui-testing
description: User interface testing for web and desktop applications. Use when testing UI components, verifying visual elements, cross-browser testing, and responsive design validation.
---

# UI Testing

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for comprehensive user interface testing across web, desktop, and mobile applications. Covers UI component testing, visual validation, cross-browser compatibility, responsive design testing, and user interaction verification.

## When to Use

Use this skill:
- When testing web application user interfaces
- For cross-browser compatibility verification
- When testing responsive design across devices
- For UI component interaction testing
- When validating visual elements and layouts
- For accessibility UI compliance
- During user interface automation

## UI Testing Types

### Functional UI Testing

Testing user interface functionality:

**Element Interactions:**
- Button clicks and form submissions
- Dropdown selections and multi-select
- Drag and drop functionality
- Modal dialogs and popups
- Navigation and routing
- Form validation

**State Verification:**
- Element visibility states
- Enabled/disabled states
- Loading states
- Error states
- Success states

### Visual UI Testing

Visual element validation:

**Layout Testing:**
- Element positioning
- Spacing and alignment
- Responsive behavior
- Grid/flexbox layouts
- Overflow handling

**Styling Verification:**
- Color schemes and contrast
- Typography and fonts
- Iconography
- Shadows and borders

### Cross-Browser Testing

Browser compatibility verification:

| Browser | Market Share | Priority |
|---------|--------------|----------|
| Chrome | 65%+ | High |
| Firefox | 10%+ | High |
| Safari | 15%+ | Medium |
| Edge | 5%+ | Medium |

### Responsive Design Testing

Device and viewport testing:

**Common Viewports:**
| Device | Width | Height |
|--------|-------|--------|
| Mobile S | 320px | 568px |
| Mobile M | 375px | 667px |
| Mobile L | 414px | 896px |
| Tablet | 768px | 1024px |
| Desktop | 1280px | 800px |
| Desktop HD | 1920px | 1080px |

## UI Testing Tools

### Selenium WebDriver

Industry-standard web automation:

```python
# Selenium WebDriver Python Example
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class UIAutomation:
    def __init__(self):
        self.driver = webdriver.Chrome()
    
    def test_login_form(self):
        self.driver.get("https://example.com/login")
        
        # Wait for elements
        username = WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located((By.ID, "username"))
        )
        
        # Fill form
        username.send_keys("testuser")
        password = self.driver.find_element(By.ID, "password")
        password.send_keys("password123")
        
        # Submit
        submit_btn = self.driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
        submit_btn.click()
        
        # Verify redirect
        WebDriverWait(self.driver, 10).until(
            EC.url_contains("/dashboard")
        )
        
    def test_responsive_layout(self):
        viewports = [
            (320, 568),   # Mobile S
            (768, 1024),  # Tablet
            (1280, 800)   # Desktop
        ]
        
        for width, height in viewports:
            self.driver.set_window_size(width, height)
            self.driver.get("https://example.com")
            
            # Verify layout adapts
            container = self.driver.find_element(By.CLASS_NAME, "container")
            assert container.is_displayed()
```

### Playwright

Modern web testing:

```typescript
// Playwright TypeScript Example
import { test, expect } from '@playwright/test';

test.describe('UI Testing', () => {
  test('login form interaction', async ({ page }) => {
    await page.goto('/login');
    
    // Fill form
    await page.fill('#username', 'testuser');
    await page.fill('#password', 'password123');
    
    // Submit and verify
    await page.click('button[type="submit"]');
    await expect(page).toHaveURL('/dashboard');
  });
  
  test('responsive design', async ({ page }) => {
    const viewports = [
      { width: 320, height: 568 },
      { width: 768, height: 1024 },
      { width: 1280, height: 800 }
    ];
    
    for (const viewport of viewports) {
      await page.setViewportSize(viewport);
      await page.goto('/');
      
      // Verify responsive behavior
      const header = page.locator('header');
      await expect(header).toBeVisible();
    }
  });
  
  test('modal dialog interaction', async ({ page }) => {
    await page.goto('/');
    
    // Open modal
    await page.click('.open-modal-btn');
    await expect(page.locator('.modal')).toBeVisible();
    
    // Close modal
    await page.click('.modal .close-btn');
    await expect(page.locator('.modal')).not.toBeVisible();
  });
});
```

### Cypress

JavaScript-centric testing:

```javascript
// Cypress Example
describe('UI Testing', () => {
  beforeEach(() => {
    cy.visit('/login');
  });
  
  it('should display login form', () => {
    cy.get('#username').should('be.visible');
    cy.get('#password').should('be.visible');
    cy.get('button[type="submit"]').should('be.visible');
  });
  
  it('should validate form inputs', () => {
    cy.get('button[type="submit"]').click();
    cy.get('.error-message').should('contain', 'Username is required');
  });
  
  it('should login successfully', () => {
    cy.get('#username').type('testuser');
    cy.get('#password').type('password123');
    cy.get('button[type="submit"]').click();
    
    cy.url().should('include', '/dashboard');
  });
  
  it('should work on mobile viewport', () => {
    cy.viewport(320, 568);
    cy.get('.hamburger-menu').should('be.visible');
    cy.get('.desktop-nav').should('not.be.visible');
  });
});
```

## UI Testing Best Practices

### Element Selection

1. **Use stable selectors** - Prefer data-testid, aria-labels
2. **Avoid fragile selectors** - Don't use generated classes
3. **Semantic selectors** - Use accessible names
4. **Explicit waits** - Wait for elements explicitly

### Test Organization

```markdown
## UI Test Structure

### Page Object Model
```
pages/
├── LoginPage.js
├── DashboardPage.js
└── ProfilePage.js
```

### Test Categories
- **Smoke Tests** - Critical path verification
- **Regression Tests** - Full UI coverage
- **Visual Tests** - Appearance verification
- **Accessibility Tests** - A11y compliance
```

### Responsive Testing Strategy

```markdown
## Responsive Testing Matrix

| Feature | Mobile | Tablet | Desktop |
|---------|--------|--------|---------|
| Navigation | Hamburger | Full | Full |
| Forms | Stacked | Stacked | Inline |
| Tables | Scroll | Scroll | Full |
| Modals | Full-screen | Centered | Centered |
```

## UI Testing Checklist

### Pre-Testing
- [ ] Test environment prepared
- [ ] Test data created
- [ ] Browser versions confirmed
- [ ] Device list defined

### Functional Testing
- [ ] All buttons clickable
- [ ] Forms submit correctly
- [ ] Navigation works
- [ ] Error messages display
- [ ] Loading states shown

### Visual Testing
- [ ] Layout correct on all viewports
- [ ] Colors match design
- [ ] Typography consistent
- [ ] Images load properly
- [ ] Animations smooth

### Cross-Browser
- [ ] Chrome tested
- [ ] Firefox tested
- [ ] Safari tested
- [ ] Edge tested

### Accessibility
- [ ] Keyboard navigation works
- [ ] Screen reader compatible
- [ ] Focus states visible
- [ ] Color contrast adequate

## Common UI Test Scenarios

### Form Testing
```gherkin
Scenario: Valid form submission
  Given I am on the registration page
  When I fill in "username" with "newuser"
  And I fill in "email" with "user@example.com"
  And I fill in "password" with "SecurePass123!"
  And I click the "Register" button
  Then I should see a success message
  And I should be redirected to the dashboard

Scenario: Invalid email format
  Given I am on the registration page
  When I fill in "email" with "invalid-email"
  And I click the "Register" button
  Then I should see "Please enter a valid email"
```

### Navigation Testing
```gherkin
Scenario: Menu navigation on desktop
  Given I am on the homepage at desktop size
  When I hover over "Products" in the menu
  Then I should see a dropdown with product categories

Scenario: Menu navigation on mobile
  Given I am on the homepage at mobile size
  When I click the hamburger menu icon
  Then I should see the navigation menu
```

## Related Skills

- test-automation-frameworks — automation framework design
- accessibility-testing — accessibility compliance
- performance-testing — UI performance
- test-case-design — test case creation
- visual-regression-testing — visual validation

---

*UI Testing — ensuring perfect user interfaces across all platforms*
