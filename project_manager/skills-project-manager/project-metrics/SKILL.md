---
name: project-metrics
description: Управление метриками проекта и EVM. Используйте для расчёта CPI, SPI, EVM, анализа трендов velocity, cycle time, lead time и подготовки отчётности для стейкхолдеров. Стратегический уровень — фокус на прогнозах и аналитике.
---

# Project Metrics

> **Meta:** v2.0.0 | 09-03-2026
> **Updated:** Добавлено разъяснение области применения и связь с development-tracking

## Purpose

Skill for comprehensive tracking and analysis of project key performance indicators. Provides objective progress assessment, schedule and cost forecasting, and supports data-driven management decision-making.

## Когда использовать

- При подготовке отчётов для стейкхолдеров
- При анализе отклонений от плана
- При прогнозировании сроков завершения
- При оценке эффективности команды
- При расчёте EVM-метрик (CPI, SPI, EAC)

**Примечание:** Для оперативного отслеживания прогресса разработки (daily standups, текущий burndown) используйте навык [`development-tracking`](development-tracking/SKILL.md).

## Functions

### CPI (Cost Performance Index)

Cost performance index — shows budget utilization efficiency.

**Formula:**
```
CPI = EV / AC

where:
EV (Earned Value) — earned value
AC (Actual Cost) — actual cost
```

**Interpretation:**
| Value | Interpretation | Action |
|----------|---------------|----------|
| CPI > 1.0 | Under budget | Can reallocate resources |
| CPI = 1.0 | On budget | Continue as planned |
| CPI < 1.0 | Over budget | Corrective measures required |

**Calculation Example:**
```markdown
## Example: CPI for ERP Implementation Project

Planned Value (PV): 1,000,000 RUB
Earned Value (EV): 600,000 RUB
Actual Cost (AC): 720,000 RUB

CPI = 600,000 / 720,000 = 0.83

Conclusion: For every ruble spent, 0.83 rubles of value was received.
Recommendation: Review budget or reduce scope.
```

### SPI (Schedule Performance Index)

Schedule performance index — shows adherence to schedule.

**Formula:**
```
SPI = EV / PV

where:
EV (Earned Value) — earned value
PV (Planned Value) — planned value
```

**Interpretation:**
| Value | Interpretation | Action |
|----------|---------------|----------|
| SPI > 1.0 | Ahead of schedule | Can use buffer |
| SPI = 1.0 | On schedule | Continue as planned |
| SPI < 1.0 | Behind schedule | Corrective measures required |

**Calculation Example:**
```markdown
## Example: SPI for Development Project

Planned Value (PV): 800,000 RUB
Earned Value (EV): 600,000 RUB

SPI = 600,000 / 800,000 = 0.75

Conclusion: Only 75% of planned scope was completed.
Forecast: At current pace, project will finish late.
```

### Earned Value Management (EVM)

Comprehensive project management methodology for cost and schedule.

**Key EVM Metrics:**

```markdown
## EVM Metrics

### Baseline Metrics
| Metric | Designation | Description |
|------------|-------------|----------|
| Planned Value | PV | Planned value of work performed |
| Earned Value | EV | Cost of work actually performed |
| Actual Cost | AC | Actual costs |

### Derived Metrics
| Metric | Formula | Description |
|------------|---------|----------|
| Cost Variance (CV) | EV - AC | Cost deviation |
| Schedule Variance (SV) | EV - PV | Schedule deviation |
| Cost Performance Index (CPI) | EV / AC | Cost performance index |
| Schedule Performance Index (SPI) | EV / PV | Schedule performance index |

### Forecast Metrics
| Metric | Formula | Description |
|------------|---------|----------|
| EAC (Estimate at Completion) | BAC / CPI | Forecast cost at completion |
| ETC (Estimate to Complete) | EAC - AC | Cost of remaining work |
| VAC (Variance at Completion) | BAC - EAC | Forecast variance |
| TCPI (To-Complete Performance Index) | (BAC-EV) / (BAC-AC) | Required CPI to complete on plan |
```

