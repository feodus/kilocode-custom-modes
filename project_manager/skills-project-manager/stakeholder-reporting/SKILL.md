---
name: stakeholder-reporting
description: Generating reports for stakeholders at all project phases. Use for creating status reports, executive summaries, dashboards and KPI reporting.
---

# Stakeholder Reporting

> **Meta:** v1.0.0 | 22-02-2026

## Purpose

Skill for creating effective reporting for various stakeholder groups throughout the project lifecycle. Ensures transparency, timeliness and relevance of information for decision-making at all levels of the organization.

## When to Use

- When preparing weekly/monthly status reports
- When creating reports for management (Executive Summary)
- When forming dashboards for stakeholders
- When preparing KPI reports
- When communicating status to steering committee

## Functions

### Status Reports

Regular reports on current project state.

**Weekly Status Report:**
```markdown
## Weekly Status Report

**Project:** [Name]
**Period:** [Week X] | [Start Date] — [End Date]
**PM:** [Name]
**Project Status:** 🟢 On Track / 🟡 At Risk / 🔴 Off Track

---

### 📊 Key Metrics

| Metric | Value | Trend |
|------------|----------|-------|
| Progress | X% | ↑/↓/→ |
| Budget | X% spent | ↑/↓/→ |
| Schedule | X days variance | ↑/↓/→ |
| Open Risks | X | ↑/↓/→ |
| Open Issues | X | ↑/↓/→ |

### ✅ Completed This Week

1. [Completed task 1]
2. [Completed task 2]
3. [Completed task 3]

### 🔄 In Progress

| Task | Owner | Progress | Due Date |
|--------|---------------|----------|------|
| Task 1 | Name | 80% | Date |
| Task 2 | Name | 60% | Date |

### 📅 Next Week Plan

1. [Planned task 1]
2. [Planned task 2]
3. [Planned task 3]

### ⚠️ Risks and Issues

| # | Description | Impact | Mitigation Plan |
|---|----------|---------|----------------|
| 1 | [Risk/Issue] | High/Med/Low | [Action] |

### 📝 Requests/Decisions

| Request | From | Status | Comment |
|---------|---------|--------|-------------|
| [Request] | [Stakeholder] | Pending/Approved | |

### 📎 Attachments

- [Link to detailed report]
- [Link to dashboard]

---

**Contacts:** [PM Email] | [Phone]
```

**Monthly Status Report:**
```markdown
## Monthly Project Report

**Project:** [Name]
**Month:** [Month Year]
**PM:** [Name]

---

### Executive Summary

[2-3 sentences about key achievements and overall project status]

### 📈 Financial Status

| Metric | Plan | Actual | Deviation |
|------------|------|------|------------|
| Total budget | X RUB | Y RUB | Z% |
| Monthly expenses | X RUB | Y RUB | Z% |
| EAC (forecast) | X RUB | Y RUB | Z% |

### 📅 Schedule Status

| Milestone | Plan | Forecast | Deviation |
|------|------|---------|------------|
| Milestone 1 | Date | Date | +/- days |
| Milestone 2 | Date | Date | +/- days |
| Go-live | Date | Date | +/- days |

### 🎯 Scope Progress

| Category | Plan | Completed | % |
|-----------|------|-----------|---|
| Requirements | N | M | X% |
| Epics | N | M | X% |
| Stories | N | M | X% |

### ⚠️ Top 5 Risks

| # | Risk | Probability | Impact | Status |
|---|------|-------------|---------|--------|
| 1 | | H/M/L | H/M/L | Open/Mitigated |

### 📋 Key Decisions This Month

| Date | Decision | Made By | Impact |
|------|---------|-----------|---------|
| | | | |

### 📅 Next Month Plan

| Week | Key Activities |
|--------|---------------------|
| W1 | |
| W2 | |
| W3 | |
| W4 | |

### 📊 Quality Metrics

| Metric | Target | Actual | Trend |
|---------|------|------|-------|
| Velocity | X SP | Y SP | |
| Defect Rate | < X | Y | |
| Code Coverage | > X% | Y% | |

---

*Distribution: Steering Committee, Sponsor, Key Stakeholders*
```

### Executive Summaries

Brief reports for top management.

