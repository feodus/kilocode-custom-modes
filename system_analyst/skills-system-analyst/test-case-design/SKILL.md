---
name: test-case-design
description: Создание тест-кейсов и тест-сценариев на основе требований. Использовать при проектировании тестирования, создании тестовой документации, определении граничных условий.
---

# Test Case Design

> **Meta:** v1.0.0 | 23-02-2026

## Назначение

Навык для создания тест-кейсов и тест-сценариев на основе требований. Включает проектирование тестовых случаев, определение граничных условий, создание тестовых данных, формирование матрицы трассируемости и группировку тестов в сценарии. Предназначен для обеспечения качества ПО через систематическое тестирование всех требований.

## Когда использовать

Используйте этот навык:
- При переходе к фазе тестирования в SDLC
- Для создания тестовой документации на основе SRS
- При необходимости покрытия требований тестами
- Для определения граничных условий и edge cases
- При планировании тестовых данных
- Для создания traceability matrix
- При передаче данных QA-команде

## Функции

### Test Case Design

Структура тест-кейса:

```markdown
## TC-{ID}: {Название тест-кейса}

**Requirement:** {Ссылка на требование FR-ID}
**Priority:** {High|Medium|Low}
**Type:** {Functional|Non-Functional|Regression|Smoke}

### Pre-conditions
- Условие 1
- Условие 2

### Test Steps
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Действие 1 | Ожидаемый результат 1 |
| 2 | Действие 2 | Ожидаемый результат 2 |

### Test Data
- {данные для теста}

### Post-conditions
- Ожидаемое состояние после выполнения

### Priority
- {Critical|High|Medium|Low}

### Test Type
- Positive — проверка ожидаемого поведения
- Negative — проверка обработки ошибок
- Boundary — проверка граничных условий
```

**Атрибуты тест-кейса:**
| Атрибут | Описание | Пример |
|---------|----------|--------|
| TC ID | Уникальный идентификатор | TC-001 |
| Title | Название тест-кейса | Successful User Login |
| Requirement | Ссылка на требование | FR-001 |
| Priority | Приоритет | High |
| Type | Тип теста | Functional |
| Pre-conditions | Предусловия | User exists in system |
| Steps | Шаги выполнения | 5 steps |
| Expected Result | Ожидаемый результат | Dashboard displayed |
| Status | Статус | Ready/In Progress |

### Test Scenarios

Группировка тест-кейсов по логическим сценариям:

```markdown
## TS-{ID}: {Название тестового сценария}

**Description:** {Описание сценария}
**Related Requirements:** {Список FR-ID}

### Test Cases
| TC ID | Test Case Name | Priority |
|-------|----------------|----------|
| TC-001 | ... | High |
| TC-002 | ... | Medium |

### Test Flow
1. {Описание потока}
2. {Описание потока}
```

**Типы сценариев:**
- **Happy Path** — успешное выполнение основного сценария
- **Alternative Flow** — альтернативные варианты
- **Error Handling** — обработка ошибок
- **Boundary Testing** — граничные условия

### Edge Cases

Определение граничных условий:

**Категории Edge Cases:**
| Категория | Описание | Примеры |
|-----------|---------|---------|
| Boundary Values | Граничные значения | min/max, first/last |
| Empty Values | Пустые значения | null, "", [] |
| Invalid Data | Невалидные данные | wrong format, overflow |
| Concurrency | Параллельный доступ | race conditions |
| Performance | Нагрузка | large data, timeout |
| Security | Безопасность | SQL injection, XSS |

**Методы определения:**
- Equivalence Partitioning — разбиение на классы эквивалентности
- Boundary Value Analysis — анализ граничных значений
- Decision Table Testing — таблицы решений
- State Transition Testing — переходы состояний

### Test Data Requirements

Определение тестовых данных:

```markdown
## Test Data Requirements

### Required Test Data
| Data | Type | Source | Purpose |
|------|------|--------|---------|
| Username | String | Generated | Login tests |
| Email | Email | Generated | Registration |
| Credit Card | Card | Mock data | Payment tests |

### Test Data Categories
- **Valid Data** — валидные данные для positive tests
- **Invalid Data** — невалидные данные для negative tests
- **Boundary Data** — граничные значения
- **Large Data** — данные для performance tests

### Data Preparation
- Test data creation scripts
- Test data cleanup procedures
- Data masking for sensitive information
```

### Traceability Matrix

Матрица трассируемости требований:

```markdown
## Traceability Matrix

| Requirement | TC ID | TC Name | Priority | Status |
|-------------|-------|---------|----------|--------|
| FR-001 | TC-001, TC-002, TC-003 | Login tests | High | Ready |
| FR-002 | TC-004, TC-005 | Registration | High | Ready |
| NFR-001 | TC-010 | Performance | Medium | In Progress |

### Coverage Metrics
- Total Requirements: {N}
- Covered by Tests: {N}
- Coverage: {X}%

### Critical Path Testing
| Requirement | Priority | Test Coverage |
|-------------|----------|---------------|
| FR-001 | Critical | 100% |
| FR-002 | Critical | 100% |
```

## Интеграция с Project Manager

### Данные для Project Manager

Предоставляет следующие данные для PM:

**Для оценки QA:**
- Общее количество тест-кейсов
- Количество по приоритетам (Critical/High/Medium/Low)
- Предварительная оценка времени тестирования
- Требования к тестовым данным

**Для планирования:**
- Покрытие требований тестами (%)
- Критические тест-кейсы (blocking)
- Зависимости от требований
- Риски неполного покрытия

**Для отчётности:**
- Статус покрытия требований
- Тест-кейсы по категориям
- Готовность к UAT

### Взаимодействие

- PM запрашивает тест-кейсы для планирования QA-работ
- PM получает метрики покрытия для отчётности
- PM использует данные для координации с QA-командой
- SA уточняет граничные условия с разработчиками

## Примеры использования

### Пример 1: Тест-кейс для авторизации

```markdown
## TC-001: Successful User Login

**Requirement:** FR-001 User Authentication
**Priority:** High
**Type:** Functional

### Pre-conditions
- User exists in system with credentials:
  - Username: "test_user"
  - Password: "TestPass123!"
- User is not logged in
- Login page is accessible

### Test Steps
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to login page | Login form is displayed |
| 2 | Enter valid username "test_user" | Username is accepted and displayed |
| 3 | Enter valid password "TestPass123!" | Password is masked with asterisks |
| 4 | Click "Login" button | System processes authentication |
| 5 | Verify redirect | User is redirected to dashboard |

### Test Data
- Username: test_user
- Password: TestPass123!

### Post-conditions
- User session is created in database
- User is authenticated
- Dashboard page is displayed
- Session cookie is set

### Priority: Critical
### Test Type: Positive
```

### Пример 2: Тест-кейс для граничных условий

```markdown
## TC-015: Password Length Validation

**Requirement:** FR-001 User Authentication
**Priority:** High
**Type:** Boundary

### Pre-conditions
- User is on registration page

### Test Steps
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter password with 5 characters | Error: "Password too short" |
| 2 | Enter password with 6 characters | Password accepted |
| 3 | Enter password with 50 characters | Password accepted |
| 4 | Enter password with 51 characters | Error: "Password too long" |

### Boundary Values Tested
- Min length: 6 characters
- Max length: 50 characters

### Priority: High
### Test Type: Boundary
```

### Пример 3: Тестовый сценарий

