---
name: api-design
description: Designing RESTful API and OpenAPI specifications: creating RESTful endpoints using REST principles, designing OpenAPI 3.0 specifications (Paths, Schemas, Parameters, Responses), defining authentication and authorization (OAuth 2.0, JWT, API Keys), API versioning, pagination, error handling, URL structure design and HTTP status codes
---

# API Design

> **Meta:** v1.0.0 | 23-02-2026

## Purpose

Skill for designing RESTful APIs and creating OpenAPI/Swagger specifications. Includes defining REST architecture principles, designing endpoints, describing data schemas and parameters, configuring authentication and authorization, implementing API versioning, pagination, and error handling. The skill provides complete API specification for implementation in Universal Coding Agent.

## When to Use

Use this skill:
- When designing a new RESTful API
- For creating OpenAPI/Swagger specifications
- When defining endpoint and resource structure
- For configuring authentication (OAuth 2.0, JWT, API Keys)
- When designing API versioning
- For implementing pagination and filtering
- When defining error formats and status codes
- During system integration design phase
- When documenting existing APIs

## Functions

### REST Principles

Principles of RESTful architecture:

**Resources:**

| Concept | Description | Example |
|---------|-------------|---------|
| Resource | Entity accessible via API | `/users`, `/orders`, `/products` |
| Collection | Set of resources | `/users`, `/orders` |
| Instance | Specific resource | `/users/123`, `/orders/456` |
| Sub-resource | Nested resource | `/users/123/orders` |

**Resource Naming:**

- Use plural nouns: `/users` not `/user`
- Use snake_case for URLs: `/user-profiles` not `/userProfiles`
- Avoid verbs in URLs: use HTTP methods
- Use hierarchy for relationships: `/users/123/orders`

**HTTP Methods:**

| Method | Semantics | Example |
|--------|-----------|---------|
| **GET** | Retrieve resource | `GET /users` — list, `GET /users/123` — single |
| **POST** | Create resource | `POST /users` — create user |
| **PUT** | Full resource replacement | `PUT /users/123` — replace data |
| **PATCH** | Partial update | `PATCH /users/123` — update part |
| **DELETE** | Remove resource | `DELETE /users/123` — delete user |

**HTTP Status Codes:**

| Code | Category | Description |
|------|----------|-------------|
| **2xx Success** | Successful operations |
| 200 | OK | Successful GET/PUT/PATCH |
| 201 | Created | Resource created (POST) |
| 204 | No Content | Successful deletion (DELETE) |
| **3xx Redirection** | Redirection |
| 304 | Not Modified | Cached data |
| **4xx Client Error** | Client errors |
| 400 | Bad Request | Invalid syntax |
| 401 | Unauthorized | Authentication required |
| 403 | Forbidden | No access |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Data conflict |
| 422 | Unprocessable Entity | Validation error |
| 429 | Too Many Requests | Rate limit exceeded |
| **5xx Server Error** | Server errors |
| 500 | Internal Server Error | Internal error |
| 503 | Service Unavailable | Service unavailable |

**HATEOAS (Hypermedia as the Engine of Application State):**

Principle of including links in API responses for navigation:

```json
{
  "id": 123,
  "name": "John Doe",
  "_links": {
    "self": "/users/123",
    "orders": "/users/123/orders",
    "profile": "/profiles/123"
  }
}
```

**Richardson Maturity Model:**

| Level | Name | Description |
|-------|------|-------------|
| 0 | Swamp of POX | One endpoint, everything in POST |
| 1 | Resources | Division into resources |
| 2 | HTTP Verbs | Use of HTTP methods |
| 3 | Hypermedia Controls | HATEOAS |

### OpenAPI Specification

Designing OpenAPI 3.0 specifications:

**OpenAPI Document Structure:**

