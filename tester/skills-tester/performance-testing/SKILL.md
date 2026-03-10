---
name: performance-testing
description: Load testing, stress testing, scalability testing using JMeter, Gatling. Use when measuring performance, identifying bottlenecks, testing system limits.
---

# Performance Testing

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for performing performance testing including load testing, stress testing, endurance testing, and scalability testing. Designed for measuring system performance, identifying bottlenecks, and validating system behavior under various load conditions using tools like JMeter and Gatling.

## When to Use

Use this skill:
- When measuring application performance metrics
- For load testing web applications
- When conducting stress testing
- For endurance testing to find memory leaks
- When validating scalability requirements
- During performance tuning exercises
- Before major releases

## Functions

### Performance Testing Types

Different types of performance testing:

```markdown
## Performance Test Types

| Type | Purpose | Load Profile | Duration |
|------|---------|--------------|----------|
| Load Testing | Normal expected load | Ramp up to target | 1-2 hours |
| Stress Testing | Beyond breaking point | Beyond capacity | 30-60 min |
| Endurance Testing | Prolonged operation | Normal load | 8-24 hours |
| Spike Testing | Sudden load changes | Sharp increases | 10-30 min |
| Scalability Testing | Scaling behavior | Increasing load | 2-4 hours |

### Key Metrics
- **Response Time** — time to process request
- **Throughput** — requests per second
- **Error Rate** — percentage of failed requests
- **Resource Utilization** — CPU, Memory, Disk, Network
- **Concurrent Users** — number of active users
```

### JMeter Setup and Configuration

Apache JMeter configuration:

```xml
<!-- jmeter.properties -->
# Thread Group Configuration
thread_group.num_threads=100
thread_group.ramp_time=60
thread_group.duration=3600

# HTTP Request Defaults
http.request.timeout=30000
http.response.timeout=60000

# Result File Configuration
jmeter.save.saveservice.output_format=csv
jmeter.save.saveservice.response_data=true
jmeter.save.saveservice.samplerData=true
```

### JMeter Test Plan

```xml
<?xml version="1.0" encoding="UTF-8"?>
<testPlan version="1.4" properties="5.0" jmeter="5.5">
  <hashTree>
    <!-- Thread Group -->
    <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup">
      <stringProp name="ThreadGroup.num_threads">100</stringProp>
      <stringProp name="ThreadGroup.ramp_time">60</stringProp>
      <stringProp name="ThreadGroup.duration">3600</stringProp>
      <boolProp name="ThreadGroup.scheduler">true</boolProp>
    </ThreadGroup>
    <hashTree>
      <!-- HTTP Request -->
      <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy">
        <stringProp name="HTTPSampler.domain">api.example.com</stringProp>
        <stringProp name="HTTPSampler.path">/users</stringProp>
        <stringProp name="HTTPSampler.method">GET</stringProp>
        <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
      </HTTPSamplerProxy>
      <hashTree>
        <!-- Response Assertion -->
        <ResponseAssertion guiclass="ResponseAssertionGui" testclass="ResponseAssertion">
          <collectionProp name="Asserion.test_strings">
            <stringProp name="49586">200</stringProp>
          </collectionProp>
        </ResponseAssertion>
      </hashTree>
    </hashTree>
  </hashTree>
</testPlan>
```

### JMeter Test Script (GUI Steps)

```markdown
## Creating JMeter Test Plan

### 1. Thread Group Configuration
- Number of Threads: 100
- Ramp-up Period: 60 seconds
- Loop Count: Forever
- Duration: 3600 seconds

### 2. HTTP Request Defaults
- Server Name: api.example.com
- Port: 443
- Protocol: https

### 3. Adding Requests
- GET /api/users - Fetch user list
- GET /api/users/{id} - Fetch user details
- POST /api/users - Create user
- PUT /api/users/{id} - Update user
- DELETE /api/users/{id} - Delete user

### 4. Adding Assertions
- Response Code: 200 OK
- Response Time: < 2000ms
- JSON Path: $.success == true

### 5. Listeners
- View Results Tree
- Summary Report
- Aggregate Report
- Response Time Graph
```

