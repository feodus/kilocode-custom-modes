---
name: accessibility-testing
description: Accessibility testing according to WCAG, Section 508. Use when testing application accessibility, validating screen reader compatibility, ensuring compliance.
---

# Accessibility Testing

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for performing accessibility testing according to WCAG (Web Content Accessibility Guidelines) and Section 508. Designed for ensuring applications are usable by people with disabilities, including visual, motor, cognitive, and auditory impairments.

## When to Use

Use this skill:
- When testing web application accessibility
- For validating screen reader compatibility
- When ensuring keyboard navigation works
- During WCAG compliance validation
- For testing with assistive technologies
- Before accessibility certification
- When fixing accessibility issues

## Functions

### WCAG Guidelines

Understanding accessibility standards:

```markdown
## WCAG 2.1 Principles

### Four Core Principles (POUR)

| Principle | Description | Guidelines |
|-----------|-------------|------------|
| **Perceivable** | Information presented in ways users can perceive | 1.1-1.4 |
| **Operable** | Interface components must be operable | 2.1-2.5 |
| **Understandable** | Content must be understandable | 3.1-3.3 |
| **Robust** | Content must be robust enough for various technologies | 4.1 |

### Conformance Levels
| Level | Description | Requirement |
|-------|-------------|-------------|
| A | Basic accessibility features | Must have |
| AA | Addresses most common barriers | Should have |
| AAA | Highest level of accessibility | Nice to have |

### Quick WCAG Checklist

#### Perceivable (Level A/AA)
- [ ] Images have alt text
- [ ] Videos have captions
- [ ] Color is not the only means of conveying info
- [ ] Audio has transcript
- [ ] Text has sufficient contrast

#### Operable (Level A/AA)
- [ ] All functionality via keyboard
- [ ] No keyboard traps
- [ ] Page titles are descriptive
- [ ] Focus order is logical
- [ ] Skip links provided

#### Understandable (Level A/AA)
- [ ] Language is specified
- [ ] Navigation is consistent
- [ ] Error messages are clear
- [ ] Labels are descriptive

#### Robust (Level A/AA)
- [ ] Valid HTML
- [ ] ARIA used correctly
- [ ] Name, role, value available
```

### Accessibility Testing Tools

```markdown
## Accessibility Testing Tools

### Automated Tools

| Tool | Type | Platform | Key Features |
|------|------|----------|---------------|
| axe DevTools | Browser Extension | Chrome/Firefox | CLI, integrates with CI |
| WAVE | Browser Extension | Chrome/Firefox | Visual feedback |
| Lighthouse | DevTools | Chrome | Comprehensive audit |
| Accessibility Insights | Browser Extension | Chrome/Edge | Guided testing |
| NVDA | Screen Reader | Windows | Free, widely used |
| VoiceOver | Screen Reader | macOS/iOS | Built-in |
| Color Contrast Analyzer | Tool | All | Contrast checking |

### Using axe-core

```javascript
// Accessibility testing with axe-core
const { AxeBuilder } = require('axe-core');

async function runAccessibilityTest(page) {
    const results = await new AxeBuilder({ page })
        .withTags(['wcag2a', 'wcag2aa', 'wcag21aa'])
        .analyze();
    
    console.log(`Violations found: ${results.violations.length}`);
    
    results.violations.forEach(violation => {
        console.log(`\n${violation.id} - ${violation.description}`);
        console.log(`Impact: ${violation.impact}`);
        violation.nodes.forEach(node => {
            console.log(`  - ${node.html}`);
        });
    });
    
    return results;
}
```

### Using Accessibility Insights

```markdown
## Accessibility Insights Test Flow

### Automated Checks
1. Run accessibility scan
2. Review violations by severity
3. Fix critical issues first
4. Re-scan to verify

### Guided Tests
1. **Tab Order** — Navigate via keyboard
2. **Focus Visibility** — Visible focus indicator
3. **Text Alternatives** — Alt text for images
4. **Headings** — Proper heading hierarchy
5. **Color Contrast** — AA/AAA compliance

### Assessment Mode
- Full-page scan
- Issue breakdown
- Fix recommendations
- Export report
```

### Testing with Screen Readers

```markdown
## Screen Reader Testing

