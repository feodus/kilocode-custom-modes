---
name: testing-coordination
description: Coordinating testing process: planning, environment, defect tracking, release criteria. Use when planning testing phases, coordinating teams, and managing release readiness.
---

# Testing Coordination

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for coordinating software testing process. Includes test planning, test environment preparation, defect tracking, defining release criteria, and product quality assurance. Helps organize effective testing process and ensure product meets requirements.

## When to Use

Use this skill:
- When planning project testing phase
- When preparing test infrastructure
- When coordinating testing team work
- When managing defect detection and fixing process
- When determining product readiness for release
- When defining quality gates and exit criteria

## Test Planning Coordination

### Defining Testing Levels

Planning testing at different levels:

1. **Unit Testing**
   - Focus: Individual components and functions
   - Responsibility: Developers
   - Tools: pytest, unittest, JUnit

2. **Integration Testing**
   - Focus: Interactions between components
   - Responsibility: QA Engineers
   - Tools: Postman, REST Assured, integration test frameworks

3. **System Testing**
   - Focus: Complete system functionality
   - Responsibility: QA Engineers
   - Tools: Selenium, Cypress, Playwright

4. **Acceptance Testing**
   - Focus: Business requirements validation
   - Responsibility: Business Analysts, Stakeholders
   - Tools: Manual testing, UAT scenarios

### Planning Test Types

| Test Type | Purpose | Timing | Resources |
|-----------|---------|--------|-----------|
| Functional | Verify functionality | During development | QA Engineers |
| Regression | Ensure no new bugs | Before release | QA Engineers, Automation |
| Performance | Check speed and scalability | Before release | Performance Engineers |
| Security | Identify vulnerabilities | Before release | Security Engineers |
| Usability | Validate user experience | During development | UX Specialists |
| Smoke | Quick sanity check | After each build | QA Engineers |

### Setting Testing Deadlines

- Define clear milestones and checkpoints
- Account for test execution time
- Include buffer for bug fixing
- Coordinate with development timeline
- Consider UAT scheduling

### Allocating Testing Resources

- Assess skill requirements for each test type
- Match tester expertise to test types
- Plan for knowledge transfer
- Consider automation vs manual balance
- Account for availability and holidays

## Test Environment Setup

### Coordinating Environment Setup

1. **Environment Requirements**
   - Define hardware specifications
   - Specify software versions
   - Document network configurations
   - Identify external service dependencies

2. **Environment Provisioning**
   - Create development environment
   - Set up staging environment
   - Configure pre-production environment
   - Prepare production-like environment

3. **Access Management**
   - Grant appropriate access levels
   - Document access credentials
   - Implement security protocols
   - Track access logs

### Ensuring Data Relevance

- Create representative test data sets
- Implement data refresh procedures
- Mask sensitive production data
- Maintain data consistency across environments
- Document data dependencies

### Ensuring Environment Isolation

- Isolate test environments from production
- Prevent cross-environment contamination
- Use separate databases
- Configure independent service instances
- Implement environment-specific configurations

### Planning Environment Updates

- Schedule regular updates
- Test updates before deployment
- Document change procedures
- Maintain rollback capabilities
- Communicate changes to team

## Defect Tracking Management

### Setting Up Registration Process

1. **Choose defect tracking tool**
   - JIRA
   - Azure DevOps
   - Bugzilla
   - Linear
   - YouTrack

2. **Define defect workflow**
   - New → Open → In Progress → Resolved → Closed
   - Include verification step
   - Define rejection criteria

3. **Set up notification rules**
   - Assignee notifications
   - Status change alerts
   - SLA breach warnings

### Classifying and Prioritizing Defects

**Severity Levels:**

| Severity | Description | Examples | Target Fix Time |
|----------|-------------|----------|-----------------|
| Critical | System down, data loss | Crash, security breach | 24 hours |
| High | Major functionality broken | Login fails, payment error | 3 days |
| Medium | Feature partially works | Slow response, minor bug | 1 week |
| Low | Cosmetic or minor issue | Typo, alignment | Next release |

**Priority Levels:**

| Priority | Description | Action |
|----------|-------------|--------|
| P1 | Must fix before release | Block release |
| P2 | Should fix before release | Include in current release |
| P3 | Fix if time permits | Backlog |
| P4 | Won't fix | Won't implement |

### Tracking Fix Status

- Monitor defect lifecycle
- Track time to resolution
- Identify bottlenecks
- Generate status reports
- Review aging defects

### Analyzing Defect Trends