**EVM Analysis Example:**
```markdown
## EVM Dashboard for "Mobile Application" Project

### Initial Data
- Budget at Completion (BAC): 5,000,000 RUB
- Current status: 60% time, 50% work

### Current Metrics
| Metric | Value | Plan | Deviation |
|------------|----------|------|------------|
| PV | 3,000,000 | - | - |
| EV | 2,500,000 | 3,000,000 | -500,000 |
| AC | 2,800,000 | 3,000,000 | -200,000 |

### Indices
| Index | Value | Status |
|--------|----------|--------|
| CPI | 0.89 | ⚠️ Over budget |
| SPI | 0.83 | ⚠️ Behind schedule |
| CV | -300,000 | ⚠️ Budget exceeded |
| SV | -500,000 | ⚠️ Behind schedule |

### Forecasts
| Metric | Value | Comment |
|------------|----------|-------------|
| EAC | 5,618,000 | At current CPI |
| ETC | 2,818,000 | Remaining costs |
| VAC | -618,000 | Budget exceeded |
| TCPI | 1.08 | Required efficiency |

### Recommendations
1. Analyze causes of delay
2. Consider scope reduction
3. Evaluate possibility of adding resources
```

### Burndown Charts

Burndown charts for progress visualization.

**Sprint Burndown:**
```markdown
## Sprint Burndown Chart

### Data
| Day | Plan (SP) | Actual (SP) | Remaining |
|------|-----------|-----------|---------|
| 1 | 40 | 35 | 65 |
| 2 | 30 | 28 | 37 |
| 3 | 20 | 18 | 19 |
| 4 | 10 | 12 | 7 |
| 5 | 0 | 0 | 0 |

### Interpretation
- Plan line — ideal burndown
- Actual line — real progress
- Deviation shows risks

### Typical Patterns
- "Staircase" — tasks closed in batches at the end
- "Gentle slope" — low productivity
- "Sharp drop" — mass task closure
```

**Release Burndown:**
```markdown
## Release Burndown (by sprints)

### Data
| Sprint | Plan | Actual | Remaining | Forecast |
|--------|------|------|---------|---------|
| S1 | 120 | 100 | 220 | +20 |
| S2 | 100 | 95 | 125 | +5 |
| S3 | 80 | 90 | 35 | -10 |
| S4 | 35 | 35 | 0 | 0 |

### Velocity Trend
- Average velocity: 95 SP
- Trend: stable
- Forecast completion: S4
```

### Velocity Tracking

Team performance tracking.

**Velocity Analysis:**
```markdown
## Velocity Dashboard

### Sprint History
| Sprint | Committed | Completed | Velocity | Δ |
|--------|-----------|-----------|----------|---|
| S1 | 100 | 85 | 85 | - |
| S2 | 90 | 92 | 92 | +8% |
| S3 | 95 | 88 | 88 | -4% |
| S4 | 90 | 95 | 95 | +8% |
| S5 | 100 | 97 | 97 | +2% |
| S6 | 95 | 93 | 93 | -4% |

### Statistics
- Average velocity: 91.7 SP
- Standard deviation: 4.2 SP
- Range: 85-97 SP
- Coefficient of variation: 4.6%

### Planning Recommendations
- Commit to 90% of average velocity: ~82 SP
- Consider standard deviation in forecasts
- Analyze causes of deviations > 10%
```

**Velocity Stability Index:**
```
VSI = 1 - (Standard Deviation / Average Velocity)

VSI > 0.9 — stable team
VSI 0.7-0.9 — moderate stability
VSI < 0.7 — unstable team
```

### Additional Metrics

**Cycle Time:**
```markdown
## Cycle Time Analysis

### Definition
Time from task start to completion

### Distribution
| Task Type | P50 | P85 | P95 |
|------------|-----|-----|-----|
| Bug | 2 days | 4 days | 7 days |
| Feature (S) | 3 days | 5 days | 8 days |
| Feature (M) | 7 days | 12 days | 18 days |
| Feature (L) | 14 days | 21 days | 28 days |

### SLA for Cycle Time
- 85% of tasks should complete within P85
- Exceeding P95 requires analysis
```

**Lead Time:**
```markdown
## Lead Time Analysis

### Definition
Time from request creation to implementation

### Stages
| Stage | Average Time | % of Total |
|------|---------------|-------------|
| Backlog | 15 days | 50% |
| In Progress | 8 days | 27% |
| Code Review | 2 days | 7% |
| QA | 4 days | 13% |
| Deployment | 1 day | 3% |
| **Total** | **30 days** | **100%** |

### Optimization Opportunities
1. Reduce time in Backlog (prioritization)
2. Automate Code Review
3. Improve QA process
```

