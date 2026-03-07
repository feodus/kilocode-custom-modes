---
name: gherkin-specifications
description: Написание спецификаций на языке Gherkin для BDD тестирования. Использовать при создании feature-файлов, описании сценариев поведения системы, подготовке к автоматизированному тестированию.
---

# Gherkin Specifications

> **Meta:** v1.0.0 | 23-02-2026

## Назначение

Навык для создания спецификаций на языке Gherkin — формальном языке описания поведения системы в стиле BDD (Behavior-Driven Development). Gherkin позволяет записывать требования в виде исполняемых сценариев, понятных всем участникам команды: аналитикам, разработчикам, тестировщикам и бизнес-заказчикам.

Gherkin является основой для BDD-фреймворков автоматизации, таких как Cucumber, Behave, SpecFlow и подобных. Этот навык охватывает все элементы языка Gherkin, правила написания сценариев и их интеграцию с процессом разработки.

## Когда использовать

Используйте этот навык:

- При переходе к фазе тестирования в SDLC
- Для создания исполняемой документации (executable specifications)
- При необходимости описания поведения системы на языке бизнеса
- Для подготовки данных к автоматизированному BDD-тестированию
- При создании feature-файлов для Cucumber/Behave/SpecFlow
- Для улучшения коммуникации между техническими и нетехническими участниками
- При написании пользовательских историй с критериями приёмки в Gherkin-формате

## Структура Gherkin

### Feature

Блок `Feature` — основной элемент Gherkin, описывающий функцию или возможность системы:

```gherkin
Feature: {Название функции}
  As a {роль}
  I want {возможность}
  So that {выгода/ценность}
```

**Элементы Feature:**

| Элемент | Описание | Обязательно |
|---------|---------|-------------|
| Feature | Название функции | Да |
| As a | Роль пользователя | Рекомендуется |
| I want | Желаемое действие | Рекомендуется |
| So that | Бизнес-ценность | Рекомендуется |

**Пример:**

```gherkin
Feature: User Authentication
  As a registered user
  I want to log into the system
  So that I can access my personal dashboard
```

### Scenario

`Scenario` — отдельный тестовый сценарий внутри Feature:

```gherkin
Scenario: {Название сценария}
  Given {предусловие}
  When {действие}
  Then {ожидаемый результат}
```

### Steps (Given/When/Then/And/But)

Основные ключевые слова Gherkin:

| Ключевое слово | Назначение | Рекомендация |
|----------------|------------|--------------|
| Given | Предусловие, начальное состояние | Использовать для предусловий |
| When | Действие пользователя или системы | Основное действие сценария |
| Then | Ожидаемый результат | Проверка результата |
| And | Добавление условия/действия/результата | Использовать с Given/When/Then |
| But | Противоположное условие/результат | Использовать для негативных случаев |

**Правила использования Steps:**

1. **Given** — описывает контекст/состояние системы
2. **When** — описывает действие, которое мы тестируем
3. **Then** — описывает ожидаемый результат

**Пример:**

```gherkin
Scenario: Successful login
  Given I am on the login page
  When I enter username "admin"
  And I enter password "password123"
  And I click the "Login" button
  Then I should see the dashboard
  And I should see "Welcome" message
```

### Scenario Outline

`Scenario Outline` — параметризованный сценарий для тестирования с разными входными данными:

```gherkin
Scenario Outline: {Описание}
  Given {условие с <переменной>}
  When {действие с <переменной>}
  Then {ожидаемый результат}

  Examples:
    | variable |
    | value1   |
    | value2   |
```

**Пример:**

```gherkin
Scenario Outline: Login validation
  Given I am on the login page
  When I enter username "<username>"
  And I enter password "<password>"
  Then I should see error message "<error>"

  Examples:
    | username | password  | error                  |
    | empty   | anypass   | Username is required   |
    | user1   | empty     | Password is required   |
    | invalid | wrong     | Invalid credentials    |
```

### Background

`Background` — общие предусловия для всех сценариев в Feature:

```gherkin
Background:
  Given the system is running
  And the database is accessible
  And I am an authenticated user
```

**Правила использования Background:**

1. Использовать только для общих предусловий (более 2 сценариев)
2. Избегать длинных цепочек в Background
3. Не использовать Background для данных, специфичных для сценария

### Tags

`Tags` — метаданные для категоризации сценариев:

```gherkin
@authentication @smoke
Feature: User Authentication
  ...
  
  @happy-path
  Scenario: Successful login
  ...
  
  @negative @validation
  Scenario: Invalid login
  ...
```

**Стандартные теги:**

| Тег | Назначение |
|-----|------------|
| @smoke | Smoke-тесты (критический функционал) |
| @regression | Регрессионные тесты |
| @negative | Негативные сценарии |
| @security | Тесты безопасности |
| @performance | Нагрузочные тесты |
| @wip | Work in progress (не готовы) |

## Интеграция с Universal Coding Agent

### Данные для Universal Coding Agent

При передаче Gherkin-спецификаций в Universal Coding Agent для автоматизации:

**Структура проекта для BDD:**

```
project/
├── features/
│   ├── authentication.feature
│   ├── user_management.feature
│   └── ...
├── steps/
│   ├── authentication_steps.py
│   └── ...
├── environment.py
└── requirements.txt
```

**Требования к step definitions:**

