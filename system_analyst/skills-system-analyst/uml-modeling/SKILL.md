---
name: uml-modeling
description: Создание UML-диаграмм для визуализации структуры и поведения системы. Включает Class Diagrams (классы, атрибуты, методы, отношения), Sequence Diagrams (взаимодействие объектов во времени), Activity Diagrams (потоки управления и деятельности), State Machine Diagrams (состояния объекта и переходы). Используется для проектирования архитектуры, документирования системы и коммуникации с командой.
---

# UML Modeling

> **Meta:** v1.0.0 | 23-02-2026

## Назначение

Навык для создания UML-диаграмм (Unified Modeling Language) — стандартизированного языка моделирования для визуализации, спецификации, проектирования и документирования программных систем.

UML предоставляет множество типов диаграмм, каждая из которых фокусируется на определённом аспекте системы:

- **Structure Diagrams (Структурные диаграммы):** показывают статическую структуру системы
  - Class Diagram, Object Diagram, Component Diagram, Package Diagram, Deployment Diagram
  
- **Behavior Diagrams (Диаграммы поведения):** показывают динамическое поведение системы
  - Use Case Diagram, Activity Diagram, State Machine Diagram
  - Interaction Diagrams (Sequence Diagram, Communication Diagram, Timing Diagram)

Данный навык фокусируется на четырёх ключевых типах диаграмм, наиболее часто используемых при проектировании программных систем.

## Когда использовать

Используйте этот навык:

- При проектировании объектно-ориентированной архитектуры
- Для документирования структуры классов и их отношений
- При необходимости визуализации взаимодействия между компонентами системы
- Для моделирования бизнес-процессов и потоков управления
- При проектировании конечных автоматов (state machines)
- На этапе архитектурного проектирования (Фаза 5 SDLC)
- Для онбординга новых членов команды
- При подготовке технической документации для Project Manager
- Для коммуникации архитектурных решений со стейкхолдерами

## Функции

### Class Diagrams

Диаграмма классов — основа объектно-ориентированного проектирования. Показывает статическую структуру системы в виде классов, их атрибутов, методов и отношений между ними.

**Основные элементы:**

| Элемент | Описание | Обозначение |
|---------|----------|-------------|
| Класс | Базовый элемент с атрибутами и методами | Прямоугольник с тремя секциями |
| Interface | Контракт без реализации | `<<interface>>` стереотип |
| Enumeration | Набор констант | `<<enumeration>>` стереотип |
| Abstract Class | Класс с абстрактными методами | Курсивное название |
| Visibility | Область видимости | `+` public, `-` private, `#` protected, `~` package |

**Типы отношений:**

| Тип | Описание | Обозначение Mermaid |
|-----|----------|---------------------|
| Association | Простая связь | `<--`, `-->` |
| Aggregation | "часть-целое" (has-a), не владеет | `o--` |
| Composition | "часть-целое" (owns-a), полностью владеет | `*--` |
| Inheritance | Наследование | `--\|>` |
| Realization | Реализация интерфейса | `..\|>` |
| Dependency | Зависимость | `<..`, `..>` |

**Пример Class Diagram для E-commerce системы:**

