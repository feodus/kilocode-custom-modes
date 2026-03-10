---
name: unit-economics
description: Unit economics: calculating product unit economics, profitability analysis, forecasting
---

# Unit Economics

> **Meta:** v1.1.0 | 08-03-2026

## Purpose

Skill for calculating and analyzing unit economics of products and services. Includes defining unit economics, profitability analysis, calculating payback period, and forecasting economic efficiency.

## When to Use

Use this skill:
- When evaluating product profitability
- For making scaling decisions
- When planning marketing budget
- For determining allowable customer acquisition cost
- When analyzing channel profitability

## Functions

### Unit Definition
- Identifying unit of economic analysis
- Defining unit boundaries
- Separating variable and fixed costs

### Profitability Analysis
- Calculating margin
- Break-even analysis
- Profitability assessment
- Competitor comparison

### Forecasting
- Scenario modeling
- Revenue forecasting
- Profit planning
- Stress testing

### Decision Making
- Scaling recommendations
- Cost optimization
- Pricing
- Channel selection

## Calculation Formulas

### Main Indicators

| Indicator | Formula |
|------------|---------|
| Margin | Price - Cost |
| Marginality | Margin / Price × 100% |
| LTV | Average check × Frequency × Lifetime |
| CAC | Acquisition costs / Customers |
| LTV/CAC | LTV / CAC |
| Payback period | CAC / Margin from customer |
| Contribution Margin | Revenue - Variable costs |

## Usage Examples

### Example 1: Calculating SaaS unit economics
| Parameter | Value |
|----------|----------|
| Monthly Subscription | 2,000 ₽ |
| Cost (server, support) | 400 ₽ |
| Margin | 1,600 ₽ (80%) |
| Average lifetime | 24 months |
| LTV | 1,600 × 24 = 38,400 ₽ |
| CAC | 6,000 ₽ |
| LTV/CAC | 38,400 / 6,000 = 6.4 ✅ |
| Payback period | 6,000 / 1,600 = 3.75 months |

**Conclusion:** Very healthy economics. Can increase CAC.

### Example 2: Unit analysis by channel
| Channel | CAC | LTV | LTV/CAC | Payback period | Decision |
|-------|-----|-----|---------|-----------------|---------|
| SEO | 1,500 ₽ | 38,400 ₽ | 25.6 | 0.9 months | ✅ Scale |
| Context | 5,000 ₽ | 38,400 ₽ | 7.7 | 3.1 months | ✅ Scale |
| Target | 8,000 ₽ | 38,400 ₽ | 4.8 | 5.0 months | ✅ Keep |
| CPA | 12,000 ₽ | 38,400 ₽ | 3.2 | 7.5 months | ⚠️ Optimize |

### Example 3: Break-even point
| Indicator | Value |
|------------|----------|
| Fixed costs/month | 500,000 ₽ |
| Margin per unit | 3,000 ₽ |
| Break-even point | 500,000 / 3,000 = 167 units |

**Current sales:** 200 units/month
**Safety margin:** (200-167)/167 = 20% ✅

## Integration with Universal Coding Agent

- Delegate technical tracking implementation
- Request creation of unit economics dashboards
- Delegate analytics setup by units

## Related Skills

- marketing-metrics
- budget-management
- forecasting
- web-analytics

---
