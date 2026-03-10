---
name: user-stories
description: Writing user stories with acceptance criteria using Agile methodology: User Story format, INVEST criteria, Acceptance Criteria in Gherkin, Story Mapping, Story Points estimation
---

# User Stories

> **Meta:** v1.0.0 | 23-02-2026

## Purpose

Skill for writing User Stories with acceptance criteria using Agile methodology. Includes creating stories in standard format, validation against INVEST criteria, writing Acceptance Criteria in Gherkin format (Given-When-Then), organizing stories into User Story Map, and estimating complexity in Story Points.

## When to Use

Use this skill:
- When formalizing requirements in Agile format
- For creating Product Backlog
- When planning Sprints (Sprint Planning)
- For decomposing large requirements into atomic stories
- When writing acceptance criteria for developers and QA
- For estimating effort in Story Points
- When building User Story Map

## Functions

### User Story Format

User story format:

```markdown
## US-{ID}: {Title}

**As a** {user role},
**I want** {desired functionality},
**So that** {value received}.

**Acceptance Criteria:**
{Acceptance criteria in Gherkin format}

**Story Points:** {estimate}
**Priority:** {MoSCoW priority}
**Dependencies:** {dependencies from other stories}
```

**Writing Rules:**
- Role should be specific (not "user" but "registered customer")
- Functionality should be atomic and testable
- Value should be understandable to business

### INVEST Criteria

Validating User Story quality using INVEST criteria:

| Criterion | Description | Validation |
|----------|----------|----------|
| **I**ndependent | Story doesn't depend on other stories | Can it be implemented separately? |
| **N**egotiable | Story can be changed | Is there room for discussion? |
| **V**aluable | Story brings value to business | Is the value clear to customer? |
| **E**stimable | Story can be estimated | Is there enough information for estimation? |
| **S**mall | Story is small enough | Can it be completed in one sprint? |
| **T**estable | Story can be tested | Can acceptance criteria be written? |

**INVEST Checklist:**

```markdown
### INVEST Checklist for US-{ID}

- [ ] **Independent:** {Yes/No — justification}
- [ ] **Negotiable:** {Yes/No — justification}
- [ ] **Valuable:** {Yes/No — justification}
- [ ] **Estimable:** {Yes/No — justification}
- [ ] **Small:** {Yes/No — justification}
- [ ] **Testable:** {Yes/No — justification}

**Verdict:** {Ready/Needs Refinement}
```

### Acceptance Criteria

Acceptance criteria in Gherkin format:

```gherkin
Feature: {Feature name}

Scenario: {Scenario name 1}
  Given {precondition}
  When {action}
  Then {expected result}

Scenario: {Scenario name 2}
  Given {precondition}
  And {additional precondition}
  When {action}
  And {additional action}
  Then {expected result}
  And {additional result}
```

**Scenario Types:**
- **Happy Path** — main successful scenario
- **Alternative Flow** — alternative flow variations
- **Edge Cases** — boundary cases
- **Error Handling** — error handling scenarios

### Story Mapping

Organizing stories into User Story Map:

```markdown
## User Story Map: {Product name}

### Backbone (User Activities)
| Activity 1 | Activity 2 | Activity 3 |
|------------|------------|------------|

### User Tasks (Stories organized by priority)
| Priority | Task 1 | Task 2 | Task 3 |
|----------|--------|--------|--------|
| **Must Have** | US-001 | US-003 | US-005 |
| **Should Have** | US-002 | US-004 | - |
| **Could Have** | US-006 | - | - |
```

**Story Map Elements:**
- **Backbone** — main user activities
- **User Tasks** — specific user tasks
- **Slices** — horizontal slices for release planning
- **Priorities** — vertical distribution by priority

### Story Points

Complexity estimation using Fibonacci sequence:

| Points | Complexity | Criteria |
|--------|-----------|----------|
| **1** | Trivial | Known solution, < 2 hours |
| **2** | Very Simple | Simple solution, 2-4 hours |
| **3** | Simple | Standard solution, 4-8 hours |
| **5** | Medium | Requires effort, 1-2 days |
| **8** | Complex | Significant effort, 2-4 days |
| **13** | Very Complex | Major effort, 1-2 weeks |
| **21** | Epic | Requires decomposition |

