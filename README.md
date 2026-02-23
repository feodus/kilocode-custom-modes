# KiloCode Custom Modes

> **Last Updated:** 23-02-2026 13:35:00 UTC+3 | Branch: master | Commit: e141615 | Version: 1.10.0

Коллекция пользовательских режимов для расширения функциональности KiloCode. Каждый каталог — автономный проект со специфическими возможностями для решения задач в своей области.

## Пользовательские режимы

Проект включает **девять режимов**:

| Режим | Назначение |
|-------|------------|
| **System Analyst Pro** | Анализ требований, проектирование API, BPMN, UML |
| **Orchestrator** | Координация сложных рабочих процессов |
| **Project Manager** | Управление проектами, расчёт бюджетов |
| **TG Bot Expert** | Разработка Telegram-ботов с CI/CD |
| **Universal Coding Agent** | Универсальная разработка (18+ навыков) |
| **Excel VBA Coder** | VBA-решения для Microsoft Excel |
| **Keenetic & Synology Admin** | Администрирование сетевого оборудования |
| **Moscow Estate Expert** | Юридические консультации по недвижимости |
| **Documentation Specialist** | Техническая документация |

## Структура проекта

```
kilocode-custom-modes/
├── .gitignore                    # Файл игнорирования для артефактов разработки
├── .kilocodemodes                # Файл конфигурации KiloCode
├── LICENSE                      # Лицензия MIT для проекта
├── README.MD                    # Основная документация проекта
├── AGENTS.md                    # Основные инструкции для AI-агентов
├── .kilocode/                   # Конфигурация, специфичная для KiloCode
│   ├── rules/                   # Определения правил
│   │   ├── memory-bank-backup.zip  # Бэкап Memory Bank
│   │   ├── Custom Modes.md      # Документация по пользовательским режимам
│   │   ├── Custom Rules.md      # Документация по пользовательским правилам
│   │   └── Skills.md            # Документация по навыкам Agent Skills
│   └── workflows/               # Рабочие процессы KiloCode
├── admin-keenetic-syn/          # Режим Keenetic & Synology Admin
├── universal-coding-agent/      # Режим Universal Coding Agent
│   ├── universal-coding-agent_v1-6.yaml
│   ├── SKILLS_SETUP_INSTRUCTIONS.md
│   └── skills-universal-coding-agent/  # 18+ навыков
├── codicon-preview/             # Превью иконок VSCode Codicons
├── excel-vba-coder/             # Режим Excel VBA Coder
├── kilocode-rules-instructions/ # Инструкции по созданию правил
├── language-rules/              # Языковые правила
├── memory-bank-instructions with Git/  # Инструкции по Memory Bank
├── MoscowEstateExpert/          # Режим Moscow Estate Expert
├── orchestrator/                # Режим Orchestrator
├── project_manager/             # Режим Project Manager
│   └── skills-project-manager/  # Навыки Project Manager (SDLC)
├── rule-memory-bank-to-agents/  # Правила миграции Memory Bank → AGENTS.md
├── system_analyst/              # Режим System Analyst Pro
│   └── skills-system-analyst/   # Навыки System Analyst
├── tg_bot_expert/               # Режим TG Bot Expert
└── KiloCode_workflows/          # Рабочие процессы KiloCode
```

## Описание режимов

### System Analyst Pro

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

**Расположение:** встроен в [`.kilocodemodes`](.kilocodemodes)

Техническая документация: ясное изложение, поддержка README, CHANGELOG и других форматов (`.md`, `.mdx`, `.txt`, `.rst`, `.adoc`).

## Дополнительные компоненты

### KiloCode_workflows
Компонент `KiloCode_workflows` предоставляет шаблоны для коммитов и Docker.

### language-rules
Языковые правила с поддержкой специфических правил для разных языков (например, русский язык).

### codicon-preview
Справочник иконок VSCode Codicons для визуального оформления режимов.

### kilocode-rules-instructions
Инструкции по созданию правил KiloCode.

## Контроль доступа к файлам

Каждый режим реализует детализированный доступ:

| Режим | Разрешённые типы файлов |
|-------|------------------------|
| System Analyst Pro | `.md`, `.mdx`, `.txt`, `.json`, `.yaml`, `.yml`, `.xml`, `.sql`, `.csv`, `.tsv`, `.puml`, `.mermaid`, `.graphql`, `.feature`, `.drawio` |
| Project Manager | `.md`, `.docx`, `.xlsx`, `.xls`, `.csv`, `.pdf`, `.json`, `.yaml`, `.yml` |
| TG Bot Expert | Полный доступ |
| Universal Coding Agent | Полный доступ |
| Excel VBA Coder | `.vba`, `.bas`, `.cls`, `.md`, `.txt` |
| Keenetic & Synology Admin | Конфигурационные файлы и документация |
| Moscow Estate Expert | Юридическая документация |
| Documentation Specialist | `.md`, `.mdx`, `.txt`, `.rst`, `.adoc`, `README`, `CHANGELOG` |

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

### v1.10.0 (23-02-2026)

#### Добавлено
- 15 новых навыков System Analyst Pro для полного SDLC:
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