```yaml
openapi: 3.0.0
info:
  title: API Name
  version: 1.0.0
  description: API Description
  contact:
    name: API Support
    email: support@example.com
servers:
  - url: https://api.example.com/v1
    description: Production server
  - url: https://staging.example.com/v1
    description: Staging server
paths:
  /resource:
    get:
      summary: Get resources
      operationId: getResources
      tags:
        - Resources
      parameters:
        - $ref: '#/components/parameters/Page'
        - $ref: '#/components/parameters/Limit'
      responses:
        '200':
          $ref: '#/components/responses/ResourceList'
components:
  schemas:
    Resource:
      $ref: '#/components/schemas/Resource'
  parameters:
    Page:
      $ref: '#/components/parameters/Page'
  responses:
    ResourceList:
      $ref: '#/components/responses/ResourceList'
```

**Paths and Operations:**

```yaml
paths:
  /users:
    get:
      summary: Get user list
      description: Returns list of all users with pagination support
      operationId: getUsers
      tags:
        - Users
      parameters:
        - name: page
          in: query
          description: Page number
          schema:
            type: integer
            default: 1
            minimum: 1
        - name: limit
          in: query
          description: Number of items per page
          schema:
            type: integer
            default: 20
            maximum: 100
        - name: sort
          in: query
          description: Field to sort by
          schema:
            type: string
            enum: [name, created_at, email]
        - name: order
          in: query
          description: Sort direction
          schema:
            type: string
            enum: [asc, desc]
            default: asc
        - name: status
          in: query
          description: Status filter
          schema:
            type: string
            enum: [active, inactive, suspended]
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '500':
          $ref: '#/components/responses/InternalServerError'
    
    post:
      summary: Create user
      operationId: createUser
      tags:
        - Users
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UserCreate'
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '400':
          $ref: '#/components/responses/BadRequest'
        '422':
          $ref: '#/components/responses/ValidationError'

  /users/{userId}:
    get:
      summary: Get user by ID
      operationId: getUserById
      tags:
        - Users
      parameters:
        - name: userId
          in: path
          required: true
          description: User ID
          schema:
            type: integer
            format: int64
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'

    put:
      summary: Full user update
      operationId: updateUser
      tags:
        - Users
      parameters:
        - name: userId
          in: path
          required: true
          schema:
            type: integer
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UserUpdate'
      responses:
        '200':
          description: User updated
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'

    patch:
      summary: Partial user update
      operationId: patchUser
      tags:
        - Users
      parameters:
        - name: userId
          in: path
          required: true
          schema:
            type: integer
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UserPatch'
      responses:
        '200':
          description: User updated
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'

    delete:
      summary: Delete user
      operationId: deleteUser
      tags:
        - Users
      parameters:
        - name: userId
          in: path
          required: true
          schema:
            type: integer
      responses:
        '204':
          description: User deleted
        '404':
          $ref: '#/components/responses/NotFound'
```

**Schemas (Data Models):**

