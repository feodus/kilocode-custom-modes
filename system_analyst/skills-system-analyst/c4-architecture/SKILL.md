---
name: c4-architecture
description: Моделирование архитектуры по модели C4: создание Context Diagram (система в контексте), Container Diagram (приложения, базы данных, сервисы), Component Diagram (компоненты внутри контейнеров), Code Diagram (опционально). Используется для визуализации архитектуры системы на разных уровнях детализации.
---

# C4 Architecture

> **Meta:** v1.0.0 | 23-02-2026

## Назначение

Навык для моделирования архитектуры программной системы по модели C4 (Context, Containers, Components, Code). Модель C4 предоставляет иерархический подход к визуализации архитектуры программного обеспечения на четырёх уровнях детализации:

- **Level 1 (Context):** Самое высокоуровневое представление системы
- **Level 2 (Container):** Технологическая архитектура системы
- **Level 3 (Component):** Компоненты внутри контейнеров
- **Level 4 (Code):** Детали реализации (опционально)

Модель C4 была создана Simon Brown для упрощения коммуникации между техническими и нетехническими стейкхолдерами, обеспечивая единообразное понимание архитектуры системы.

## Когда использовать

Используйте этот навык:

- При проектировании новой системы
- Для документирования существующей архитектуры
- При онбординге новых членов команды
- Для коммуникации архитектуры с нетехническими стейкхолдерами
- На этапе архитектурного проектирования (Фаза 5 SDLC)
- При необходимости выбора технологического стека
- Для анализа существующей системы перед рефакторингом
- При подготовке технических спецификаций для Project Manager

## Функции

### Level 1: Context Diagram (Диаграмма контекста)

Диаграмма контекста показывает систему в самом широком масштабе — как она вписывается в окружающий мир. Это самая высокоуровневая диаграмма, которая показывает:

**Элементы диаграммы:**

| Элемент | Описание | Обозначение в Mermaid |
|---------|----------|---------------------|
| Система (System) | Разрабатываемая система | `[Система]` |
| Пользователи (Users) | Люди, взаимодействующие с системой | `([Пользователь])` |
| Внешние системы | Системы, с которыми взаимодействует система | `[[Внешняя система]]` |
| Потоки данных | Отношения между элементами | Стрелки `-->`, `<--` |

**Пример Context Diagram для CRM системы:**

```mermaid
flowchart TB
    subgraph "Organization"
        Customer(["Customer"]) -->|Uses| CRM[("CRM System")]
        Manager(["Sales Manager"]) -->|Manages| CRM
        Admin(["System Admin"]) -->|Configures| CRM
    end
    
    subgraph "External Systems"
        CRM -->|Sends emails| Email[["Email Service"]]
        CRM -->|Processes payments| Payment[["Payment Gateway"]]
        CRM -->|Syncs data| ERP[["ERP System"]]
        CRM -->|Stores files| Storage[["Cloud Storage"]]
    end
    
    style CRM fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    style Customer fill:#f3e5f5,stroke:#7b1fa2
    style Manager fill:#f3e5f5,stroke:#7b1fa2
    style Admin fill:#f3e5f5,stroke:#7b1fa2
```

**Рекомендации по Context Diagram:**

1. Включайте только внешние системы, непосредственно связанные с вашей системой
2. Используйте понятные названия для пользователей (роли)
3. Показывайте только основные потоки данных
4. Избегайте технических деталей на этом уровне

---

### Level 2: Container Diagram (Диаграмма контейнеров)

Диаграмма контейнеров показывает технологическую архитектуру системы — из чего она состоит. Контейнер — это автономный выполняемый компонент, который:

- Запускается как отдельный процесс
- Содержит свою бизнес-логику
- Может быть развёрнут независимо

**Типы контейнеров:**

| Тип | Описание | Примеры |
|-----|----------|---------|
| Server-side приложение | Веб-приложение, API | React SPA, Angular, Vue.js |
| Серверное приложение | Backend сервис | Node.js, Python, Java, Go |
| Мобильное приложение | iOS/Android приложение | Swift, Kotlin, React Native |
| Desktop приложение | Десктопное приложение | Electron, WPF |
| База данных | Хранилище данных | PostgreSQL, MongoDB, Redis |
| Message Broker | Асинхронная коммуникация | RabbitMQ, Kafka |
| Файловая система | Хранение файлов | S3, NFS |
| Кэш | Временное хранилище | Redis, Memcached |

**Пример Container Diagram для E-commerce платформы:**

