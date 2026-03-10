---
name: requirements-analysis
description: System requirements gathering, analysis and documentation: functional and non-functional requirements, user stories, acceptance criteria
---

# Requirements Analysis

> **Meta:** v1.0.0 | 23-02-2026

## Purpose

Skill for gathering, analyzing and documenting system requirements. Includes identifying functional and non-functional requirements, creating user stories, defining acceptance criteria, and forming requirement documentation for transfer to the development team and Project Manager.

## When to Use

Use this skill:
- During project initiation and planning phase
- When gathering requirements from stakeholders
- When formalizing functional and non-functional requirements
- When creating user stories and use case scenarios
- For preparing data for Project Manager (estimates, risks)

## Functions

### Requirements Gathering
Collecting requirements from various sources:
- Stakeholder interviews
- Business process analysis (BPMN)
- Analysis of existing systems
- Document and specification review
- Brainstorming with the team

### Requirements Categorization
Classifying requirements by type:
- Functional requirements (what the system must do)
- Non-functional requirements (how the system should operate)
  - Performance
  - Security
  - Scalability
  - Reliability
  - Usability
- Interface requirements
- Constraints (technical, business, legal)
- Assumptions

### Requirements Prioritization
Prioritizing requirements by criteria:
- Impact on business goals
- Criticality for users
- Implementation complexity
- Risks and dependencies
- MoSCoW (Must have, Should have, Could have, Won't have)

### Requirements Documentation
Documenting requirements in structured form:
- Creating SRS (Software Requirements Specification)
- Describing User Stories
- Format: "As a <role>, I want <feature>, so that <benefit>"
- Creating acceptance criteria (Gherkin: Given-When-Then)
- Use Case diagrams (UML)

## Integration with Project Manager

### Data for Project Manager
Provides the following data for PM:
- **Effort estimates:** preliminary estimates of requirements complexity
- **Requirements risks:** requirements with high uncertainty
- **Dependencies:** relationships between requirements and external systems
- **Priorities:** justification for requirements prioritization

### Interaction
- PM requests requirements analysis for planning
- PM receives data for budget and timeline estimation
- PM uses priorities for iteration planning
- SA validates requirements changes with PM

## Usage Examples

### Example 1: Requirements Analysis for CRM System

**Functional Requirements:**
| ID | Requirement | Priority | Estimate |
|----|------------|-----------|----------|
| FR-001 | Customer contact management | Must | 40 hrs |
| FR-002 | Sales tracking | Must | 60 hrs |
| FR-003 | Task management | Should | 30 hrs |
| FR-004 | Report generation | Could | 20 hrs |

**Non-Functional Requirements:**
| ID | Requirement | Metric |
|----|-------------|--------|
| NFR-001 | Performance | Response time < 2 sec |
| NFR-002 | Scalability | 1000+ concurrent users |
| NFR-003 | Availability | 99.9% uptime |
| NFR-004 | Security | GDPR compliance |

**User Stories:**
```
US-001: Contact Management
As a sales manager,
I want to create, edit and delete customer contacts,
So that I can maintain my customer database.

Acceptance Criteria:
Given I am on the contacts page
When I click "Add Contact"
Then the contact creation form opens
And all required fields are marked with asterisk
```

### Example 2: Requirements Analysis for Mobile Application

**Functional Requirements:**
- User registration and authorization
- Service search and booking
- Payments and confirmation
- Reviews and ratings

**Non-Functional Requirements:**
- Support for iOS 12+ and Android 8+
- Offline mode support
- Launch time less than 3 seconds
- Energy efficiency

**Data for PM:**
- Total effort estimate: 320 hours
- High risks: payment system integration
- Critical dependencies: third-party service APIs

## Related Skills

- srs-specification
- use-case-modeling
- bpmn-modeling
- api-design

---
