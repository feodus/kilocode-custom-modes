---
name: visual-regression-testing
description: Visual regression testing for detecting unintended UI changes. Use when validating visual consistency, detecting layout shifts, and comparing UI snapshots across versions.
---

# Visual Regression Testing

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for comprehensive visual regression testing to detect unintended UI changes, ensure visual consistency across updates, and validate design implementations. Covers screenshot comparison, layout validation, and visual diff automation.

## When to Use

Use this skill:
- When detecting unintended UI changes
- For ensuring visual consistency across pages
- During responsive design verification
- When validating design system compliance
- For detecting layout shifts
- During CSS/styling changes

## Visual Regression Testing Types

### Screenshot Comparison

Comparing visual output:

**Full Page Screenshots:**
- Complete page rendering
- Scrollable content
- Dynamic elements

**Component Screenshots:**
- Individual UI components
- Reusable elements
- Module-level validation

### Layout Validation

Checking layout correctness:

**Structure Testing:**
- Element positioning
- Spacing consistency
- Grid alignment
- Flexbox behavior

**Responsive Layouts:**
- Breakpoint behavior
- Fluid layouts
- Container queries

### Design System Validation

Ensuring design consistency:

**Style Compliance:**
- Color usage
- Typography consistency
- Spacing systems
- Component states

## Visual Regression Testing Tools

### Playwright Visual Testing

```typescript
// Playwright Visual Testing
import { test, expect } from '@playwright/test';

test.describe('Visual Regression Tests', () => {
  test('homepage visual consistency', async ({ page }) => {
    await page.goto('/');
    
    // Take screenshot
    await expect(page).toHaveScreenshot('homepage.png', {
      maxDiffPixelRatio: 0.1,
    });
  });
  
  test('component visual comparison', async ({ page }) => {
    await page.goto('/components/button');
    
    // Test button variants
    const button = page.locator('.btn-primary');
    await expect(button).toHaveScreenshot('button-primary.png');
    
    const buttonSecondary = page.locator('.btn-secondary');
    await expect(buttonSecondary).toHaveScreenshot('button-secondary.png');
  });
  
  test('responsive layouts', async ({ page }) => {
    const viewports = [
      { width: 375, height: 667, name: 'mobile' },
      { width: 768, height: 1024, name: 'tablet' },
      { width: 1280, height: 800, name: 'desktop' }
    ];
    
    for (const viewport of viewports) {
      await page.setViewportSize(viewport);
      await page.goto('/');
      
      await expect(page).toHaveScreenshot(
        `homepage-${viewport.name}.png`,
        { maxDiffPixelRatio: 0.1 }
      );
    }
  });
});
```

### Cypress Visual Testing

```javascript
// Cypress Visual Regression
describe('Visual Regression Tests', () => {
  beforeEach(() => {
    cy.visit('/');
  });
  
  it('should match homepage snapshot', () => {
    cy.matchSnapshot('homepage');
  });
  
  it('should match component at different states', () => {
    // Default state
    cy.get('.button').should('matchSnapshot', 'button-default');
    
    // Hover state
    cy.get('.button').realHover();
    cy.get('.button').should('matchSnapshot', 'button-hover');
    
    // Disabled state
    cy.get('.button').should('have.attr', 'disabled');
    cy.get('.button').should('matchSnapshot', 'button-disabled');
  });
  
  it('should match across viewports', () => {
    cy.viewport(375, 667);
    cy.matchSnapshot('homepage-mobile');
    
    cy.viewport(1280, 800);
    cy.matchSnapshot('homepage-desktop');
  });
});
```

### BackstopJS

Open-source visual testing:

```javascript
// BackstopJS configuration
{
  "id": "visual-regression",
  "viewports": [
    {
      "label": "phone",
      "width": 375,
      "height": 667
    },
    {
      "label": "tablet",
      "width": 768,
      "height": 1024
    },
    {
      "label": "desktop",
      "width": 1280,
      "height": 800
    }
  ],
  "scenarios": [
    {
      "label": "Homepage",
      "url": "https://example.com/",
      "selectors": ["document"],
      "readyEvent": "networkidle0"
    },
    {
      "label": "Product Page",
      "url": "https://example.com/product/123",
      "selectors": [".product-container"],
      "readyEvent": "networkidle0"
    }
  ],
  "report": ["browser"],
  "engine": "puppeteer"
}
```