- Track defect density over time
- Identify recurring issues
- Analyze root causes
- Monitor defect distribution by component
- Generate trend reports

### Managing Fix SLA

| Priority | Response Time | Resolution Time |
|----------|---------------|------------------|
| Critical | 1 hour | 24 hours |
| High | 4 hours | 3 days |
| Medium | 1 day | 1 week |
| Low | 2 days | Next release |

## Release Criteria Definition

### Defining Quality Thresholds

1. **Test Coverage**
   - Minimum code coverage: 80%
   - Critical path coverage: 100%
   - New feature coverage: 90%

2. **Defect Metrics**
   - Zero critical defects
   - Zero high-priority open defects
   - Defect density below threshold

3. **Performance Metrics**
   - Response time within SLA
   - Throughput meets requirements
   - Resource usage acceptable

### Setting Test Pass Criteria

- All critical test cases pass
- All blocking defects resolved
- Smoke test suite passes 100%
- Regression suite pass rate > 95%
- Performance tests meet benchmarks

### Verifying Requirements Compliance

- Trace tests to requirements
- Ensure all requirements covered
- Review acceptance criteria met
- Document any deviations
- Obtain sign-off from stakeholders

### Assessing Risks of Remaining Defects

- Evaluate open defects impact
- Assess workarounds available
- Consider user workaround severity
- Document known limitations
- Make release decision

### Approving Release Readiness

1. **Final QA Sign-off**
   - All critical tests passed
   - No blocking issues
   - Performance benchmarks met

2. **Security Approval**
   - Security scan complete
   - No critical vulnerabilities
   - Penetration test passed (if required)

3. **Business Approval**
   - Product owner sign-off
   - Stakeholder acceptance
   - Release notes approved

## Integration with Other Skills

### From System Analyst

- Accounting for non-functional requirements in test planning
- Using scenarios from System Analyst for testing
- Verifying requirements compliance
- System Analyst involvement in defect analysis

### From Test Case Design

- Design comprehensive test cases
- Ensure requirement traceability
- Prioritize test cases by risk

### From Defect Management

- Effective defect reporting
- Clear reproduction steps
- Proper severity classification

### From Test Management Tools

- Use TestRail for test case management
- Track execution progress
- Generate quality reports

## Usage Examples

### Example 1: Coordinating Web Application Testing

**Testing types:**
- Unit tests: 100% coverage of critical paths
- Integration tests: verification of integration with external APIs
- E2E tests: key user scenarios
- Performance tests: load up to 1000 concurrent users
- Security tests: OWASP Top 10 vulnerability check

**Test environments:**
- Development: for developers
- Staging: for integration testing
- Pre-production: for acceptance testing
- Production: for UAT and load testing

**Release criteria:**
- 0 critical and 0 high defects
- 95% successful automated test results
- Response time not exceeding 2 seconds under load
- At least 90% of test cases passed

### Example 2: Defect Management in Project

**Process:**
- Registration: through JIRA
- Classification: by type and priority
- Assignment: to responsible developers
- SLA: critical - 24 hours, high - 3 days, medium - 1 week
- Statuses: Open → In Progress → Resolved → Closed

**Tracking:**
- Daily defect status reviews
- Weekly trend reports
- Metrics: defect density, fix time
- Retrospectives: analyzing defect causes

### Example 3: Planning Acceptance Testing

**UAT planning:**
- Participants: key users and business analysts
- Scenarios: based on user stories
- Infrastructure: pre-production environment
- Duration: 2 weeks
- Success criteria: 95% of scenarios completed successfully

**Coordination:**
- Preparing test data
- Training users on testing process
- Collecting and analyzing feedback
- Iterative product improvement
- Preparing readiness conclusion

## Testing Coordination Checklist

### Pre-Testing Phase
- [ ] Test plan approved
- [ ] Test environment ready
- [ ] Test data prepared
- [ ] Test cases reviewed
- [ ] Resources allocated
- [ ] Schedule communicated

### During Testing
- [ ] Daily status updates
- [ ] Defect tracking active
- [ ] Blocker escalation process
- [ ] Environment issues resolved
- [ ] Progress against plan

### Post-Testing
- [ ] Test results documented
- [ ] Release criteria met
- [ ] Sign-offs obtained
- [ ] Lessons learned documented
- [ ] Handover to support

## Related Skills

- test-case-design — designing test cases
- test-management-tools — test case management
- defect-management — defect tracking
- quality-metrics — quality measurement
- uat-coordination — user acceptance testing
- performance-testing — performance validation

---
*Testing Coordination — organizing effective testing to ensure product quality*
