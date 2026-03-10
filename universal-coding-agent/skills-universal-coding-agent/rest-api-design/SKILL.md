---
name: rest-api-design
description: REST API design. Use this skill when creating API endpoints, documenting with OpenAPI/Swagger, versioning, and ensuring API security.
---

# REST API Design

## REST Principles

```
https://api.example.com/v1
```

### HTTP Methods

| Method | Usage | Idempotent |
|-------|---------------|-----------------|
| GET | Retrieve resources | Yes |
| POST | Create resources | No |
| PUT | Full resource replacement | Yes |
| PATCH | Partial update | No |
| DELETE | Delete resource | Yes |

### Standard Response Codes

```
2xx - Success
200 - OK
201 - Created
204 - No Content (successful deletion)

4xx - Client Error
400 - Bad Request
401 - Unauthorized
403 - Forbidden
404 - Not Found
409 - Conflict
422 - Unprocessable Entity
429 - Too Many Requests

5xx - Server Error
500 - Internal Server Error
502 - Bad Gateway
503 - Service Unavailable
```

## URL Structure

### Resources

```yaml
# Collections
GET    /users              # User list
POST   /users              # Create user

# Single resource
GET    /users/{id}         # Get user
PUT    /users/{id}         # Update user (full)
PATCH  /users/{id}         # Partial update
DELETE /users/{id}         # Delete user

# Nested resources
GET    /users/{id}/posts           # User posts
POST   /users/{id}/posts           # Create user post
GET    /users/{id}/posts/{postId}  # Specific post
```

### Filtering, Sorting, Pagination

```yaml
# Pagination
GET /users?page=2&limit=20

# Filtering
GET /users?status=active&role=admin

# Sorting
GET /users?sort=createdAt,desc

# Search
GET /users?q=john&fields=name,email
```

### Versioning

```yaml
# URL path (recommended)
GET /v1/users
GET /v2/users

# Query parameter
GET /users?version=2

# Header
Accept: application/vnd.example.v2+json
```

## API Example

### OpenAPI Specification

```yaml
openapi: 3.0.3
info:
  title: User Management API
  version: 1.0.0
  description: API for user management

servers:
  - url: https://api.example.com/v1
    description: Production
  - url: https://staging-api.example.com/v1
    description: Staging

paths:
  /users:
    get:
      summary: Get list of users
      description: Returns paginated list of users
      tags:
        - Users
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
            maximum: 100
        - name: status
          in: query
          schema:
            type: string
            enum: [active, inactive]
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UsersList'
        '400':
          $ref: '#/components/responses/BadRequest'
        '401':
          $ref: '#/components/responses/Unauthorized'
    
    post:
      summary: Create user
      tags:
        - Users
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '400':
          $ref: '#/components/responses/BadRequest'
        '409':
          $ref: '#/components/responses/Conflict'

  /users/{id}:
    get:
      summary: Get user by ID
      tags:
        - Users
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'
    
    patch:
      summary: Update user
      tags:
        - Users
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateUserRequest'
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
      tags:
        - Users
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '204':
          description: User deleted
        '404':
          $ref: '#/components/responses/NotFound'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string
        status:
          type: string
          enum: [active, inactive]
        createdAt:
          type: string
          format: date-time
        updatedAt:
          type: string
          format: date-time

    UsersList:
      type: object
      properties:
        data:
          type: array
          items:
            $ref: '#/components/schemas/User'
        meta:
          $ref: '#/components/schemas/PaginationMeta'

    PaginationMeta:
      type: object
      properties:
        total:
          type: integer
        page:
          type: integer
        limit:
          type: integer
        totalPages:
          type: integer

    CreateUserRequest:
      type: object
      required:
        - email
        - name
        - password
      properties:
        email:
          type: string
          format: email
        name:
          type: string
          minLength: 2
        password:
          type: string
          minLength: 8

    UpdateUserRequest:
      type: object
      properties:
        email:
          type: string
          format: email
        name:
          type: string
        status:
          type: string
          enum: [active, inactive]

  responses:
    BadRequest:
      description: Invalid request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    Unauthorized:
      description: Not authorized
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    NotFound:
      description: Resource not found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    Conflict:
      description: Conflict
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ErrorResponse'

    ErrorResponse:
      type: object
      properties:
        error:
          type: object
          properties:
            code:
              type: string
            message:
              type: string
            details:
              type: array
              items:
                type: object
                properties:
                  field:
                    type: string
                  message:
                    type: string
```

## Response Formats

### Success Responses

```json
// GET /users - List
{
  "data": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "user@example.com",
      "name": "John Doe",
      "status": "active"
    }
  ],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 20,
    "totalPages": 5
  }
}

// GET /users/{id} - Single resource
{
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "name": "John Doe",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}

// POST /users - Creation
{
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "name": "John Doe",
    "createdAt": "2024-01-15T10:30:00Z"
  },
  "message": "User created successfully"
}
```

### Errors

```json
// 400 Bad Request
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request data",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      },
      {
        "field": "password",
        "message": "Password must be at least 8 characters"
      }
    ]
  }
}

// 401 Unauthorized
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication required"
  }
}

// 404 Not Found
{
  "error": {
    "code": "NOT_FOUND",
    "message": "User with id 123 not found"
  }
}

// 429 Too Many Requests
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests",
    "retryAfter": 60
  }
}

// 500 Internal Server Error
{
  "error": {
    "code": "INTERNAL_ERROR",
    "message": "An unexpected error occurred"
  }
}
```

## Authentication and Authorization

### Bearer Token

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### API Key

```http
X-API-Key: your-api-key-here
```

### Refresh Token

```typescript
// POST /auth/refresh
// Request
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}

// Response
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600
}
```

## Rate Limiting

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640995200
```

## HATEOAS (optional)

```json
{
  "data": {
    "id": "123",
    "name": "John",
    "links": {
      "self": "/users/123",
      "posts": "/users/123/posts",
      "avatar": "/users/123/avatar"
    }
  }
}
```

## Best Practices

1. **Naming** - plural nouns
2. **Verbs only for actions** - /actions, /search
3. **Status codes** - correct HTTP codes
4. **Versioning** - v1, v2 in URL
5. **Pagination** - always for collections
6. **Filtering** - query parameters
7. **Documentation** - OpenAPI/Swagger
8. **Authentication** - Bearer tokens
9. **Rate limiting** - abuse protection
10. **Error responses** - consistent format
11. **CORS** - configure for frontend
12. **SSL/TLS** - HTTPS only in production
13. **Caching** - ETag, Last-Modified headers
14. **Idempotency** - PUT/DELETE are idempotent