```mermaid
classDiagram
    class User {
        +int id
        +string email
        +string passwordHash
        +string firstName
        +string lastName
        +UserTier tier
        +DateTime createdAt
        +login(email, password) boolean
        +logout() void
        +updateProfile(profile) void
        +getOrders() List~Order~
    }
    
    class Order {
        +int id
        +int userId
        +OrderStatus status
        +decimal totalAmount
        +DateTime createdAt
        +DateTime? shippedAt
        +create(items) Order
        +calculateTotal() decimal
        +addItem(item) void
        +removeItem(itemId) void
        +updateStatus(status) void
        +cancel() void
    }
    
    class OrderItem {
        +int id
        +int orderId
        +int productId
        +int quantity
        +decimal unitPrice
        +decimal getSubtotal() decimal
    }
    
    class Product {
        +int id
        +string name
        +string description
        +decimal price
        +int stockQuantity
        +int categoryId
        +boolean isActive
        +isAvailable() boolean
        +reserveStock(quantity) boolean
        +updateStock(quantity) void
    }
    
    class Category {
        +int id
        +string name
        +int? parentId
        +getProducts() List~Product~
        +getSubcategories() List~Category~
    }
    
    class UserTier {
        <<enumeration>>
        BRONZE
        SILVER
        GOLD
        PLATINUM
    }
    
    class OrderStatus {
        <<enumeration>>
        PENDING
        CONFIRMED
        PROCESSING
        SHIPPED
        DELIVERED
        CANCELLED
        REFUNDED
    }
    
    User "1" --> "*" Order : places
    Order "1" --> "*" OrderItem : contains
    OrderItem "*" --> "1" Product : references
    Product "1" --> "1" Category : belongs_to
    Order "1" --> "1" OrderStatus : has
    User "1" --> "1" UserTier : has
    
    class Payment {
        +int id
        +int orderId
        +PaymentMethod method
        +PaymentStatus status
        +decimal amount
        +DateTime processedAt
        +process() boolean
        +refund() boolean
    }
    
    class Shipping {
        +int id
        +int orderId
        +string carrier
        +string trackingNumber
        +ShippingStatus status
        +DateTime shippedAt
        +DateTime? deliveredAt
        +track() ShippingStatus
    }
    
    Order "1" --> "1" Payment : has
    Order "1" --> "1" Shipping : has
    
    class PaymentMethod {
        <<enumeration>>
        CREDIT_CARD
        DEBIT_CARD
        PAYPAL
        BANK_TRANSFER
        CRYPTO
    }
    
    class PaymentStatus {
        <<enumeration>>
        PENDING
        PROCESSING
        COMPLETED
        FAILED
        REFUNDED
    }
    
    class ShippingStatus {
        <<enumeration>>
        PENDING
        LABEL_CREATED
        IN_TRANSIT
        OUT_FOR_DELIVERY
        DELIVERED
        EXCEPTION
    }
```

**Рекомендации по Class Diagrams:**

1. Начинайте с основных сущностей домена
2. Показывайте только публичные методы (контракт класса)
3. Используйте интерфейсы для абстракций
4. Применяйте правильные типы отношений (агрегация vs композиция)
5. Обозначайте multiplicity (1, *, 0..1, 1..*)
6. Используйте enums для фиксированных наборов значений

---

### Sequence Diagrams

Диаграмма последовательности показывает взаимодействие объектов во времени. Особенно полезна для визуализации сценариев использования и потоков данных.

**Основные элементы:**

| Элемент | Описание | Обозначение |
|---------|----------|-------------|
| Participant | Участник взаимодействия | Объект, актер или компонент |
| Lifeline | Вертикальная линия жизни | Пунктирная линия вниз |
| Message | Сообщение между участниками | Горизонтальная стрелка |
| Activation Bar | Блок активации | Прямоугольник на lifeline |
| Return Message | Возврат результата | Пунктирная стрелка |
| Self Message | Вызов самого себя | Стрелка к себе |
| Found Message | Входящее асинхронное | Стрелка от начала |
| Lost Message | Исходящее асинхронное | Стрелка к концу |

**Типы сообщений:**

| Тип | Описание | Обозначение Mermaid |
|-----|----------|---------------------|
| Synchronous | Синхронный вызов (ждёт ответа) | `->>` |
| Asynchronous | Асинхронный вызов (не ждёт) | `-->>` |
| Return | Возврат значения | `-->` |
| Dotted | Информационный | `-.->` |

**Фрагменты взаимодействия:**

| Фрагмент | Описание | Обозначение |
|----------|----------|-------------|
| alt | Альтернативные пути | `alt` / `else` / `end` |
| opt | Опциональный путь | `opt` / `end` |
| loop | Повторение | `loop` / `end` |
| par | Параллельное выполнение | `par` / `end` |
| break | Выход из цикла | `break` / `end` |
| ref | Ссылка на другую диаграмму | `ref` |