```yaml
components:
  schemas:
    # Base schemas
    User:
      type: object
      description: System user
      required:
        - id
        - email
        - created_at
      properties:
        id:
          type: integer
          format: int64
          description: Unique identifier
        email:
          type: string
          format: email
          description: User email
        name:
          type: string
          description: User name
        status:
          type: string
          enum: [active, inactive, suspended]
          default: active
        created_at:
          type: string
          format: date-time
          description: Creation date
        updated_at:
          type: string
          format: date-time
          description: Update date
    
    UserCreate:
      type: object
      required:
        - email
        - password
        - name
      properties:
        email:
          type: string
          format: email
        password:
          type: string
          format: password
          minLength: 8
        name:
          type: string
          minLength: 1
        role:
          type: string
          enum: [user, admin, moderator]
          default: user
    
    UserUpdate:
      allOf:
        - $ref: '#/components/schemas/UserCreate'
        - type: object
          properties:
            id:
              type: integer
    
    UserPatch:
      type: object
      properties:
        email:
          type: string
          format: email
        name:
          type: string
        status:
          type: string
          enum: [active, inactive, suspended]
    
    UserList:
      type: object
      properties:
        data:
          type: array
          items:
            $ref: '#/components/schemas/User'
        meta:
          $ref: '#/components/schemas/PaginationMeta'
        links:
          $ref: '#/components/schemas/PaginationLinks'
    
    PaginationMeta:
      type: object
      properties:
        page:
          type: integer
        limit:
          type: integer
        total:
          type: integer
          format: int64
        total_pages:
          type: integer
    
    PaginationLinks:
      type: object
      properties:
        self:
          type: string
          format: uri
        first:
          type: string
          format: uri
        prev:
          type: string
          format: uri
        next:
          type: string
          format: uri
        last:
          type: string
          format: uri
    
    Error:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: string
          description: Error code
        message:
          type: string
          description: Error message
        details:
          type: array
          items:
            $ref: '#/components/schemas/ValidationError'
        trace_id:
          type: string
          description: Logging ID
    
    ValidationError:
      type: object
      properties:
        field:
          type: string
          description: Field with error
        message:
          type: string
          description: Error message
        code:
          type: string
          description: Validation error code

  parameters:
    Page:
      name: page
      in: query
      description: Page number
      schema:
        type: integer
        default: 1
        minimum: 1
    
    Limit:
      name: limit
      in: query
      description: Number of items
      schema:
        type: integer
        default: 20
        maximum: 100

  responses:
    BadRequest:
      description: Invalid request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            code: "BAD_REQUEST"
            message: "Invalid request parameters"
            trace_id: "req-abc123"
    
    Unauthorized:
      description: Authentication required
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            code: "UNAUTHORIZED"
            message: "Authentication required"
    
    Forbidden:
      description: Access denied
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    
    NotFound:
      description: Resource not found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            code: "NOT_FOUND"
            message: "User with id 123 not found"
    
    ValidationError:
      description: Validation error
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            code: "VALIDATION_ERROR"
            message: "Validation failed"
            details:
              - field: "email"
                message: "Invalid email format"
                code: "INVALID_FORMAT"
    
    InternalServerError:
      description: Internal server error
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            code: "INTERNAL_ERROR"
            message: "An unexpected error occurred"
            trace_id: "err-xyz789"
```

### Authentication/Authorization

API security configuration:

**Security Schemes (OpenAPI):**

```yaml
components:
  securitySchemes:
    # OAuth 2.0 with Password Flow
    OAuth2Password:
      type: oauth2
      flows:
        password:
          tokenUrl: /auth/login
          scopes:
            read: Read access
            write: Write access
            admin: Admin access
    
    # OAuth 2.0 with Authorization Code Flow
    OAuth2AuthorizationCode:
      type: oauth2
      flows:
        authorizationCode:
          authorizationUrl: /auth/authorize
          tokenUrl: /auth/token
          scopes:
            read: Read access
            write: Write access
    
    # API Key in header
    ApiKeyHeader:
      type: apiKey
      in: header
      name: X-API-Key
      description: API key for authentication
    
    # API Key in query parameter
    ApiKeyQuery:
      type: apiKey
      in: query
      name: api_key
      description: API key in request parameter
    
    # Bearer Token (JWT)
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      description: JWT access token

# Security application
security:
  - BearerAuth: []
  - OAuth2Password:
      - read
      - write
  - ApiKeyHeader: []
```

**OAuth 2.0 Flows:**

| Flow | Usage | Application |
|------|-------|--------------|
| **Authorization Code** | Server-side apps | Web applications with backend |
| **Password** | Trusted apps | Mobile apps (not recommended) |
| **Client Credentials** | Machine-to-machine | Services and daemons |
| **Implicit** | Legacy | Not recommended (use PKCE) |

**JWT Token Example:**

```json
{
  "header": {
    "alg": "RS256",
    "typ": "JWT"
  },
  "payload": {
    "sub": "1234567890",
    "name": "John Doe",
    "email": "john@example.com",
    "roles": ["user", "admin"],
    "scope": "read write",
    "iat": 1516239022,
    "exp": 1516242622
  }
}
```

