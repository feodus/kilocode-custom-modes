---
name: kanban-flow
description: Kanban boards, WIP limits, task flow management, Lead Time/Cycle Time metrics
---

# Kanban Flow Management

> **Meta:** v1.0.0 | 22-02-2026

## Purpose

Skill for managing task flow using Kanban methodology. Includes setting up and maintaining Kanban boards, establishing WIP limits, analyzing work flows, measuring task completion time (Lead Time/Cycle Time), and process optimization. Helps visualize work, manage team workload, and improve efficiency.

## When to Use

Use this skill:
- When managing projects with continuous task flow
- When work process visualization is important
- When team workload management is needed
- For optimizing task completion time
- When working with teams not ready for full transition to Scrum

## Functions

### Kanban Board Setup
Setting up Kanban boards:
- Defining process columns
- Setting task transition rules
- Establishing work policies
- Setting up automation
- Integrating with tracking tools

### WIP Limit Management
Managing WIP limits:
- Determining optimal limits
- Monitoring limit compliance
- Adjusting limits as needed
- Accounting for team specifics
- Balancing work flows

### Flow Visualization
Visualizing work flow:
- Displaying tasks on the board
- Color differentiation of task types
- Indicating priorities
- Showing blockers and risks
- Visualizing dependencies

### Lead Time & Cycle Time Analysis
Analyzing completion time:
- Measuring time from creation to completion
- Analyzing time distribution
- Identifying bottlenecks
- Forecasting completion dates
- Optimizing processes

## Integration with System Analyst

- Accounting for analytical tasks in the flow
- Visualizing analysis tasks on the board
- Managing System Analyst workload
- Tracking time for analytical work
- Integrating analysis results into development flow

## Usage Examples

### Example 1: Setting Up Kanban Board for Development Team
Columns:
- Backlog: tasks for future work
- Ready: tasks ready for work
- Analysis: requirements analysis (2 WIP limit)
- Development: development (4 WIP limit)
- Testing: testing (2 WIP limit)
- Done: completed tasks

WIP limits:
- Overall limit: 8 tasks
- By roles: 2 analysts, 4 developers, 2 testers
- Monitoring: daily at standup meetings

Time metrics:
- Average Lead Time: 8 days
- Average Cycle Time: 5 days
- 80% of tasks completed within 10 days

### Example 2: Optimizing Task Flow
Problem:
- Tasks stuck in "Testing" column
- Average Cycle Time increased by 40%

Analysis:
- Lead Time: 8 → 12 days
- Cycle Time: 5 → 7 days
- Blockers: lack of testers, complex integrations

Solutions:
- Increased WIP limit in Testing to 3
- Added automated tests
- Parallel testing of individual components
- Result: Cycle Time reduced to 6 days

### Example 3: Managing Different Task Types
Task classification:
- Feature: new features (red color)
- Bug: bug fixes (orange)
- Tech Debt: technical debt (blue)
- Analysis: analytical tasks (purple)

Policies:
- Bug reports have high priority
- Feature tasks limited to 60% of total flow
- Tech Debt: at least 20% of time
- Analysis: up to 30% of time depending on project

## Related Skills

- agile-scrum-management
- development-tracking
- team-capacity
- project-metrics

---