**Пример Sequence Diagram для аутентификации пользователя:**

```mermaid
sequenceDiagram
    participant U as User
    participant FE as Frontend
    participant API as API Gateway
    participant Auth as Auth Service
    participant DB as Database
    participant Cache as Redis
    participant Email as Email Service
    
    Note over U,Email: User Login Flow
    
    U->>FE: Enter credentials (email/password)
    FE->>API: POST /api/auth/login
    API->>Auth: Forward request
    Auth->>DB: Query user by email
    
    alt User not found
        DB-->>Auth: No user found
        Auth-->>FE: 401 Unauthorized
        FE-->>U: Show error "Invalid credentials"
    
    else User found
        DB-->>Auth: User data
        Auth->>Auth: Verify password hash
        
        alt Invalid password
            Auth-->>FE: 401 Unauthorized
            FE-->>U: Show error "Invalid credentials"
        
        else Password valid
            Auth->>Auth: Generate JWT tokens
            Auth->>Cache: Store session
            Auth-->>FE: { accessToken, refreshToken }
            FE-->>U: Redirect to dashboard
            
            Note over U,Email: Store tokens securely
        end
    end
```

**Пример Sequence Diagram с фрагментами (создание заказа):**

```mermaid
sequenceDiagram
    participant U as User
    participant FE as Frontend
    participant API as Order API
    participant Inv as Inventory Service
    participant Pay as Payment Service
    participant DB as Database
    participant Notif as Notification Service
    
    U->>FE: Click "Place Order"
    FE->>API: POST /api/orders
    
    rect rgb(240, 248, 255)
        note right of API: Validate Cart
        API->>DB: Get cart items
        DB-->>API: Cart items
        alt Cart empty
            API-->>FE: 400 Bad Request
            FE-->>U: Show "Cart is empty"
        end
    end
    
    rect rgb(255, 250, 240)
        note right of API: Check Inventory
        API->>Inv: Check stock availability
        loop For each item
            Inv->>Inv: Check quantity
        end
        alt Insufficient stock
            Inv-->>API: OutOfStock error
            API-->>FE: 400 Items unavailable
            FE-->>U: Show unavailable items
        end
        Inv-->>API: Stock OK
    end
    
    rect rgb(240, 255, 240)
        note right of API: Process Payment
        API->>Pay: Process payment
        Pay->>Pay: Authorize charge
        
        alt Payment failed
            Pay-->>API: Payment failed
            API-->>FE: 402 Payment required
            FE-->>U: Show payment error
        
        else Payment successful
            Pay-->>API: Payment confirmed
            API->>DB: Create order
            DB-->>API: Order created
            
            API->>Inv: Reserve stock
            Inv-->>API: Stock reserved
            
            API->>Notif: Send confirmation
            Notif-->>API: Email sent
            
            API-->>FE: 201 Order created
            FE-->>U: Show success + order details
        end
    end
```

**Рекомендации по Sequence Diagrams:**

1. Начинайте с основного сценария (happy path)
2. Добавляйте альтернативные потоки с помощью `alt`
3. Показывайте асинхронные операции пунктирными стрелками
4. Используйте активационные блоки для визуализации занятости
5. Группируйте логические блоки с помощью `rect`
6. Добавляйте примечания для пояснений

---

### Activity Diagrams

Диаграмма деятельности показывает потоки управления и деятельности в системе. Особенно полезна для моделирования бизнес-процессов и рабочих потоков.

**Основные элементы:**

| Элемент | Описание | Обозначение |
|---------|----------|-------------|
| Activity | Деятельность (процесс) | Скруглённый прямоугольник |
| Action | Действие (атомарная операция) | Прямоугольник |
| Start/End | Начало/конец | Круг / Двойной круг |
| Decision | Условие (ветвление) | Ромб |
| Merge | Слияние ветвей | Ромб |
| Fork | Параллельное разветвление | Чёрная черта |
| Join | Синхронизация параллельных ветвей | Чёрная черта |
| Swimlane | Дорожка (участник) | Вертикальные секции |
| Object Flow | Поток объектов | Стрелка с пунктиром |

