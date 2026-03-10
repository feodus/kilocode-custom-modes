---
name: marketing-metrics
description: Marketing metrics: ROI, CAC, LTV, ROMI
---

# Marketing Metrics

> **Meta:** v1.1.0 | 08-03-2026

## Purpose

Skill for calculating and analyzing marketing metrics. Includes calculating ROI, CAC, LTV, ROMI, and other key marketing performance indicators.

## When to Use

Use this skill:
- When evaluating marketing campaign effectiveness
- For calculating unit economics
- When optimizing marketing budget
- For creating reports
- When making scaling decisions

## Functions

### ROI Analysis
- Calculating Return on Investment
- Payback analysis
- Channel comparison
- Budget optimization

### Customer Acquisition Metrics
- CAC (Customer Acquisition Cost)
- CPA (Cost per Acquisition)
- CPC (Cost per Click)
- CPM (Cost per Mille)

### Customer Value Metrics
- LTV (Lifetime Value)
- ARPU (Average Revenue Per User)
- Revenue per Customer
- Customer Margin

### Marketing Efficiency
- ROMI (Return on Marketing Investment)
- ROAS (Return on Ad Spend)
- Marketing Efficiency Ratio
- Channel Attribution

## Calculation Formulas

### Main Metrics

| Metric | Formula |
|---------|---------|
| ROI | (Revenue - Costs) / Costs × 100% |
| CAC | Marketing costs / Number of customers |
| LTV | Average check × Purchase frequency × Lifetime |
| ROMI | (Marketing revenue - Marketing costs) / Costs × 100% |
| ROAS | Advertising revenue / Advertising costs |

## Usage Examples

### Example 1: CAC calculation by channel
| Channel | Costs | New Customers | CAC |
|-------|---------|---------------|-----|
| Yandex Direct | 150,000 ₽ | 50 | 3,000 ₽ |
| Google Ads | 120,000 ₽ | 30 | 4,000 ₽ |
| SEO | 50,000 ₽ | 40 | 1,250 ₽ |
| Email | 20,000 ₽ | 20 | 1,000 ₽ |
| **Total** | **340,000 ₽** | **140** | **2,428 ₽** |

### Example 2: LTV calculation
| Parameter | Value |
|----------|----------|
| Average check | 15,000 ₽ |
| Purchase frequency | 4 times/year |
| Customer lifetime | 3 years |
| Margin | 40% |
| **LTV** | **15,000 × 4 × 3 × 0.4 = 72,000 ₽** |

### Example 3: ROMI analysis by channel
| Channel | Costs | Revenue | ROMI | Assessment |
|-------|---------|-------|------|--------|
| Yandex Direct | 150,000 | 450,000 | 200% | ✅ Good |
| Google Ads | 120,000 | 240,000 | 100% | ⚠️ Neutral |
| SEO | 50,000 | 300,000 | 500% | ✅ Excellent |
| Email | 20,000 | 180,000 | 800% | ✅ Excellent |

**Recommendations:**
1. Increase budget for SEO and Email
2. Optimize Google Ads
3. Test new channels

### Example 4: Product unit economics
| Indicator | Value |
|-----------|----------|
| Price | 5,000 ₽ |
| Cost | 1,500 ₽ |
| Margin | 3,500 ₽ (70%) |
| First payment | 5,000 ₽ |
| Repeat purchases | 2 per year |
| LTV | 5,000 + 2 × 3,500 = 12,000 ₽ |
| CAC | 3,000 ₽ |
| LTV/CAC | 12,000 / 3,000 = 4.0 ✅ |
| Payback period | 3,000 / 3,500 = 0.86 months |

**Conclusion:** Unit economics are healthy. LTV/CAC > 3 - can scale.

## Key Metrics Dashboard

| Metric | Target | Current | Status |
|---------|---------|---------|--------|
| ROI | > 150% | 180% | ✅ |
| CAC | < 3,000 ₽ | 2,428 ₽ | ✅ |
| LTV | > 50,000 ₽ | 72,000 ₽ | ✅ |
| ROMI | > 150% | 200% | ✅ |
| LTV/CAC | > 3 | 4.0 | ✅ |

## Integration with Universal Coding Agent

- Delegate technical tracking implementation
- Request attribution setup
- Delegate dashboard creation

## Related Skills

- unit-economics
- web-analytics
- budget-management
- forecasting

---
