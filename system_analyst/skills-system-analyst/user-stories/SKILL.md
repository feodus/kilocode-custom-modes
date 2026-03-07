---
name: user-stories
description: Написание пользовательских историй с критериями приёмки по методологии Agile: формат User Story, критерии INVEST, Acceptance Criteria в Gherkin, Story Mapping, оценка Story Points
---

# User Stories

> **Meta:** v1.0.0 | 23-02-2026

## Назначение

Навык для написания пользовательских историй (User Stories) с критериями приёмки по методологии Agile. Включает создание историй в стандартном формате, проверку по критериям INVEST, написание Acceptance Criteria в формате Gherkin (Given-When-Then), организацию историй в карту пользовательского опыта (Story Mapping) и оценку сложности в Story Points.

## Когда использовать

Используйте этот навык:
- При формализации требований в формате Agile
- Для создания бэклога продукта (Product Backlog)
- При планировании спринтов (Sprint Planning)
- Для декомпозиции крупных требований на атомарные истории
- При написании критериев приёмки для разработчиков и QA
- Для оценки трудозатрат в Story Points
- При построении User Story Map

## Функции

### User Story Format

Формат пользовательской истории:

```markdown
## US-{ID}: {Название}

**As a** {роль пользователя},
**I want** {желаемая функциональность},
**So that** {получаемая ценность}.

**Acceptance Criteria:**
{Критерии приёмки в формате Gherkin}

**Story Points:** {оценка}
**Priority:** {MoSCoW приоритет}
**Dependencies:** {зависимости от других историй}
```

**Правила написания:**
- Роль должна быть конкретной (не "пользователь", а "зарегистрированный клиент")
- Функциональность должна быть атомарной и тестируемой
- Ценность должна быть понятна бизнесу

### INVEST Criteria

Проверка качества User Story по критериям INVEST:

| Критерий | Описание | Проверка |
|----------|----------|----------|
| **I**ndependent | История не зависит от других историй | Можно ли реализовать отдельно? |
| **N**egotiable | История может быть изменена | Есть ли место для обсуждения? |
| **V**aluable | История приносит ценность бизнесу | Понятна ли ценность заказчику? |
| **E**stimable | Историю можно оценить | Достаточно ли информации для оценки? |
| **S**mall | История достаточно мала | Можно ли завершить за один спринт? |
| **T**estable | Историю можно протестировать | Можно ли написать критерии приёмки? |

**Чек-лист INVEST:**

```markdown
### INVEST Checklist for US-{ID}

- [ ] **Independent:** {Да/Нет — обоснование}
- [ ] **Negotiable:** {Да/Нет — обоснование}
- [ ] **Valuable:** {Да/Нет — обоснование}
- [ ] **Estimable:** {Да/Нет — обоснование}
- [ ] **Small:** {Да/Нет — обоснование}
- [ ] **Testable:** {Да/Нет — обоснование}

**Verdict:** {Ready/Needs Refinement}
```

### Acceptance Criteria

Критерии приёмки в формате Gherkin:

```gherkin
Feature: {Название функциональности}

Scenario: {Название сценария 1}
  Given {предусловие}
  When {действие}
  Then {ожидаемый результат}

Scenario: {Название сценария 2}
  Given {предусловие}
  And {дополнительное предусловие}
  When {действие}
  And {дополнительное действие}
  Then {ожидаемый результат}
  And {дополнительный результат}
```

**Типы сценариев:**
- **Happy Path** — основной успешный сценарий
- **Alternative Flow** — альтернативные варианты развития
- **Edge Cases** — граничные случаи
- **Error Handling** — обработка ошибок

### Story Mapping

Организация историй в карту пользовательского опыта:

```markdown
## User Story Map: {Название продукта}

### Backbone (User Activities)
| Activity 1 | Activity 2 | Activity 3 |
|------------|------------|------------|

### User Tasks (Stories organized by priority)
| Priority | Task 1 | Task 2 | Task 3 |
|----------|--------|--------|--------|
| **Must Have** | US-001 | US-003 | US-005 |
| **Should Have** | US-002 | US-004 | - |
| **Could Have** | US-006 | - | - |
```

**Элементы Story Map:**
- **Backbone** — основные виды деятельности пользователя
- **User Tasks** — конкретные задачи пользователя
- **Slices** — горизонтальные срезы для планирования релизов
- **Priorities** — вертикальное распределение по приоритетам

### Story Points

Оценка сложности по шкале Фибоначчи:

| Points | Сложность | Критерии |
|--------|-----------|----------|
| **1** | Тривиальная | Известное решение, < 2 часов |
| **2** | Очень простая | Простое решение, 2-4 часа |
| **3** | Простая | Стандартное решение, 4-8 часов |
| **5** | Средняя | Требует усилий, 1-2 дня |
| **8** | Сложная | Существенные усилия, 2-4 дня |
| **13** | Очень сложная | Значительные усилия, 1-2 недели |
| **21** | Эпик | Требует декомпозиции |

**Факторы оценки:**
- Объём работы (Volume)
- Сложность (Complexity)
- Риски и неопределённость (Risk/Uncertainty)
- Зависимости (Dependencies)

### Story Decomposition

Декомпозиция крупных историй (Epic → Story → Task):

```markdown
## Epic: {Название эпика}

### Stories:
- US-001: {История 1}
- US-002: {История 2}
- US-003: {История 3}

### Decomposition Rules:
- Epic: > 21 story points → требует декомпозиции
- Story: 1-13 story points → готова к реализации
- Task: технические подзадачи для разработчиков
```

## Интеграция с Project Manager

### Данные для Project Manager

Предоставляет следующие данные для PM:

**Для планирования спринтов:**
- Готовые User Stories с критериями приёмки
- Оценки Story Points для capacity planning
- Зависимости между историями

**Для управления бэклогом:**
- Приоритизированный список историй
- INVEST-валидация историй
- Рекомендации по декомпозиции

**Для отчётности:**
- Velocity команды (на основе завершённых story points)
- Прогресс по эпикам
- Покрытие требований историями

### Взаимодействие

- PM запрашивает User Stories для планирования итераций
- PM получает оценки для расчёта velocity
- PM использует зависимости для планирования релизов
- SA валидирует изменения историй с PM
- PM запрашивает декомпозицию эпиков

## Примеры использования

### Пример 1: User Story для аутентификации

```markdown
## US-001: User Login

**As a** registered user,
**I want to** log into the system,
**So that** I can access my personal dashboard.

**Acceptance Criteria:**
```gherkin
Feature: User Authentication

Scenario: Successful login with valid credentials
  Given I am on the login page
  When I enter valid username "john_doe"
  And I enter valid password "SecurePass123!"
  And I click "Login" button
  Then I should be redirected to my dashboard
  And I should see "Welcome, john_doe" in the header
  And a session cookie should be created

Scenario: Login with invalid credentials
  Given I am on the login page
  When I enter username "john_doe"
  And I enter invalid password "wrong_password"
  And I click "Login" button
  Then I should see error message "Invalid username or password"
  And I should remain on the login page
  And the password field should be cleared

Scenario: Account locked after multiple failed attempts
  Given I am on the login page
  And I have failed login 2 times previously
  When I enter username "john_doe"
  And I enter invalid password "wrong_password"
  And I click "Login" button
  Then I should see error message "Account locked. Please try again in 30 minutes"
  And I should not be able to attempt login for 30 minutes

Scenario: Login with remember me option
  Given I am on the login page
  When I enter valid credentials
  And I check "Remember me" checkbox
  And I click "Login" button
  Then I should be redirected to my dashboard
  And a persistent cookie should be created with 30-day expiration
```

**Story Points:** 3
**Priority:** Must Have
**Dependencies:** None
**Epic:** Authentication System

### INVEST Validation for US-001:

```markdown
### INVEST Checklist for US-001

- [x] **Independent:** Да — история не зависит от других историй
- [x] **Negotiable:** Да — можно изменить критерии приёмки
- [x] **Valuable:** Да — пользователи могут получить доступ к системе
- [x] **Estimable:** Да — стандартная функциональность, оценка 3 points
- [x] **Small:** Да — можно завершить за 1-2 дня
- [x] **Testable:** Да — есть чёткие критерии приёмки

**Verdict:** Ready for Sprint
```

### Пример 2: Story Mapping для E-Commerce

```markdown
## User Story Map: E-Commerce Platform

### Backbone (User Activities)
| Browse Products | Manage Cart | Checkout | Track Order |
|-----------------|-------------|----------|-------------|

### User Tasks (Stories organized by priority)

| Priority | Browse Products | Manage Cart | Checkout | Track Order |
|----------|-----------------|-------------|----------|-------------|
| **Must Have** | US-001: View catalog | US-005: Add to cart | US-008: Checkout flow | US-012: View order status |
| | US-002: Search products | US-006: Remove from cart | US-009: Payment processing | |
| | US-003: View product details | US-007: Update quantity | US-010: Shipping selection | |
| **Should Have** | US-004: Filter by category | | US-011: Apply discount code | US-013: Order notifications |
| **Could Have** | | | US-014: Gift wrapping | US-015: Order history |

