---
name: defect-management
description: Effective defect reporting, tracking, and management in JIRA, Azure DevOps. Use when reporting bugs, tracking issues, managing defect lifecycle.
---

# Defect Management

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for effective defect reporting, tracking, and management using JIRA and Azure DevOps. Designed for creating actionable defect reports, managing defect lifecycle, and coordinating fix verification.

## When to Use

Use this skill:
- When reporting software defects
- For tracking defect status and progress
- When managing defect lifecycle
- During triage meetings
- For defect prioritization
- When coordinating with developers
- For defect metrics and reporting

## Functions

### Defect Lifecycle

Managing defect states:

```markdown
## Defect Lifecycle States

| State | Description | Owner |
|-------|-------------|-------|
| New | Defect reported, not reviewed | QA |
| Assigned | Assigned to developer | Lead |
| In Progress | Being fixed | Developer |
| In Review | Fix under review | Developer/Lead |
| Ready for Test | Fix available for verification | QA |
| Verified | Fix confirmed, closed | QA |
| Reopened | Issue persists | QA |
| Closed | Defect resolved | QA |
| Won't Fix | Not going to fix | Product |
| Duplicate | Already exists | QA/Lead |

### State Transitions
```
New → Assigned → In Progress → In Review → Ready for Test
                                    ↓ (failed)
                              Verified → Closed
                                    ↓
                                Reopened → ...
```
```

### JIRA Defect Template

Creating effective JIRA issues:

```markdown
## JIRA Bug Report Template

### Issue Fields

**Project:** {Project Key}
**Issue Type:** Bug
**Summary:** [Brief description - what and where]

### Description

h3. Environment
- OS: Windows 11 / macOS Ventura
- Browser: Chrome 120 / Firefox 120
- App Version: v2.1.0
- Build: #1234

h3. Steps to Reproduce
1. Navigate to [page/feature]
2. Click [button/link]
3. Enter [data]
4. Click [submit]

h3. Expected Result
[What should happen]

h3. Actual Result
[What actually happened]

h3. Severity
- [ ] Critical - System down
- [ ] High - Major feature broken
- [ ] Medium - Feature impaired
- [ ] Low - Minor issue

h3. Priority
- [ ] P1 - Must fix
- [ ] P2 - Should fix
- [ ] P3 - Fix if time
- [ ] P4 - Won't fix

### Attachments
- Screenshot: bug_screenshot.png
- Video: reproduction.webm
- Log file: error.log

### Labels
- bug
- regression
- [module_name]
```

### Azure DevOps Bug Template

```markdown
## Azure DevOps Bug Template

### Basic Info
- **Type:** Bug
- **Title:** [What and where]

### Description

#### Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

#### Expected Behavior
[What should happen]

#### Actual Behavior
[What happened instead]

#### Environment
- Application: [Version]
- OS: [OS Version]
- Browser: [Browser]

### Repro Frequency
- [ ] Always
- [ ] Sometimes
- [ ] Rarely

### Severity
- [ ] 1 - Critical
- [ ] 2 - High
- [ ] 3 - Medium
- [ ] 4 - Low

### System Info
- CPU: [Info]
- RAM: [Info]
- Network: [Type]

### Related Work Items
- Feature: [ID]
- Requirement: [ID]
```

### Defect Reporting Best Practices

Creating effective bug reports:

```markdown
## Effective Bug Report Elements

### The 5Ws of Bug Reporting
| Element | Question | Example |
|---------|----------|---------|
| What | What's wrong? | Login fails |
| Where | Where does it occur? | Login page |
| When | When does it happen? | After entering credentials |
| Why | Why is it wrong? | Error message unclear |
| How | How to reproduce? | See steps below |

### Good Bug Report Checklist
- [ ] Clear, specific title
- [ ] Environment details
- [ ] Steps to reproduce
- [ ] Expected vs actual result
- [ ] Severity and priority
- [ ] Screenshots/videos
- [ ] Logs if applicable
- [ ] Reproducible (or not)

### Anti-Patterns to Avoid
- ❌ "It's not working"
- ❌ "Something is wrong"
- ❌ No steps to reproduce
- ❌ Multiple issues in one bug
- ❌ Vague descriptions
```

### Defect Prioritization

Prioritizing defects effectively:

```markdown
## Defect Prioritization Matrix

### Severity vs Priority

| Severity/Impact | Urgency High | Urgency Low |
|-----------------|--------------|-------------|
| **High** | P1 | P2 |
| **Medium** | P2 | P3 |
| **Low** | P3 | P4 |

### Severity Definitions
| Level | Definition | Example |
|-------|------------|---------|
| Critical | System unusable | App crashes |
| High | Major function broken | Can't login |
| Medium | Feature impaired | Search slow |
| Low | Cosmetic | Typo |

### Priority Definitions
| Level | Definition | Timeline |
|-------|------------|----------|
| P1 | Critical business impact | 24 hours |
| P2 | Major issue | 1 week |
| P3 | Should fix | Next release |
| P4 | Nice to have | Backlog |

### Triage Meeting Guidelines
1. Review new defects daily
2. Assign severity and priority
3. Identify duplicates
4. Set target dates
5. Assign to developers
```

### Defect Metrics

Tracking and analyzing defects:

```markdown
## Defect Metrics

### Key Metrics
| Metric | Formula | Target |
|--------|---------|--------|
| Defect Density | Defects/KLOC | < 1.0 |
| Defect Leakage | Escaped Defects / Total | < 5% |
| Fix Rate | Fixed / Reported | > 85% |
| Avg Fix Time | Total Time / Fixed | < 5 days |
| Reopen Rate | Reopened / Fixed | < 10% |

### Defect Categories
| Category | Percentage | Action |
|----------|------------|--------|
| Requirements | 15% | Improve specs |
| Design | 20% | Review design |
| Code | 40% | Code review |
| Test | 25% | Improve testing |

### Metrics Dashboard
- Daily: New, Resolved, Closed
- Weekly: By severity, By module
- Monthly: Trends, Aging report
```

## Usage Examples

### Example 1: JIRA Bug Report

```markdown
## JIRA Issue: BUG-234

**Project:** ECOM
**Type:** Bug
**Status:** New

### Summary
Login fails with timeout after entering valid credentials

### Description

**Environment:**
- OS: Windows 11
- Browser: Chrome 120
- App Version: 2.1.0 (Build 1234)

**Steps to Reproduce:**
1. Navigate to https://app.ecommerce.com/login
2. Enter username: "testuser@example.com"
3. Enter password: "TestPass123!"
4. Click "Login" button
5. Wait for response

**Expected Result:**
User should be redirected to dashboard within 3 seconds

**Actual Result:**
Request times out after 30 seconds with no error message

**Severity:** High
**Priority:** P2

**Screenshots:**
- login_page.png
- network_tab.png
- console_errors.png
```

### Example 2: Defect Triage

```markdown
## Defect Triage Meeting - March 9, 2026

### Attendees
- Product Manager
- Development Lead
- QA Lead

### New Defects Reviewed
| ID | Summary | Severity | Priority | Decision |
|----|---------|----------|----------|----------|
| BUG-234 | Login timeout | High | P1 | Assign to John, fix today |
| BUG-235 | Cart clears | Medium | P2 | Assign to Mary |
| BUG-236 | Price display | Low | P3 | Won't fix for v2.1 |
| BUG-237 | Search slow | Medium | P2 | Performance ticket |
| BUG-238 | Duplicate of BUG-234 | - | - | Close as duplicate |

### Actions
- [ ] BUG-234: Priority escalated to P1
- [ ] Performance review for BUG-237
- [ ] Update regression suite

### Next Triage
- Daily standup tomorrow
- Focus on P1 defects
```

## Document Templates

### Defect Report Template

```markdown
## Defect Report

### Identification
- **ID:** {AUTO-GENERATED}
- **Title:** {Brief description}
- **Status:** {New/Assigned/etc.}
- **Date Reported:** {Date}

### Classification
- **Severity:** {Critical/High/Medium/Low}
- **Priority:** {P1/P2/P3/P4}
- **Type:** {Bug/Defect/Issue}
- **Category:** {Functional/UI/Performance/Security}

### Details
- **Component:** {Module name}
- **Build Number:** {Version}
- **Environment:** {Dev/Staging/Prod}

### Description
**Steps to Reproduce:**
1.
2.
3.

**Expected Result:**

**Actual Result:**

### Supporting Evidence
- Screenshot: {filename}
- Video: {filename}
- Logs: {filename}

### Resolution
- **Fixed in Build:** {Build #}
- **Fixed Date:** {Date}
- **Verified By:** {Tester name}
```

### Defect Status Report

```markdown
## Defect Status Report

**Date:** {Date}
**Period:** {Date Range}

### Summary
| Status | Count |
|--------|-------|
| New | 5 |
| Assigned | 10 |
| In Progress | 8 |
| Ready for Test | 7 |
| Verified | 15 |
| Closed | 25 |

### By Severity
| Severity | Count | % |
|----------|-------|---|
| Critical | 2 | 5% |
| High | 8 | 20% |
| Medium | 15 | 37% |
| Low | 15 | 37% |

### Aging Report
| Age | Count |
|-----|-------|
| < 1 week | 20 |
| 1-2 weeks | 10 |
| 2-4 weeks | 5 |
| > 4 weeks | 5 |

### Top Open Defects
| ID | Summary | Age | Owner |
|----|---------|-----|-------|
| BUG-234 | Login timeout | 2 days | John |
| BUG-235 | Cart clears | 3 days | Mary |
```

## Best Practices

### Defect Reporting

1. **Be specific** — clear title and steps
2. **Include context** — environment, data
3. **One issue per bug** — don't combine
4. **Reproducible** — verify before reporting
5. **Evidence** — screenshots, logs

### Defect Management

1. **Regular triage** — daily/weekly reviews
2. **Clear ownership** — always assigned
3. **Timely resolution** — SLA targets
4. **Retest promptly** — don't delay
5. **Close properly** — verify and document

### Communication

1. **Constructive tone** — focus on issue
2. **Provide context** — help reproduce
3. **Be available** — answer questions
4. **Share learnings** — team knowledge
5. **Escalate wisely** — when needed

## Related Skills

- test-case-design — test case execution
- manual-testing — manual testing findings
- test-management-tools — tracking integration
- performance-testing — performance defects
- security-testing — security vulnerabilities

---
*Defect Management — systematic approach to finding, tracking, and resolving issues
