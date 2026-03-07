# Стандартная структура проекта для координации режимов KiloCode

## Обзор
Данный шаблон определяет стандартную структуру директорий для обеспечения эффективной координации между режимами KiloCode: Project Manager, System Analyst и Universal Coding Agent.

## Структура директорий

```
project/
│
├── pm_artifacts/                    # Выходные данные Project Manager
│   ├── plans/                       # Планы проектов, расписания
│   │   ├── project_plan.md          # Основной план проекта
│   │   ├── sprint_plan.md           # Планы спринтов
│   │   └── milestone_schedule.md    # Расписание вех
│   │
│   ├── estimates/                   # Бюджетные и временные оценки
│   │   ├── budget_estimate.md       # Бюджетная оценка
│   │   ├── time_estimate.md         # Временная оценка
│   │   └── resource_allocation.md   # Распределение ресурсов
│   │
│   ├── reports/                     # Статусные отчёты, дашборды
│   │   ├── weekly_status.md         # Недельный статус
│   │   ├── stakeholder_report.md    # Отчёт для стейкхолдеров
│   │   └── risk_report.md           # Отчёт по рискам
│   │
│   └── requests/                    # Запросы к специалистам
│       ├── sa_request_001.md        # Запрос к System Analyst
│       ├── dev_request_001.md       # Запрос к Universal Coding Agent
│       └── arch_request_001.md      # Запрос к Architect
│
├── sa_artifacts/                    # Выходные данные System Analyst
│   ├── requirements/                # SRS, User Stories
│   │   ├── SRS.md                   # Спецификация требований
│   │   ├── user_stories/            # Пользовательские истории
│   │   │   ├── US-001.md
│   │   │   └── US-002.md
│   │   └── use_cases/               # Варианты использования
│   │       └── UC-001.md
│   │
│   ├── api_specs/                   # Спецификации API
│   │   ├── openapi.yaml             # OpenAPI спецификация
│   │   └── api_endpoints.md         # Документация эндпоинтов
│   │
│   ├── diagrams/                    # Визуальные модели
│   │   ├── bpmn/                    # BPMN диаграммы
│   │   ├── uml/                     # UML диаграммы
│   │   └── c4/                      # C4 Model диаграммы
│   │
│   ├── data_models/                 # Схемы данных и ERD
│   │   ├── erd.md                   # ER-диаграмма
│   │   ├── database_schema.sql      # Схема БД
│   │   └── data_dictionary.md       # Словарь данных
│   │
│   └── estimates/                   # Оценки для PM
│       ├── labor_estimates.md       # Оценка трудозатрат
│       ├── complexity_assessment.md # Оценка сложности
│       └── risks.md                 # Технические риски
│
├── arch_artifacts/                  # Выходные данные Architect
│   ├── architecture/                # Архитектурные документы
│   │   ├── system_architecture.md   # Системная архитектура
│   │   ├── tech_stack.md            # Технологический стек
│   │   └── infrastructure.md        # Инфраструктура
│   │
│   └── decisions/                   # Architecture Decision Records
│       ├── ADR-001.md               # Решение по архитектуре
│       └── ADR-002.md
│
├── dev_artifacts/                   # Выходные данные Universal Coding Agent
│   ├── progress_reports/            # Отчёты о прогрессе
│   │   ├── sprint_report_001.md     # Отчёт по спринту
│   │   └── daily_standup.md         # Daily standup notes
│   │
│   ├── metrics/                     # Метрики кода
│   │   ├── code_metrics.md          # Метрики кода
│   │   ├── test_coverage.md         # Покрытие тестами
│   │   └── quality_report.md        # Отчёт по качеству
│   │
│   ├── deployment/                  # Артефакты развёртывания
│   │   ├── deployment_guide.md      # Руководство по развёртыванию
│   │   ├── rollback_procedure.md    # Процедура отката
│   │   └── monitoring_setup.md      # Настройка мониторинга
│   │
│   ├── documentation/               # Техническая документация
│   │   ├── api_docs.md              # Документация API
│   │   ├── setup_guide.md           # Руководство по установке
│   │   └── troubleshooting.md       # Устранение неполадок
│   │
│   └── clarification_requests/      # Запросы на уточнение
│       ├── clar_req_001.md          # Запрос к SA
│       └── clar_req_002.md
│
├── src/                             # Исходный код
│   ├── backend/                     # Backend код
│   ├── frontend/                    # Frontend код
│   └── shared/                      # Общие модули
│
├── tests/                           # Тесты
│   ├── unit/                        # Unit тесты
│   ├── integration/                 # Integration тесты
│   └── e2e/                         # End-to-end тесты
│
└── docs/                            # Общая документация проекта
    ├── README.md                    # Основная документация
    ├── CHANGELOG.md                 # История изменений
    └── CONTRIBUTING.md              # Руководство по внесению вклада
```

## Потоки данных между режимами

### 1. Project Manager → System Analyst

| Запрос | Файл | Ответ |
|--------|------|-------|
| Анализ требований | `pm_artifacts/requests/sa_request_XXX.md` | `sa_artifacts/requirements/SRS.md` |
| Оценка трудозатрат | `pm_artifacts/requests/sa_request_XXX.md` | `sa_artifacts/estimates/labor_estimates.md` |
| API спецификация | `pm_artifacts/requests/sa_request_XXX.md` | `sa_artifacts/api_specs/openapi.yaml` |
| Модель данных | `pm_artifacts/requests/sa_request_XXX.md` | `sa_artifacts/data_models/erd.md` |

### 2. Project Manager → Universal Coding Agent

| Запрос | Файл | Ответ |
|--------|------|-------|
| Разработка функционала | `pm_artifacts/requests/dev_request_XXX.md` | `src/`, `tests/` |
| Отчёт о прогрессе | `pm_artifacts/requests/dev_request_XXX.md` | `dev_artifacts/progress_reports/` |
| Метрики | Запрос через new_task | `dev_artifacts/metrics/` |
| Развёртывание | `pm_artifacts/requests/dev_request_XXX.md` | `dev_artifacts/deployment/` |

### 3. Universal Coding Agent → System Analyst

| Запрос | Файл | Ответ |
|--------|------|-------|
| Уточнение требований | `dev_artifacts/clarification_requests/clar_req_XXX.md` | Обновление `sa_artifacts/requirements/` |
| Вопросы по API | `dev_artifacts/clarification_requests/clar_req_XXX.md` | Обновление `sa_artifacts/api_specs/` |

### 4. System Analyst → Project Manager

| Данные | Файл | Использование PM |
|--------|------|------------------|
| Оценки трудозатрат | `sa_artifacts/estimates/labor_estimates.md` | Расчёт бюджета |
| Технические риски | `sa_artifacts/estimates/risks.md` | Планирование рисков |
| Сложность задач | `sa_artifacts/estimates/complexity_assessment.md` | Распределение ресурсов |