```markdown
## TS-001: User Authentication

**Description:** Complete user authentication flow
**Related Requirements:** FR-001, FR-002, FR-003

### Test Cases
| TC ID | Test Case Name | Priority |
|-------|----------------|----------|
| TC-001 | Successful Login | Critical |
| TC-002 | Invalid Username | High |
| TC-003 | Invalid Password | High |
| TC-004 | Account Locked | High |
| TC-005 | Session Timeout | Medium |
| TC-006 | Remember Me Function | Medium |
| TC-007 | Logout | High |

### Test Flow
1. Start with TC-001 (baseline)
2. Execute TC-002, TC-003 (negative scenarios)
3. Execute TC-004 (account security)
4. Execute TC-005, TC-006 (session management)
5. End with TC-007 (cleanup)

### Estimated Duration: 30 minutes
```

### Пример 4: Traceability Matrix

```markdown
## Traceability Matrix: User Management Module

| Requirement | Description | TC IDs | Coverage | Status |
|-------------|-------------|--------|----------|--------|
| FR-001 | User Login | TC-001, TC-002, TC-003, TC-004 | 100% | Ready |
| FR-002 | User Registration | TC-010, TC-011, TC-012, TC-013 | 100% | Ready |
| FR-003 | Password Reset | TC-020, TC-021, TC-022 | 75% | In Progress |
| FR-004 | Profile Edit | TC-030, TC-031 | 50% | Pending |
| NFR-001 | Response Time < 2s | TC-040 | 100% | Ready |
| NFR-002 | Concurrent Users 1000+ | TC-041, TC-042 | 100% | Ready |

### Summary
- Total Requirements: 6
- Fully Covered: 3 (50%)
- Partially Covered: 2 (33%)
- Not Covered: 1 (17%)
- Critical Requirements Coverage: 100%
```

## Шаблоны документов

### Шаблон тест-кейса

```markdown
## TC-{ID}: {Название}

**Requirement:** {FR-ID}
**Priority:** {Critical|High|Medium|Low}
**Type:** {Functional|Non-Functional|Regression|Smoke}

### Pre-conditions
- Условие 1
- Условие 2

### Test Steps
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | | |
| 2 | | |

### Test Data
- {данные}

### Post-conditions
- {ожидаемое состояние}

### Notes
- {дополнительные заметки}
```

### Шаблон тестового сценария

```markdown
## TS-{ID}: {Название сценария}

**Description:** {Описание}
**Module:** {Название модуля}
**Related Requirements:** {FR-001, FR-002}

### Test Cases
| TC ID | Name | Priority |
|-------|------|----------|
| TC-XXX | | |

### Prerequisites
- {что требуется перед запуском}

### Expected Duration
- {время выполнения}
```

### Шаблон матрицы трассируемости

```markdown
## Traceability Matrix: {Модуль/Система}

| Requirement | Description | TC IDs | Coverage % | Status |
|-------------|-------------|--------|------------|--------|
| FR-001 | | | | |
| FR-002 | | | | |

### Coverage Summary
- Total: N
- Critical Coverage: N%
- High Priority Coverage: N%
```

## Лучшие практики

### Проектирование тест-кейсов

1. **Один тест-кейс — одна проверка** — избегайте комплексных проверок
2. **Независимость тестов** — каждый тест может выполняться отдельно
3. **Повторяемость** — тесты дают одинаковый результат при одинаковых данных
4. **Понятные названия** — название должно описывать что проверяется
5. **Полнота шагов** — каждый шаг должен быть выполнимым

### Определение граничных условий

1. **Анализ требований** — ищите числовые ограничения, форматы, размеры
2. **Классы эквивалентности** — группируйте похожие значения
3. **Граничные значения** — тестируйте значения до, на и после границы
4. **Negative testing** — проверяйте невалидные входные данные

### Traceability

1. **Один-ко-многим** — одно требование может покрываться несколькими тестами
2. **Полнота** — все требования должны иметь тестовое покрытие
3. **Приоритизация** — критические требования требуют большего покрытия

## Связанные навыки

- requirements-analysis — анализ требований
- user-stories — пользовательские истории с критериями приёмки
- srs-specification — спецификация требований
- use-case-modeling — варианты использования
- quality-metrics (PM) — метрики качества

---

*Test Case Design — обеспечение качества через систематическое тестирование*