### Gatling

Scala-based load testing:

```scala
// src/test/scala/simulations/BasicSimulation.scala
package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class BasicSimulation extends Simulation {

  val httpProtocol = http
    .baseUrl("https://api.example.com")
    .acceptHeader("application/json")
    .contentTypeHeader("application/json")

  val createUserRequest = """
    {
      "name": "Test User",
      "email": "test${random}@example.com",
      "age": 30
    }
  """

  val scn = scenario("API Load Test")
    // Get all users
    .exec(http("Get Users")
      .get("/users")
      .check(status.is(200))
      .check(responseTimeInMillis.lte(2000)))
    
    // Create user
    .exec(http("Create User")
      .post("/users")
      .header("Content-Type", "application/json")
      .body(StringBody(createUserRequest))
      .check(status.is(201))
      .check(jsonPath("$.id").saveAs("userId")))
    
    // Get created user
    .exec(http("Get User by ID")
      .get("/users/#{userId}")
      .check(status.is(200)))

  setUp(
    scn.inject(
      rampUsers(100).during(60.seconds),
      constantUsersPerSec(10).during(300.seconds)
    )
  ).protocols(httpProtocol)
   .assertions(
     global.responseTime.percentile3.lt(2000),
     global.successfulRequests.percent.gt(99)
   )
}
```

### Gatling Configuration

```scala
// src/test/scala/simulations/LoadSimulation.scala
package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._

class LoadSimulation extends Simulation {

  val httpProtocol = http
    .baseUrl("https://api.example.com")
    .acceptHeader("application/json")
    .userAgentHeader("Gatling/3.9")

  val feeder = csv("test-data/users.csv").random

  val scenario1 = scenario("User Journey")
    .feed(feeder)
    .exec(http("Home Page")
      .get("/")
      .check(status.is(200)))
    .pause(2)
    .exec(http("Login")
      .post("/auth/login")
      .formParam("username", "#{username}")
      .formParam("password", "#{password}")
      .check(status.is(200)))
    .pause(1)
    .exec(http("Dashboard")
      .get("/dashboard")
      .check(status.is(200)))

  val scenario2 = scenario("API Test")
    .exec(http("Get Data")
      .get("/api/data")
      .check(status.is(200)))

  setUp(
    scenario1.inject(
      rampUsers(50).during(60),
      constantUsersPerSec(5).during(300)
    ),
    scenario2.inject(
      rampUsers(100).during(120)
    )
  ).protocols(httpProtocol)
   .maxDuration(600)
   .assertions(
     global.responseTime.percentile3.lt(3000),
     global.successfulRequests.percent.gt(95)
   )
}
```

### Performance Test Scenarios

```markdown
## Performance Test Scenarios

### Scenario 1: Normal Load
| Metric | Value |
|--------|-------|
| Concurrent Users | 100 |
| Ramp-up Time | 60 seconds |
| Test Duration | 1 hour |
| Think Time | 3-5 seconds |

### Scenario 2: Peak Load
| Metric | Value |
|--------|-------|
| Concurrent Users | 500 |
| Ramp-up Time | 120 seconds |
| Test Duration | 30 minutes |
| Think Time | 1-2 seconds |

### Scenario 3: Stress Test
| Metric | Value |
|--------|-------|
| Initial Users | 100 |
| Ramp-up Rate | +50 users/min |
| Maximum Users | 1000 |
| Test Until | System failure |

### Scenario 4: Endurance Test
| Metric | Value |
|--------|-------|
| Concurrent Users | 200 |
| Test Duration | 24 hours |
| Think Time | 5 seconds |
| Monitoring | Continuous |
```

## Usage Examples

### Example 1: JMeter Load Test

```markdown
## JMeter Load Test: E-Commerce API

### Test Plan
- **Target:** E-Commerce REST API
- **Load Profile:** 500 concurrent users
- **Duration:** 1 hour
- **Ramp-up:** 5 minutes

### API Endpoints Tested
| Endpoint | Method | Weight |
|----------|--------|--------|
| GET /products | 40% | 200 users |
| GET /products/{id} | 25% | 125 users |
| POST /orders | 20% | 100 users |
| GET /user/profile | 15% | 75 users |

### Acceptance Criteria
- Response time < 2s (95th percentile)
- Error rate < 1%
- Throughput > 100 RPS
- CPU utilization < 80%

### Results
- Total Requests: 360,000
- Average Response Time: 1.2s
- 95th Percentile: 1.8s
- Error Rate: 0.3%
- Peak Throughput: 150 RPS
```

