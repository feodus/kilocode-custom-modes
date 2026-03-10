---
name: web-analytics
description: Web analytics: Google Analytics, Yandex Metrica, KPIs
---

# Web Analytics

> **Meta:** v1.1.0 | 08-03-2026

## Purpose

Skill for setting up and analyzing web analytics. Includes working with Google Analytics, Yandex Metrica, setting up goals and KPIs, creating reports, and analyzing user behavior.

## When to Use

Use this skill:
- When needing to set up analytics systems
- For analyzing user behavior on website
- When setting up goals and conversions
- For creating regular reports
- When optimizing website based on data

## Functions

### Analytics Setup
- Installing and configuring Google Analytics 4
- Setting up Yandex Metrica
- Configuring goals
- Setting up ecommerce

### User Behavior Analysis
- Funnel analysis
- Heatmaps
- Session recordings
- User segmentation

### Reporting
- Creating dashboards
- Regular reports
- Trend analysis
- Attribution analysis

### KPI Management
- Defining key indicators
- Setting up monitoring
- Establishing target values
- Deviation analysis

## Integration with Universal Coding Agent

- Delegate technical GTM and analytics setup
- Request implementation of events and goals
- Delegate advanced ecommerce setup

## Usage Examples

### Example 1: Setting up GA4 goals
| Goal | Type | Event | Value |
|------|-----|---------|----------|
| Request | Destination | /thank-you | 500 rub |
| Call | Event | call_click | 300 rub |
| Subscription | Event | newsletter_signup | 100 rub |
| Purchase | Ecommerce | purchase | By amount |

### Example 2: Sales funnel analysis
**Landing:** SaaS product

**Funnel:**

| Stage | Users | Conversion | Churn |
|-------|--------------|-----------|-------|
| Website visit | 10,000 | 100% | - |
| Viewing tariffs | 3,500 | 35% | 65% |
| Clicking "Start trial" | 700 | 20% | 80% |
| Registration | 350 | 50% | 50% |
| First payment | 70 | 20% | 80% |

**Conclusion:** Main churn at registration transition stage. Recommendation: simplify registration process.

### Example 3: Technical specification for setup
```
Universal Coding Agent, need to implement:
1. GTM container with basic tracking
2. Events: scroll 50%, time on page > 30 sec
3. E-commerce: view_item, add_to_cart, begin_checkout, purchase
4. User ID tracking for authorized users
5. Set up GA4 ecommerce events
```

## Key Metrics

| Metric | Description | Target |
|---------|----------|------------------|
| Sessions | Number of sessions | Depends on business |
| Bounce Rate | Bounces | < 40% |
| Avg. Session Duration | Average duration | > 2 min |
| Pages / Session | Pages per session | > 2 |
| Goal Conversion | Goal conversion | > 3% |
| E-commerce CR | Ecommerce conversion | > 2% |

## Related Skills

- seo-optimization
- landing-page-design
- marketing-metrics
- context-advertising

---