**Scopes and Permissions:**

```yaml
# Scopes definition
components:
  securitySchemes:
    OAuth2Scopes:
      type: oauth2
      flows:
        authorizationCode:
          authorizationUrl: /auth/authorize
          tokenUrl: /auth/token
          scopes:
            # Users
            users:read: Read users
            users:write: Create/update users
            users:delete: Delete users
            # Orders
            orders:read: Read orders
            orders:write: Create orders
            # Admin
            admin:full: Full administrative access
```

**Rate Limiting:**

```yaml
paths:
  /users:
    get:
      summary: Get user list
      # Rate limiting via headers
      x-rate-limit:
        limit: 1000
        period: 3600  # 1000 requests per hour
      x-rate-limit-tier: premium  # Rate plan tier
      responses:
        '200':
          description: Success
        '429':
          description: Too Many Requests
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
              example:
                code: "RATE_LIMIT_EXCEEDED"
                message: "Rate limit exceeded. Try again later."
                details:
                  retry_after: 3600
```

### Versioning

API versioning strategies:

| Strategy | Example | Advantages | Disadvantages |
|----------|---------|------------|---------------|
| **URL Path** | `/v1/users` | Simplicity, explicitness | URL pollution |
| **Query Param** | `/users?version=1` | Clean URLs | Caching |
| **Header** | `Accept: application/vnd.api.v1+json` | Clean URLs | Complexity |
| **Content Negotiation** | `Accept: application/vnd.example.v1+json` | Flexibility | Documentation |

**Recommendation:** Use URL Path versioning (`/v1/`, `/v2/`)

**Versioning Practices:**

```yaml
# OpenAPI with versioning
servers:
  - url: https://api.example.com/v1
    description: Version 1 (current)
  - url: https://api.example.com/v2
    description: Version 2 (beta)
  - url: https://api.example.com/v3
    description: Version 3 (development)

paths:
  /v1/users:
    get:
      summary: Get users (v1)
      deprecated: true
      description: |
        ## Deprecated
        Use `/v2/users` for new integrations.
        This version will be removed on 31.12.2026.
      responses:
        '200':
          description: Success

  /v2/users:
    get:
      summary: Get users (v2)
      description: |
        ## Changes from v1
        - Added `profile_url` field
        - Changed date format to ISO 8601
      responses:
        '200':
          description: Success
```

**Deprecation Strategy:**

```yaml
# Deprecation via headers
components:
  headers:
    Deprecation:
      description: |
        URL of the substituted by a more recent
        stable resource that's supported.
      schema:
        type: string
        format: uri
    Sunset:
      description: |
        Indicates when the associated response
        should no longer be used.
      schema:
        type: string
        format: date-time

# Usage example
paths:
  /users:
    get:
      summary: Get users
      deprecated: true
      responses:
        '200':
          description: Success
          headers:
            Deprecation:
              $ref: '#/components/headers/Deprecation'
            Sunset:
              $ref: '#/components/headers/Sunset'
          content:
            application/json:
              schema:
                type: object
```

### Pagination

Implementing pagination:

**Offset-based Pagination:**

```yaml
# Parameters
parameters:
  Offset:
    name: offset
    in: query
    description: Offset (record number)
    schema:
      type: integer
      default: 0
      minimum: 0
  
  Limit:
    name: limit
    in: query
    description: Number of records
    schema:
      type: integer
      default: 20
      maximum: 100
      minimum: 1

# Response
responses:
  UserList:
    description: User list
    content:
      application/json:
        schema:
          type: object
          properties:
            data:
              type: array
              items:
                $ref: '#/components/schemas/User'
            meta:
              type: object
              properties:
                total:
                  type: integer
                offset:
                  type: integer
                limit:
                  type: integer
                has_more:
                  type: boolean
```

**Cursor-based Pagination:**