### Example 2: Gatling Stress Test

```scala
// Stress test simulation
class StressSimulation extends Simulation {

  val httpProtocol = http
    .baseUrl("https://api.example.com")

  val searchFeeder = Iterator.continually(Map(
    "query" -> s"search_${scala.util.Random.nextInt(1000)}"
  ))

  val scn = scenario("Stress Test")
    .feed(searchFeeder)
    .exec(http("Search")
      .get("/search?q=#{query}")
      .check(status.is(200)))
    .pause(100.millis)

  setUp(
    scn.inject(
      incrementUsersPerSec(5)
        .times(10)
        .eachLevelLasting(30.seconds)
        .startingFrom(10)
    )
  ).protocols(httpProtocol)
   .assertions(
     global.responseTime.percentile3.lt(5000),
     global.successfulRequests.percent.gt(90)
   )
}
```

## Document Templates

### Performance Test Report

```markdown
## Performance Test Report

**Date:** {Date}
**Application:** {App Name vX.X}
**Environment:** {Staging/Production-like}

### Executive Summary
{Pass/Fail} — System {passed/failed} performance requirements

### Test Configuration
| Parameter | Value |
|-----------|-------|
| Test Type | {Load/Stress/Endurance} |
| Duration | {X hours} |
| Concurrent Users | {N} |
| Total Requests | {N} |

### Performance Metrics
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Response Time (avg) | < 2s | 1.5s | ✅ Pass |
| Response Time (95th) | < 3s | 2.8s | ✅ Pass |
| Throughput | > 100 RPS | 150 RPS | ✅ Pass |
| Error Rate | < 1% | 0.2% | ✅ Pass |

### Resource Utilization
| Resource | Usage | Threshold |
|----------|-------|-----------|
| CPU | 65% | 80% |
| Memory | 72% | 85% |
| Disk I/O | 45% | 70% |
| Network | 55% | 80% |

### Findings
- {Finding 1}
- {Finding 2}

### Recommendations
1. {Recommendation 1}
2. {Recommendation 2}
```

### Performance Test Plan

```markdown
## Performance Test Plan

### Objectives
1. Validate response time requirements
2. Determine system capacity
3. Identify performance bottlenecks

### Scope
- **In Scope:** API endpoints, Database queries
- **Out Scope:** Third-party integrations

### Test Scenarios
| Scenario | Type | Users | Duration |
|----------|------|-------|----------|
| Login Flow | Load | 100 | 1 hour |
| Search | Load | 200 | 1 hour |
| Checkout | Stress | 500 | 30 min |

### Success Criteria
- Response time P95 < 3s
- Error rate < 1%
- No system failures
```

## Best Practices

### Test Design

1. **Realistic scenarios** — use real user behavior patterns
2. **Proper warm-up** — always include warm-up phase
3. **Monitor comprehensively** — track all resources
4. **Repeat tests** — verify consistency
5. **Document everything** — capture all parameters

### Execution

1. **Isolate environment** — test in dedicated environment
2. **Control variables** — minimize external factors
3. **Incremental load** — start low, increase gradually
4. **Monitor continuously** — watch metrics in real-time
5. **Capture evidence** — save all logs and reports

### Analysis

1. **Compare baselines** — measure against known good state
2. **Focus on bottlenecks** — identify root causes
3. **Trend analysis** — compare historical data
4. **Correlate metrics** — connect system and app metrics
5. **Provide recommendations** — actionable improvements

## Related Skills

- test-automation-frameworks — automated performance tests
- test-case-design — performance test case design
- security-testing — security under load
- mobile-testing — mobile performance testing
- test-data-management — performance test data

---
*Performance Testing — ensuring speed, scalability, and stability under load