### NVDA (Windows)
| Key | Action |
|-----|--------|
| NVDA + Tab | Read next focusable element |
| NVDA + Arrow Keys | Navigate content |
| H | Next heading |
| 1-6 | Heading level |
| T | Next table |
| B | Button |
| Link | Next link |

### VoiceOver (macOS)
| Key | Action |
|-----|--------|
| VO + Arrow | Navigate |
| VO + Space | Activate |
| VO + H | Headings |
| VO + R | Regions |
| VO + T | Tables |

### Testing Checklist
- [ ] All images have alt text
- [ ] Form fields have labels
- [ ] Buttons have accessible names
- [ ] Links have descriptive text
- [ ] Headings are logical
- [ ] Tables have headers
- [ ] ARIA landmarks present
```

### Manual Accessibility Tests

```markdown
## Manual Accessibility Testing

### Keyboard Navigation
| Test | Expected Behavior |
|------|-------------------|
| Tab through page | Logical focus order |
| Enter/Space | Activate buttons/links |
| Arrow keys | Navigate within components |
| Escape | Close modals/menus |
| Home/End | Jump to start/end |

### Visual Testing
| Test | Check |
|------|-------|
| Color contrast | 4.5:1 text, 3:1 UI |
| Focus indicator | Visible on all elements |
| Text resizing | Works up to 200% |
| Content reflow | No horizontal scroll at 320px |
| Animation | Can be paused/reduced |

### Screen Reader Testing
| Element | What to Check |
|---------|----------------|
| Images | Alt text describes content |
| Forms | Labels associated with inputs |
| Buttons | Name describes action |
| Links | Name describes destination |
| Headings | Logical hierarchy |
| Tables | Headers properly marked |
```

### ARIA Implementation

Proper ARIA usage:

```markdown
## ARIA Best Practices

### ARIA Roles
| Role | Use When |
|------|-----------|
| role="navigation" | Navigation regions |
| role="main" | Main content |
| role="banner" | Page header |
| role="contentinfo" | Page footer |
| role="search" | Search form |
| role="dialog" | Modal dialogs |
| role="alert" | Important messages |

### ARIA Attributes
| Attribute | Use |
|-----------|-----|
| aria-label | Accessible name |
| aria-describedby | Additional description |
| aria-required | Required field |
| aria-invalid | Invalid input |
| aria-hidden | Hide from AT |
| aria-expanded | Expand/collapse state |
| aria-selected | Selection state |

### Example: Accessible Modal

```html
<!-- Wrong -->
<div class="modal" onclick="close()">
  <div class="modal-content">
    <h2>Confirm Action</h2>
    <button>Close</button>
  </div>
</div>

<!-- Correct -->
<div role="dialog" aria-modal="true" aria-labelledby="modal-title">
  <h2 id="modal-title">Confirm Action</h2>
  <button aria-label="Close" onclick="close()">×</button>
</div>
```

### Example: Accessible Form

```html
<!-- Wrong -->
<input type="text" placeholder="Email">

<!-- Correct -->
<label for="email">Email Address</label>
<input 
    type="email" 
    id="email" 
    name="email" 
    required
    aria-required="true"
    aria-describedby="email-help"
>
<span id="email-help">We'll never share your email</span>
```

## Usage Examples

### Example 1: Accessibility Audit

```markdown
## Accessibility Audit Report

**Date:** 09-03-2026
**Application:** E-Commerce Platform
**URL:** https://app.example.com
**Standard:** WCAG 2.1 AA

### Summary
| Metric | Count |
|--------|-------|
| Total Issues | 24 |
| Critical | 3 |
| Major | 8 |
| Minor | 13 |

### Critical Issues
| ID | Issue | WCAG | Impact | Fix |
|----|-------|------|--------|-----|
| A11Y-001 | Images missing alt | 1.1.1 | Screen reader users | Add alt text |
| A11Y-002 | Form labels missing | 1.3.1 | All users | Add labels |
| A11Y-003 | No skip link | 2.4.1 | Keyboard users | Add skip link |

### Recommendations
1. Fix critical issues before release
2. Implement automated testing in CI
3. Train developers on accessibility
4. Quarterly accessibility audits
```