**Пример Activity Diagram для обработки заказа:**

```mermaid
flowchart TD
    subgraph "Customer"
        A1([Начало: Клиент оформляет заказ]) --> A2[Выбор товаров]
        A2 --> A3{Товары в наличии?}
        A3 -->|Да| A4[Добавление в корзину]
        A3 -->|Нет| A5[Уведомление о недоступности]
        A5 --> A2
    end
    
    A4 --> A6[Переход к оформлению]
    
    subgraph "Checkout Process"
        A6 --> A7[Ввод данных доставки]
        A7 --> A8[Выбор способа оплаты]
        A8 --> A9[Ввод платёжных данных]
    end
    
    A9 --> A10{Валидация данных?}
    
    rect rgb(255, 240, 240)
        A10 -->|Ошибка| A11[Показать ошибки валидации]
        A11 --> A7
    end
    
    A10 -->|Успех| A12[Подтверждение заказа]
    
    subgraph "Payment Processing"
        A12 --> A13[Обработка платежа]
        A13 --> A14{Платёж успешен?}
        
        rect rgb(255, 240, 240)
            A14 -->|Нет| A15[Уведомление об ошибке]
            A15 --> A8
        end
    end
    
    A14 -->|Да| A16[Создание заказа в БД]
    A16 --> A17[Резервирование товара]
    A17 --> A18[Отправка email подтверждения]
    A18 --> A19([Конец: Заказ оформлен])
    
    style A1 fill:#e3f2fd,stroke:#1565c0
    style A19 fill:#e8f5e9,stroke:#2e7d32
    style A3 fill:#fff3e0,stroke:#e65100
    style A10 fill:#fff3e0,stroke:#e65100
    style A14 fill:#fff3e0,stroke:#e65100
    style A13 fill:#f3e5f5,stroke:#7b1fa2
    style A16 fill:#f3e5f5,stroke:#7b1fa2
```

**Пример Activity Diagram с Swimlanes (процесс ревью кода):**

```mermaid
flowchart LR
    subgraph Developer
        D1[Написать код] --> D2[Запустить локальные тесты]
        D2 --> D3{Тесты прошли?}
        D3 -->|Нет| D4[Исправить ошибки]
        D4 --> D2
        D3 -->|Да| D5[Создать Pull Request]
    end
    
    subgraph "CI/CD Pipeline"
        D5 --> CI1[Автоматические тесты]
        CI1 --> CI2{Все тесты прошли?}
        CI2 -->|Нет| CI3[Уведомить об ошибках]
        CI3 --> D1
    end
    
    subgraph Reviewer
        CI2 -->|Да| R1[Проверить код]
        R1 --> R2{Есть замечания?}
        R2 -->|Да| R3[Оставить комментарии]
        R3 --> D1
        R2 -->|Нет| R4[Одобрить PR]
    end
    
    R4 --> M1[Merge в main]
    M1 --> M2[Деплой]
    
    style D1 fill:#e3f2fd,stroke:#1565c0
    style R4 fill:#e8f5e9,stroke:#2e7d32
    style M2 fill:#e8f5e9,stroke:#2e7d32
    style R3 fill:#fff3e0,stroke:#e65100
    style CI3 fill:#ffcdd2,stroke:#c62828
```

**Рекомендации по Activity Diagrams:**

1. Используйте swimlanes для разделения ответственности
2. Применяйте решения (ромбы) для ветвления логики
3. Используйте fork/join для параллельных потоков
4. Добавляйте начальное и конечное состояния
5. Группируйте связанные действия в подграфы
6. Используйте цвета для визуального разделения этапов

---

### State Machine Diagrams

Диаграмма состояний (State Machine) показывает состояния объекта и переходы между ними. Особенно полезна для моделирования поведения объектов с конечным набором состояний.

**Основные элементы:**

