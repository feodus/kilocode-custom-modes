---
name: project-closure
description: Project closure and handover. Use when closing the project, preparing final reports, analyzing lessons learned, and transferring operational responsibility.
---

# Project Closure

> **Meta:** v1.0.0 | 22-02-2026

## Purpose

Skill for formalized project closure, ensuring smooth handover of results to operations team and documenting lessons learned. Guarantees that all commitments are fulfilled, resources are released, and knowledge is preserved for future projects.

## When to Use

- When all project goals are achieved
- When project is terminated early
- When project is handed over to operations team
- When project is closed due to external reasons
- When finalizing contracts and settlements

## Functions

### Closure Activities

Structured project closure process.

**Project Closure Checklist:**

```markdown
## Project Closure Checklist

### 1. Functional Completion
- [ ] All requirements implemented or agreed upon exclusion
- [ ] All tests passed
- [ ] Documentation completed
- [ ] UAT signed by customer
- [ ] Product accepted for operation

### 2. Technical Completion
- [ ] Code transferred to repository
- [ ] Environment configurations documented
- [ ] Accesses transferred/revoked
- [ ] Licenses documented
- [ ] Monitoring configured

### 3. Administrative Closure
- [ ] Contracts closed
- [ ] Payments completed
- [ ] Resources released
- [ ] Archiving completed
- [ ] Final report approved

### 4. Knowledge Transfer
- [ ] Documentation transferred
- [ ] Training conducted
- [ ] Knowledge Transfer sessions completed
- [ ] Lessons Learned document prepared
```

**Closure Timeline:**
```markdown
## Closure Timeline

| Stage | Duration | Responsible | Deadline |
|-------|----------|-------------|----------|
| Final Testing | 1 week | QA Lead | -3 weeks |
| UAT Completion | 1 week | PM | -2 weeks |
| Documentation Finalization | 3 days | Tech Writer | -1.5 weeks |
| Knowledge Transfer | 1 week | Team Lead | -1 week |
| Contract Closure | 3 days | PM/Legal | -3 days |
| Final Report | 2 days | PM | -1 day |
| Project Closure Meeting | 1 day | PM | Day 0 |
```

### Handover Process

Organized handover of product to operations team.

**Handover Plan Structure:**
```markdown
## Handover Plan

### 1. Receiving Party Definition
| Role | Name | Responsibilities |
|------|-----|-------------|
| Service Owner | TBD | Service owner |
| Operations Lead | TBD | Operations manager |
| Support Lead | TBD | Support manager |
| Technical Lead | TBD | Technical manager |

### 2. Handover Artifacts
| Category | Document | Status | Recipient |
|-----------|----------|--------|------------|
| Documentation | User Manual | ✅ Ready | Support Team |
| Documentation | Admin Guide | ✅ Ready | Ops Team |
| Documentation | API Reference | ✅ Ready | Dev Team |
| Documentation | Architecture Doc | ✅ Ready | Tech Lead |
| Access | Repository Access | 🔄 Pending | Dev Team |
| Access | Production Access | 🔄 Pending | Ops Team |
| Access | Monitoring Access | 🔄 Pending | Ops Team |
| Infrastructure | Server Credentials | 🔄 Pending | Ops Team |
| Infrastructure | Database Access | 🔄 Pending | DBA |

### 3. Training
| Topic | Audience | Format | Date |
|-------|----------|--------|------|
| System Overview | All | Presentation | TBD |
| Admin Operations | Ops Team | Workshop | TBD |
| Support Procedures | Support Team | Workshop | TBD |
| Troubleshooting | Tech Team | Workshop | TBD |

### 4. Support Period
| Parameter | Value |
|-----------|-------|
| Duration | 30 days |
| Support Level | L3 |
| Response Time | 4 hours |
| Responsible | Development Team |
```