```yaml
parameters:
  Cursor:
    name: cursor
    in: query
    description: Cursor for next page
    schema:
      type: string

# Response
responses:
  UserListCursor:
    description: User list
    content:
      application/json:
        schema:
          type: object
          properties:
            data:
              type: array
              items:
                $ref: '#/components/schemas/User'
            pagination:
              type: object
              properties:
                cursor:
                  type: string
                  description: Cursor for next page
                has_next:
                  type: boolean
                has_prev:
                  type: boolean
```

**Comparison:**

| Characteristic | Offset-based | Cursor-based |
|----------------|--------------|--------------|
| Simplicity | ✅ Simple | ⚠️ More complex |
| Page URL | ✅ `/page/2` | ⚠️ None |
| Skips on insert | ❌ Yes | ✅ No |
| Performance | ❌ Slow for large offsets | ✅ Fast |
| Caching | ✅ Good | ❌ Poor |

**Recommendation:**
- For small datasets use offset-based
- For large datasets or real-time data use cursor-based

### Error Handling

Standardized error format:

**Error Structure:**

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format",
        "code": "INVALID_FORMAT",
        "value": "invalid-email"
      }
    ],
    "trace_id": "req-abc123-xyz789",
    "timestamp": "2026-02-23T12:00:00Z",
    "documentation_url": "https://api.example.com/docs/errors#validation"
  }
}
```

**Error Types:**

```yaml
components:
  schemas:
    ErrorCode:
      type: object
      description: API error codes
      enum:
        # 4xx Client Errors
        - BAD_REQUEST
        - VALIDATION_ERROR
        - UNAUTHORIZED
        - FORBIDDEN
        - NOT_FOUND
        - CONFLICT
        - RATE_LIMIT_EXCEEDED
        - INVALID_ACCEPT_HEADER
        # 5xx Server Errors
        - INTERNAL_ERROR
        - SERVICE_UNAVAILABLE
        - EXTERNAL_SERVICE_ERROR
```

**Retry Strategy:**

```json
{
  "error": {
    "code": "SERVICE_UNAVAILABLE",
    "message": "Service temporarily unavailable",
    "retry_after": 30,
    "trace_id": "req-abc123"
  }
}
```

**Logging:**

- Always include `trace_id` for tracing
- Use unified format for all errors
- Document all possible error codes

## Integration with Project Manager

### Data for Project Manager

Provides the following data for PM:

**Quantitative Metrics:**

| Metric | Description |
|--------|-------------|
| Number of endpoints | Total endpoints in API |
| Number of operations | Number of operations (GET, POST, PUT, PATCH, DELETE) |
| Number of schemas | Number of defined data models |
| API versions | Number of supported versions |

**API Complexity Estimation:**

| Complexity | Criteria | Time Estimate |
|------------|----------|----------------|
| **Simple** | 5-10 endpoints, CRUD operations, basic authentication | 16-32 hours |
| **Medium** | 15-30 endpoints, business logic, pagination, OAuth | 32-64 hours |
| **Complex** | 30+ endpoints, complex authorization, real-time, versioning | 64-120 hours |

**Security Requirements:**

| Requirement | Risk Level | Required Actions |
|-------------|-------------|-------------------|
| Authentication | Critical | OAuth 2.0 / JWT |
| Authorization | Critical | RBAC / Scopes |
| Rate Limiting | High | Request limiting |
| API Keys | Medium | For external integrations |
| Encryption | Critical | HTTPS + TLS 1.3 |

**Integration Risks:**

- Complexity of integration with external APIs
- Dependencies on third-party authentication services
- Versioning and compatibility
- SLA requirements for external services
- Error handling and timeout

### Interaction

- PM requests API specification for development time estimation
- PM receives data for resource planning
- PM uses metrics for task distribution
- SA validates API changes with PM

## Usage Examples

### Example 1: OpenAPI Specification for User Management API

```yaml
openapi: 3.0.0
info:
  title: User Management API
  version: 1.0.0
  description: API for managing system users
  contact:
    name: API Support
    email: support@example.com
  license:
    name: MIT
    url: https://opensource.org/licenses/MIT