## Integration with System Analyst

### Input Data from System Analyst

**Task Data:**
- Task estimates (story points, hours)
- Task statuses
- Status change history
- Task dependencies

**Requirements Data:**
- Requirements priorities
- Scope changes
- Number of requirements by phases

**Quality Data:**
- Number of defects
- Time to fix
- Repeat defects

### Output Artifacts for System Analyst

- Project dashboard with metrics
- Completion forecasts
- Risk analysis based on metrics
- Plan adjustment recommendations

## Usage Examples

### Example 1: EVM Analysis for Stakeholder Report

**Context:** Weekly report for project sponsor

**Input Data:**
- BAC: 10,000,000 RUB
- Time elapsed: 50%
- EV: 4,000,000 RUB
- AC: 4,800,000 RUB
- PV: 5,000,000 RUB

**Calculations:**
```
CPI = 4,000,000 / 4,800,000 = 0.83
SPI = 4,000,000 / 5,000,000 = 0.80
EAC = 10,000,000 / 0.83 = 12,048,193 RUB
VAC = 10,000,000 - 12,048,193 = -2,048,193 RUB
```

**Report:**
```markdown
## Project Status (EVM Summary)

### Key Metrics
| Metric | Value | Status |
|---------|----------|--------|
| CPI | 0.83 | 🔴 Over budget |
| SPI | 0.80 | 🔴 Behind schedule |

### Forecast
- Forecast budget: 12.0M RUB (+20% to plan)
- Forecast completion: +3 weeks to plan

### Recommendations
1. Hold scope review session
2. Evaluate need for additional funding
3. Consider adding resources to critical tasks
```

### Example 2: Velocity Analysis for Sprint Planning

**Context:** Planning next sprint

**Analysis:**
- Average velocity over 6 sprints: 91.7 SP
- Standard deviation: 4.2 SP
- Recommended commitment: 82-85 SP (90% of average)

**Solution:**
- Plan 85 SP
- Keep 10 SP buffer for unexpected tasks
- Don't commit more than 90 SP

## Metrics Dashboard

```markdown
## Project Dashboard

### 📊 EVM Summary
| Metric | Value | Trend |
|------------|----------|-------|
| CPI | 0.95 | ↑ |
| SPI | 1.02 | → |
| EAC | 4.8M | ↓ |

### 🏃 Sprint Metrics
| Metric | Current | Previous | Δ |
|---------|---------|------------|---|
| Velocity | 95 SP | 92 SP | +3% |
| Cycle Time | 4.2 days | 4.5 days | -7% |
| Lead Time | 12 days | 14 days | -14% |

### 📈 Quality Metrics
| Metric | Value | Target | Status |
|---------|----------|--------|--------|
| Defect Rate | 2.1/KLOC | < 3 | ✅ |
| Code Coverage | 78% | > 75% | ✅ |
| Tech Debt | 15 SP | < 20 SP | ✅ |

### 🎯 Progress
- Scope: 67% complete
- Budget: 62% spent
- Time: 65% elapsed
```

## Tools

### For EVM
- Microsoft Project
- Primavera P6
- Jira + EVM plugins
- Excel/Google Sheets

### For Agile Metrics
- Jira (Velocity, Burndown)
- Azure DevOps
- Trello + Burndown plugins
- Linear

### For Visualization
- Grafana
- Power BI
- Tableau
- Google Data Studio

## Best Practices

1. **Regular data collection** — metrics must be current
2. **Contextual interpretation** — don't look at metrics in isolation
3. **Trends over points** — analyze dynamics, not individual values
4. **Actionable insights** — each metric should lead to action
5. **Transparency** — metrics available to entire team

## Связанные навыки

- [`development-tracking`](development-tracking/SKILL.md) — оперативное отслеживание прогресса (burndown, daily standups)
- [`stakeholder-reporting`](stakeholder-reporting/SKILL.md) — отчётность для stakeholders
- [`release-deployment-management`](release-deployment-management/SKILL.md) — метрики релизов
- [`agile-scrum-management`](agile-scrum-management/SKILL.md) — Agile-практики

---

*Часть навыков Project Manager SDLC — Phase 7: Поддержка и сопровождение*
*Обновлено: v2.0, 09-03-2026*