**Handover Acceptance Protocol Template:**
```markdown
## Handover Acceptance Protocol

**Project:** [Project Name]
**Handover Date:** [Date]
**Handing Over Party:** [Project Team]
**Receiving Party:** [Operations Team]

### Handover Components
| Component | Version | Status | Comment |
|-----------|--------|--------|-------------|
| Application | v1.0.0 | ✅ Accepted | |
| Database | v1.0.0 | ✅ Accepted | |
| Documentation | v1.0 | ✅ Accepted | |
| Infrastructure | - | ✅ Accepted | |

### Open Issues
| # | Description | Priority | Responsible | Deadline |
|---|----------|-----------|---------------|------|
| 1 | | | | |

### Signatures
- Handing over party: _________________ / Date: _______
- Receiving party: _________________ / Date: _______
- Project Sponsor: _________________ / Date: _______
```

### Lessons Learned

Documenting experience for future projects.

**Lessons Learned Document Structure:**
```markdown
## Lessons Learned Report

**Project:** [Name]
**Period:** [Start] — [End]
**Retrospective Participants:** [List]

---

### 1. Overall Project Assessment

| Criterion | Assessment (1-5) | Comment |
|----------|--------------|-------------|
| Schedule adherence | | |
| Budget adherence | | |
| Result quality | | |
| Customer satisfaction | | |
| Teamwork | | |

### 2. What Went Well (Successes)

#### Success 1: [Title]
- **Description:** What worked well?
- **Result:** What positive effect was achieved?
- **Success Factors:** What contributed to success?
- **Recommendation:** How to repeat in future?

#### Success 2: [Title]
...

### 3. What Could Be Improved (Challenges)

#### Challenge 1: [Title]
- **Description:** What was the issue?
- **Impact:** How did it affect the project?
- **Cause:** Why did it happen?
- **Solution:** What was done to fix?
- **Recommendation:** How to avoid in future?

#### Challenge 2: [Title]
...

### 4. Recommendations for Future Projects

| Category | Recommendation | Priority |
|-----------|--------------|-----------|
| Process | | High/Medium/Low |
| Communication | | |
| Technologies | | |
| Management | | |
| Resources | | |

### 5. Project Metrics

| Metric | Plan | Fact | Deviation |
|---------|------|------|------------|
| Timeline | X months | Y months | +/- Z% |
| Budget | X rubles | Y rubles | +/- Z% |
| Scope | N requirements | M requirements | +/- K% |
| Quality | < N defects | M defects | +/- K% |

### 6. Document Archive

| Document | Location | Responsible |
|----------|--------------|---------------|
| Project Charter | [Link] | PM |
| Requirements | [Link] | BA |
| Architecture | [Link] | Architect |
| Test Reports | [Link] | QA |
| User Manuals | [Link] | Tech Writer |
```

**Lessons Learned Collection Methodology:**
```markdown
## Lessons Learned Workshop Agenda

**Duration:** 2-3 hours
**Participants:** Entire project team

### Agenda
1. **Introduction (15 min)**
   - Session objectives
   - Rules (no blame, focus on processes)

2. **Timeline Review (30 min)**
   - Building project timeline
   - Key events and milestones

3. **What Went Well (30 min)**
   - Individual notes
   - Grouping by topics
   - Discussion

4. **What Could Be Improved (30 min)**
   - Individual notes
   - Grouping by topics
   - Discussion

5. **Recommendations (30 min)**
   - Prioritization
   - Assigning responsible parties
   - Implementation plan

6. **Closing (15 min)**
   - Next steps
   - Thanks to team
```

### Final Reporting

Preparing final project documentation.