```mermaid
flowchart TB
    subgraph "E-Commerce Platform"
        WebApp["Web Application\n(React + TypeScript)"]
        MobileApp["Mobile App\n(React Native)"]
        APIGateway["API Gateway\n(Kong / Nginx)"]
        AuthService["Auth Service\n(Node.js)"]
        ProductService["Product Service\n(Node.js)"]
        OrderService["Order Service\n(Python)"]
        PaymentService["Payment Service\n(Java)"]
        NotificationService["Notification Service\n(Go)"]
        
        WebApp -->|HTTPS| APIGateway
        MobileApp -->|HTTPS| APIGateway
        APIGateway -->|REST/gRPC| AuthService
        APIGateway -->|REST/gRPC| ProductService
        APIGateway -->|REST/gRPC| OrderService
        APIGateway -->|REST/gRPC| PaymentService
        
        ProductService -->|SQL| PostgreSQL[("Product Database\nPostgreSQL")]
        OrderService -->|SQL| PostgreSQL2[("Order Database\nPostgreSQL")]
        AuthService -->|Token| Redis[("Session Cache\nRedis")]
        
        OrderService -->|AMQP| RabbitMQ[("Message Queue\nRabbitMQ")]
        RabbitMQ -->|Consumes| NotificationService
        NotificationService -->|SMTP| EmailService[["Email Service"]]
    end
    
    style WebApp fill:#e3f2fd,stroke:#1565c0
    style MobileApp fill:#e3f2fd,stroke:#1565c0
    style APIGateway fill:#fff3e0,stroke:#e65100
    style AuthService fill:#e8f5e9,stroke:#2e7d32
    style ProductService fill:#e8f5e9,stroke:#2e7d32
    style OrderService fill:#e8f5e9,stroke:#2e7d32
    style PaymentService fill:#e8f5e9,stroke:#2e7d32
    style NotificationService fill:#e8f5e9,stroke:#2e7d32
```

**Рекомендации по Container Diagram:**

1. Выбирайте технологии для каждого контейнера
2. Показывайте протоколы взаимодействия (REST, gRPC, AMQP)
3. Указывайте направление потоков данных
4. Обозначайте асинхронные взаимодействия
5. Показывайте внешние системы как прямоугольники пунктиром

---

### Level 3: Component Diagram (Диаграмма компонентов)

Диаграмма компонентов показывает, из чего состоит каждый контейнер. Компонент — это сгруппированный набор связанных обязанностей внутри контейнера.

**Типичные компоненты:**

| Компонент | Описание | Примеры |
|-----------|----------|---------|
| Controller | Обработка входящих запросов | REST Controller, GraphQL Resolver |
| Service | Бизнес-логика | OrderService, PaymentProcessor |
| Repository | Доступ к данным | UserRepository, ProductDAO |
| Model/DTO | Модели данных | User, Order, Product |
| Validator | Валидация входных данных | InputValidator |
| Transformer | Преобразование данных | DataMapper |
| Client | Взаимодействие с внешними системами | PaymentClient, EmailClient |

**Пример Component Diagram для API сервиса:**

```mermaid
flowchart TB
    subgraph "Order Service Container"
        subgraph "API Layer"
            OrderController["OrderController\n(REST Endpoints)"]
            DTO["DTOs\n(OrderRequest, OrderResponse)"]
        end
        
        subgraph "Business Logic Layer"
            OrderService["OrderService\n(Business Logic)"]
            PricingEngine["PricingEngine\n(Price Calculation)"]
            InventoryChecker["InventoryChecker\n(Stock Validation)"]
            PaymentProcessor["PaymentProcessor\n(Payment Handling)"]
        end
        
        subgraph "Data Access Layer"
            OrderRepository["OrderRepository\n(Database Access)"]
            OrderMapper["OrderMapper\n(Entity-DTO Mapping)"]
        end
        
        subgraph "External Clients"
            PaymentClient["PaymentClient\n(External API)"]
            NotificationClient["NotificationClient\n(External API)"]
        end
        
        OrderController --> DTO
        DTO --> OrderService
        OrderService --> PricingEngine
        OrderService --> InventoryChecker
        OrderService --> PaymentProcessor
        OrderService --> OrderRepository
        OrderRepository --> OrderMapper
        PaymentProcessor --> PaymentClient
        PaymentProcessor --> NotificationClient
    end
    
    style OrderController fill:#ffecb3,stroke:#ff6f00
    style DTO fill:#ffecb3,stroke:#ff6f00
    style OrderService fill:#c8e6c9,stroke:#2e7d32
    style PricingEngine fill:#c8e6c9,stroke:#2e7d32
    style InventoryChecker fill:#c8e6c9,stroke:#2e7d32
    style PaymentProcessor fill:#c8e6c9,stroke:#2e7d32
    style OrderRepository fill:#bbdefb,stroke:#1565c0
    style OrderMapper fill:#bbdefb,stroke:#1565c0
    style PaymentClient fill:#f8bbd0,stroke:#c2185b
    style NotificationClient fill:#f8bbd0,stroke:#c2185b
```

