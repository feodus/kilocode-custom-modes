---
name: marketing-automation
description: Marketing automation: CRM, triggers, funnels - automation setup, funnel creation, trigger campaigns
---

# Marketing Automation

> **Meta:** v1.1.0 | 08-03-2026

## Purpose

Skill for setting up marketing automation. Includes working with CRM systems, creating funnels, setting up triggers, and automating communications.

## When to Use

Use this skill:
- When setting up automatic funnels
- For increasing conversion
- When working with CRM
- For personalizing communications
- When scaling manual processes

## Functions

### Automation Setup
- Tool selection and setup
- CRM integration
- Trigger setup
- Scenario creation

### Funnel Creation
- Acquisition funnel
- Nurturing funnel
- Sales funnel
- Retention funnel

### Trigger Campaigns
- Behavioral triggers
- Time-based triggers
- Event-based triggers
- Combined triggers

### Personalization
- Segmentation
- Dynamic content
- Data-based personalization
- A/B testing

## Automation Tools

| Tool | Purpose | Complexity |
|------------|------------|------------|
| SendPulse | Email, Telegram, SMS | Low |
| Mindbox | Enterprise CRM + automation | High |
| Retail Rocket | E-commerce automation | Medium |
| Pipedrive | CRM with automation | Medium |
| amoCRM | CRM for small business | Low |
| GetResponse | Email marketing + automation | Low |

## Usage Examples

### Example 1: Welcome funnel
```
Trigger: New registration

Day 0 (registration moment):
- Email: "Welcome!" + product introduction
- After 30 minutes: Push notification "Start with..."

Day 1:
- Email: "5 tips for getting started"
- Added to segment "Beginners"

Day 3:
- Email: "How to use key features"
- Demo call offer

Day 7:
- Email: "Client success story"
- CTA: First payment

Day 14:
- If didn't buy: Email with limited offer
```

### Example 2: Triggers
| Trigger | Action | Channel |
|----------|----------|-------|
| Abandoned cart | Reminder after 1 hour | Email |
| Viewed 5 pages | Demo offer | Chatbot |
| Inactive 30 days | Reactivation series | Email |
| Birthday | Congratulations + bonus | Email + SMS |
| New blog article | Newsletter to subscribers | Email |

### Example 3: Lead-Nurturing scenario
```
State: Lead in segment "Interested in product"

Trigger: Downloaded guide

Day 1: Email "What to do with the guide"
Day 3: Email with case
Day 5: Webinar offer
Day 7: If signed up → "Webinar" funnel
       If not → Email with objections
Day 10: Warm call from manager

Transition to "Hot lead":
- Product demonstration
- Qualification
- Commercial offer
```

### Example 4: Automation metrics
| Metric | Target | Current | Status |
|---------|---------|---------|--------|
| Open Rate | 25% | 32% | ✅ |
| Click Rate | 5% | 6.5% | ✅ |
| Funnel conversion | 15% | 12% | ⚠️ |
| Response time | < 1 hour | 2 hours | ⚠️ |
| Automated emails | 80% | 65% | ⚠️ |

### Example 5: Implementation checklist
- [ ] Platform selected
- [ ] CRM integration
- [ ] Main triggers set up
- [ ] Key funnels created
- [ ] Segmentation set up
- [ ] Templates prepared
- [ ] Tracking set up

## Integration with Universal Coding Agent

- Delegate technical implementation of integrations
- Request API integration setup
- Delegate automation development
- Request dashboard creation

## Related Skills

- email-marketing
- smm-management
- web-analytics
- campaign-management
- crm-integration (delegation)

---