**Executive Summary Template:**
```markdown
## Executive Summary

**Project:** [Name]
**Date:** [Date]
**Status:** 🟢 On Track / 🟡 At Risk / 🔴 Off Track

---

### 📌 One-Liner

[One sentence about current project state]

### 💰 Budget

| Metric | Value |
|------------|----------|
| Approved budget | X M RUB |
| Spent | Y M RUB (Z%) |
| Forecast (EAC) | Y M RUB |
| Deviation | +/- Z% |

### 📅 Schedule

| Metric | Value |
|------------|----------|
| Planned completion | [Date] |
| Forecast completion | [Date] |
| Deviation | +/- X days |

### 🎯 Key Achievements

1. [Achievement 1]
2. [Achievement 2]
3. [Achievement 3]

### ⚠️ Critical Issues

| Issue | Owner | Due Date |
|--------|---------------|------|
| [Issue requiring resolution] | [Name] | [Date] |

### 📊 Traffic Light Summary

| Area | Status | Comment |
|---------|--------|-------------|
| Schedule | 🟢/🟡/🔴 | |
| Budget | 🟢/🟡/🔴 | |
| Scope | 🟢/🟡/🔴 | |
| Quality | 🟢/🟡/🔴 | |
| Risks | 🟢/🟡/🔴 | |

### 🎯 Next Steps

1. [Next step 1]
2. [Next step 2]

---

**Decision Required:** [Yes/No — if yes, what]
```

### Dashboards

Visualization of key metrics.

**Project Dashboard Structure:**
```markdown
## Project Dashboard

### 🚦 Overall Status

| Area | Status | Comment |
|---------|--------|-------------|
| 📅 Schedule | 🟢 | +2 days |
| 💰 Budget | 🟡 | CPI = 0.95 |
| 📦 Scope | 🟢 | 100% |
| ⭐ Quality | 🟢 | 2.1 defects/KLOC |
| ⚠️ Risks | 🟡 | 3 open high risks |

---

### 📈 Progress Chart

```
Progress: ████████████░░░░░░░░ 60%

Planned:  ██████████████░░░░░░ 70%
Actual:   ████████████░░░░░░░░ 60%
```

---

### 💰 Budget Overview

```
Budget Status: ████████████░░░░░░░░ 62%

BAC:  5,000,000 RUB
EV:   3,000,000 RUB
AC:   3,100,000 RUB
EAC:  5,166,667 RUB
```

---

### 📊 Sprint Progress

| Sprint | Velocity | Commit | Δ |
|--------|----------|--------|---|
| S1 | 85 SP | 90 SP | -5 |
| S2 | 92 SP | 90 SP | +2 |
| S3 | 88 SP | 85 SP | +3 |
| S4 | 95 SP | 90 SP | +5 |

---

### ⚠️ Risk Heat Map

| Probability \ Impact | Low | Medium | High |
|-----------------------|-----|--------|------|
| **High** | | R2 | R1 |
| **Medium** | R5 | R3 | |
| **Low** | | R4 | |

---

### 📅 Milestones

| Milestone | Date | Status |
|------|------|--------|
| M1: Requirements | 01.02 | ✅ Done |
| M2: Design | 15.02 | ✅ Done |
| M3: Development | 15.04 | 🔄 In Progress |
| M4: Testing | 01.05 | ⏳ Pending |
| M5: Go-live | 15.05 | ⏳ Pending |
```

### KPI Reporting

Tracking key performance indicators.

**KPI Dashboard Template:**
```markdown
## Project KPI Dashboard

**Period:** [Month/Quarter]
**Project:** [Name]

---

### 📊 Performance KPIs

| KPI | Target | Actual | % | Trend |
|-----|------|------|---|-------|
| CPI (Cost Performance Index) | ≥ 1.0 | 0.95 | 95% | ↑ |
| SPI (Schedule Performance Index) | ≥ 1.0 | 1.02 | 102% | → |
| Scope Completion | 100% | 85% | 85% | ↑ |
| Quality Score | ≥ 90% | 92% | 92% | → |

---

### 📈 Trend Analysis (Last 6 months)

| Month | CPI | SPI | Quality |
|-------|-----|-----|---------|
| M1 | 0.92 | 0.95 | 85% |
| M2 | 0.94 | 0.98 | 88% |
| M3 | 0.93 | 1.00 | 90% |
| M4 | 0.95 | 1.01 | 91% |
| M5 | 0.95 | 1.02 | 92% |
| M6 | 0.95 | 1.02 | 92% |

---

### 🎯 Delivery KPIs

| KPI | Target | Actual | Status |
|-----|------|------|--------|
| On-time Delivery | ≥ 90% | 92% | ✅ |
| On-budget Delivery | ≥ 95% | 95% | ✅ |
| Scope Delivery | 100% | 98% | ✅ |
| Defect Escape Rate | < 5% | 3% | ✅ |

---

### 👥 Team KPIs

| KPI | Target | Actual | Status |
|-----|------|------|--------|
| Velocity Stability | ≥ 90% | 94% | ✅ |
| Team Morale (eNPS) | ≥ 30 | 42 | ✅ |
| Knowledge Transfer | 100% | 100% | ✅ |
| Training Completion | ≥ 80% | 85% | ✅ |

---

### 📋 Action Items

| # | KPI Issue | Action | Owner | Due |
|---|-----------|--------|-------|-----|
| 1 | CPI < 1.0 | Review budget allocation | PM | Date |
| 2 | | | | |
```