| Элемент | Описание |
|---------|----------|
| Step Definitions | Python/Java/JavaScript код, связывающий Gherkin с кодом |
| Hooks | setup/teardown логика (Before, After, etc.) |
| Data Tables | Работа с таблицами в Gherkin |
| Scenario Outline | Параметризация тестов |

**Пример Step Definition (Python/Behave):**

```python
from behave import given, when, then

@given('I am on the login page')
def step_login_page(context):
    context.page.navigate_to("/login")

@when('I enter username "{username}"')
def step_enter_username(context, username):
    context.page.enter_username(username)

@when('I click the "{button}" button')
def step_click_button(context, button):
    context.page.click_button(button)

@then('I should see the dashboard')
def step_verify_dashboard(context):
    assert context.page.is_dashboard_visible()
```

### Рекомендации по автоматизации

1. **Именование файлов:** `*.feature` для Gherkin, `*_steps.py` для step definitions
2. **Структура steps:** Группировать по функциональности
3. **Page Objects:** Использовать паттерн Page Object для UI-взаимодействий
4. **Hooks:** Определять общую логику в `environment.py` (Behave)

## Примеры использования

### Пример 1: Аутентификация пользователя

```gherkin
@authentication @smoke
Feature: User Authentication
  As a registered user
  I want to log into the system
  So that I can access my personal dashboard

  Background:
    Given the authentication system is running
    And the database is accessible

  @happy-path
  Scenario: Successful login with valid credentials
    Given I am on the login page
    When I enter valid username "john_doe"
    And I enter valid password "SecurePass123!"
    And I click the "Login" button
    Then I should be redirected to the dashboard
    And I should see "Welcome, John!" message

  @negative @validation
  Scenario: Login fails with invalid credentials
    Given I am on the login page
    When I enter username "invalid_user"
    And I enter password "wrong_password"
    And I click the "Login" button
    Then I should see error message "Invalid credentials"
    And I should remain on the login page

  @security
  Scenario: Account locked after multiple failed attempts
    Given a user "john_doe" exists in the system
    And the maximum login attempts is 3
    When I fail to login 3 times with username "john_doe"
    Then the account "john_doe" should be locked
    And I should see "Account locked. Contact support." message
```

### Пример 2: Управление пользователями (Scenario Outline)

```gherkin
@user-management @crud
Feature: User Profile Management
  As a user
  I want to manage my profile
  So that I can keep my information up to date

  @positive
  Scenario Outline: Update user profile fields
    Given I am logged in as "test_user"
    And I am on the profile edit page
    When I update the field "<field>" to "<value>"
    And I click "Save" button
    Then the profile should be updated
    And I should see success message "Profile updated"

    Examples:
      | field      | value              |
      | first_name | John               |
      | last_name  | Doe                |
      | email      | john@example.com   |
      | phone      | +7-999-123-45-67   |

  @negative
  Scenario Outline: Validation errors on profile update
    Given I am logged in as "test_user"
    And I am on the profile edit page
    When I update the field "<field>" to "<invalid_value>"
    And I click "Save" button
    Then I should see validation error "<error>"

    Examples:
      | field | invalid_value     | error                        |
      | email | not-an-email      | Invalid email format         |
      | phone | 123               | Phone must be 10+ digits    |
      | name  | (empty)           | Name is required             |
```

### Пример 3: Работа с данными (Data Tables)

```gherkin
@admin @users
Feature: Bulk User Operations
  As an administrator
  I want to perform bulk operations on users
  So that I can efficiently manage multiple accounts

  Scenario: Add multiple users from table
    Given I am on the admin users page
    When I add the following users:
      | username  | email              | role    |
      | user1     | user1@example.com  | editor  |
      | user2     | user2@example.com  | viewer  |
      | user3     | user3@example.com  | editor  |
    Then 3 new users should be created
    And I should see success message "3 users added"

  Scenario: Filter users by role
    Given the following users exist:
      | username | role   |
      | alice    | admin  |
      | bob      | editor |
      | charlie  | viewer |
    When I filter by role "editor"
    Then I should see only:
      | username |
      | bob      |
```

## Лучшие практики

### Написание сценариев

1. **Один сценарий — одно поведение** — избегайте сложных сценариев
2. **Именование по формату:** `Scenario: {действие} with {условие}`
3. **Используйте бизнес-язык** — избегайте технических деталей в Gherkin
4. **Минимизируйте количество Steps** — рекомендуется до 10 шагов
5. **Избегайте условной логики** — Gherkin не поддерживает if/else

### Структура Feature-файлов

1. **Один Feature — один файл** — для удобства навигации
2. **Группировка по функциональности** — директории по модулям
3. **Теги для категоризации** — @smoke, @regression, @module-name
4. **Background — только общее** — не более 3-4 шагов

### Поддержание качества

1. **Трассируемость** — связывать сценарии с требованиями (FR-ID)
2. **Независимость** — сценарии не должны зависеть друг от друга
3. **Повторяемость** — одинаковый результат при многократном запуске
4. **Атомарность** — каждый сценарий проверяет одно поведение

## Связанные навыки

- test-case-design — проектирование тест-кейсов
- user-stories — пользовательские истории с критериями приёмки
- requirements-analysis — анализ требований
- srs-specification — спецификация требований к ПО
- use-case-modeling — варианты использования

---

*Gherkin Specifications — исполняемая документация для BDD-тестирования*