**Estimation Factors:**
- Volume of work
- Complexity
- Risks and Uncertainty
- Dependencies

### Story Decomposition

Decomposing large stories (Epic → Story → Task):

```markdown
## Epic: {Epic name}

### Stories:
- US-001: {Story 1}
- US-002: {Story 2}
- US-003: {Story 3}

### Decomposition Rules:
- Epic: > 21 story points → requires decomposition
- Story: 1-13 story points → ready for implementation
- Task: technical subtasks for developers
```

## Integration with Project Manager

### Data for Project Manager

Provides the following data for PM:

**For Sprint Planning:**
- Ready User Stories with acceptance criteria
- Story Points estimates for capacity planning
- Dependencies between stories

**For Backlog Management:**
- Prioritized list of stories
- INVEST validation of stories
- Decomposition recommendations

**For Reporting:**
- Team velocity (based on completed story points)
- Epic progress
- Requirements coverage by stories

### Interaction

- PM requests User Stories for iteration planning
- PM receives estimates for velocity calculation
- PM uses dependencies for release planning
- SA validates story changes with PM
- PM requests epic decomposition

## Usage Examples

### Example 1: User Story for Authentication

```markdown
## US-001: User Login

**As a** registered user,
**I want to** log into the system,
**So that** I can access my personal dashboard.

**Acceptance Criteria:**
```gherkin
Feature: User Authentication

Scenario: Successful login with valid credentials
  Given I am on the login page
  When I enter valid username "john_doe"
  And I enter valid password "SecurePass123!"
  And I click "Login" button
  Then I should be redirected to my dashboard
  And I should see "Welcome, john_doe" in the header
  And a session cookie should be created

Scenario: Login with invalid credentials
  Given I am on the login page
  When I enter username "john_doe"
  And I enter invalid password "wrong_password"
  And I click "Login" button
  Then I should see error message "Invalid username or password"
  And I should remain on the login page
  And the password field should be cleared

Scenario: Account locked after multiple failed attempts
  Given I am on the login page
  And I have failed login 2 times previously
  When I enter username "john_doe"
  And I enter invalid password "wrong_password"
  And I click "Login" button
  Then I should see error message "Account locked. Please try again in 30 minutes"
  And I should not be able to attempt login for 30 minutes

Scenario: Login with remember me option
  Given I am on the login page
  When I enter valid credentials
  And I check "Remember me" checkbox
  And I click "Login" button
  Then I should be redirected to my dashboard
  And a persistent cookie should be created with 30-day expiration
```

**Story Points:** 3
**Priority:** Must Have
**Dependencies:** None
**Epic:** Authentication System

### INVEST Validation for US-001:

```markdown
### INVEST Checklist for US-001

- [x] **Independent:** Yes — story doesn't depend on other stories
- [x] **Negotiable:** Yes — acceptance criteria can be changed
- [x] **Valuable:** Yes — users can access the system
- [x] **Estimable:** Yes — standard functionality, estimate 3 points
- [x] **Small:** Yes — can be completed in 1-2 days
- [x] **Testable:** Yes — clear acceptance criteria available

**Verdict:** Ready for Sprint
```

### Example 2: Story Mapping for E-Commerce

```markdown
## User Story Map: E-Commerce Platform

### Backbone (User Activities)
| Browse Products | Manage Cart | Checkout | Track Order |
|-----------------|-------------|----------|-------------|

### User Tasks (Stories organized by priority)

| Priority | Browse Products | Manage Cart | Checkout | Track Order |
|----------|-----------------|-------------|----------|-------------|
| **Must Have** | US-001: View catalog | US-005: Add to cart | US-008: Checkout flow | US-012: View order status |
| | US-002: Search products | US-006: Remove from cart | US-009: Payment processing | |
| | US-003: View product details | US-007: Update quantity | US-010: Shipping selection | |
| **Should Have** | US-004: Filter by category | | US-011: Apply discount code | US-013: Order notifications |
| **Could Have** | | | US-014: Gift wrapping | US-015: Order history |

