---
name: api-design
description: Проектирование RESTful API и спецификаций OpenAPI: создание RESTful endpoints с использованием принципов REST, проектирование OpenAPI 3.0 спецификаций (Paths, Schemas, Parameters, Responses), определение аутентификации и авторизации (OAuth 2.0, JWT, API Keys), версионирование API, пагинация, обработка ошибок, проектирование URL структуры и кодов состояния HTTP
---

# API Design

> **Meta:** v1.0.0 | 23-02-2026

## Назначение

Навык для проектирования RESTful API и создания спецификаций OpenAPI/Swagger. Включает определение принципов REST архитектуры, проектирование эндпоинтов, описание схем данных и параметров, настройку аутентификации и авторизации, версионирование API, реализацию пагинации и обработку ошибок. Навык предоставляет полную спецификацию API для реализации в Universal Coding Agent.

## Когда использовать

Используйте этот навык:
- При проектировании нового RESTful API
- Для создания спецификаций OpenAPI/Swagger
- При определении структуры endpoints и ресурсов
- Для настройки аутентификации (OAuth 2.0, JWT, API Keys)
- При проектировании версионирования API
- Для реализации пагинации и фильтрации
- При определении формата ошибок и кодов состояния
- На этапе проектирования интеграций между системами
- При документировании существующего API

## Функции

### REST Principles

Принципы построения RESTful архитектуры:

**Ресурсы (Resources):**

| Концепция | Описание | Пример |
|-----------|----------|--------|
| Ресурс | Сущность, доступная через API | `/users`, `/orders`, `/products` |
| Коллекция | Множество ресурсов | `/users`, `/orders` |
| Экземпляр | Конкретный ресурс | `/users/123`, `/orders/456` |
| Подресурс | Вложенный ресурс | `/users/123/orders` |

**Именование ресурсов:**

- Используйте существительные во множественном числе: `/users` не `/user`
- Используйте snake_case для URL: `/user-profiles` не `/userProfiles`
- Избегайте глаголов в URL: используйте HTTP методы
- Используйте иерархию для отношений: `/users/123/orders`

**HTTP Методы:**

| Метод | Семантика | Пример |
|-------|-----------|--------|
| **GET** | Получение ресурса | `GET /users` — список, `GET /users/123` — один |
| **POST** | Создание ресурса | `POST /users` — создать пользователя |
| **PUT** | Полная замена ресурса | `PUT /users/123` — заменить данные |
| **PATCH** | Частичное обновление | `PATCH /users/123` — изменить часть данных |
| **DELETE** | Удаление ресурса | `DELETE /users/123` — удалить пользователя |

**Коды состояния HTTP:**

| Код | Категория | Описание |
|-----|-----------|----------|
| **2xx Success** | Успешные операции |
| 200 | OK | Успешный GET/PUT/PATCH |
| 201 | Created | Ресурс создан (POST) |
| 204 | No Content | Успешное удаление (DELETE) |
| **3xx Redirection** | Перенаправление |
| 304 | Not Modified | Кэшированные данные |
| **4xx Client Error** | Ошибки клиента |
| 400 | Bad Request | Неверный синтаксис |
| 401 | Unauthorized | Требуется аутентификация |
| 403 | Forbidden | Нет доступа |
| 404 | Not Found | Ресурс не найден |
| 409 | Conflict | Конфликт данных |
| 422 | Unprocessable Entity | Ошибка валидации |
| 429 | Too Many Requests | Превышен лимит |
| **5xx Server Error** | Ошибки сервера |
| 500 | Internal Server Error | Внутренняя ошибка |
| 503 | Service Unavailable | Сервис недоступен |

**HATEOAS (Hypermedia as the Engine of Application State):**

Принцип включения ссылок в ответы API для навигации:

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

| Уровень | Название | Описание |
|---------|----------|----------|
| 0 | Swamp of POX | Один endpoint, всё в POST |
| 1 | Resources | Разделение на ресурсы |
| 2 | HTTP Verbs | Использование HTTP методов |
| 3 | Hypermedia Controls | HATEOAS |

### OpenAPI Specification

Проектирование спецификаций OpenAPI 3.0:

**Структура документа OpenAPI:**

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

**Paths и Operations:**

