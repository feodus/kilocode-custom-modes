# Инструкция по настройке Universal Coding Agent с навыками (Skills)

> **Meta:** v2.0.0 | 15.02.2026

## Обзор

Данная инструкция описывает, как настроить и использовать режим **Universal Coding Agent** с мультитехнологичными навыками (skills) в новом проекте.

## Компоненты

### 1. Universal Coding Agent (режим)

Файл: [`universal-coding-agent_v1-4.yaml`](universal-coding-agent_v1-4.yaml)

- Расширенный AI-агент для универсальной разработки
- Поддержка всех основных языков программирования и фреймворков
- Автоматическая интеграция со специализированными навыками

### 2. Навыки (Skills)

Директория: `skills-universal-coding-agent/`

**17 навыков, разделённых по категориям:**

| Категория | Навыки |
|-----------|--------|
| **Backend (Python)** | `django-development`, `fastapi-development`, `python-project-setup`, `python-testing`, `moex-bond-api-python` |
| **Backend (JS/TS)** | `express-api-development`, `typescript-best-practices` |
| **Frontend** | `react-nextjs-development`, `tailwind-css` |
| **DevOps & CI/CD** | `docker-kubernetes`, `github-actions-ci`, `gitlab-ci-cd` |
| **Database** | `postgresql-development` |
| **Architecture & API** | `clean-architecture`, `rest-api-design` |
| **Specialized** | `telegram-bot-development`, `excel-vba-development` |

---

## Шаг 1: Копирование файлов в новый проект

### 1.1 Копирование режима

Скопируйте файл [`universal-coding-agent_v1-4.yaml`](universal-coding-agent_v1-4.yaml) в корень вашего проекта:

```
ваш-проект/
├── .kilocodemodes              # Добавьте конфигурацию режима
└── ... (остальные файлы проекта)
```

### 1.2 Копирование навыков

Создайте директорию `.kilocode/skills-universal-coding-agent/` и скопируйте нужные навыки:

```
ваш-проект/
└── .kilocode/
    └── skills-universal-coding-agent/
        ├── clean-architecture/
        │   └── SKILL.md
        ├── django-development/
        │   └── SKILL.md
        ├── docker-kubernetes/
        │   └── SKILL.md
        ├── ... (другие навыки)
        └── typescript-best-practices/
            └── SKILL.md
```

**Примечание:** Вы можете скопировать только те навыки, которые актуальны для вашего проекта.

---

## Шаг 2: Интеграция режима в проект

### 2.1 Добавление режима в .kilocodemodes

Откройте (или создайте) файл `.kilocodemodes` в корне проекта:

```yaml
customModes:
  - slug: universal-coding-agent
    name: Universal Coding Agent
    iconName: codicon-code
    description: A powerful universal coding agent with extended capabilities covering all major frameworks, best practices, and development workflows - Updated v1.4, 15.02.2026
    whenToUse: Use this mode for comprehensive coding tasks requiring universal language support, advanced tool usage, and cross-framework expertise. Ideal for complex development scenarios spanning multiple technologies.
    roleDefinition: |
      # Universal Coding Agent

      ## Identity and Role
      You are a Universal Coding Agent, an advanced AI coding assistant with extensive knowledge across all programming languages, frameworks, and development practices.

      ## Technology Agnostic Approach
      - Support all major programming languages: JavaScript/TypeScript, Python, Java, C#, Go, Rust, PHP, Ruby, etc.
      - Framework support includes: React, Vue, Angular, Next.js, Svelte, Node.js, Django, Flask, FastAPI, Spring Boot, etc.
      - Follow language-specific best practices and idioms

      [Полное содержимое roleDefinition из universal-coding-agent_v1-4.yaml]
    groups:
      - read
      - edit
      - browser
      - command
      - mcp
    source: project
```


---

## Шаг 3: Проверка работоспособности

### 3.1 Перезагрузка VS Code

После копирования файлов перезагрузите VS Code:

- Нажмите `Cmd+Shift+P` (Mac) или `Ctrl+Shift+P` (Windows)
- Введите "Developer: Reload Window"
- Нажмите Enter

### 3.2 Проверка доступности режима

1. Откройте KiloCode в VS Code
2. В списке режимов должен появиться **Universal Coding Agent**
3. Выберите этот режим

### 3.3 Проверка навыков

Для проверки доступности навыков спросите агента:

- "Какие навыки у тебя доступны?"
- "What skills do you have available?"

Агент должен перечислить установленные навыки.

---

## Шаг 4: Использование навыков

### 4.1 Автоматическая активация

Навыки активируются автоматически, когда запрос соответствует их описанию:

| Навык | Примеры запросов |
|-------|------------------|
| `react-nextjs-development` | "создай Next.js приложение", "добавь App Router" |
| `fastapi-development` | "создай API", "разработай FastAPI эндпоинт" |
| `django-development` | "создай Django проект", "добавь модель" |
| `docker-kubernetes` | "контейнеризируй приложение", "создай Dockerfile" |
| `github-actions-ci` | "настрой CI/CD", "создай пайплайн" |
| `telegram-bot-development` | "создай Telegram бота", "добавь обработчик" |
| `postgresql-development` | "оптимизируй запрос", "создай индекс" |
| `tailwind-css` | "стилизуй компонент", "добавь Tailwind" |

### 4.2 Явный вызов навыка

Вы можете явно указать агенту использовать конкретный навык:

```
Use the docker-kubernetes skill to create a Docker Compose setup
```

```
Используй навык react-nextjs-development для создания компонента
```

---

## Структура директорий после настройки

```
ваш-проект/
├── .kilocodemodes                    # Конфигурация режимов
├── .kilocode/
│   └── skills-universal-coding-agent/
│       ├── clean-architecture/
│       │   └── SKILL.md
│       ├── django-development/
│       │   └── SKILL.md
│       ├── docker-kubernetes/
│       │   └── SKILL.md
│       └── ... (другие навыки)
├── src/                              # Исходный код
├── tests/                            # Тесты
├── pyproject.toml / package.json     # Конфигурация проекта
└── README.md
```

---

## Устранение проблем

### Режим не отображается

**Решение:**
1. Проверьте синтаксис YAML в `.kilocodemodes`
2. Убедитесь, что файл режима находится в правильном месте
3. Перезагрузите VS Code

### Навыки не активируются

**Решение:**
1. Проверьте наличие директории `.kilocode/skills-universal-coding-agent/`
2. Убедитесь, что файлы `SKILL.md` находятся внутри поддиректорий
3. Проверьте, что поле `name` в frontmatter совпадает с именем директории
4. Перезагрузите VS Code

### Навыки работают некорректно

**Решение:**
1. Проверьте формат frontmatter в каждом `SKILL.md`
2. Убедитесь в наличии обязательных полей `name` и `description`
3. Проверьте Output panel: `View → Output → "Kilo Code"`

---

## Расширение набора навыков

Вы можете добавлять собственные навыки в директорию `.kilocode/skills-universal-coding-agent/`:

### Пример: Создание нового навыка

1. Создайте директорию:
   ```
   .kilocode/skills-universal-coding-agent/my-custom-skill/
   ```

2. Создайте файл `SKILL.md`:
   ```markdown
   ---
   name: my-custom-skill
   description: Описание навыка и когда его использовать. Включите ключевые слова для автоматической активации.
   ---

   # My Custom Skill

   Подробные инструкции для агента...

   ## Примеры использования
   - Пример 1
   - Пример 2
   ```

3. Перезагрузите VS Code

---

## Глобальные навыки (опционально)

Для использования навыков во всех проектах, создайте директорию глобальных навыков:

**Mac/Linux:**
```
~/.kilocode/skills-universal-coding-agent/
```

**Windows:**
```
C:\Users\YourUsername\.kilocode\skills-universal-coding-agent\
```

**Приоритет:** Навыки проекта переопределяют глобальные навыки с тем же именем.

---

## Полный список навыков

| Навык | Описание |
|-------|----------|
| `clean-architecture` | Принципы чистой архитектуры для проектирования приложений |
| `django-development` | Разработка на Django с лучшими практиками |
| `docker-kubernetes` | Контейнеризация и оркестрация с Docker и Kubernetes |
| `excel-vba-development` | Разработка VBA-решений для Microsoft Excel |
| `express-api-development` | Разработка REST API на Express.js |
| `fastapi-development` | Разработка API на FastAPI |
| `github-actions-ci` | Настройка CI/CD с GitHub Actions |
| `gitlab-ci-cd` | Настройка CI/CD с GitLab CI/CD |
| `moex-bond-api-python` | Работа с API Московской биржи (облигации) |
| `postgresql-development` | Работа с PostgreSQL, оптимизация запросов |
| `python-project-setup` | Настройка Python-проектов |
| `python-testing` | Тестирование Python-приложений |
| `react-nextjs-development` | Разработка React и Next.js приложений |
| `rest-api-design` | Проектирование REST API |
| `tailwind-css` | Стилизация с Tailwind CSS |
| `telegram-bot-development` | Разработка Telegram-ботов с CI/CD |
| `typescript-best-practices` | Лучшие практики TypeScript |

---

## Заключение

После выполнения всех шагов у вас будет полностью настроенный **Universal Coding Agent** с мультитехнологичными навыками. Агент будет автоматически использовать соответствующие навыки в зависимости от контекста задачи.

### Основные преимущества

1. **Универсальность** — поддержка 17+ технологий и фреймворков
2. **Автоматическая активация** — навыки срабатывают по контексту запроса
3. **Расширяемость** — возможность добавления собственных навыков
4. **Согласованность** — единые стандарты для разных типов проектов
5. **Кросс-фреймворк экспертиза** — лучшими практиками для каждой технологии