**Final Project Report Structure:**
```markdown
## Final Project Report

**Project:** [Name]
**Sponsor:** [Name]
**PM:** [Name]
**Period:** [Start] — [End]
**Status:** Completed / Completed Early

---

### Executive Summary

**Brief project description:**
[2-3 sentences about goals and results]

**Key Achievements:**
- Achievement 1
- Achievement 2
- Achievement 3

**Final Status:**
| Indicator | Plan | Fact | Status |
|------------|------|------|--------|
| Timeline | | | ✅/⚠️/❌ |
| Budget | | | ✅/⚠️/❌ |
| Scope | | | ✅/⚠️/❌ |
| Quality | | | ✅/⚠️/❌ |

---

### 1. Goals and Results

| Goal | Status | Comment |
|------|--------|-------------|
| Goal 1 | ✅ Achieved | |
| Goal 2 | ⚠️ Partially | [Reason] |
| Goal 3 | ❌ Not Achieved | [Reason] |

### 2. Financial Report

| Category | Budget | Fact | Deviation |
|-----------|--------|------|------------|
| Personnel | | | |
| Technologies | | | |
| Infrastructure | | | |
| External Services | | | |
| Other | | | |
| **Total** | | | |

### 3. Financial Indicators

| Indicator | Value |
|------------|----------|
| ROI | X% |
| NPV | X rubles |
| Payback Period | X months |

### 4. Quality Indicators

| Metric | Target | Actual | Status |
|---------|---------|-------------|--------|
| Defect Density | < 3/KLOC | X/KLOC | |
| Code Coverage | > 75% | X% | |
| Uptime SLA | 99.5% | X% | |
| Performance | < 2s | Xs | |

### 5. Risks and Issues

#### Realized Risks
| Risk | Impact | Mitigation | Result |
|------|---------|-----------|-----------|
| | | | |

#### Open Issues
| Issue | Responsible | Deadline | Status |
|----------|---------------|------|--------|
| | | | |

### 6. Handover and Support

| Element | Recipient | Status | Date |
|---------|------------|--------|------|
| Product | Ops Team | ✅ Transferred | |
| Documentation | All Teams | ✅ Transferred | |
| Knowledge | Support Team | ✅ Transferred | |

### 7. Recommendations

**For the organization:**
1. Recommendation 1
2. Recommendation 2

**For future projects:**
1. Recommendation 1
2. Recommendation 2

### 8. Recognition

**Project Team:**
| Participant | Role | Contribution |
|----------|------|-------|
| | | |

**Acknowledgments:**
- [External teams, vendors, stakeholders]

---

**Signatures:**

Project Manager: _________________ / Date: _______

Project Sponsor: _________________ / Date: _______
```

## Integration with System Analyst

### Input from System Analyst

**Project Data:**
- Complete requirements history
- Status of each requirement implementation
- Architecture and decisions documentation
- Scope change history

**Quality Data:**
- Testing results
- Defect statistics
- Code quality metrics

**Knowledge Data:**
- Technical documentation
- Diagrams and models
- Procedures and regulations

### Output Artifacts for System Analyst

- Final Project Report
- Lessons Learned Document
- Handover Protocol
- Archive Index
- Knowledge Base Structure

## Usage Examples

### Example 1: Standard Project Closure

**Context:** CRM implementation project completed successfully

**Closure Process:**
1. **Week -3:** Final testing and UAT
2. **Week -2:** Documentation preparation
3. **Week -1:** Knowledge Transfer sessions
4. **Week 0:** Lessons Learned workshop and Closure Meeting

**Results:**
- Product handed over to operations team
- All contracts closed
- Lessons Learned documented
- Team released for new projects

### Example 2: Early Project Closure

**Context:** Project closed due to changed business priorities

**Specifics:**
- Documenting current state
- Archiving incomplete work
- Analyzing possibility of resumption
- Calculating sunk costs
- Transferring partial results

## Project Closure Metrics

| Metric | Target Value |
|--------|--------------|
| % requirements implemented | 100% (or agreed) |
| Open defects | 0 critical/high |
| Documentation completed | 100% |
| Knowledge Transfer | 100% of key knowledge |
| Contracts closed | 100% |
| Resources released | 100% |

## Tools

### Documentation
- Confluence
- SharePoint
- Google Drive
- Notion

### Closure Task Management
- Jira
- Asana
- Microsoft Planner
- Trello

### Lessons Learned
- Miro (for workshops)
- Retrium
- TeamRetro

## Best Practices

1. **Plan closure from the beginning** — include closure phase in project plan
2. **Regular retrospectives** — don't wait until project end to extract lessons
3. **Formal handover** — always sign handover protocol
4. **Archiving** — ensure knowledge availability for future projects
5. **Team recognition** — acknowledge each participant's contribution

## Related Skills

- [`stakeholder-reporting`](../stakeholder-reporting/SKILL.md) — stakeholder reporting
- [`project-metrics`](../project-metrics/SKILL.md) — final metrics
- [`maintenance-planning`](../maintenance-planning/SKILL.md) — handover to support
- [`deployment-planning`](../deployment-planning/SKILL.md) — final deployment

---

*Part of Project Manager SDLC Skills — Phase 8: Project Closure*