**Рекомендации по Component Diagram:**

1. Включайте только компоненты внутри выбранного контейнера
2. Показывайте зависимости между компонентами
3. Обозначайте направление зависимостей (стрелки указывают на то, от чего зависит компонент)
4. Группируйте компоненты по слоям (API, Business, Data)

---

### Level 4: Code Diagram (Диаграмма кода)

Диаграмма кода показывает детали реализации — классы, интерфейсы, отношения между ними. Это опциональный уровень, который используется для:

- Сложных доменных моделей
- Объяснения архитектурных паттернов
- Документирования публичных API
- Онбординга разработчиков

**Когда использовать:**

| Ситуация | Рекомендация |
|----------|--------------|
| Новые члены команды | Создавайте для ключевых модулей |
| Сложные доменные модели | Всегда создавайте |
| Паттерны (Strategy, Factory) | Документируйте |
| Публичные API библиотек | Создавайте |
| Простые CRUD сервисы | Пропускайте |

**Пример Class Diagram:**

```mermaid
classDiagram
    class Order {
        +int id
        +DateTime createdAt
        +OrderStatus status
        +decimal totalAmount
        +create() Order
        +calculateTotal() decimal
        +addItem(OrderItem) void
        +removeItem(int) void
        +updateStatus(OrderStatus) void
    }
    
    class OrderItem {
        +int id
        +int productId
        +int quantity
        +decimal unitPrice
        +decimal getSubtotal() decimal
    }
    
    class Product {
        +int id
        +string name
        +decimal price
        +int stockQuantity
        +isAvailable() boolean
        +reserveStock(int) boolean
    }
    
    class Customer {
        +int id
        +string email
        +string name
        +CustomerTier tier
        +placeOrder(Order) Order
        +getOrderHistory() List~Order~
    }
    
    Order "1" --> "*" OrderItem : contains
    Order "1" --> "1" Customer : places
    OrderItem "1" --> "1" Product : references
    
    class OrderStatus {
        <<enumeration>>
        PENDING
        CONFIRMED
        PROCESSING
        SHIPPED
        DELIVERED
        CANCELLED
    }
    
    class CustomerTier {
        <<enumeration>>
        BRONZE
        SILVER
        GOLD
        PLATINUM
    }
```

## Интеграция с Project Manager

### Данные для Project Manager

Навык предоставляет следующие данные для планирования:

**Количественные метрики:**

| Метрика | Описание |
|---------|----------|
| Количество контейнеров | Общее число контейнеров в системе |
| Количество компонентов | Число компонентов (суммарно) |
| Количество сервисов | Число микросервисов/сервисов |
| Внешние интеграции | Число внешних систем |
| Технологический стек | Список технологий |

**Оценка сложности архитектуры:**

| Сложность | Контейнеры | Компоненты | Оценка времени |
|-----------|------------|------------|----------------|
| Простая | 1-3 | 5-10 | 8-16 часов |
| Средняя | 4-8 | 10-25 | 16-40 часов |
| Сложная | 9-15 | 25-50 | 40-80 часов |
| Очень сложная | 15+ | 50+ | 80-160 часов |

**Архитектурные решения:**

| Решение | Влияние |
|---------|---------|
| Monolith vs Microservices | Выбор влияет на команду и DevOps |
| Синхронные vs Асинхронные | Влияет на производительность |
| Базы данных (SQL/NoSQL) | Влияет на данные и миграции |
| Кэширование | Влияет на производительность |
| API Gateway | Влияет на безопасность и мониторинг |

**Риски архитектуры:**

| Риск | Вероятность | Влияние | Митигация |
|------|-------------|---------|-----------|
| Сложность микросервисов | Высокая | Высокое | Начните с модульного монолита |
| Зависимости между сервисами | Средняя | Высокое | Используйте контракты |
| Производительность сети | Средняя | Среднее | Оптимизация запросов |
| Управление данными | Высокая | Высокое | Стратегия миграции |
| Безопасность | Высокая | Критично | Security by design |

### Взаимодействие

- PM запрашивает архитектурные решения для бюджетирования
- SA предоставляет C4 диаграммы для визуализации
- PM использует метрики для оценки команды
- SA консультирует по выбору технологий

## Инструменты для C4

### Рекомендуемые инструменты