### Release Slices:
- **MVP (Sprint 1-2):** US-001, US-002, US-003, US-005, US-006, US-008, US-009
- **Release 1.0 (Sprint 3-4):** US-004, US-007, US-010, US-012
- **Release 1.1 (Sprint 5):** US-011, US-013, US-014, US-015
```

### Пример 3: Оценка Story Points

```markdown
## Story Points Estimation Session

### US-008: Checkout Flow

**Complexity Factors:**
| Factor | Assessment | Points |
|--------|------------|--------|
| Volume | Multiple steps, validation logic | +2 |
| Complexity | Integration with payment gateway | +3 |
| Risk | New payment provider integration | +2 |
| Dependencies | Depends on US-005, US-006 | +1 |

**Team Estimates (Planning Poker):**
| Developer | Estimate |
|-----------|----------|
| Dev 1 | 8 |
| Dev 2 | 5 |
| Dev 3 | 8 |
| Dev 4 | 5 |
| QA | 8 |

**Final Estimate:** 8 points (consensus after discussion)

**Rationale:** Integration with payment gateway adds complexity. Need to handle multiple payment methods and error scenarios.
```

### Пример 4: Декомпозиция эпика

```markdown
## Epic: EP-001 User Profile Management
**Initial Estimate:** 21+ points

### Decomposed Stories:

**US-020: View Profile**
- As a registered user, I want to view my profile information
- Points: 2
- Priority: Must Have

**US-021: Edit Profile**
- As a registered user, I want to edit my profile information
- Points: 3
- Priority: Must Have

**US-022: Change Password**
- As a registered user, I want to change my password
- Points: 3
- Priority: Must Have

**US-023: Upload Avatar**
- As a registered user, I want to upload my profile picture
- Points: 5
- Priority: Should Have

**US-024: Manage Addresses**
- As a registered user, I want to manage my delivery addresses
- Points: 5
- Priority: Should Have

**US-025: Privacy Settings**
- As a registered user, I want to configure my privacy settings
- Points: 3
- Priority: Could Have

**Total Decomposed:** 21 points across 6 stories
```

## Шаблоны документов

### Шаблон User Story

```markdown
## US-{ID}: {Название}

**As a** {роль},
**I want** {функциональность},
**So that** {ценность}.

**Acceptance Criteria:**
```gherkin
Feature: {Название}

Scenario: {Сценарий 1}
  Given {предусловие}
  When {действие}
  Then {результат}
```

**Story Points:** {1|2|3|5|8|13|21}
**Priority:** {Must Have|Should Have|Could Have|Won't Have}
**Dependencies:** {список US-ID или None}
**Epic:** {EP-ID}
**Notes:** {дополнительная информация}
```

### Шаблон таблицы историй для бэклога

| ID | Title | As a | I want | So that | Points | Priority | Status |
|----|-------|------|--------|---------|--------|----------|--------|
| US-001 | User Login | registered user | log into the system | access my dashboard | 3 | Must | Done |
| US-002 | Password Reset | registered user | reset my password | recover account access | 5 | Should | In Progress |
| US-003 | Profile Edit | registered user | edit my profile | keep info updated | 3 | Should | To Do |

## Лучшие практики

### Написание User Stories

1. **Используйте язык бизнеса** — избегайте технических терминов
2. **Будьте конкретны** — "зарегистрированный пользователь" вместо "пользователь"
3. **Описывайте ценность** — чётко формулируйте "so that"
4. **Держите истории атомарными** — одна история = одна функциональность

### Acceptance Criteria

1. **Покрывайте все сценарии** — happy path, alternative, error
2. **Используйте измеримые критерии** — избегайте субъективных оценок
3. **Пишите с точки зрения пользователя** — не описывайте реализацию
4. **Оставляйте место для уточнения** — детали обсуждаются с разработчиками

### Оценка Story Points

1. **Используйте Planning Poker** — коллективная оценка
2. **Оценивайте относительно** — сравнивайте с эталонными историями
3. **Учитывайте все факторы** — объём, сложность, риски, зависимости
4. **Переоценивайте при изменении** — актуализируйте оценки

### Типичные ошибки

1. **Слишком крупные истории** — требуют декомпозиции
2. **Отсутствие ценности** — "so that" не понятен бизнесу
3. **Технические истории** — фокус на решение, а не на ценность
4. **Нет критериев приёмки** — невозможно протестировать
5. **Неопределённые зависимости** — блокируют планирование

## Связанные навыки

- requirements-analysis — сбор и анализ требований
- srs-specification — спецификация требований к ПО
- use-case-modeling — варианты использования
- bpmn-modeling — моделирование бизнес-процессов
- api-design — проектирование API

---