| Элемент | Описание | Обозначение |
|---------|----------|-------------|
| Initial State | Начальное состояние | Залитый круг |
| Final State | Конечное состояние | Двойной залитый круг |
| State | Состояние | Прямоугольник со скруглёнными углами |
| Transition | Переход | Стрелка между состояниями |
| Event | Событие (триггер перехода) | Надпись на стрелке |
| Guard Condition | Условие перехода | `[condition]` на стрелке |
| Action | Действие при переходе | `/ action` на стрелке |

**Типы действий:**

| Тип | Описание | Обозначение |
|-----|----------|-------------|
| Entry | Действие при входе в состояние | `entry / action` |
| Exit | Действие при выходе | `exit / action` |
| Do | Действие внутри состояния | `do / action` |
| Transition | Действие при переходе | `event / action` |

**Пример State Machine Diagram для жизненного цикла заказа:**

```mermaid
stateDiagram-v2
    [*] --> Draft: Create Order
    
    state Draft {
        [*] --> NewDraft
        NewDraft --> Editing: Add Items
        Editing --> NewDraft: Remove All
        Editing --> Submitted: Submit Order
        Submitted --> Editing: Cancel Submit
        NewDraft --> [*]: Abandon
    }
    
    Submitted --> Confirmed: Confirm
    Submitted --> Cancelled: Cancel
    
    state Confirmed {
        [*] --> PaymentPending
        PaymentPending --> Processing: Payment Received
        PaymentPending --> Cancelled: Payment Failed
        Processing --> Shipped: Ship Order
    }
    
    state Shipped {
        [*] --> InTransit
        InTransit --> OutForDelivery: Arrived at Local Hub
        OutForDelivery --> Delivered: Delivered
        OutForDelivery --> Exception: Delivery Failed
    }
    
    Delivered --> [*]: Complete
    
    state Exception {
        [*] --> AttemptingRetry
        AttemptingRetry --> AttemptingRetry: Retry Delivery
        AttemptingRetry --> ReturnToSender: Max Retries
        ReturnToSender --> Refunded: Refund Complete
        Exception --> Delivered: Successfully Resolved
    }
    
    Cancelled --> Refunded: Process Refund
    Refunded --> [*]
    
    note right of Delivered
        Order lifecycle complete
        Customer can leave review
    end note
```

**Пример State Machine Diagram для конечного автомата (лифт):**

```mermaid
stateDiagram-v2
    [*] --> Idle
    
    Idle --> MovingUp: / Close doors
    MovingUp --> MovingUp: Floor button pressed
    MovingUp --> Arriving: Reached floor
    Arriving --> Idle: / Open doors
    
    Idle --> MovingDown: / Close doors
    MovingDown --> MovingDown: Floor button pressed
    MovingDown --> Arriving: Reached floor
    Arriving --> Idle: / Open doors
    
    state Arriving {
        [*] --> Arriving
        Arriving: entry / stop motor
        Arriving: exit / start motor
    }
    
    note right of Idle
        Waiting for requests
        Doors can open/close
    end note
    
    note right of MovingUp
        Motor running upward
        Cannot change direction
    end note
```

**Пример State Machine Diagram для аутентификации:**

```mermaid
stateDiagram-v2
    [*] --> Unauthenticated
    
    Unauthenticated --> Authenticating: Submit credentials
    Authenticating --> Authenticated: Valid credentials
    Authenticating --> Failed: Invalid credentials
    Authenticating --> Locked: Max attempts exceeded
    
    state Authenticated {
        [*] --> ActiveSession
        ActiveSession --> ActiveSession: User activity
        ActiveSession --> IdleTimeout: No activity
        IdleTimeout --> ActiveSession: User activity
        ActiveSession --> LoggingOut: Logout request
        IdleTimeout --> Expired: Timeout exceeded
        Expired --> [*]
    }
    
    Authenticated --> Unauthenticated: Logout
    Failed --> Unauthenticated: Try again
    Locked --> Unauthenticated: Account unlock
    
    state Locked {
        [*] --> AccountLocked
        AccountLocked --> AccountLocked: Attempt login
        AccountLocked --> UnlockedAfterDelay: Timer expires
    }
    
    note right of Authenticating
        Validate password hash
        Generate session token
        Log attempt
    end note
    
    note right of ActiveSession
        Session token active
        Update last activity
    end note
```

