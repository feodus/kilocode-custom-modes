# KiloCode Custom Modes

> **Last Updated:** 10-03-2026 16:34:00 UTC+3 | Branch: master | Commit: 056da89 | Version: 1.21.0

Коллекция пользовательских режимов для расширения функциональности KiloCode. Каждый каталог — автономный проект со специфическими возможностями для решения задач в своей области.

## Пользовательские режимы

Проект включает **одиннадцать режимов**:

| Режим | Назначение |
|-------|------------|
| **System Analyst** | Анализ требований, проектирование API, BPMN, UML |
| **Orchestrator** | Координация сложных рабочих процессов |
| **Project Manager** | Управление проектами, расчёт бюджетов |
| **TG Bot Expert** | Разработка Telegram-ботов с CI/CD |
| **Universal Coding Agent** | Универсальная разработка (18+ навыков) |
| **Excel VBA Coder** | VBA-решения для Microsoft Excel |
| **Keenetic & Synology Admin** | Администрирование сетевого оборудования |
| **Moscow Estate Expert** | Юридические консультации по недвижимости |
| **Documentation Specialist** | Техническая документация |
| **Marketer** | Маркетинговые стратегии и инструменты продвижения |
| **Tester** | Тестирование программного обеспечения |

## Структура проекта

```
kilocode-custom-modes/
├── .gitignore                    # Файл игнорирования Git
├── .kilocodemodes               # Конфигурация KiloCode
├── LICENSE                      # Лицензия MIT
├── AGENTS.md                   # Документация для AI-агентов
├── Readme.md                    # Документация проекта
├── sync-to-github-universal.sh  # Скрипт синхронизации с GitHub
├── .kilocode/                   # Конфигурация KiloCode
├── admin-keenetic-syn/          # Режим Keenetic & Synology Admin
├── universal-coding-agent/      # Режим Universal Coding Agent
│   ├── universal-coding-agent_v1-6.yaml
│   ├── SKILLS_SETUP_INSTRUCTIONS.md
│   └── skills-universal-coding-agent/  # Навыки
├── codicon-preview/             # Превью иконок VSCode Codicons
├── excel-vba-coder/             # Режим Excel VBA Coder
├── marketer/                    # Режим Marketer
│   ├── marketer.yaml            # Конфигурация режима
│   └── skills-marketer/        # Навыки Marketer
├── MoscowEstateExpert/          # Режим Moscow Estate Expert
├── orchestrator/                # Режим Orchestrator
├── project_manager/             # Режим Project Manager
│   ├── Project_manager_v2.yaml   # Конфигурация режима
│   └── skills-project-manager/  # Навыки Project Manager
├── system_analyst/             # Режим System Analyst
│   ├── system_analyst_mode_v1-3.yaml  # Конфигурация режима
│   └── skills-system-analyst/  # Навыки System Analyst
├── tester/                     # Режим Tester
│   ├── tester.yaml             # Конфигурация режима
│   └── skills-tester/          # Навыки Tester
├── tg_bot_expert/               # Режим TG Bot Expert
│   └── ENG/                    # Английская версия
│       ├── TG-Bot-Expert.yaml
│       └── telegram-bot-standards.md
├── dev_artifacts/               # Артефакты разработки
├── pm_artifacts/                # Артефакты Project Manager
└── rule-memory-bank-to-agents/  # Правила миграции
```

## Описание режимов

### System Analyst

**Расположение:** [`system_analyst/`](system_analyst/)

IT-аналитик для инженерии требований (SRS, пользовательские истории), моделирования бизнес-процессов (BPMN 2.0), создания UML-диаграмм, проектирования API (OpenAPI/Swagger) и баз данных (ERD, SQL с CTE и оконными функциями).

### Orchestrator

**Расположение:** [`orchestrator/`](orchestrator/)

Координатор сложных рабочих процессов: разбиение задач на подзадачи, делегирование специализированным режимам, отслеживание прогресса и синтез результатов.

### Project Manager