servers:
  - url: https://api.example.com/v1
    description: Production server
  - url: https://staging.example.com/v1
    description: Staging server

security:
  - BearerAuth: []

tags:
  - name: Users
    description: User operations
  - name: Auth
    description: Authentication and authorization

paths:
  /auth/register:
    post:
      summary: Register new user
      operationId: registerUser
      tags:
        - Auth
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - email
                - password
                - name
              properties:
                email:
                  type: string
                  format: email
                password:
                  type: string
                  format: password
                  minLength: 8
                name:
                  type: string
      responses:
        '201':
          description: User successfully registered
          content:
            application/json:
              schema:
                type: object
                properties:
                  user:
                    $ref: '#/components/schemas/User'
                  access_token:
                    type: string
                  refresh_token:
                    type: string
        '400':
          $ref: '#/components/responses/ValidationError'
        '409':
          $ref: '#/components/responses/Conflict'

  /auth/login:
    post:
      summary: Login
      operationId: login
      tags:
        - Auth
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - email
                - password
              properties:
                email:
                  type: string
                  format: email
                password:
                  type: string
                  format: password
      responses:
        '200':
          description: Login successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  user:
                    $ref: '#/components/schemas/User'
                  access_token:
                    type: string
                  refresh_token:
                    type: string
                  expires_in:
                    type: integer
        '401':
          $ref: '#/components/responses/Unauthorized'

  /users:
    get:
      summary: Get user list
      operationId: getUsers
      tags:
        - Users
      parameters:
        - $ref: '#/components/parameters/Page'
        - $ref: '#/components/parameters/Limit'
        - name: status
          in: query
          schema:
            type: string
            enum: [active, inactive, suspended]
      responses:
        '200':
          description: User list
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'

    post:
      summary: Create user
      operationId: createUser
      tags:
        - Users
      security:
        - BearerAuth: []
        - OAuth2Password:
            - users:write
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UserCreate'
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '400':
          $ref: '#/components/responses/ValidationError'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'

  /users/{userId}:
    parameters:
      - name: userId
        in: path
        required: true
        schema:
          type: integer
          format: int64

    get:
      summary: Get user by ID
      operationId: getUserById
      tags:
        - Users
      responses:
        '200':
          description: User found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'

    patch:
      summary: Update user
      operationId: patchUser
      tags:
        - Users
      security:
        - BearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UserPatch'
      responses:
        '200':
          description: User updated
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'

    delete:
      summary: Delete user
      operationId: deleteUser
      tags:
        - Users
      security:
        - BearerAuth: []
        - OAuth2Password:
            - users:delete
      responses:
        '204':
          description: User deleted
        '404':
          $ref: '#/components/responses/NotFound'

components:
  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
    OAuth2Password:
      type: oauth2
      flows:
        password:
          tokenUrl: /auth/login
          scopes:
            users:read: Read users
            users:write: Create users
            users:delete: Delete users

  schemas:
    User:
      type: object
      required:
        - id
        - email
        - name
      properties:
        id:
          type: integer
          format: int64
        email:
          type: string
          format: email
        name:
          type: string
        status:
          type: string
          enum: [active, inactive, suspended]
        roles:
          type: array
          items:
            type: string
        created_at:
          type: string
          format: date-time

    UserCreate:
      type: object
      required:
        - email
        - password
        - name
      properties:
        email:
          type: string
          format: email
        password:
          type: string
          format: password
        name:
          type: string

    UserPatch:
      type: object
      properties:
        name:
          type: string
        status:
          type: string
          enum: [active, inactive, suspended]

    UserList:
      type: object
      properties:
        data:
          type: array
          items:
            $ref: '#/components/schemas/User'
        meta:
          type: object
          properties:
            total:
              type: integer
            page:
              type: integer
            limit:
              type: integer

  parameters:
    Page:
      name: page
      in: query
      schema:
        type: integer
        default: 1
    Limit:
      name: limit
      in: query
      schema:
        type: integer
        default: 20

  responses:
    ValidationError:
      description: Validation error
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    Unauthorized:
      description: Not authorized
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    Forbidden:
      description: Access denied
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    NotFound:
      description: Not found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    Conflict:
      description: Conflict
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'

  Error:
    type: object
    required:
      - code
      - message
    properties:
      code:
        type: string
      message:
        type: string
      details:
        type: array
        items:
          type: object
      trace_id:
        type: string