**Рекомендации по State Machine Diagrams:**

1. Определите все возможные состояния объекта
2. Идентифицируйте события, вызывающие переходы
3. Добавьте guard conditions для условных переходов
4. Определите действия при входе/выходе/переходе
5. Проверьте, что каждое состояние достижимо
6. Используйте подсостояния для сложных машин
7. Документируйте неочевидные переходы

## Интеграция с Project Manager

### Данные для Project Manager

Навык предоставляет следующие данные для планирования:

**Количественные метрики:**

| Метрика | Описание |
|---------|----------|
| Количество классов | Общее число классов в диаграмме |
| Количество интерфейсов | Число интерфейсов и контрактов |
| Количество состояний | Число состояний в state machine |
| Количество сценариев | Число вариантов использования (sequence) |
| Сложность отношений | Число связей между классами |

**Оценка сложности:**

| Сложность | Классы | Состояния | Sequence Steps | Оценка времени |
|-----------|--------|-----------|----------------|----------------|
| Простая | 1-5 | 2-4 | 3-5 | 4-8 часов |
| Средняя | 6-15 | 5-8 | 5-10 | 8-24 часа |
| Сложная | 16-30 | 9-15 | 10-20 | 24-48 часов |
| Очень сложная | 30+ | 15+ | 20+ | 48-80 часов |

**Данные для оценки проекта:**

| Данные | Использование PM |
|--------|------------------|
| Структура классов | Оценка объёма работ по разработке |
| Зависимости между классами | Планирование модульной разработки |
| State diagrams | Оценка сложности бизнес-логики |
| Sequence diagrams | Оценка интеграционных работ |
| Activity flows | Планирование тестирования |

**Архитектурные решения:**

| Решение | Влияние |
|---------|---------|
| Architecture Pattern | MVC, MVVM, DDD влияют на структуру классов |
| Инкапсуляция | Visibility модификаторы влияют на тестирование |
| Композиция vs Наследование | Влияет на гибкость системы |
| State Management | Выбор паттерна влияет на сложность state machine |

**Риски проектирования:**

| Риск | Вероятность | Влияние | Митигация |
|------|-------------|---------|-----------|
| Слишком много классов | Средняя | Среднее | Использовать композицию |
| Глубокое наследование | Высокая | Высокое | Предпочитать композицию |
| Сложные state machines | Средняя | Высокое | Декомпозиция на подмашины |
| Неполные sequence diagrams | Средняя | Среднее | Итеративное уточнение |

### Взаимодействие

- PM запрашивает UML диаграммы для документирования архитектуры
- SA создаёт диаграммы для визуализации системы
- PM использует метрики для оценки сложности и планирования
- SA предоставляет обновлённые диаграммы при изменении архитектуры

## Инструменты для UML

### Рекомендуемые инструменты

| Инструмент | Тип | Плюсы | Минусы |
|------------|-----|-------|--------|
| **Mermaid** | Онлайн/VSCode | Встроенная поддержка, простота | Ограниченные возможности |
| **PlantUML** | Онлайн/IDE | Мощный, все типы UML | Сложный синтаксис |
| **draw.io** | Онлайн/Desktop | Визуальный редактор | Ручная работа |
| **StarUML** | Desktop | Профессиональный инструмент | Платный |
| **Visual Paradigm** | SaaS/Desktop | Полная поддержка UML | Платный |

### Mermaid в VSCode

Для работы с Mermaid диаграммами в VSCode:

1. Установите расширение **Mermaid Preview**
2. Создайте файл с расширением `.mmd` или используйте кодовые блоки
3. Используйте команду **Mermaid: Export** для экспорта

## Примеры использования

