# KiloCode Custom Modes

> **Last Updated:** 22-03-2026 13:17:00 UTC+3 | Branch: master | Commit: abcdef1 | Version: 1.22.1

Коллекция пользовательских режимов для расширения функциональности KiloCode. Каждый каталог — автономный проект со специфическими возможностями для решения задач в своей области.

## Пользовательские режимы

Проект включает **шесть режимов**:

| Режим | Назначение |
|-------|------------|
| **Orchestrator** | Координация сложных рабочих процессов |
| **Excel VBA Coder** | VBA-решения для Microsoft Excel |
| **Keenetic & Synology Admin** | Администрирование сетевого оборудования |
| **Moscow Estate Expert** | Юридические консультации по недвижимости |
| **Documentation Specialist** | Техническая документация |
| **Codicon Preview** | Превью иконок VSCode Codicons |

## Структура проекта

```
kilocode-custom-modes/
├── .gitignore                           # Файл игнорирования Git
├── .kilocodemodes                       # Конфигурация KiloCode
├── LICENSE                              # Лицензия MIT
├── AGENTS.md                            # Документация для AI-агентов
├── Readme.md                            # Документация проекта
├── sync-to-github-universal.sh          # Скрипт синхронизации с GitHub
├── admin-keenetic-syn/                  # Режим Keenetic & Synology Admin
│   └── keenetic-synology-admin.yaml     # Конфигурация режима
├── codicon-preview/                     # Превью иконок VSCode Codicons
│   ├── codicon-icons-reference.md        # Справочник иконок
│   └── README_codicon-preview.md        # Описание
├── excel-vba-coder/                     # Режим Excel VBA Coder
│   └── excel_vba_development_en_v2.md   # Документация
├── kilocode-rules-instructions/          # Инструкции по созданию правил
│   └── kilocode-rules-instructions-en-v4.md
├── memory-bank-instructions with Git/    # Инструкции по Memory Bank
│   ├── memory-bank-instructions (original).md
│   ├── memory-bank-instructions-v2.md
│   ├── Readme - memory-bank-enhancements-description.md
│   ├── scripts-mb/                      # Скрипты
│   │   └── check-memory-bank-freshness.sh
│   └── workflows/                        # Workflow-файлы
│       └── commit-with-mb.md
├── MoscowEstateExpert/                   # Режим Moscow Estate Expert
│   └── MoscowEstateExpert.yaml           # Конфигурация режима
└── orchestrator/                         # Режим Orchestrator
    └── orchestrator-export.yaml          # Конфигурация режима
```

## Описание режимов

### Orchestrator

**Расположение:** [`orchestrator/`](orchestrator/)

Координатор сложных рабочих процессов: разбиение задач на подзадачи, делегирование специализированным режимам, отслеживание прогресса и синтез результатов.

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

### Codicon Preview

**Расположение:** [`codicon-preview/`](codicon-preview/)

Справочник иконок VSCode Codicons для визуального оформления режимов.

## Дополнительные компоненты

### memory-bank-instructions with Git

Инструкции по использованию Memory Bank с Git: скрипты для проверки актуальности и workflow для коммитов с Memory Bank.

### kilocode-rules-instructions

Инструкции по созданию пользовательских правил (rules) для KiloCode.

## Контроль доступа к файлам

Каждый режим реализует детализированный доступ:

| Режим | Разрешённые типы файлов |
|-------|------------------------|
| Orchestrator | Полный доступ |
| Excel VBA Coder | `.vba`, `.bas`, `.cls`, `.md`, `.txt` |
| Keenetic & Synology Admin | Конфигурационные файлы и документация |
| Moscow Estate Expert | Юридическая документация |
| Documentation Specialist | `.md`, `.mdx`, `.txt`, `.rst`, `.adoc`, `README`, `CHANGELOG` |
| Codicon Preview | `.md`, `.txt` |

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

### v1.22.1 (22-03-2026)

#### Изменено
- Реорганизация: часть режимов перенесена в отдельный проект kc-sdlc-team
- Обновлена структура проекта: удалены перемещённые компоненты
- Обновлена информация о доступных режимах (6 вместо 11)
- Удалены режимы: Marketer, Project Manager, System Analyst, Tester, TG Bot Expert, Universal Coding Agent
- Удалены временные артефакты: dev_artifacts/, pm_artifacts/, rule-memory-bank-to-agents/, language-rules/

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
- Созданы 19 навыков для Tester
- Обновлена структура проекта: 11 пользовательских режимов
- Добавлена директория tester/ с конфигурацией и навыками

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
- 15 новых навыков System Analyst для полного SDLC
- Обновлена конфигурация system_analyst_mode_v1.3.yaml
- SKILLS_PLAN.md с полным списком навыков по фазам SDLC

### v1.8.0 (23-02-2026)

#### Добавлено
- Навык requirements-management в Project Manager для управления жизненным циклом требований
- SKILLS_PLAN.md для System Analyst
- Навыки requirements-analysis и srs-specification для System Analyst

#### Изменено
- Навыки requirements-analysis и srs-specification перемещены из Project Manager в System Analyst
- Обновлена конфигурация System Analyst mode

### v1.5.0 (15-02-2026)

- Исправлен список пользовательских режимов
- Удалён "Code" (встроенный режим KiloCode)
- Добавлен "Documentation Specialist"

### v1.0.0 (14-02-2026)

- Начальная версия репозитория
- Миграция с Memory Bank на AGENTS.md

## Ресурсы

- [Спецификация AGENTS.md](https://agents.md/)
- [Документация KiloCode](https://kilo.ai/docs/)
- [Примеры AGENTS.md](https://github.com/search?q=path%3AAGENTS.md)
- [Agent Skills Specification](https://agentskills.io/)

## Лицензия

Этот проект распространяется под лицензией MIT. Подробности см. в файле LICENSE.
