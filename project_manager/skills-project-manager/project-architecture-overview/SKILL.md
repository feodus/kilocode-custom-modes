---
name: project-architecture-overview
description: Project architecture overview from management perspective: components, dependencies, integrations
---

# Project Architecture Overview

> **Meta:** v1.0.0 | 22-02-2026

## Purpose

Skill for understanding and managing architectural aspects of the project from project management perspective. Includes analyzing system components, their interactions, dependencies, and integrations, enabling effective planning and management of the development project.

## When to Use

Use this skill:
- When planning a project to understand architecture complexity
- When determining dependencies between components
- When managing architecture-related risks
- When planning integration work
- When coordinating work of teams working on different components

## Functions

### Component Mapping
System component analysis:
- Identifying main modules
- Defining component boundaries
- Understanding component responsibilities
- Determining component owners
- Analyzing inter-component interactions

### Dependency Analysis
Dependency analysis:
- Internal dependencies between components
- External dependencies (libraries, services)
- Infrastructure dependencies
- Temporal dependencies
- Technology dependencies

### Integration Points
Defining integration points:
- APIs and interfaces
- Communication protocols
- Data formats
- Temporal aspects of integration
- Synchronization requirements

### Architecture Complexity Assessment
Assessing architecture complexity:
- Cognitive load assessment
- Complexity risk assessment
- Scalability assessment
- Support and maintenance assessment
- Integration risk assessment

## Integration with System Analyst

- Receiving architectural decisions from System Analyst
- Clarifying integration requirements
- Analyzing impact of architectural decisions on the project
- Accounting for technology recommendations
- Understanding architectural constraints

## Usage Examples

### Example 1: Architecture Overview for Web Application
System components:
- Frontend (React): responsible for user interface
- Backend API (Node.js): business logic processing
- Database (PostgreSQL): data storage
- Authentication service (JWT): access management
- File storage (AWS S3): file storage

Dependencies:
- Frontend depends on Backend API
- Backend depends on DB and authentication service
- Authentication service integrates with Backend

Integrations:
- Frontend ↔ Backend: REST API
- Backend ↔ DB: SQL
- Backend ↔ Authentication: JWT
- Backend ↔ S3: AWS SDK

### Example 2: Architecture Overview for Microservices Application
System components:
- Service Discovery (Consul): service registration and discovery
- API Gateway (Kong): request routing
- User Service: user management
- Order Service: order management
- Payment Service: payment processing
- Notification Service: notifications

Dependencies:
- API Gateway depends on Service Discovery
- Order Service depends on User Service and Payment Service
- Notification Service depends on other services

Integrations:
- Synchronous calls via REST
- Asynchronous calls via Message Queue
- Event-driven architecture

## Related Skills

- development-planning
- risk-assessment
- quality-planning
- methodology-selection

---