| Инструмент | Тип | Плюсы | Минусы |
|-----------|-----|-------|--------|
| **Mermaid** | Онлайн/VSCode | Встроенная поддержка, простота | Ограниченные возможности |
| **Structurizr** | SaaS/Desktop | Полная поддержка C4, экспорт | Платный для команд |
| **PlantUML** | Онлайн/IDE | Мощный, много форматов | Сложный синтаксис |
| **draw.io** | Онлайн/Desktop | Визуальный редактор | Ручная работа |
| **C4-PlantUML** | Библиотека | Специализированные диаграммы | Требует PlantUML |

### Mermaid в VSCode

Для работы с Mermaid диаграммами в VSCode:

1. Установите расширение **Mermaid Preview**
2. Создайте файл с расширением `.mmd` или используйте кодовые блоки
3. Используйте команду **Mermaid: Export** для экспорта

## Примеры использования

### Пример 1: Context Diagram для Интернет-магазина

```mermaid
flowchart LR
    subgraph "External"
        Customer["Покупатель"]
        Supplier["Поставщик"]
        PaymentBank["Банк"]
        Delivery["Служба доставки"]
    end
    
    subgraph "E-Commerce System"
        WebStore["Веб-магазин"]
        Backend["Backend API"]
        Database["База данных"]
    end
    
    Customer -->|Покупки| WebStore
    WebStore -->|Заказы| Backend
    Backend -->|Товары| Database
    Backend -->|Запросы| PaymentBank
    Backend -->|Доставка| Delivery
    Backend -->|Заказы| Supplier
```

### Пример 2: Container Diagram для SaaS приложения

```mermaid
flowchart TB
    subgraph "SaaS Platform"
        Browser["Веб-приложение\n(React)"]
        Mobile["Мобильное приложение\n(React Native)"]
        API["API Gateway\n(Kong)"]
        Auth["Auth Service\n(NestJS)"]
        Core["Core Service\n(NestJS)"]
        Worker["Background Worker\n(Python)"]
        Cache["Redis Cache"]
        DB["PostgreSQL"]
        
        Browser --> API
        Mobile --> API
        API --> Auth
        API --> Core
        Core --> Worker
        Worker --> DB
        Auth --> Cache
        Core --> Cache
        Core --> DB
    end
```

### Пример 3: Component Diagram для Auth Service

```mermaid
flowchart TB
    subgraph "Auth Service"
        Controller["AuthController\n- /login\n- /register\n- /refresh"]
        Middleware["Middleware\n- TokenValidation\n- RateLimit"]
        Service["AuthService\n- validateCredentials\n- generateTokens\n- refreshTokens"]
        JWT["JWTManager\n- sign\n- verify\n- decode"]
        UserRepo["UserRepository\n- findByEmail\n- create\n- update"]
        PasswordHasher["PasswordHasher\n- hash\n- verify"]
        OAuthClient["OAuthClient\n- Google\n- GitHub"]
        
        Controller --> Middleware
        Middleware --> Service
        Service --> JWT
        Service --> UserRepo
        Service --> PasswordHasher
        Service --> OAuthClient
    end
```

## Best Practices

### Принципы C4 моделирования

1. **Начните с контекста:** Всегда создавайте Level 1 перед переходом к деталям
2. **Один уровень за раз:** Не смешивайте уровни на одной диаграмме
3. **Показывайте отношения, не потоки:** На уровне контекста показывайте "кто с чем взаимодействует"
4.4. **Используйте легенду:** Объясняйте обозначения для нетехнических стейкхолдеров
5. **Обновляйте диаграммы:** Держите их в актуальном состоянии с кодом

### Выбор уровня детализации

| Аудитория | Рекомендуемый уровень |
|-----------|----------------------|
| Бизнес-стейкхолдеры | Level 1 (Context) |
| Команда разработки | Level 1-2 (Context, Container) |
| Архитекторы | Level 1-3 (Context, Container, Component) |
| Новые разработчики | Level 1-4 (все уровни) |
| Техническая документация | Level 1-3 |

### Чек-лист для диаграмм

- [ ] Название диаграммы описательное
- [ ] Все элементы помечены
- [ ] Технологии указаны для контейнеров
- [ ] Протоколы связи указаны
- [ ] Направление потоков понятно
- [ ] Легенда присутствует (при необходимости)

## Связанные навыки

- **uml-modeling** — для создания дополнительных UML диаграмм
- **api-design** — для проектирования API взаимодействий
- **data-modeling** — для проектирования схем данных
- **integration-patterns** — для проектирования интеграций
- **bpmn-modeling** — для моделирования бизнес-процессов

---

*Навык разработан в рамках Фазы 5 SDLC для System Analyst*
