---
name: bpmn-modeling
description: Моделирование бизнес-процессов в нотации BPMN 2.0: process mapping, gateways (XOR/AND/OR), events, tasks, pools & lanes, message flows. Анализ и оптимизация бизнес-логики, идентификация узких мест, генерация Mermaid/PlantUML диаграмм.
---

# BPMN Modeling

> **Meta:** v1.0.0 | 23-02-2026

## Назначение

Навык для моделирования бизнес-процессов в нотации BPMN 2.0 (Business Process Model and Notation). Включает создание диаграмм бизнес-процессов, определение потоков выполнения, работу с шлюзами (gateways), событиями (events), задачами (tasks), организацию участников через пулы и дорожки (pools & lanes), а также коммуникацию между процессами через message flows. Предназначен для анализа, документирования и оптимизации бизнес-логики организации.

## Когда использовать

Используйте этот навык:
- При анализе и документировании бизнес-процессов организации
- Для визуализации потоков работ (workflows) и процедур
- При идентификации узких мест и оптимизации процессов
- Для описания взаимодействия между подразделениями и системами
- При проектировании автоматизации бизнес-процессов
- Для подготовки данных для Project Manager (оценки времени, риски процессов)
- На этапе анализа требований и проектирования системы

## Функции

### Process Mapping

Определение и документирование шагов бизнес-процесса:

**Элементы процесса:**
- **Start Event** — точка начала процесса
- **End Event** — точка завершения процесса
- **Activities** — действия, выполняемые в процессе
- **Gateways** — точки принятия решений
- **Sequence Flows** — последовательность выполнения

**Уровни детализации:**
- Level 1: Обзор процесса (SIPOC)
- Level 2: Основные этапы процесса
- Level 3: Детальные шаги с исполнителями
- Level 4: Инструкции для каждого шага

### Gateways

Шлюзы для управления потоками выполнения:

| Тип | Символ | Описание | Применение |
|-----|--------|----------|------------|
| **Exclusive (XOR)** | `X` | Только один путь | Условное ветвление |
| **Parallel (AND)** | `+` | Все пути одновременно | Параллельное выполнение |
| **Inclusive (OR)** | `O` | Один или несколько путей | Множественные условия |
| **Event-based** | `◇` | Событие определяет путь | Реакция на события |
| **Complex** | `*` | Комплексные условия | Сложная логика |

**Правила использования:**
- XOR Gateway: используется для if-then-else логики
- AND Gateway: используется для параллельных задач без условий
- OR Gateway: используется при множественных истинных условиях
- Слияние (merge) должно соответствовать типу разветвления (split)

### Events

События в бизнес-процессе:

| Категория | Типы событий | Описание |
|-----------|--------------|----------|
| **Start Events** | None, Timer, Message, Signal, Conditional | Инициируют начало процесса |
| **Intermediate Events** | Timer, Message, Signal, Error, Escalation, Link | Промежуточные триггеры |
| **End Events** | None, Message, Signal, Error, Escalation, Terminate | Завершение процесса |
| **Boundary Events** | Timer, Error, Signal, Message, Escalation | Обработка событий на активности |

**Детальное описание событий:**

```
Start Events:
- None: Стандартное начало процесса
- Timer: Начало по расписанию (cron, delay)
- Message: Начало при получении сообщения
- Signal: Начало по сигналу от другого процесса
- Conditional: Начало при выполнении условия

Intermediate Events:
- Timer: Задержка или ожидание
- Message: Отправка/получение сообщения
- Signal: Broadcast сигнала
- Error: Обработка ошибки
- Escalation: Эскалация проблемы

End Events:
- None: Нормальное завершение
- Message: Отправка сообщения при завершении
- Error: Завершение с ошибкой
- Terminate: Принудительное завершение всего процесса
```

### Tasks

Типы задач в бизнес-процессе:

| Тип | Обозначение | Описание | Пример |
|-----|-------------|----------|--------|
| **User Task** | Иконка пользователя | Выполняется человеком | Одобрение заявки |
| **Service Task** | Иконка шестерёнки | Выполняется системой | Обработка платежа |
| **Script Task** | Иконка скрипта | Выполняет скрипт | Валидация данных |
| **Business Rule Task** | Иконка таблицы | Применяет бизнес-правила | Расчёт скидки |
| **Manual Task** | Иконка руки | Выполняется вручную | Физическая проверка |
| **Send Task** | Иконка конверта | Отправка сообщения | Отправка уведомления |
| **Receive Task** | Иконка конверта | Получение сообщения | Ожидание ответа |
| **Call Activity** | Иконка плюс | Вызов подпроцесса | Запуск другого процесса |

### Pools & Lanes

Организация участников процесса:

**Pool (Пул):**
- Представляет организацию, департамент или систему
- Может содержать один процесс или несколько
- Message Flow связывает процессы в разных пулах
- Sequence Flow не может пересекать границы пула

**Lane (Дорожка):**
- Подразделение пула для группировки активностей
- Представляет роль, должность или систему
- Помогает определить ответственность
- Sequence Flow может пересекать границы дорожек

**Структура:**
```
┌─────────────────────────────────────────────────┐
│                    Pool: Company A               │
│  ┌──────────────┬──────────────┬──────────────┐ │
│  │ Lane: Sales  │ Lane: Finance│ Lane: Warehouse│
│  │              │              │              │ │
│  │  [Task 1]    │   [Task 2]   │   [Task 3]   │ │
│  │      │       │       │      │       │      │ │
│  │      └───────┼───────┘      │       │      │ │
│  └──────────────┴──────────────┴──────────────┘ │
└─────────────────────────────────────────────────┘
```

### Message Flows

Коммуникация между пулами:

**Характеристики:**
- Связывает процессы в разных пулах
- Представляет обмен сообщениями между участниками
- Не может использоваться внутри одного пула
- Может начинаться/заканчиваться на:
  - Pools
  - Activities (Send/Receive Tasks)
  - Events (Message Events)

**Паттерны коммуникации:**
- **Request-Response:** Запрос и ожидание ответа
- **Fire-and-Forget:** Отправка без ожидания ответа
- **Broadcast:** Отправка сообщения нескольким получателям
- **Correlation:** Связывание сообщений по correlation key

## Интеграция с Project Manager

### Данные для Project Manager

Предоставляет следующие данные для PM:

**Метрики процесса:**
- Количество шагов в процессе
- Количество gateways и их типы
- Количество участников (pools, lanes)
- Количество внешних взаимодействий (message flows)

**Оценка времени выполнения:**

| Элемент процесса | Базовое время | Коэффициент сложности |
|------------------|---------------|----------------------|
| User Task | 15-60 мин | × сложность задачи |
| Service Task | 1-5 мин | × объём данных |
| Gateway XOR | 1-2 мин | × количество веток |
| Gateway AND | 0 мин | параллельное выполнение |
| Message Flow | 5-30 мин | × время ответа |

**Идентификация узких мест:**
- Задачи с наибольшей длительностью
- Gateways с несбалсированными ветками
- Ожидание внешних сообщений (Message Flows)
- Ручные задачи (Manual Tasks)

**Риски процесса:**
- Процессы с множественными шлюзами (высокая сложность)
- Зависимости от внешних систем (Message Flows)
- Процессы без обработки ошибок (Error Events)
- Длинные цепочки последовательных задач

### Взаимодействие

- PM запрашивает модели процессов для оптимизации
- PM получает данные для оценки трудозатрат на автоматизацию
- PM использует метрики процессов для планирования улучшений
- SA валидирует изменения процессов с PM и стейкхолдерами

## Примеры использования

### Пример 1: Процесс обработки заказа (базовый)

```mermaid
flowchart TD
    Start([Start: Order Received]) --> A[User Task: Submit Order]
    A --> B[Service Task: Validate Order]
    B --> C{Gateway XOR: Payment Valid?}
    C -->|Yes| D[Service Task: Process Payment]
    C -->|No| E[User Task: Show Error]
    E --> A
    D --> F{Gateway XOR: In Stock?}
    F -->|Yes| G[Service Task: Ship Order]
    F -->|No| H[Service Task: Backorder]
    H --> I[User Task: Notify Customer]
    I --> G
    G --> J[Service Task: Send Confirmation]
    J --> End([End: Order Complete])
    
    style Start fill:#90EE90
    style End fill:#FFB6C1
    style C fill:#FFD700
    style F fill:#FFD700
    style E fill:#FF6B6B
```

**Описание процесса:**
| ID | Элемент | Тип | Исполнитель | Время |
|----|---------|-----|-------------|-------|
| 1 | Start | Start Event | - | - |
| 2 | Submit Order | User Task | Customer | 5 мин |
| 3 | Validate Order | Service Task | System | 2 мин |
| 4 | Payment Valid? | Gateway XOR | System | 1 мин |
| 5 | Process Payment | Service Task | Payment Gateway | 3 мин |
| 6 | In Stock? | Gateway XOR | Inventory System | 1 мин |
| 7 | Ship Order | Service Task | Warehouse | 30 мин |
| 8 | Backorder | Service Task | Warehouse | 10 мин |
| 9 | Notify Customer | User Task | System | 2 мин |
| 10 | Send Confirmation | Service Task | System | 1 мин |
| 11 | End | End Event | - | - |

### Пример 2: Процесс с Pool и Lanes