```

### Example 2: Pagination Implementation

**Cursor-based:**

```json
// GET /users?cursor=eyJpZCI6MTAwfQ&limit=20

{
  "data": [
    { "id": 101, "name": "User 101" },
    { "id": 102, "name": "User 102" }
  ],
  "pagination": {
    "cursor": "eyJpZCI6MTAyfQ",
    "has_next": true,
    "has_prev": false
  }
}
```

**Offset-based:**

```json
// GET /users?page=2&limit=20

{
  "data": [
    { "id": 21, "name": "User 21" },
    { "id": 22, "name": "User 22" }
  ],
  "meta": {
    "total": 1000,
    "page": 2,
    "limit": 20,
    "total_pages": 50,
    "has_next": true,
    "has_prev": true
  },
  "links": {
    "self": "/users?page=2&limit=20",
    "first": "/users?page=1&limit=20",
    "prev": "/users?page=1&limit=20",
    "next": "/users?page=3&limit=20",
    "last": "/users?page=50&limit=20"
  }
}
```

### Example 3: Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed for user creation",
    "details": [
      {
        "field": "email",
        "message": "Email already exists",
        "code": "DUPLICATE_VALUE",
        "value": "john@example.com"
      },
      {
        "field": "password",
        "message": "Password must contain at least 8 characters",
        "code": "MIN_LENGTH",
        "value": "123"
      }
    ],
    "trace_id": "req-abc123-def456",
    "timestamp": "2026-02-23T12:30:00.000Z",
    "documentation_url": "https://api.example.com/docs/errors#validation"
  }
}
```

### Example 4: Authentication Flow (OAuth 2.0 Password Flow)

```yaml
# 1. Get token
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securePassword123"
}

# Response
200 OK
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "users:read users:write"
}

# 2. Use token
GET /users
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# 3. Refresh token
POST /auth/refresh
Content-Type: application/json

{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}

# Response
200 OK
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 3600
}
```

## Best Practices

### URL Design

1. **Resource naming:**
   - Use plural nouns
   - Apply snake_case
   - Avoid verbs in path

2. **Hierarchy:**
   - Reflect resource relationships
   - Limit nesting to 2-3 levels

3. **Versioning:**
   - Use URL path: `/v1/`, `/v2/`
   - Document deprecated versions
   - Set support timelines

### Security

1. **Authentication:**
   - Use OAuth 2.0 or JWT
   - Always apply HTTPS
   - Implement rate limiting

2. **Authorization:**
   - Use scopes/permissions
   - Apply principle of least privilege
   - Validate permissions on each endpoint

3. **Data:**
   - Don't pass sensitive data in URLs
   - Validate all input data
   - Use prepared statements

### Performance

1. **Pagination:**
   - Always implement pagination for collections
   - Use cursor-based for large datasets
   - Limit maximum page size

2. **Caching:**
   - Use ETag and Last-Modified
   - Apply client-side caching
   - Document cacheable resources

3. **Filtering and Sorting:**
   - Support filtering via query params
   - Allow sorting by key fields
   - Limit number of parameters

### Documentation

1. **OpenAPI:**
   - Keep specification up-to-date
   - Include response examples
   - Document all errors

2. **Descriptions:**
   - Write brief summaries
   - Add description for complex operations
   - Specify required scopes

## Related Skills

- integration-patterns — designing integration patterns
- data-modeling — designing data models for API
- sql-development — writing SQL queries for API
- bpm-modeling — modeling API business processes
- c4-architecture — system architecture with API
- workflow-design — designing API workflows