```yaml
paths:
  /users:
    get:
      summary: Получить список пользователей
      description: Возвращает список всех пользователей с поддержкой пагинации
      operationId: getUsers
      tags:
        - Users
      parameters:
        - name: page
          in: query
          description: Номер страницы
          schema:
            type: integer
            default: 1
            minimum: 1
        - name: limit
          in: query
          description: Количество элементов на странице
          schema:
            type: integer
            default: 20
            maximum: 100
        - name: sort
          in: query
          description: Поле для сортировки
          schema:
            type: string
            enum: [name, created_at, email]
        - name: order
          in: query
          description: Направление сортировки
          schema:
            type: string
            enum: [asc, desc]
            default: asc
        - name: status
          in: query
          description: Фильтр по статусу
          schema:
            type: string
            enum: [active, inactive, suspended]
      responses:
        '200':
          description: Успешный ответ
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
      summary: Создать пользователя
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
          description: Пользователь создан
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
      summary: Получить пользователя по ID
      operationId: getUserById
      tags:
        - Users
      parameters:
        - name: userId
          in: path
          required: true
          description: ID пользователя
          schema:
            type: integer
            format: int64
      responses:
        '200':
          description: Успешный ответ
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'

    put:
      summary: Обновить пользователя полностью
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
          description: Пользователь обновлён
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'

    patch:
      summary: Частично обновить пользователя
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
          description: Пользователь обновлён
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'

    delete:
      summary: Удалить пользователя
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
          description: Пользователь удалён
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
      description: Пользователь системы
      required:
        - id
        - email
        - created_at
      properties:
        id:
          type: integer
          format: int64
          description: Уникальный идентификатор
        email:
          type: string
          format: email
          description: Email пользователя
        name:
          type: string
          description: Имя пользователя
        status:
          type: string
          enum: [active, inactive, suspended]
          default: active
        created_at:
          type: string
          format: date-time
          description: Дата создания
        updated_at:
          type: string
          format: date-time
          description: Дата обновления
    
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
          description: Код ошибки
        message:
          type: string
          description: Сообщение об ошибке
        details:
          type: array
          items:
            $ref: '#/components/schemas/ValidationError'
        trace_id:
          type: string
          description: ID для логирования
    
    ValidationError:
      type: object
      properties:
        field:
          type: string
          description: Поле с ошибкой
        message:
          type: string
          description: Сообщение об ошибке
        code:
          type: string
          description: Код ошибки валидации

  parameters:
    Page:
      name: page
      in: query
      description: Номер страницы
      schema:
        type: integer
        default: 1
        minimum: 1
    
    Limit:
      name: limit
      in: query
      description: Количество элементов
      schema:
        type: integer
        default: 20
        maximum: 100

  responses:
    BadRequest:
      description: Неверный запрос
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            code: "BAD_REQUEST"
            message: "Invalid request parameters"
            trace_id: "req-abc123"
    
    Unauthorized:
      description: Требуется аутентификация
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            code: "UNAUTHORIZED"
            message: "Authentication required"
    
    Forbidden:
      description: Доступ запрещён
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    
    NotFound:
      description: Ресурс не найден
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
          example:
            code: "NOT_FOUND"
            message: "User with id 123 not found"
    
    ValidationError:
      description: Ошибка валидации
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
      description: Внутренняя ошибка сервера
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

Настройка безопасности API:

**Security Schemes (OpenAPI):**

```yaml
components:
  securitySchemes:
    # OAuth 2.0 с Password Flow
    OAuth2Password:
      type: oauth2
      flows:
        password:
          tokenUrl: /auth/login
          scopes:
            read: Read access
            write: Write access
            admin: Admin access
    
    # OAuth 2.0 с Authorization Code Flow
    OAuth2AuthorizationCode:
      type: oauth2
      flows:
        authorizationCode:
          authorizationUrl: /auth/authorize
          tokenUrl: /auth/token
          scopes:
            read: Read access
            write: Write access
    
    # API Key в заголовке
    ApiKeyHeader:
      type: apiKey
      in: header
      name: X-API-Key
      description: API ключ для аутентификации
    
    # API Key в query параметре
    ApiKeyQuery:
      type: apiKey
      in: query
      name: api_key
      description: API ключ в параметре запроса
    
    # Bearer Token (JWT)
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      description: JWT токен доступа

# Применение безопасности
security:
  - BearerAuth: []
  - OAuth2Password:
      - read
      - write
  - ApiKeyHeader: []
```

**OAuth 2.0 Flows:**

| Flow | Использование | Применение |
|------|---------------|------------|
| **Authorization Code** | Server-side apps | Веб-приложения с бэкендом |
| **Password** | Trusted apps | Мобильные приложения (не рекомендуется) |
| **Client Credentials** | Machine-to-machine | Сервисы и демоны |
| **Implicit** | Legacy | Не рекомендуется (используйте PKCE) |

**Пример JWT токена:**

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

**Scopes и Permissions:**

```yaml
# Определение scopes
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
            users:read: Чтение пользователей
            users:write: Создание/обновление пользователей
            users:delete: Удаление пользователей
            # Orders
            orders:read: Чтение заказов
            orders:write: Создание заказов
            # Admin
            admin:full: Полный административный доступ