```mermaid
flowchart TD
    subgraph Pool_Customer["Pool: Customer Portal"]
        subgraph Lane_Web["Lane: Web Interface"]
            A1[User Task: Submit Request]
            A2[User Task: View Status]
        end
    end
    
    subgraph Pool_Company["Pool: Company Internal"]
        subgraph Lane_Sales["Lane: Sales Team"]
            B1[User Task: Review Request]
            B2[User Task: Prepare Quote]
        end
        subgraph Lane_Finance["Lane: Finance"]
            B3[User Task: Approve Discount]
            B4[Service Task: Process Payment]
        end
        subgraph Lane_Ops["Lane: Operations"]
            B5[Service Task: Fulfill Order]
        end
    end
    
    A1 -->|Message Flow| B1
    B1 --> B2
    B2 --> C{Discount > 10%?}
    C -->|Yes| B3
    C -->|No| D[Send Quote]
    B3 --> D
    D -->|Message Flow| A2
    A2 -->|Message Flow| B4
    B4 --> B5
    B5 -->|Message Flow| A2
    
    style C fill:#FFD700
```

**Матрица ответственности (RACI):**

| Этап | Customer | Sales | Finance | Operations |
|------|----------|-------|---------|------------|
| Submit Request | R | I | - | - |
| Review Request | I | R | C | - |
| Approve Discount | I | C | R | - |
| Process Payment | I | I | R | I |
| Fulfill Order | I | I | C | R |

### Пример 3: Процесс с Timer Events

```mermaid
flowchart TD
    Start([Start]) --> A[Service Task: Create Subscription]
    A --> B[User Task: Send Welcome Email]
    B --> C[Timer Event: Wait 7 Days]
    C --> D[Service Task: Check Usage]
    D --> E{Gateway XOR: Active User?}
    E -->|Yes| F[Service Task: Send Tips]
    E -->|No| G[User Task: Send Re-engagement Email]
    F --> H[Timer Event: Wait 30 Days]
    G --> H
    H --> I[Service Task: Generate Report]
    I --> J{Gateway XOR: Continue?}
    J -->|Yes| C
    J -->|No| End([End])
    
    style Start fill:#90EE90
    style End fill:#FFB6C1
    style C fill:#87CEEB
    style H fill:#87CEEB
    style E fill:#FFD700
    style J fill:#FFD700
```

**Описание Timer Events:**

| Timer | Тип | Условие | Действие |
|-------|-----|---------|----------|
| Timer 1 | Duration | 7 days after signup | Check user engagement |
| Timer 2 | Duration | 30 days after first check | Generate monthly report |
| Timer 3 | Cycle | Every 30 days | Repeat process |

### Пример 4: Процесс с Error Handling

```mermaid
flowchart TD
    Start([Start]) --> A[Service Task: Process Payment]
    A --> B{Gateway XOR: Success?}
    B -->|Yes| C[Service Task: Confirm Order]
    B -->|No| D{Gateway XOR: Retry Count < 3?}
    D -->|Yes| E[User Task: Request New Payment]
    E --> A
    D -->|No| F[Error Event: Payment Failed]
    F --> G[User Task: Notify Customer]
    G --> H[Service Task: Cancel Order]
    H --> End1([End: Cancelled])
    C --> I[Service Task: Ship Order]
    I --> J{Gateway XOR: Delivery OK?}
    J -->|Yes| End2([End: Complete])
    J -->|No| K[Error Event: Delivery Failed]
    K --> L[User Task: Process Refund]
    L --> End3([End: Refunded])
    
    style Start fill:#90EE90
    style End1 fill:#FFB6C1
    style End2 fill:#90EE90
    style End3 fill:#FFB6C1
    style F fill:#FF6B6B
    style K fill:#FF6B6B
    style B fill:#FFD700
    style D fill:#FFD700
    style J fill:#FFD700
```

**Обработка ошибок:**

| Error Event | Триггер | Действие | Ответственный |
|-------------|---------|----------|---------------|
| Payment Failed | 3 failed attempts | Cancel order, notify customer | System |
| Delivery Failed | Carrier error | Process refund | Operations |
| Timeout | No response in 24h | Escalate to manager | System |

### Пример 5: Процесс с Message Flow между пулами