### Release Slices:
- **MVP (Sprint 1-2):** US-001, US-002, US-003, US-005, US-006, US-008, US-009
- **Release 1.0 (Sprint 3-4):** US-004, US-007, US-010, US-012
- **Release 1.1 (Sprint 5):** US-011, US-013, US-014, US-015
```

### Example 3: Story Points Estimation

```markdown
## Story Points Estimation Session

### US-008: Checkout Flow

**Complexity Factors:**
| Factor | Assessment | Points |
|--------|------------|--------|
| Volume | Multiple steps, validation logic | +2 |
| Complexity | Integration with payment gateway | +3 |
| Risk | New payment provider integration | +2 |
| Dependencies | Depends on US-005, US-006 | +1 |

**Team Estimates (Planning Poker):**
| Developer | Estimate |
|-----------|----------|
| Dev 1 | 8 |
| Dev 2 | 5 |
| Dev 3 | 8 |
| Dev 4 | 5 |
| QA | 8 |

**Final Estimate:** 8 points (consensus after discussion)

**Rationale:** Integration with payment gateway adds complexity. Need to handle multiple payment methods and error scenarios.
```

### Example 4: Epic Decomposition

```markdown
## Epic: EP-001 User Profile Management
**Initial Estimate:** 21+ points

### Decomposed Stories:

**US-020: View Profile**
- As a registered user, I want to view my profile information
- Points: 2
- Priority: Must Have

**US-021: Edit Profile**
- As a registered user, I want to edit my profile information
- Points: 3
- Priority: Must Have

**US-022: Change Password**
- As a registered user, I want to change my password
- Points: 3
- Priority: Must Have

**US-023: Upload Avatar**
- As a registered user, I want to upload my profile picture
- Points: 5
- Priority: Should Have

**US-024: Manage Addresses**
- As a registered user, I want to manage my delivery addresses
- Points: 5
- Priority: Should Have

**US-025: Privacy Settings**
- As a registered user, I want to configure my privacy settings
- Points: 3
- Priority: Could Have

**Total Decomposed:** 21 points across 6 stories
```

## Document Templates

### User Story Template

```markdown
## US-{ID}: {Title}

**As a** {role},
**I want** {functionality},
**So that** {value}.

**Acceptance Criteria:**
```gherkin
Feature: {Name}

Scenario: {Scenario 1}
  Given {precondition}
  When {action}
  Then {result}
```

**Story Points:** {1|2|3|5|8|13|21}
**Priority:** {Must Have|Should Have|Could Have|Won't Have}
**Dependencies:** {list of US-ID or None}
**Epic:** {EP-ID}
**Notes:** {additional information}
```

### Backlog Story Table Template

| ID | Title | As a | I want | So that | Points | Priority | Status |
|----|-------|------|--------|---------|--------|----------|--------|
| US-001 | User Login | registered user | log into the system | access my dashboard | 3 | Must | Done |
| US-002 | Password Reset | registered user | reset my password | recover account access | 5 | Should | In Progress |
| US-003 | Profile Edit | registered user | edit my profile | keep info updated | 3 | Should | To Do |

## Best Practices

### Writing User Stories

1. **Use business language** — avoid technical terms
2. **Be specific** — "registered user" instead of "user"
3. **Describe value** — clearly state "so that"
4. **Keep stories atomic** — one story = one functionality

### Acceptance Criteria

1. **Cover all scenarios** — happy path, alternative, error
2. **Use measurable criteria** — avoid subjective assessments
3. **Write from user perspective** — don't describe implementation
4. **Leave room for clarification** — details are discussed with developers

### Story Points Estimation

1. **Use Planning Poker** — collective estimation
2. **Estimate relatively** — compare with reference stories
3. **Consider all factors** — volume, complexity, risks, dependencies
4. **Re-estimate when changed** — update estimates

### Common Mistakes

1. **Stories too large** — need decomposition
2. **No value** — "so that" unclear to business
3. **Technical stories** — focus on solution, not value
4. **No acceptance criteria** — cannot test
5. **Undefined dependencies** — block planning

## Related Skills

- requirements-analysis — requirements gathering and analysis
- srs-specification — software requirements specification
- use-case-modeling — use cases
- bpmn-modeling — business process modeling
- api-design — API design

---