### Example 2: Screen Reader Test

```markdown
## Screen Reader Test: Login Page

**Tool:** NVDA 2024.1
**Browser:** Chrome 120

### Test Results
| Element | NVDA Output | Status |
|---------|-------------|--------|
| Username field | "Username, edit, required" | ✅ Pass |
| Password field | "Password, edit, required" | ✅ Pass |
| Login button | "Log in, button" | ✅ Pass |
| Error message | "Invalid credentials" | ✅ Pass |
| Logo image | "Company logo" | ⚠️ Should be empty |
| Social link | "Continue with Google" | ⚠️ Vague |

### Issues Found
1. Logo alt should be decorative (empty)
2. Social login link text unclear for screen readers
```

## Document Templates

### Accessibility Test Report

```markdown
## Accessibility Test Report

**Date:** {Date}
**Application:** {App Name}
**Standard:** WCAG 2.1 {A/AA/AAA}
**URL:** {URL}

### Executive Summary
- Total Issues: {N}
- Critical: {N}
- Major: {N}
- Minor: {N}
- Pass Rate: {X}%

### Results by Principle
| Principle | Issues | Coverage |
|-----------|--------|----------|
| Perceivable | {N} | {X}% |
| Operable | {N} | {X}% |
| Understandable | {N} | {X}% |
| Robust | {N} | {X}% |

### Issues by WCAG Criterion
| Criterion | Count | Severity |
|-----------|-------|----------|
| 1.1.1 Non-text Content | 3 | Critical |
| 1.3.1 Info and Relationships | 5 | Major |
| 2.1.1 Keyboard | 2 | Critical |

### Remediation Plan
| Priority | Issue | Owner | Due Date |
|----------|-------|-------|----------|
| 1 | Fix alt text | Dev Team | {Date} |
| 2 | Add labels | Dev Team | {Date} |
```

### Accessibility Checklist

```markdown
## WCAG 2.1 AA Checklist

### Perceivable
- [ ] 1.1.1 Non-text Content (A) - Alt text
- [ ] 1.3.1 Info and Relationships (A) - Structure
- [ ] 1.3.2 Meaningful Sequence (A)
- [ ] 1.4.1 Use of Color (A)
- [ ] 1.4.3 Contrast (AA) - 4.5:1
- [ ] 1.4.4 Resize text (AA)

### Operable
- [ ] 2.1.1 Keyboard (A)
- [ ] 2.1.2 No Keyboard Trap (A)
- [ ] 2.4.1 Bypass Blocks (A) - Skip links
- [ ] 2.4.2 Page Titled (A)
- [ ] 2.4.3 Focus Order (A)
- [ ] 2.4.4 Link Purpose (A)

### Understandable
- [ ] 3.1.1 Language of Page (A)
- [ ] 3.2.1 On Focus (A)
- [ ] 3.2.2 On Input (A)
- [ ] 3.3.1 Error Identification (A)
- [ ] 3.3.2 Labels or Instructions (A)

### Robust
- [ ] 4.1.1 Parsing (A)
- [ ] 4.1.2 Name, Role, Value (A)
```

## Best Practices

### Accessibility Testing

1. **Test early** — integrate into development
2. **Test often** — automated in CI/CD
3. **Use multiple tools** — automated + manual
4. **Test with real users** — assistive technology
5. **Prioritize issues** — fix critical first

### Design for Accessibility

1. **Semantic HTML** — proper structure
2. **ARIA only when needed** — native elements preferred
3. **Focus management** — visible and logical
4. **Color independence** — don't rely on color
5. **Provide alternatives** — text for non-text

### Continuous Improvement

1. **Set standards** — WCAG AA minimum
2. **Automate checks** — catch regressions
3. **Manual reviews** — expert testing
4. **User feedback** — real-world insights
5. **Regular audits** — quarterly reviews

## Related Skills

- manual-testing — exploratory testing
- test-automation-frameworks — automated a11y tests
- test-case-design — accessibility test cases
- mobile-testing — mobile accessibility
- security-testing — accessible security features

---
*Accessibility Testing — ensuring digital inclusion for all users