```mermaid
flowchart TD
    subgraph Pool_Supplier["Pool: Supplier"]
        S1[Receive Task: Wait for Order]
        S2[User Task: Process Order]
        S3[Service Task: Ship Goods]
        S4[Send Task: Send Invoice]
    end
    
    subgraph Pool_Buyer["Pool: Buyer"]
        B1[Send Task: Submit PO]
        B2[Receive Task: Receive Goods]
        B3[User Task: Verify Goods]
        B4{Gateway XOR: Accept?}
        B5[Service Task: Process Payment]
        B6[Send Task: Send Rejection]
    end
    
    B1 -->|Message Flow: PO| S1
    S1 --> S2
    S2 --> S3
    S3 -->|Message Flow: Goods| B2
    S3 --> S4
    S4 -->|Message Flow: Invoice| B5
    B2 --> B3
    B3 --> B4
    B4 -->|Yes| B5
    B4 -->|No| B6
    B6 -->|Message Flow: Rejection| S2
    
    style B4 fill:#FFD700
```

**Спецификация Message Flows:**

| Message | From | To | Data Payload | Trigger |
|---------|------|-----|--------------|---------|
| Purchase Order | Buyer | Supplier | Order items, quantities, delivery date | Submit PO |
| Goods Shipment | Supplier | Buyer | Items, tracking number, ETA | Ship Goods |
| Invoice | Supplier | Buyer | Amount, due date, payment terms | Send Invoice |
| Rejection Notice | Buyer | Supplier | Rejection reason, return instructions | Send Rejection |

### Пример 6: Параллельный процесс с AND Gateway

```mermaid
flowchart TD
    Start([Start: Order Placed]) --> A[Gateway AND: Fork]
    A --> B[Service Task: Process Payment]
    A --> C[Service Task: Reserve Inventory]
    A --> D[Service Task: Generate Invoice]
    
    B --> E[Gateway AND: Join Payments]
    C --> F[Service Task: Prepare Shipment]
    D --> E
    
    F --> G[Gateway AND: Join Shipping]
    E --> G
    
    G --> H[Service Task: Ship Order]
    H --> I[Service Task: Send Notification]
    I --> End([End])
    
    style Start fill:#90EE90
    style End fill:#FFB6C1
    style A fill:#98FB98
    style E fill:#98FB98
    style G fill:#98FB98
```

## Шаблоны документов

### Шаблон описания процесса

```markdown
# Process: {Название процесса}

**Process ID:** PROC-XXX
**Version:** X.X
**Owner:** {Владелец процесса}
**Last Updated:** DD-MM-YYYY

## Цель процесса
{Описание цели}

## Триггеры
- {Триггер 1}
- {Триггер 2}

## Участники (Pools & Lanes)
| Pool | Lane | Роль |
|------|------|------|
| Pool A | Lane 1 | Описание роли |

## Входные данные
| Данные | Источник | Формат |
|--------|----------|--------|
| Data 1 | System A | JSON |

## Выходные данные
| Данные | Получатель | Формат |
|--------|------------|--------|
| Data 1 | System B | XML |

## KPI процесса
- Среднее время выполнения: X часов
- Количество шагов: X
- Уровень автоматизации: X%

## Диаграмма процесса
{Mermaid диаграмма}
```

### Шаблон таблицы анализа процесса

| ID | Элемент | Тип | Исполнитель | Время | Риски | Улучшения |
|----|---------|-----|-------------|-------|-------|-----------|
| 1 | Task 1 | User Task | Role A | 15 мин | Human error | Автоматизация |
| 2 | Task 2 | Service Task | System | 2 мин | API failure | Retry logic |
| 3 | Gateway | XOR | System | 1 мин | - | - |

## Лучшие практики

### Уровень детализации

- **Strategic Level:** Обзор процессов для руководства
- **Operational Level:** Детали для исполнителей
- **Technical Level:** Детали для автоматизации

### Именование элементов

- **Processes:** Глагол + существительное (Process Order)
- **Tasks:** Глагол + объект (Validate Payment)
- **Events:** Существительное + состояние (Order Received)
- **Gateways:** Вопрос (Payment Valid?)

### Типичные ошибки

1. **Слишком сложные диаграммы** — разбивайте на подпроцессы
2. **Отсутствие обработки ошибок** — добавляйте Error Events
3. **Смешивание уровней** — используйте Call Activity для подпроцессов
4. **Неопределённые исполнители** — всегда указывайте Lanes
5. **Отсутствие начала и конца** — каждый процесс должен иметь Start и End Events

### Оптимизация процессов

**Идентификация проблем:**
- Дублирование действий
- Лишние согласования
- Ручные задачи, которые можно автоматизировать
- Узкие места (bottlenecks)

**Методы оптимизации:**
- Параллелизация задач (AND Gateway)
- Автоматизация рутинных операций (Service Tasks)
- Устранение лишних согласований
- Внедрение самообслуживания (User Tasks → Self-service)

## Связанные навыки

- requirements-analysis — сбор и анализ требований
- use-case-modeling — варианты использования системы
- srs-specification — спецификация требований к ПО
- api-design — проектирование API на основе процессов

---
