---
name: srs-specification
description: Creating Software Requirements Specification (SRS): functional and non-functional requirements, constraints, requirements traceability
---

# Software Requirements Specification (SRS)

> **Meta:** v1.0.0 | 23-02-2026

## Purpose

Skill for creating detailed Software Requirements Specification (SRS). Includes formalization of functional and non-functional requirements, defining constraints and assumptions, creating structured SRS document according to IEEE 830 standard, which serves as the foundation for design, development, and testing.

## When to Use

Use this skill:
- When preparing detailed requirements specification
- When formalizing and structuring collected requirements
- For creating a document that will be used by the development team
- When requiring stakeholder agreement on requirements
- For providing Project Manager with data for planning

## Functions

### Functional Requirements Specification
Defining functional requirements:
- Description of system functions
- Input and output data
- Function execution conditions
- User interaction
- Integration with other systems
- Business rules and validation

### Non-functional Requirements Specification
Defining non-functional requirements:
- **Performance:** response time, throughput
- **Scalability:** horizontal and vertical scaling
- **Security:** authentication, authorization, data protection
- **Reliability:** availability, fault tolerance, recovery
- **Usability:** user experience, accessibility
- **Compatibility:** browsers, devices, operating systems
- **Maintainability:** logging, monitoring, debugging

### Constraints and Assumptions
Formulating constraints and assumptions:
- Technical constraints (technologies, platforms)
- Time and budget constraints
- Legal and regulatory requirements
- Assumptions about the environment
- External system constraints
- Team resource constraints

### SRS Document Creation
Creating SRS document according to IEEE 830 standard:
- Document structure
- Requirements formatting
- Requirements prioritization
- Document versioning
- Requirements traceability
- Approval and change control

## SRS Document Structure

### 1. Introduction
- 1.1 Document Purpose
- 1.2 Scope
- 1.3 Definitions and Abbreviations
- 1.4 References
- 1.5 Document Overview

### 2. Overall Description
- 2.1 Product Perspective
- 2.2 Product Features
- 2.3 User Characteristics
- 2.4 Constraints
- 2.5 Assumptions and Dependencies

### 3. Specific Requirements
- 3.1 Functional Requirements
- 3.2 Non-functional Requirements
- 3.3 Interface Requirements
- 3.4 Data Requirements

### 4. Appendices
- 4.1 Diagrams (Use Case, Sequence, Activity)
- 4.2 Data Models (ERD)
- 4.3 Traceability Matrix

## Integration with Project Manager

### Data for Project Manager
Provides the following data for PM:
- **Scope:** number of requirements for estimation
- **Complexity:** classification of requirements by complexity
- **Risks:** requirements with high uncertainty
- **Dependencies:** relationships between requirements
- **Priorities:** justification for iteration planning

### Interaction
- PM requests SRS for project planning
- PM receives data for budget and timeline estimation
- PM uses priorities for release planning
- SA validates requirements changes with PM

## Usage Examples

### Example 1: SRS for Task Management Web Application

**Functional Requirements:**

| ID | Requirement | Description | Priority |
|----|------------|----------|-----------|
| FR-001 | Task Creation | User can create tasks with title, description, due date | Must |
| FR-002 | Task Assignment | User can assign tasks to other users | Must |
| FR-003 | Task Filtering | System provides filtering by status, assignee, due date | Should |
| FR-004 | Reports | System generates task completion reports | Could |

**Non-Functional Requirements:**

| ID | Requirement | Metric | Rationale |
|----|------------|---------|-------------|
| NFR-001 | Performance | Response time < 2 sec | UX requirements |
| NFR-002 | Scalability | 500 concurrent users | Planned growth |
| NFR-003 | Availability | 99.5% uptime | SLA |
| NFR-004 | Security | SSL/TLS for all connections | Data protection |

**Data for PM:**
- Total requirements: 15 functional, 8 non-functional
- Complexity estimate: 8 simple, 4 medium, 3 complex
- Risks: external calendar integration
- Critical dependencies: notification API

### Example 2: SRS for Mobile Banking Application

**Functional Requirements:**
- User authentication (biometrics, PIN)
- Account balance and transaction history viewing
- Internal and external transfers
- Payments by details and QR code
- Card management (blocking, limits)

**Non-Functional Requirements:**
- Support for iOS 12+ and Android 8+
- Application launch time no more than 3 seconds
- Offline mode support for history viewing
- PCI DSS security standard compliance
- Device data encryption

**Constraints:**
- Integration with banking core via API
- Compliance with Central Bank of Russia requirements
- Data localization within Russian Federation

**Data for PM:**
- Total effort estimate: 450 hours
- High risks: security, regulatory compliance
- Critical dependencies: banking core, SMS provider

## Requirements Traceability

### Traceability Matrix

| Requirement | User Story | Test Case | Code |
|------------|------------|-----------|-----|
| FR-001 | US-001, US-002 | TC-001, TC-002 | module.tasks |
| FR-002 | US-003 | TC-003, TC-004 | module.assignments |
| NFR-001 | US-010 | TC-010 | infra.caching |

## Related Skills

- requirements-analysis
- use-case-modeling
- api-design
- data-modeling

---