```

**Rate Limiting:**

```yaml
paths:
  /users:
    get:
      summary: Получить список пользователей
      # Rate limiting через заголовки
      x-rate-limit:
        limit: 1000
        period: 3600  # 1000 запросов в час
      x-rate-limit-tier: premium  # Уровень тарифного плана
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

Стратегии версионирования API:

| Стратегия | Пример | Преимущества | Недостатки |
|-----------|--------|--------------|------------|
| **URL Path** | `/v1/users` | Простота, явность | URL pollution |
| **Query Param** | `/users?version=1` | Чистые URL | Кэширование |
| **Header** | `Accept: application/vnd.api.v1+json` | Чистые URL | Сложность |
| **Content Negotiation** | `Accept: application/vnd.example.v1+json` | Гибкость | Документация |

**Рекомендация:** Используйте URL Path versioning (`/v1/`, `/v2/`)

**Практики версионирования:**

```yaml
# OpenAPI с версионированием
servers:
  - url: https://api.example.com/v1
    description: Версия 1 (текущая)
  - url: https://api.example.com/v2
    description: Версия 2 (бета)
  - url: https://api.example.com/v3
    description: Версия 3 (разработка)

paths:
  /v1/users:
    get:
      summary: Get users (v1)
      deprecated: true
      description: |
        ## Deprecated
        Используйте `/v2/users` для новых интеграций.
        Эта версия будет удалена 31.12.2026.
      responses:
        '200':
          description: Success

  /v2/users:
    get:
      summary: Get users (v2)
      description: |
        ## Changes from v1
        - Добавлено поле `profile_url`
        - Изменён формат дат на ISO 8601
      responses:
        '200':
          description: Success
```

**Deprecation Strategy:**

```yaml
# Deprecation через заголовки
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

# Пример использования
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

Реализация пагинации:

**Offset-based Pagination:**

```yaml
# Параметры
parameters:
  Offset:
    name: offset
    in: query
    description: Смещение (номер записи)
    schema:
      type: integer
      default: 0
      minimum: 0
  
  Limit:
    name: limit
    in: query
    description: Количество записей
    schema:
      type: integer
      default: 20
      maximum: 100
      minimum: 1

# Ответ
responses:
  UserList:
    description: Список пользователей
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
    description: Курсор для следующей страницы
    schema:
      type: string

# Ответ
responses:
  UserListCursor:
    description: Список пользователей
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
                  description: Курсор для следующей страницы
                has_next:
                  type: boolean
                has_prev:
                  type: boolean
```

**Сравнение подходов:**

| Характеристика | Offset-based | Cursor-based |
|----------------|--------------|--------------|
| Простота | ✅ Простой | ⚠️ Сложнее |
| URL для страницы | ✅ `/page/2` | ⚠️ Нет |
| Пропуски при вставке | ❌ Да | ✅ Нет |
| Производительность | ❌ Медленно для больших offset | ✅ Быстро |
| Кэширование | ✅ Хорошо | ❌ Плохо |

**Рекомендация:** 
- Для небольших数据集 используйте offset-based
- Для больших数据集 или real-time данных используйте cursor-based

### Error Handling

Стандартизированный формат ошибок:

**Структура ошибки:**

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

**Типы ошибок:**

```yaml
components:
  schemas:
    ErrorCode:
      type: object
      description: Коды ошибок API
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

**Логирование:**

- Всегда включайте `trace_id` для трассировки
- Используйте统一的 формат для всех ошибок
- Документируйте все возможные коды ошибок

## Интеграция с Project Manager

### Данные для Project Manager

Предоставляет следующие данные для PM:

**Количественные метрики:**

| Метрика | Описание |
|---------|----------|
| Количество endpoints | Общее число endpoints в API |
| Количество операций | Число операций (GET, POST, PUT, PATCH, DELETE) |
| Количество schemas | Число определённых моделей данных |
| Версии API | Количество поддерживаемых версий |

**Оценка сложности API:**

| Сложность | Критерии | Оценка времени |
|-----------|----------|----------------|
| **Простая** | 5-10 endpoints, CRUD операции, базовая аутентификация | 16-32 часа |
| **Средняя** | 15-30 endpoints, бизнес-логика, пагинация, OAuth | 32-64 часа |
| **Сложная** | 30+ endpoints, сложная авторизация, real-time, versioning | 64-120 часов |

**Требования к безопасности:**

| Требование | Уровень риска | Необходимые действия |
|------------|---------------|----------------------|
| Аутентификация | Критично | OAuth 2.0 / JWT |
| Авторизация | Критично | RBAC / Scopes |
| Rate Limiting | Высокий | Ограничение запросов |
| API Keys | Средний | Для внешних интеграций |
| Шифрование | Критично | HTTPS + TLS 1.3 |