### Пример 1: Class Diagram для Domain Model (система управления задачами)

```mermaid
classDiagram
    class Project {
        +int id
        +string name
        +string description
        +DateTime startDate
        +DateTime? endDate
        +ProjectStatus status
        +createTask(title, desc) Task
        +addMember(user) void
        +removeMember(userId) void
    }
    
    class Task {
        +int id
        +int projectId
        +string title
        +string description
        +TaskPriority priority
        +TaskStatus status
        +int? assigneeId
        +DateTime? dueDate
        +assignTo(userId) void
        +updateStatus(status) void
        +addComment(text) void
    }
    
    class User {
        +int id
        +string email
        +string name
        +UserRole role
        +getAssignedTasks() List~Task~
        +getProjects() List~Project~
    }
    
    class Comment {
        +int id
        +int taskId
        +int authorId
        +string text
        +DateTime createdAt
    }
    
    class Label {
        +int id
        +string name
        +string color
    }
    
    Project "1" --> "*" Task : contains
    Task "*" --> "1" User : assigned_to
    Task "1" --> "*" Comment : has
    Task "*" --> "*" Label : tagged
    Project "1" --> "*" User : has_members
    
    class TaskStatus {
        <<enumeration>>
        TODO
        IN_PROGRESS
        IN_REVIEW
        DONE
    }
    
    class TaskPriority {
        <<enumeration>>
        LOW
        MEDIUM
        HIGH
        CRITICAL
    }
    
    class ProjectStatus {
        <<enumeration>>
        PLANNING
        ACTIVE
        ON_HOLD
        COMPLETED
        ARCHIVED
    }
    
    class UserRole {
        <<enumeration>>
        ADMIN
        MANAGER
        MEMBER
        VIEWER
    }
```

### Пример 2: Sequence Diagram для регистрации пользователя

```mermaid
sequenceDiagram
    participant U as User
    participant FE as Frontend
    participant API as Auth API
    participant DB as Database
    participant Email as Email Service
    participant Cache as Cache
    
    U->>FE: Fill registration form
    FE->>FE: Validate input
    
    alt Validation failed
        FE-->>U: Show validation errors
    
    else Validation passed
        FE->>API: POST /api/auth/register
        API->>DB: Check if email exists
        
        alt Email already exists
            DB-->>API: Email exists
            API-->>FE: 409 Conflict
            FE-->>U: Show "Email already registered"
        
        else Email available
            DB-->>API: No user found
            API->>DB: Create user record
            DB-->>API: User created
            API->>API: Generate verification token
            API->>Cache: Store verification token
            API->>Email: Send verification email
            Email-->>API: Email sent
            
            API-->>FE: 201 Created
            FE-->>U: Show success + redirect to email verification
        end
    end
    
    Note over U,Email: User verifies email
    U->>FE: Click verification link
    FE->>API: GET /api/auth/verify?token=xxx
    API->>Cache: Get token
    Cache-->>API: Token valid
    API->>DB: Mark email as verified
    DB-->>API: Updated
    API-->>FE: 200 OK
    FE-->>U: Email verified! Redirect to login
```

### Пример 3: Activity Diagram для процесса онбординга сотрудника

```mermaid
flowchart TD
    subgraph "HR Process"
        A1([Начало: Новый сотрудник принят]) --> A2[Создание учётной записи]
        A2 --> A3[Настройка email]
        A3 --> A4[Выдача оборудования]
        A4 --> A5[Назначение ментора]
    end
    
    A5 --> A6[Согласование документов]
    
    subgraph "Documentation"
        A6 --> A7[Подписание договора]
        A7 --> A8[Подписание NDA]
        A8 --> A9[Заполнение анкеты]
        A9 --> A10[Согласование графика]
    end
    
    A10 --> A11{Документы в порядке?}
    
    rect rgb(255, 240, 240)
        A11 -->|Нет| A12[Запросить недостающие]
        A12 --> A6
    end
    
    A11 -->|Да| A13[Создание профиля в системе]
    
    subgraph "IT Setup"
        A13 --> A14[Доступ к почте]
        A14 --> A15[Доступ к Slack/Teams]
        A15 --> A16[Доступ к GitHub/Jira]
        A16 --> A17[Доступ к корпоративным системам]
    end
    
    A17 --> A18[Настройка рабочего места]
    A18 --> A19[Инструктаж по безопасности]
    A19 --> A20[Первый день работы]
    A20 --> A21([Конец: Онбординг завершён])
    
    style A1 fill:#e3f2fd,stroke:#1565c0
    style A21 fill:#e8f5e9,stroke:#2e7d32
    style A11 fill:#fff3e0,stroke:#e65100
    style A12 fill:#ffcdd2,stroke:#c62828
```