### Applitools

AI-powered visual testing:

```java
// Applitools with Java
import com.applitools.eyes.selenium.Eyes;
import org.openqa.selenium.WebDriver;

public class VisualTest {
    
    @Test
    public void visualRegressionTest() {
        // Initialize Eyes
        Eyes eyes = new Eyes();
        eyes.setApiKey("YOUR_API_KEY");
        
        WebDriver driver = new ChromeDriver();
        
        try {
            // Start visual testing
            driver = eyes.open(driver, "My App", "Homepage Test");
            
            // Navigate to page
            driver.get("https://example.com");
            
            // Check entire page
            eyes.checkWindow("Homepage");
            
            // Check specific element
            eyes.checkElement(By.cssSelector(".hero-section"));
            
            // Check with region
            eyes.checkRegion(By.cssSelector(".sidebar"));
            
            // Close eyes
            eyes.close();
            
        } finally {
            eyes.abortIfNotClosed();
            driver.quit();
        }
    }
}
```

## Visual Testing Best Practices

### Test Strategy

```markdown
## Visual Testing Strategy

### What to Test
- Critical user paths
- Key UI components
- Design system elements
- Responsive layouts

### What NOT to Test
- Dynamic content (dates, times)
- Third-party widgets
- Randomized content
- Animated elements (unless intentional)

### Test Organization
```
visual-tests/
├── pages/
│   ├── homepage/
│   ├── checkout/
│   └── dashboard/
├── components/
│   ├── buttons/
│   ├── forms/
│   └── navigation/
└── responsive/
    ├── mobile/
    ├── tablet/
    └── desktop/
```
```

### Configuration

```typescript
// Visual testing configuration
export const visualConfig = {
  // Threshold for pixel differences
  threshold: 0.1,
  
  // Ignore dynamic content
  ignore: [
    { selector: '.dynamic-timestamp' },
    { selector: '.user-generated-content' }
  ],
  
  // Ignore color differences
  ignoreColors: true,
  
  // Ignore antialiasing
  ignoreAntialiasing: true,
  
  // Ignore text caret
  ignoreTextCaret: true
};
```

### Handling Dynamic Content

```typescript
// Handling dynamic elements
test('page with dynamic content', async ({ page }) => {
  // Replace dynamic content with static text
  await page.addStyleTag({
    content: `
      .timestamp, .date { visibility: hidden; }
      .timestamp::after, .date::after { 
        content: 'Static Date'; 
        visibility: visible; 
      }
    `
  });
  
  // Take screenshot
  await expect(page).toHaveScreenshot('page.png');
});
```

## Visual Testing Checklist

### Pre-Testing
- [ ] Baseline screenshots captured
- [ ] Test environment stable
- [ ] Browser versions documented
- [ ] Viewport sizes defined

### Capture Settings
- [ ] Proper viewport sizes
- [ ] Hide dynamic content
- [ ] Disable animations
- [ ] Hide scrollbars

### Comparison Settings
- [ ] Threshold configured
- [ ] Ignore rules set
- [ ] Color tolerance defined
- [ ] Layout boundaries set

### Analysis
- [ ] Review diff images
- [ ] Verify intentional changes
- [ ] Document acceptable differences
- [ ] Update baselines when needed

## Common Visual Test Scenarios

### Page-Level Testing
```gherkin
Scenario: Homepage visual consistency
  Given I am on the homepage
  When I take a screenshot
  Then it should match the baseline
  And any differences should be within acceptable threshold
```

### Component Testing
```gherkin
Scenario: Button component states
  Given I am on the button component page
  When I capture the default button state
  Then it should match the baseline
  When I hover over the button
  Then the hover state should match the baseline
  When the button is disabled
  Then the disabled state should match the baseline
```

### Responsive Testing
```gherkin
Scenario: Responsive layout across devices
  Given I am on the product page
  When I view at mobile viewport
  Then it should match mobile baseline
  When I view at tablet viewport
  Then it should match tablet baseline
  When I view at desktop viewport
  Then it should match desktop baseline
```

## Related Skills

- ui-testing — UI component testing
- accessibility-testing — visual accessibility
- test-automation-frameworks — automation frameworks
- test-case-design — visual test case design

---

*Visual Regression Testing — ensuring pixel-perfect consistency*