**Риски интеграции:**

- Сложность интеграции с внешними API
- Зависимости от сторонних сервисов аутентификации
- Версионирование и совместимость
- Требования к SLA внешних сервисов
- Обработка ошибок и timeout

### Взаимодействие

- PM запрашивает спецификацию API для оценки времени разработки
- PM получает данные для планирования ресурсов
- PM использует метрики для распределения задач
- SA валидирует изменения API с PM

## Примеры использования

### Пример 1: OpenAPI спецификация для User Management API

```yaml
openapi: 3.0.0
info:
  title: User Management API
  version: 1.0.0
  description: API для управления пользователями системы
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
    description: Операции с пользователями
  - name: Auth
    description: Аутентификация и авторизация

paths:
  /auth/register:
    post:
      summary: Регистрация нового пользователя
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
          description: Пользователь успешно зарегистрирован
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
      summary: Вход в систему
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
          description: Успешный вход
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
      summary: Получить список пользователей
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
          description: Список пользователей
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
        '401':
          $ref: '#/components/responses/Unauthorized'
        '403':
          $ref: '#/components/responses/Forbidden'

    post:
      summary: Создать пользователя
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
          description: Пользователь создан
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
      summary: Получить пользователя по ID
      operationId: getUserById
      tags:
        - Users
      responses:
        '200':
          description: Пользователь найден
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'

    patch:
      summary: Обновить пользователя
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
          description: Пользователь обновлён
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          $ref: '#/components/responses/NotFound'

    delete:
      summary: Удалить пользователя
      operationId: deleteUser
      tags:
        - Users
      security:
        - BearerAuth: []
        - OAuth2Password:
            - users:delete
      responses:
        '204':
          description: Пользователь удалён
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
            users:read: Чтение пользователей
            users:write: Создание пользователей
            users:delete: Удаление пользователей

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
      description: Ошибка валидации
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    Unauthorized:
      description: Не авторизован
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    Forbidden:
      description: Доступ запрещён
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    NotFound:
      description: Не найден
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    Conflict:
      description: Конфликт
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

### Пример 2: Pagination Implementation

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

### Пример 3: Error Response Format

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

### Пример 4: Authentication Flow (OAuth 2.0 Password Flow)

```yaml
# 1. Получение токена
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securePassword123"
}

# Ответ
200 OK
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "users:read users:write"
}

# 2. Использование токена
GET /users
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# 3. Обновление токена
POST /auth/refresh
Content-Type: application/json

{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}

# Ответ
200 OK
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 3600
}
```

## Лучшие практики

### Проектирование URL

1. **Именование ресурсов:**
   - Используйте существительные во множественном числе
   - Применяйте snake_case
   - Избегайте глаголов в path

2. **Иерархия:**
   - Отражайте отношения между ресурсами
   - Ограничьте вложенность до 2-3 уровней

3. **Версионирование:**
   - Используйте URL path: `/v1/`, `/v2/`
   - Документируйте устаревшие версии
   - Устанавливайте сроки поддержки

### Безопасность

1. **Аутентификация:**
   - Используйте OAuth 2.0 или JWT
   - Применяйте HTTPS всегда
   - Реализуйте rate limiting

2. **Авторизация:**
   - Используйте scopes/permissions
   - Применяйте принцип наименьших привилегий
   - Валидируйте права на каждом endpoint

3. **Данные:**
   - Не передавайте чувствительные данные в URL
   - Валидируйте все входные данные
   - Используйте prepared statements

### Производительность

1. **Пагинация:**
   - Всегда реализуйте пагинацию для коллекций
   - Используйте cursor-based для больших数据集
   - Ограничивайте максимальный размер страницы

2. **Кэширование:**
   - Используйте ETag и Last-Modified
   - Применяйте кэширование на стороне клиента
   - Документируйте кэшируемые ресурсы

3. **Фильтрация и сортировка:**
   - Поддерживайте фильтрацию через query params
   - Разрешайте сортировку по ключевым полям
   - Ограничивайте количество параметров

### Документация

1. **OpenAPI:**
   - Поддерживайте актуальную спецификацию
   - Включайте примеры ответов
   - Документируйте все ошибки

2. **Описание:**
   - Пишите краткие summary
   - Добавляйте description для сложных операций
   - Указывайте требуемые scopes

## Связанные навыки

- integration-patterns — проектирование интеграционных паттернов
- data-modeling — проектирование моделей данных для API
- sql-development — написание SQL-запросов для API
- bpmn-modeling — моделирование бизнес-процессов API
- c4-architecture — архитектура системы с API
- workflow-design — проектирование рабочих процессов API