### Пример 4: State Machine Diagram для статуса подписки

```mermaid
stateDiagram-v2
    [*] --> Trial
    
    state Trial {
        [*] --> ActiveTrial
        ActiveTrial --> ExpiringSoon: 2 days left
        ExpiringSoon --> Expired: Time expired
        ExpiringSoon --> Subscribed: Upgrade
    }
    
    Trial --> Expired: Trial ended
    Trial --> Cancelled: User cancelled
    
    state Subscribed {
        [*] --> Active
        Active --> PaymentDue: Next billing date
        PaymentDue --> Active: Payment received
        PaymentDue --> PastDue: Payment failed
        PastDue --> Active: Payment received
        PastDue --> Cancelled: Payment failed 3 times
        Active --> Cancelled: User cancelled
        Active --> Upgrading: Upgrade plan
        Upgrading --> Active
    }
    
    Subscribed --> Expired: Subscription ended
    Expired --> Trial: Start trial again
    Expired --> Subscribed: Resubscribe
    
    Cancelled --> [*]: Account deleted
    
    state PastDue {
        [*] --> AttemptingPayment
        AttemptingPayment --> AttemptingPayment: Retry daily
        AttemptingPayment --> Cancelled: Max retries
        AttemptingPayment --> Active: Payment success
    }
    
    note right of Trial
        14-day free trial
        Full feature access
    end note
    
    note right of Subscribed
        Recurring billing
        Monthly or annual
    end note
```

## Best Practices

### Принципы UML моделирования

1. **Выбирайте правильный тип диаграммы:** Не пытайтесь показать всё на одной диаграмме
2. **Начинайте с высокого уровня:** Создавайте overview перед детализацией
3. **Поддерживайте актуальность:** Обновляйте диаграммы при изменении кода
4. **Используйте стандартные обозначения:** Следуйте UML спецификации
5. **Добавляйте документацию:** Комментируйте сложные элементы
6. **Итеративно уточняйте:** Начинайте с простого, добавляйте детали

### Чек-лист для диаграмм

- [ ] Название диаграммы описательное
- [ ] Все элементы помечены и имеют значения
- [ ] Отношения имеют правильные типы
- [ ] Multiplicity указаны (где применимо)
- [ ] Начальное и конечное состояния присутствуют
- [ ] Легенда добавлена (при необходимости)
- [ ] Диаграмма помещается на одном экране

### Выбор типа диаграммы

| Задача | Рекомендуемая диаграмма |
|--------|------------------------|
| Показать структуру классов | Class Diagram |
| Показать взаимодействие во времени | Sequence Diagram |
| Показать бизнес-процесс | Activity Diagram |
| Показать поведение объекта | State Machine Diagram |
| Показать архитектуру системы | C4 (Container/Component) |
| Показать варианты использования | Use Case Diagram |

## Связанные навыки

- **c4-architecture** — для моделирования архитектуры на уровне контейнеров и компонентов
- **data-modeling** — для проектирования схем данных и ERD
- **bpmn-modeling** — для моделирования бизнес-процессов в нотации BPMN
- **workflow-design** — для проектирования рабочих процессов и автоматизации
- **api-design** — для проектирования API взаимодействий

---

*Навык разработан в рамках Фазы 5 SDLC для System Analyst*
