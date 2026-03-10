---
name: requirements-management
description: Requirements lifecycle management: traceability, change control, coordination with System Analyst, validation of completeness
---

# Requirements Management

> **Meta:** v1.0.0 | 23-02-2026

## Purpose

Skill for managing requirements lifecycle throughout the project. Includes requirements traceability, change control, coordination with System Analyst, validation of requirements completeness, and scope management. Does NOT include requirements analysis and documentation - this is the function of System Analyst.

## When to Use

Use this skill:
- When managing requirements changes
- For scope control
- When coordinating with System Analyst on requirements
- For validating requirements completeness before planning
- When tracing requirements to tasks and tests

## Functions

### Requirements Traceability Management
Managing requirements traceability:
- Creating traceability matrix (RTM - Requirements Traceability Matrix)
- Linking requirements to tasks, tests, code
- Tracking requirements coverage
- Identifying orphan requirements (without implementation)
- Identifying orphan tasks (without requirements)

### Requirements Change Control
Controlling requirements changes:
- Change request process
- Assessing change impact on project
- Analyzing impact on budget and schedule
- Gaining agreement with stakeholders
- Updating baseline requirements

### Scope Management
Managing project scope:
- Defining project boundaries (in-scope / out-of-scope)
- Controlling scope creep
- Prioritizing requirements based on business goals
- Managing requirements backlog
- Planning releases based on priorities

### Requirements Validation
Validating requirements:
- Checking completeness of requirements from System Analyst
- Checking requirements consistency
- Validating priorities with business goals
- Checking requirements feasibility
- Preparing for requirements approval

## Integration with System Analyst

### Requesting Data from System Analyst
PM requests from SA the following data:
- **SRS document** - requirements specification
- **Effort estimates** - preliminary estimates per requirement
- **Requirements risks** - requirements with high uncertainty
- **Dependencies** - relationships between requirements and external systems
- **Priorities** - prioritization rationale

### Providing Data to System Analyst
PM provides SA with:
- Approved requirements changes
- Updated priorities from business
- Feedback from development team
- Requirements feasibility data

### Coordination Process
1. PM requests SRS from System Analyst
2. PM validates completeness and consistency
3. PM creates traceability matrix
4. PM requests clarifications if needed
5. PM includes requirements in project plan

## Usage Examples

### Example 1: Requirements Traceability Matrix

| Requirement | User Story | Task | Test Case | Status |
|------------|------------|--------|-----------|--------|
| FR-001 | US-001 | TASK-101 | TC-001, TC-002 | Done |
| FR-002 | US-002 | TASK-102 | TC-003 | In Progress |
| FR-003 | US-003 | - | - | Not Started |
| FR-004 | - | - | - | Missing |

**Analysis:**
- FR-003 has no task - creation required
- FR-004 has no User Story - request from SA

### Example 2: Requesting Data from System Analyst

**PM Request:**
```
System Analyst, the following data is needed for Sprint #3 planning:
1. Details of requirements FR-005, FR-006 (User Stories, Acceptance Criteria)
2. Effort estimates for new requirements
3. Dependencies between FR-005 and existing requirements
4. Risks associated with FR-006 implementation

Deadline: 25.02.2026
```

**System Analyst Response:**
```
Here is the requested data:
1. US-005, US-006 with Acceptance Criteria - in attachment
2. Estimate: FR-005 - 16h, FR-006 - 24h
3. Dependencies: FR-005 depends on FR-002 (blocking)
4. Risks: FR-006 requires external API integration - high uncertainty
```

### Example 3: Requirements Change Control

**Change Request:**
| Field | Value |
|------|----------|
| ID | CR-001 |
| Requirement | FR-003 |
| Requested change | Add PDF export function |
| Initiator | Business customer |
| Request date | 20.02.2026 |

**Impact Analysis:**
- Impact on budget: +40 hours ($2,000)
- Impact on schedule: +1 week
- Dependencies: requires PDF generation library
- Risks: compatibility with existing functionality

**Decision:** Declined in current sprint, moved to backlog

## Requirements Management Process

### 1. Initiation
1. Request SRS from System Analyst
2. Validate completeness
3. Create traceability matrix
4. Set requirements baseline

### 2. Planning
1. Prioritize requirements
2. Distribute across iterations/sprints
3. Estimate resources for implementation
4. Agree with stakeholders

### 3. Execution
1. Track requirements status
2. Manage changes
3. Coordinate with System Analyst
4. Update traceability matrix

### 4. Control
1. Control scope creep
2. Analyze requirements coverage
3. Conduct change reviews
4. Report to stakeholders

### 5. Closure
1. Verify implementation of all requirements
2. Confirm test coverage
3. Get sign-off from customer
4. Document final status

## Related Skills

- change-request
- project-initiation
- stakeholder-reporting
- development-tracking

---