### Traffic Light Reports

Quick visual status assessment.

**Traffic Light Report Template:**
```markdown
## Traffic Light Report

**Project:** [Name]
**Date:** [Date]
**Period:** [Week/Month]

---

### 🚦 Status by Area

| Area | Status | Comment | Action |
|---------|--------|-------------|----------|
| 📅 Schedule | 🟢 | 2 days ahead | — |
| 💰 Budget | 🟡 | CPI 0.95, monitoring | Cost control |
| 📦 Scope | 🟢 | All requirements in progress | — |
| ⭐ Quality | 🟢 | Fewer defects than planned | — |
| 👥 Team | 🟢 | Team fully staffed | — |
| ⚠️ Risks | 🟡 | 2 high risks | Mitigation |
| 🔗 Dependencies | 🟢 | No blockers | — |
| 📋 Stakeholders | 🟢 | Positive feedback | — |

### 🚦 Status by Milestones

| Milestone | Status | Plan Date | Actual Date | Comment |
|------|--------|------------|------------|-------------|
| M1 | 🟢 | 01.02 | 01.02 | Completed on time |
| M2 | 🟢 | 15.02 | 14.02 | Completed early |
| M3 | 🟡 | 31.03 | 02.04 | 2 days delay risk |
| M4 | ⚪ | 15.04 | — | Not started |

### Legend

| Status | Meaning |
|--------|----------|
| 🟢 Green | On plan or better |
| 🟡 Yellow | Risks, require attention |
| 🔴 Red | Critical issues |
| ⚪ White | Not started / Not applicable |

---

### ⚠️ Critical Issues (Red items)

| Issue | Impact | Owner | Due Date |
|----------|---------|---------------|--------------|
| [Issue] | [Impact description] | [Name] | [Date] |

### 🟡 Attention Zones (Yellow items)

| Zone | Risk | Action Plan |
|------|------|---------------|
| [Area] | [Risk description] | [Action] |
```

## Stakeholder and Reporting Matrix

```markdown
## Stakeholder Communication Matrix

| Stakeholder | Level | Format | Frequency | Channel |
|-------------|---------|--------|---------|-------|
| Sponsor | Executive | Executive Summary | Weekly | Email + Meeting |
| Steering Committee | Executive | Full Report | Monthly | Meeting |
| Business Owner | Management | Status Report | Weekly | Email |
| IT Director | Management | Technical Status | Weekly | Email + Meeting |
| Team Lead | Team | Daily Standup | Daily | Standup |
| Development Team | Team | Sprint Review | By sprints | Meeting |
| End Users | Operational | User Updates | As needed | Newsletter |
| Vendors | External | Vendor Report | Monthly | Email |
```

## Integration with System Analyst

### Input Data from System Analyst

**Progress Data:**
- Status of requirements and tasks
- Change history
- Completion metrics

**Quality Data:**
- Testing results
- Defect statistics
- Code metrics

**Risk Data:**
- Identified risks
- Mitigation status
- New issues

### Output Artifacts for System Analyst

- Weekly Status Reports
- Monthly Reports
- Executive Summaries
- Dashboard Templates
- KPI Reports

## Usage Examples

### Example 1: Weekly Report for Sponsor

**Context:** Project sponsor requires brief report every Friday

**Approach:**
- Format: Executive Summary (1 page)
- Key elements: Traffic Light, Top 3 achievements, Top 3 risks
- Channel: Email with PDF attachment

**Result:** Sponsor aware of status, can make quick decisions

### Example 2: Monthly Report for Steering Committee

**Context:** Monthly steering committee meeting

**Approach:**
- Format: Full Monthly Report + Presentation
- Content: Finance, schedule, scope, risks, decisions
- Channel: Presentation at meeting + PDF via email

**Result:** Committee makes decisions on key issues

## Tools

### For Reporting
- Microsoft PowerPoint
- Google Slides
- Confluence
- Notion

### For Dashboards
- Power BI
- Tableau
- Grafana
- Google Data Studio

### For Automation
- Jira Reports
- Azure DevOps Dashboards
- Monday.com
- Smartsheet

## Best Practices

1. **Know the audience** — adapt content and detail level for stakeholder
2. **Be concise** — use Executive Summary for management
3. **Visualize** — charts and dashboards are more effective than tables
4. **Be honest** — report problems, not just successes
5. **Action-oriented** — each report should lead to decisions or actions

## Related Skills

- [`project-metrics`](../project-metrics/SKILL.md) — metrics for reporting
- [`escalation-management`](../escalation-management/SKILL.md) — issue escalation
- [`project-closure`](../project-closure/SKILL.md) — final reporting
- [`risk-assessment`](../risk-assessment/SKILL.md) — risk reporting

---

*Part of Project Manager SDLC Skills — Universal Skills*
