---
name: adr-template
description: Creating Architecture Decision Record (ADR) for documenting project architectural decisions. Used when selecting technologies, design patterns, and architectural approaches.
---

# Architecture Decision Record (ADR)

## Purpose

**Architecture Decision Record (ADR)** is a document that captures important architectural decisions for a project. ADR helps to:
- Document the context and rationale for decisions
- Ensure transparency for the team and stakeholders
- Preserve the history of decisions for future reference
- Simplify onboarding of new team members

## When to Use

Use ADR when making the following decisions:
- Technology stack selection (languages, frameworks, databases)
- Architectural patterns (microservices, monolith, event-driven)
- Integration solutions (API, message brokers, synchronization)
- Infrastructure solutions (cloud providers, containerization)
- Security and authentication

## ADR Structure

### 1. Title

```markdown
# ADR-{number}: {Brief description of the decision}

**Date:** DD-MM-YYYY
**Status:** Proposed | Accepted | Deprecated | Superseded
**Author:** Author name
**Project Context:** Project name or epic
```

### 2. Context

Describe the problem or situation that requires a decision:
- What business or technical problem are we facing?
- What requirements influence the decision?
- What constraints exist?

### 3. Decision

Clearly state the decision made:
- What was specifically chosen?
- Why does this solution fit?
- Which components are involved?

### 4. Consequences

Describe the outcomes of the decision:

**Positive:**
- Benefits of the solution

**Negative:**
- Drawbacks or risks
- What needs to be considered during implementation

### 5. Alternatives

Considered alternatives and reasons for rejection:
- Alternative 1: [Description] → Reason for rejection
- Alternative 2: [Description] → Reason for rejection

---

## ADR Example: Technology Stack Selection

### Title

```markdown
# ADR-001: Technology Stack Selection for Web Application

**Date:** 15-02-2026
**Status:** Accepted
**Author:** System Analyst
**Project Context:** Corporate Management System
```

### Context

It is necessary to determine the technology stack for a new corporate web application taking into account the following requirements:

- High performance and scalability
- Support for asynchronous operations
- Compliance with data localization requirements (Russia)
- Modern ecosystem and active community
- Ability to use both for API and batch processing

### Decision

#### Backend

| Technology | Version | Rationale |
|------------|---------|------------|
| **Python** | 3.12+ | Modern version with improved typing and performance |
| **FastAPI** | latest | Async framework with automatic OpenAPI generation |
| **PostgreSQL** | 15+ | Reliable RDBMS with JSONB support and extensions (pgvector) |
| **SQLAlchemy** | 2.0+ | Async ORM with powerful capabilities |
| **Pydantic** | latest | Data validation and strict typing |
| **Valkey** | latest | Redis-compatible solution for caching and sessions |
| **RabbitMQ** | latest | Message broker for async architecture |

#### Authentication

| Library | Purpose |
|---------|---------|
| **python-jose** | Working with JWT tokens |
| **httpx** | Interaction with OAuth providers |

#### Frontend

| Technology | Rationale |
|------------|-----------|
| **React** | Industry standard for interactive interfaces |
| **Vite** | Fast build and hot reload |
| **Tailwind CSS** | Utility-first approach for custom interfaces |

#### DevOps and Infrastructure

| Technology | Rationale |
|------------|-----------|
| **Docker** | Containerization for environment consistency |
| **HashiCorp Vault** | Secrets management and encryption |
| **Selectel / Yandex Cloud** | Russian cloud providers (data localization) |
| **Poetry** | Python dependency management |
| **Pytest** | Python application testing |

#### Notifications

| Channel | Purpose |
|---------|---------|
| **Email** | Formal and non-urgent notifications |
| **Telegram** | Real-time operational notifications (python-telegram-bot) |

### Consequences

**Positive:**
- High performance thanks to async architecture
- Automatic API documentation via OpenAPI/Swagger
- Data storage flexibility (relational + JSONB)
- Professional secrets management
- Compliance with data localization requirements

**Negative:**
- Learning curve for the team (if no experience with Python/FastAPI)
- Need to monitor Redis solution performance
- Costs for Russian cloud providers

### Alternatives

1. **Node.js + Express + MongoDB**
   - Reason for rejection: MongoDB does not provide the same level of reliability for transactional data as PostgreSQL

2. **Java Spring Boot + PostgreSQL**
   - Reason for rejection: Higher resource requirements, longer development time

3. **Go + PostgreSQL**
   - Reason for rejection: Less developed ecosystem for rapid API development compared to Python/FastAPI

---

## ADR Template (Markdown)

```markdown
# ADR-{number}: {Title}

**Date:** DD-MM-YYYY
**Status:** Proposed | Accepted | Deprecated | Superseded
**Author:** Author name
**Project Context:** Project name

## Context

[Description of the problem or situation that requires a decision]

## Decision

[Clear description of the decision made]

### Technologies/Components

| Component | Version/Details | Rationale |
|-----------|----------------|------------|
| ... | ... | ... |

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Drawback 1]
- [Drawback 2]

## Alternatives

1. **Alternative 1**: [Description]
   - Reason for rejection: [Rationale]

2. **Alternative 2**: [Description]
   - Reason for rejection: [Rationale]

## Related Documents

- Link to SRS
- Link to architectural diagram
- Link to requirements
```

## Best Practices

1. **Numbering**: Use sequential ADR numbering (ADR-001, ADR-002...)
2. **Status**: Update status when the decision changes
3. **Conciseness**: ADR should be brief (1-2 pages)
4. **References**: Link ADR to requirements and other documents
5. **Review**: Conduct ADR review before making a decision
6. **Storage**: Store ADR in the repository alongside code

## Integration with Other Skills

- **[c4-architecture](/system_analyst/skills-system-analyst/c4-architecture/SKILL.md)**: C4 diagrams complement ADR with visualization
- **[srs-specification](/system_analyst/skills-system-analyst/srs-specification/SKILL.md)**: SRS contains requirements that ADR relies on
- **[api-design](/system_analyst/skills-system-analyst/api-design/SKILL.md)**: API design extends architectural decisions to the interface level