**Расположение:** [`project_manager/`](project_manager/)

Управление проектами на основе данных от системного аналитика: расчёт бюджетов, оценка рисков, координация команды, создание проектной документации.

### TG Bot Expert

**Расположение:** [`tg_bot_expert/`](tg_bot_expert/)

Разработка Telegram-ботов с GitLab CI/CD, Docker, Clean Architecture. Настройка webhook, Nginx, безопасность.

### Universal Coding Agent

**Расположение:** [`universal-coding-agent/`](universal-coding-agent/)

Универсальная разработка на всех языках (JS/TS, Python, Java, C#, Go, Rust, PHP, Ruby) и фреймворках (React, Vue, Angular, Next.js, Django, FastAPI, Spring Boot). Система навыков с **18+ технологиями**:

| Навык | Описание |
|-------|----------|
| Clean Architecture | Принципы чистой архитектуры |
| Create Custom Modes | Создание пользовательских режимов KiloCode |
| Django Development | Разработка на Django |
| Docker & Kubernetes | Контейнеризация и оркестрация |
| Express API Development | API на Express.js |
| FastAPI Development | API на FastAPI |
| GitHub Actions CI/CD | CI/CD с GitHub Actions |
| GitLab CI/CD | CI/CD с GitLab |
| Kilo Skill Expert | Создание и управление навыками (Skills) для KiloCode |
| MOEX API Python | API Московской биржи (облигации) |
| PostgreSQL Development | Работа с PostgreSQL |
| Python Project Setup | Настройка Python-проектов |
| Python Testing | Тестирование Python |
| React/Next.js Development | React и Next.js приложения |
| REST API Design | Проектирование REST API |
| Tailwind CSS | Стилизация с Tailwind |
| Excel VBA Development | VBA для Excel |
| Telegram Bot Development | Telegram-боты с CI/CD |
| TypeScript Best Practices | Лучшие практики TypeScript |

### Excel VBA Coder

**Расположение:** [`excel-vba-coder/`](excel-vba-coder/)

Разработка VBA-решений для Microsoft Excel: архитектурные принципы, стандарты кодирования, корпоративные приложения.

### Keenetic & Synology Admin

**Расположение:** [`admin-keenetic-syn/`](admin-keenetic-syn/)

Администрирование сетевого оборудования: роутеры Keenetic, NAS Synology (DSM, RAID, бэкапы), VPN, межсетевые экраны.

### Moscow Estate Expert

**Расположение:** [`MoscowEstateExpert/`](MoscowEstateExpert/)

Юридические консультации по недвижимости Москвы: правовая экспертиза сделок, переоборудование, взаимодействие с ДГИ, налоговые расчёты.

### Documentation Specialist
Техническая документация: ясное изложение, поддержка README, CHANGELOG и других форматов (`.md`, `.mdx`, `.txt`, `.rst`, `.adoc`).

### Marketer

**Расположение:** [`marketer/`](marketer/)

Маркетинговые стратегии и инструменты продвижения: SEO, SMM, email-маркетинг, контекстная и таргетированная реклама, веб-аналитика, копирайтинг, контент-стратегия. Система навыков с **21 технологией**:

| Навык | Описание |
|-------|----------|
| seo-optimization | SEO оптимизация: ключевые слова, мета-теги, техническое SEO |
| smm-management | SMM: социальные сети, контент-план, сообщества |
| email-marketing | Email-маркетинг: рассылки, сегментация, автоматизация |
| web-analytics | Веб-аналитика: Google Analytics, Яндекс Метрика |
| context-advertising | Контекстная реклама: Google Ads, Яндекс Директ |
| targeted-advertising | Таргетированная реклама: VK, Telegram, myTarget |
| copywriting | Копирайтинг: тексты для сайтов и рекламы |
| content-strategy | Контент-стратегия: планирование и распространение |
| landing-page-design | Лендинги: структура и оптимизация конверсий |
| visual-content | Визуальный контент: баннеры, инфографика |
| brand-management | Управление брендом: позиционирование |
| market-research | Маркетинговые исследования: ЦА, спрос |
| competitor-analysis | Анализ конкурентов: мониторинг и стратегии |
| marketing-metrics | Маркетинговые метрики: ROI, CAC, LTV |
| unit-economics | Юнит-экономика: расчёт unit-экономики |
| forecasting | Прогнозирование: продажи, трафик |
| budget-management | Управление бюджетом: планирование |
| affiliate-marketing | Партнёрский маркетинг: программы |
| influencer-marketing | Инфлюенсер-маркетинг: размещения |
| campaign-management | Управление кампаниями: запуск и оптимизация |
| marketing-automation | Маркетинговая автоматизация: CRM, воронки |

### Tester
**Расположение:** [`tester/`](tester/)

Эксперт в области тестирования программного обеспечения: создание и выполнение тест-кейсов, автоматизация тестирования, обеспечение качества ПО. Включает 19 навыков для различных видов тестирования:

Навык | Описание |
|-------|----------|
**test-case-design** | Создание тест-кейсов и сценариев: edge cases, test data requirements |
**gherkin-specifications** | Спецификации на языке Gherkin: Feature Files, Given-When-Then |
**api-testing** | Тестирование API (REST, SOAP, GraphQL): функциональность, безопасность, производительность |
**database-testing** | Тестирование баз данных: целостность данных, транзакции, хранимые процедуры |
**ui-testing** | Тестирование пользовательского интерфейса: элементы, взаимодействия, валидации |
**mobile-testing** | Тестирование мобильных приложений: функциональность, производительность, совместимость |
**performance-testing** | Тестирование производительности: нагрузочное, стресс-тестирование |
**security-testing** | Тестирование безопасности: уязвимости, аутентификация, авторизация |
**accessibility-testing** | Тестирование доступности: соответствие стандартам WCAG |
**manual-testing** | Ручное тестирование: функциональность, UX, сценарии использования |
**integration-testing** | Тестирование интеграции: взаимодействие между компонентами |
**python-testing** | Тестирование с использованием Python: pytest, unittest, behave, selenium |
**visual-regression-testing** | Тестирование визуальных регрессий: сравнение скриншотов |
**test-data-management** | Управление тестовыми данными: генерация, подготовка, очистка |
**test-management-tools** | Работа с инструментами управления тестированием: TestRail, Zephyr |
**defect-management** | Управление дефектами: документирование, отслеживание, приоритезация |
**testing-coordination** | Координация процесса тестирования: планирование, распределение задач |
**test-automation-frameworks** | Фреймворки автоматизации: Selenium, Cypress, Playwright, Appium |

## Дополнительные компоненты

### codicon-preview
Справочник иконок VSCode Codicons для визуального оформления режимов.

## Контроль доступа к файлам

Каждый режим реализует детализированный доступ:

| Режим | Разрешённые типы файлов |
|-------|------------------------|
| System Analyst | `.md`, `.mdx`, `.txt`, `.json`, `.yaml`, `.yml`, `.xml`, `.sql`, `.csv`, `.tsv`, `.puml`, `.mermaid`, `.graphql`, `.feature`, `.drawio` |
| Project Manager | `.md`, `.docx`, `.xlsx`, `.xls`, `.csv`, `.pdf`, `.json`, `.yaml`, `.yml` |
| TG Bot Expert | Полный доступ |
| Universal Coding Agent | Полный доступ |
| Excel VBA Coder | `.vba`, `.bas`, `.cls`, `.md`, `.txt` |
| Keenetic & Synology Admin | Конфигурационные файлы и документация |
| Moscow Estate Expert | Юридическая документация |
| Documentation Specialist | `.md`, `.mdx`, `.txt`, `.rst`, `.adoc`, `README`, `CHANGELOG` |
| Marketer | `.md`, `.docx`, `.xlsx`, `.xls`, `.csv`, `.pdf`, `json`, `yaml`, `yml`, `txt` |
| Tester | `.feature`, `.test`, `test_*.py`, `*_test.py`, `*.spec.js`, `*.md`, `.txt`, `.json`, `.yaml`, `.yml`, `.env`, `.ini`, `.cfg`, `.conf`, `.log`, `.xml`, `.html`, `.csv`, `.py`, `.js`, `.ts`, `.java`, `.cs`, `.rb`, `.php`, `.go`, `.rs`, `.cpp`, `.h`, `.sql` |

## Установка и использование

### Установка

1. Клонируйте репозиторий в локальную папку:
   ```bash
   git clone https://github.com/ваш-репозиторий/kilocode-custom-modes.git
   ```

2. Скопируйте нужные файлы режимов в ваш проект или глобальную директорию KiloCode.

3. Для каждого режима, который вы хотите использовать, убедитесь, что соответствующий YAML-файл конфигурации добавлен в настройки KiloCode.

### Использование

1. Откройте проект в VSCode с установленным расширением KiloCode.
2. Перейдите в настройки KiloCode и добавьте пути к YAML-файлам конфигурации нужных режимов.
3. Выберите нужный режим из выпадающего списка в интерфейсе KiloCode.

Назначение каждого режима см. в таблице выше и разделе [Описание режимов](#описание-режимов).

## История изменений

### v1.21.0 (10-03-2026)

#### Изменено
- Реорганизация навыков Project Manager: удалены устаревшие навыки, добавлены новые
- Обновлена конфигурация режимов в .kilocodemodes

### v1.20.0 (09-03-2026)

#### Изменено
- Исправлена структура проекта в README.md: исправлено имя файла README.MD → Readme.md
- Удалён отсутствующий файл SKILLS_PLAN.md из директории marketer/
- Добавлены YAML-конфигурации режимов: Project_manager_v2.yaml, system_analyst_mode_v1-3.yaml, tester.yaml
- Обновлена структура tg_bot_expert: добавлена поддиректория ENG/
- Добавлены служебные директории: .gitignore, .kilocodemodes, AGENTS.md, dev_artifacts/, pm_artifacts/, rule-memory-bank-to-agents/

### v1.19.0 (09-03-2026)

#### Добавлено
- Новый режим Tester для тестирования программного обеспечения
- Созданы 19 навыков для Tester: accessibility-testing, api-testing, database-testing, defect-management, gherkin-specifications, integration-testing, manual-testing, mobile-testing, performance-testing, python-testing, security-testing, test-automation-frameworks, test-case-design, test-data-management, test-management-tools, testing-coordination, ui-testing, visual-regression-testing
- Обновлена структура проекта: 11 пользовательских режимов
- Добавлена директория tester/ с конфигурацией и навыками

### v1.18.0 (09-03-2026)

#### Добавлено
- Новый навык ADR Template (Architecture Decision Record) для System Analyst
- Создан шаблон ADR с интегрированным примером

#### Изменено
- Обновлены 15 навыков System Analyst: улучшены инструкции и содержание
- Обновлён навык MOEX Bond API Python
- Обновлена конфигурация Project Manager

### v1.17.0 (08-03-2026)

#### Изменено
- Обновлены 26 навыков Project Manager: улучшены инструкции и содержание SKILL.md
- Оптимизировано форматирование и структура навыков для лучшей читаемости

### v1.16.0 (08-03-2026)

#### Добавлено
- Режим Marketer с 21 навыком для маркетинговых стратегий и инструментов продвижения
- Новые навыки: targeted-advertising, unit-economics, budget-management, campaign-management, visual-content, brand-management, forecasting, affiliate-marketing, influencer-marketing, marketing-automation
- Добавлена директория marketer/ с конфигурацией и навыками
- Обновлена структура проекта: 10 пользовательских режимов

### v1.12.0 (08-03-2026)

#### Изменено
- Обновлена структура проекта в README.md: удалены внутренние конфигурационные файлы и папки
- Удалены разделы: KiloCode_workflows, language-rules, kilocode-rules-instructions
- Обновлено описание Documentation Specialist

### v1.11.0 (07-03-2026)

#### Добавлено
- Новый навык Create Custom Modes для создания пользовательских режимов KiloCode
- Добавлены примеры и шаблоны режимов (web-developer, api-developer, mobile-developer)
- Обновлена система навыков до 19 технологий

### v1.10.0 (23-02-2026)

#### Добавлено
- 15 новых навыков System Analyst для полного SDLC:
  - api-design, bpmn-modeling, c4-architecture, data-modeling
  - gherkin-specifications, integration-patterns, nosql-design
  - sql-development, test-case-design, uml-modeling
  - use-case-modeling, user-stories, workflow-design
  - requirements-analysis, srs-specification
- Обновлена конфигурация system_analyst_mode_v1.3.yaml
- SKILLS_PLAN.md с полным списком навыков по фазам SDLC

### v1.9.0 (23-02-2026)

#### Добавлено
- Отчёт о различиях версий режимов (MODE_VERSIONS_DIFF_REPORT.md)

#### Изменено
- Обновлены версии режимов: Project Manager v2, System Analyst v1.3, Universal Coding Agent v1.6
- Перераспределены навыки между режимами Project Manager и System Analyst

### v1.8.0 (23-02-2026)

#### Добавлено
- Навык requirements-management в Project Manager для управления жизненным циклом требований
- SKILLS_PLAN.md для System Analyst
- Навыки requirements-analysis и srs-specification для System Analyst

#### Изменено
- Навыки requirements-analysis и srs-specification перемещены из Project Manager в System Analyst
- Обновлена конфигурация System Analyst mode

### v1.7.0 (21-02-2026)

#### Добавлено
- Universal Coding Agent v1.5 с оптимизированной структурой и обновлённым описанием

#### Изменено
- Архивирована старая версия навыка Kilo Skill Expert в директорию old-version/

### v1.6.0 (21-02-2026)

#### Добавлено
- Навык Kilo Skill Expert для создания и управления навыками (Skills) KiloCode

#### Изменено
- Обновлена система навыков до 18 технологий

### v1.5.2 (2026-02-15)

#### Изменено
- Возвращено оригинальное название "Universal Coding Agent" (без "Pro")
- Навык `moex-api-python` переименован в `moex-bond-api-python` для точного отражения фокуса на облигациях
- Файл инструкций переименован: `PYTHON_SKILLS_SETUP_INSTRUCTIONS.md` → `SKILLS_SETUP_INSTRUCTIONS.md`

### v1.5.1 (2026-02-15)

#### Изменено
- Оптимизация структуры README.md: удалены дублирования, сокращены описания режимов
- Добавлены кликабельные ссылки на директории режимов

### v1.5.0 (2026-02-15)

- Исправлен список пользовательских режимов
- Удалён "Code" (встроенный режим KiloCode)
- Добавлен "Documentation Specialist"

### v1.4.0 (2026-02-15)

- Навык MOEX API Python для работы с облигациями Московской биржи

### v1.3.0 (2026-02-15)

- Обновлены API и версии GitHub Actions в навыках
- Расширен навык python-project-setup с гибридной архитектурой Django + FastAPI

### v1.2.0 (2026-02-14)

- Новые навыки: Excel VBA Development, Telegram Bot Development

### v1.1.0 (2026-02-14)

- Система навыков (Skills) для Universal Coding Agent

### v1.0.0 (2026-02-14)

- Начальная версия репозитория
- Миграция с Memory Bank на AGENTS.md

## Ресурсы

- [Спецификация AGENTS.md](https://agents.md/)
- [Документация KiloCode](https://kilo.ai/docs/)
- [Примеры AGENTS.md](https://github.com/search?q=path%3AAGENTS.md)
- [Agent Skills Specification](https://agentskills.io/)

## Лицензия

Этот проект распространяется под лицензией MIT. Подробности см. в файле LICENSE.
