---
name: manual-testing
description: Manual testing techniques, exploratory testing, usability testing. Use when performing manual testing, designing test sessions, evaluating user experience.
---

# Manual Testing Techniques

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for performing manual testing including functional testing, exploratory testing, usability testing, and ad-hoc testing. Designed for comprehensive quality assurance when automation is not feasible or as a complement to automated testing.

## When to Use

Use this skill:
- When performing functional testing of applications
- For exploratory testing sessions
- When evaluating user experience and interface usability
- For ad-hoc testing to find unexpected defects
- When testing requires human judgment
- For verification of visual elements and layout
- When starting a new testing project without existing automation

## Functions

### Functional Testing

Systematic testing of application functions:

```markdown
## Functional Test Categories

### Unit Testing (Manual)
- Test individual functions and methods
- Verify input/output relationships
- Check error handling

### Integration Testing
- Test component interactions
- Verify data flow between modules
- Check API integrations

### System Testing
- Test complete system workflows
- Verify end-to-end scenarios
- Check system requirements compliance

### Acceptance Testing
- Test business requirements
- Verify user acceptance criteria
- Validate final deployment readiness
```

**Testing Approaches:**
| Approach | Description | When to Use |
|----------|-------------|-------------|
| Bottom-Up | Test from底层 upwards | When lower modules are ready |
| Top-Down | Test from top downwards | When stubs can be used |
| Big Bang | Test all together | Small projects |
| Sandwich | Combination of above | Large projects |

### Exploratory Testing

Session-based exploratory testing:

```markdown
## Exploratory Testing Session

### Session Charter
**Mission:** {Test mission description}
**Duration:** 30-60 minutes
**Coverage Area:** {Feature/Area to test}
**Learning Objectives:** {What to discover}

### Test Charter Template
- **Feature:** {What to test}
- **Initial State:** {Starting conditions}
- **Depth:** {How deep to explore}
- **Risks to Consider:** {Potential issues}

### Session Notes
| Time | Action | Observation | Issue Found |
|------|--------|-------------|-------------|
| 00:05 | Clicked login | Form loaded | - |
| 00:10 | Entered invalid data | Error displayed | - |
| 00:15 | SQL injection test | No sanitization | DEF-001 |
```

**Exploratory Testing Techniques:**
- **Tourist** — guided exploration of features
- **Cartographer** — mapping unknown territory
- **Bug Hunter** — focused defect finding
- **Superuser** — power user scenarios

### Usability Testing

Evaluating user experience:

```markdown
## Usability Test Evaluation

### Criteria
| Criterion | Weight | Score (1-10) | Notes |
|-----------|--------|--------------|-------|
| Ease of Use | 30% | | |
| Navigation Clarity | 20% | | |
| Visual Design | 15% | | |
| Error Prevention | 20% | | |
| Help Availability | 15% | | |

### Overall Score: {X}/10

### Findings
- **Critical Issues:** {List}
- **Major Issues:** {List}
- **Minor Issues:** {List}
```

**Usability Heuristics (Nielsen):**
1. System status visibility
2. Match between system and real world
3. User control and freedom
4. Consistency and standards
5. Error prevention
6. Recognition rather than recall
7. Flexibility and efficiency of use
8. Aesthetic and minimalist design
9. Help users recognize, diagnose, recover from errors
10. Help and documentation

### Ad-Hoc Testing

Unstructured testing techniques:

```markdown
## Ad-Hoc Testing Report

### Approach
- No formal test cases
- Based on tester experience
- Focus on common error areas
- Random input testing

### Areas Tested
- Error messages
- Boundary conditions
- Data validation
- UI interactions

### Defects Found
| ID | Description | Severity | Area |
|----|-------------|----------|------|
| DEF-001 | ... | High | Login |
| DEF-002 | ... | Medium | Profile |
```

### Test Documentation

Manual test execution reporting:

```markdown
## Manual Test Execution Report

### Test Summary
| Metric | Value |
|--------|-------|
| Total Test Cases | 50 |
| Executed | 45 |
| Passed | 40 |
| Failed | 5 |
| Blocked | 0 |
| Not Executed | 5 |

### Execution Details
| TC ID | Result | Executed By | Date | Notes |
|-------|--------|-------------|------|-------|
| TC-001 | Pass | John D. | 09-03-2026 | - |
| TC-002 | Fail | John D. | 09-03-2026 | DEF-001 |

### Defect Summary
- Critical: 1
- High: 2
- Medium: 2
- Low: 0
```

## Usage Examples

### Example 1: Exploratory Testing Session

```markdown
## Exploratory Test Session: User Registration

**Date:** 09-03-2026
**Tester:** QA Team
**Duration:** 45 minutes
**Application:** Web Application v2.1

### Mission
Explore the user registration flow to identify usability issues and edge cases not covered by existing test cases.

### Test Coverage
1. Basic registration flow
2. Email validation
3. Password requirements
4. Terms acceptance
5. Duplicate account handling
6. Error message clarity

### Findings
| # | Issue | Severity | Description |
|---|-------|----------|-------------|
| 1 | REG-001 | High | No confirmation email sent |
| 2 | REG-002 | Medium | Password strength not visible |
| 3 | REG-003 | Low | "Terms" link opens same tab |

### Recommendations
1. Implement email confirmation flow
2. Add real-time password strength indicator
3. Open terms in new tab/window
```

### Example 2: Usability Test Evaluation

```markdown
## Usability Test: Checkout Process

**Test Environment:** Production
**Testers:** 5 participants
**Date:** 09-03-2026

### Task Completion Rate
| Participant | Task | Time | Success |
|-------------|------|------|---------|
| P1 | Complete purchase | 2:30 | Yes |
| P2 | Complete purchase | 3:15 | Yes |
| P3 | Complete purchase | 5:00 | No (abandoned) |

### Issues Found
1. **Confusing payment form** — 4/5 participants confused
2. **No order summary** — users unsure of total
3. **Hidden shipping costs** — appeared at final step

### Recommendations
- Add progress indicator
- Show order summary throughout
- Display shipping costs earlier
```

## Document Templates

### Test Session Report

```markdown
## Test Session Report

**Date:** {Date}
**Tester:** {Name}
**Duration:** {Minutes}
**Feature/Area:** {Feature name}

### Session Objectives
1. {Objective 1}
2. {Objective 2}

### Testing Approach
{How testing was performed}

### Coverage
{What was tested}

### Findings
| # | Issue | Severity | Description |
|---|-------|----------|-------------|
| | | | |

### Notes
{Additional observations}

### Risks Identified
{Potential issues not yet tested}
```

### Manual Test Checklist

```markdown
## Manual Test Checklist: {Feature}

### Pre-Execution
- [ ] Environment prepared
- [ ] Test data available
- [ ] Test cases reviewed
- [ ] Defect template ready

### Execution
- [ ] Execute positive test cases
- [ ] Execute negative test cases
- [ ] Test boundary conditions
- [ ] Verify error messages
- [ ] Check logging

### Post-Execution
- [ ] Document results
- [ ] Report defects
- [ ] Clean test data
- [ ] Update test status
```

## Best Practices

### Manual Testing

1. **Focus on high-value tests** — automate repetitive, stable tests
2. **Use mind maps** — visualize test coverage
3. **Pair testing** — two testers working together
4. **Time-box sessions** — set limits for focused testing
5. **Take notes** — document all observations

### Exploratory Testing

1. **Define mission** — know what to explore
2. **Learn the system** — understand before testing
3. **Take notes** — record all findings
4. **Vary approach** — don't follow the same path
5. **Share findings** — communicate discoveries

### Usability Testing

1. **Define metrics** — measure what matters
2. **Use real users** — test with target audience
3. **Observe silently** — don't influence participants
4. **Ask open questions** — encourage feedback
5. **Aggregate results** — look for patterns

## Related Skills

- test-case-design — designing test cases
- gherkin-specifications — behavior-driven testing
- accessibility-testing — testing for accessibility
- mobile-testing — mobile application testing
- defect-management — reporting defects

---
*Manual Testing — the foundation of quality assurance through human insight
