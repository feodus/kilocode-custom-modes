---
name: context-advertising
description: Contextual advertising: Google Ads, Yandex Direct, Yandex Display Network
---

# Context Advertising

> **Meta:** v1.1.0 | 08-03-2026

## Purpose

Skill for setting up and managing contextual advertising in Google Ads and Yandex Direct. Includes campaign creation, bid management, optimization, and performance analysis.

## When to Use

Use this skill:
- When needing to launch contextual advertising
- For optimizing existing campaigns
- When setting up retargeting
- For reducing cost per click
- When scaling advertising campaigns

## Functions

### Campaign Setup
- Creating search campaigns
- Setting up Yandex Display Network (RSYa)
- Setting up Google Display Network (KMS)
- Configuring display campaigns

### Keyword Management
- Negative keyword selection
- Structuring ad groups
- Using modifiers
- Long-tail strategy

### Bid Management
- Manual bid management
- Automated strategies
- Device adjustments
- Auction analysis

### Ad Copywriting
- Creating search ads
- Responsive ads
- Dynamic ads
- Callouts and extensions

## Integration with Universal Coding Agent

- Delegate creation of landing pages for ads
- Request UTM tag setup
- Delegate technical call tracking integration

## Usage Examples

### Example 1: Yandex Direct campaign structure
**Business:** Window sales

```
Campaign: Windows_Search
├── Group: Plastic windows
│   ├── [keyword] plastic windows
│   ├── [keyword] buy plastic windows
│   └── [keyword] plastic windows prices
├── Group: PVC windows
│   ├── [keyword] PVC windows
│   └── [keyword] PVC windows Moscow
└── Group: Glazing
    ├── [keyword] balcony glazing
    └── [keyword] loggia glazing
```

### Example 2: Bid optimization
| Device | Adjustment | Reason |
|-----------|---------------|---------|
| Mobile | -30% | Low conversion |
| Desktop | +20% | High conversion |
| Tablets | 0% | Medium conversion |
| Time 10-14 | +20% | Conversion peak |
| Time 0-6 | -70% | No conversions |

### Example 3: Performance analysis
| Metric | Value | Assessment |
|-----------|----------|--------|
| CTR | 5.2% | ✅ Good |
| CPC | 45 rub | ⚠️ High |
| Conversion | 3.5% | ✅ Good |
| CPA | 1,285 rub | ⚠️ High |
| ROAS | 2.8 | ✅ Good |

**Recommendations:**
1. Add more negative keywords to reduce CPC
2. A/B test headlines
3. Expand list of relevant keywords

## Related Skills

- targeted-advertising
- web-analytics
- landing-page-design
- campaign-management

---
