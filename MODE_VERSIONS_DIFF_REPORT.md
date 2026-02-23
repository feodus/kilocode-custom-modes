# Отчёт о различиях между версиями режимов

> **Meta:** v1.0.0 | 23-02-2026
> **Author:** Universal Coding Agent
> **Purpose:** Сравнительный анализ изменений между версиями пользовательских режимов

---

## Содержание

1. [Project Manager: v2.0 vs v1.0](#1-project-manager-v20-vs-v10)
2. [System Analyst: v1.3 vs v1.2](#2-system-analyst-v13-vs-v12)
3. [Universal Coding Agent: v1.6 vs v1.5](#3-universal-coding-agent-v16-vs-v15)
4. [Общие тенденции изменений](#4-общие-тенденции-изменений)

---

## 1. Project Manager: v2.0 vs v1.0

### 1.1 Метаданные

| Атрибут | v1.0 | v2.0 |
|---------|------|------|
| Версия | Не указана | v2.0.0 |
| Дата | Не указана | 23-02-2026 |
| Размер файла | ~9,241 chars | ~14,715 chars (+59%) |

### 1.2 Структурные изменения

#### Добавленные секции в v2.0:

| Секция | Описание |
|--------|----------|
| **Tool-Based Coordination Mechanisms** | Подробное описание использования инструментов `new_task` и `switch_mode` |
| **File Exchange Structure** | Стандартная структура директорий для обмена артефактами |
| **Request Template** | Шаблон запросов к специалистам |
| **Coordination Workflows by Phase** | Детальные workflow для каждой фазы проекта |
| **Integration with Custom and Built-in Modes** | Классификация режимов и правила делегирования |
| **Initialization Checklist** | Чеклист для инициализации проекта |
| **Troubleshooting** | Таблица проблем и решений |

### 1.3 Ключевые изменения в customInstructions

#### v1.0 — Текстовый формат

```
PHASE-BASED SPECIALIST COORDINATION RULES:

1. PROJECT PHASE IDENTIFICATION:
   - Determine the current project phase...
   - Project Phases: ...
```

#### v2.0 — Структурированный формат с примерами

```yaml
## 1. PROJECT PHASE IDENTIFICATION

| Phase | Primary Specialist | Secondary Specialists |
|-------|-------------------|---------------------|
| Initiation | System Analyst | Architect |
| Design | Architect | System Analyst, Code |
...
```

### 1.4 Новые возможности v2.0

#### Механизмы координации (new_task / switch_mode)

**v1.0:** Только текстовое описание процесса запроса данных

**v2.0:** Конкретные примеры использования инструментов:

```yaml
# Пример делегирования
new_task(
  mode: "system-analyst",
  message: "Analyze requirements for CRM system...",
  todos: "[-] Gather requirements\n[ ] Create SRS document..."
)
```

#### Структура обмена файлами

**v1.0:** Отсутствует

**v2.0:** Полная структура:

```
project/
├── pm_artifacts/              # Project Manager outputs
├── sa_artifacts/              # System Analyst outputs
├── arch_artifacts/            # Architect outputs
└── dev_artifacts/             # Development outputs
```

#### Интеграция с режимами

**v1.0:** Общее описание "работать с Architect mode"

**v2.0:** Детальная классификация:

| Тип режима | Метод взаимодействия |
|------------|---------------------|
| Custom Modes (`system-analyst`, `universal-coding-agent`) | `new_task` |
| Built-in Modes (`architect`, `code`, `debug`) | `switch_mode` или `new_task` |

### 1.5 Изменения в описании (description)

| Версия | Описание |
|--------|----------|
| v1.0 | Strategic Project Manager adapting to development phases by coordinating with appropriate specialists... |
| v2.0 | ... - v2.0 (добавлена версия в конце) |

### 1.6 Таблица изменений

| Категория | v1.0 | v2.0 |
|-----------|------|------|
| Формат инструкций | Текстовый список | Структурированные таблицы и примеры |
| Координация | Описательная | Инструментальная (new_task/switch_mode) |
| Файловая структура | Не определена | Стандартизирована |
| Шаблоны | Отсутствуют | Запросы, ответы, документы |
| Troubleshooting | Отсутствует | Таблица проблем и решений |
| Инициализация | Не описана | Чеклист |

---

## 2. System Analyst: v1.3 vs v1.2

### 2.1 Метаданные

| Атрибут | v1.2 | v1.3 |
|---------|------|------|
| Версия | v1.2.0 | v1.3.0 |
| Дата | 23-02-2026 | 23-02-2026 |
| Размер файла | ~12,201 chars | ~17,080 chars (+40%) |

### 2.2 Структурные изменения

#### Добавленные секции в v1.3:

| Секция | Описание |
|--------|----------|
| **Project Manager Coordination Protocol** | Протокол взаимодействия с PM |
| **Receiving Tasks from PM** | Механизмы получения задач |
| **Processing PM Requests** | Обработка запросов от PM |
| **Output Locations for PM** | Стандартные расположения выходных файлов |
| **Response Template to PM** | Шаблон ответа для PM |
| **Providing Estimates to PM** | Шаблоны оценок трудозатрат |

### 2.3 Изменения в roleDefinition

#### v1.2:

```yaml
### Integration with Project Manager:
- Provide requirements data to PM for planning
- Supply technical specifications for budget estimation
- Deliver risk assessments for project planning
- Share architecture decisions for resource planning
```

#### v1.3:

```yaml
## Integration with Project Manager

You receive tasks from Project Manager and provide structured outputs for project planning:
- Requirements estimates and complexity analysis
- Technical specifications for budget estimation
- Risk assessments for project planning
- Architecture decisions impact analysis
```

### 2.4 Новые возможности v1.3

#### Механизмы получения задач от PM

**v1.2:** Упоминание интеграции без деталей

**v1.3:** Два механизма:

1. **Direct Task Delegation (new_task):**
   - Message с описанием задачи
   - Todo list с deliverables
   - References to input documents

2. **Request Files:**
   - `project/pm_artifacts/requests/sa_request_XXX.md`
   - Структурированный шаблон запроса

#### Стандартные выходные директории

**v1.2:** `system_analyst/` в корне проекта

**v1.3:** Стандартизированная структура:

| Deliverable Type | Location |
|-----------------|----------|
| SRS Documents | `project/sa_artifacts/requirements/` |
| User Stories | `project/sa_artifacts/requirements/user_stories/` |
| API Specifications | `project/sa_artifacts/api_specs/` |
| BPMN/UML Diagrams | `project/sa_artifacts/diagrams/` |
| Data Models/ERD | `project/sa_artifacts/data_models/` |
| Labor Estimates | `project/sa_artifacts/estimates/` |

#### Шаблоны документов для PM

**v1.3 добавляет:**

1. **Response Template:**
   - Status (COMPLETED/PARTIAL/BLOCKED)
   - Deliverables Completed
   - Key Findings
   - Estimates
   - Risks Identified
   - Blockers
   - Questions for PM

2. **Labor Estimate Template:**
   - Summary (Total Hours, Complexity, Confidence)
   - Detailed Breakdown table
   - Assumptions
   - Risks

3. **Technical Risk Assessment Template:**
   - Risk ID, Description, Probability, Impact, Score, Mitigation

### 2.5 Изменения в customInstructions

#### v1.2 — Проектная инициализация:

```yaml
When starting work on a project:
1. Check if a "system_analyst" folder exists in the project root
```

#### v1.3 — Интеграция с PM:

```yaml
## 1. PROJECT MANAGER COORDINATION PROTOCOL

### 1.1 Receiving Tasks from Project Manager
...
### 1.2 Processing PM Requests
...
### 1.3 Output Locations for PM
...
### 1.4 Response Template to PM
...
```

### 2.6 Изменения в описании (description)

| Версия | Описание |
|--------|----------|
| v1.2 | ...Includes 15+ specialized skills for SDLC phases. -v1.2 |
| v1.3 | ...Integrated with Project Manager for coordination. -v1.3 |

### 2.7 Таблица изменений

| Категория | v1.2 | v1.3 |
|-----------|------|------|
| Интеграция с PM | Упоминание | Полный протокол |
| Механизмы задач | Не определены | new_task + Request Files |
| Выходные директории | `system_analyst/` | `project/sa_artifacts/` |
| Шаблоны ответов | Отсутствуют | Response + Estimates + Risks |
| Обработка запросов PM | Не описана | Пошаговый алгоритм |

---

## 3. Universal Coding Agent: v1.6 vs v1.5

### 3.1 Метаданные

| Атрибут | v1.5 | v1.6 |
|---------|------|------|
| Версия | v1.5 | v1.6.0 |
| Дата | 21.02.2026 | 23-02-2026 |
| Размер файла | ~9,739 chars | ~21,960 chars (+126%) |

### 3.2 Структурные изменения

#### Добавленные секции в v1.6:

| Секция | Описание |
|--------|----------|
| **Project Manager Coordination Protocol** | Полный протокол взаимодействия с PM |
| **Working with System Analyst Outputs** | Чтение требований и архитектуры |
| **Progress Report Template** | Шаблон отчёта о прогрессе |
| **Metrics Report Template** | Шаблон метрик кода |
| **Deployment Artifacts** | Требования к деплойменту |
| **Troubleshooting Coordination** | Эскалация проблем |
| **Initialization Checklist** | Чеклист при присоединении к проекту |
| **Quality Checklist Before Completion** | Чеклист перед завершением |

### 3.3 Изменения в roleDefinition

#### v1.5:

Отсутствует секция интеграции с PM.

#### v1.6:

```yaml
## Project Manager Integration

You receive development tasks from Project Manager and provide structured outputs:
- Code implementation and testing
- Progress reports and metrics
- Technical documentation
- Deployment artifacts
```

### 3.4 Новые возможности v1.6

#### Механизмы получения задач от PM

Аналогично System Analyst v1.3:

1. **Direct Task Delegation (new_task)**
2. **Request Files:** `project/pm_artifacts/requests/dev_request_XXX.md`

#### Выходные директории

| Deliverable Type | Location |
|-----------------|----------|
| Source Code | `project/src/` |
| Tests | `project/tests/` |
| Progress Reports | `project/dev_artifacts/progress_reports/` |
| Code Metrics | `project/dev_artifacts/metrics/` |
| Deployment Configs | `project/dev_artifacts/deployment/` |
| Technical Docs | `project/dev_artifacts/documentation/` |

#### Шаблоны отчётов

**v1.6 добавляет:**

1. **Progress Report Template:**
   - Status (COMPLETED/IN PROGRESS/BLOCKED)
   - Deliverables Completed
   - Code Metrics table
   - Technical Decisions Made
   - Issues Encountered
   - Blockers
   - Next Steps
   - Questions for PM/SA

2. **Metrics Report Template:**
   - Development Progress (Files, Lines, Coverage)
   - Quality Metrics (Linting, Type Errors, Security)
   - Build & Deployment metrics

3. **Deployment Package Template:**
   - Contents
   - Pre-deployment Checklist
   - Rollback Procedure
   - Monitoring

#### Работа с выходами System Analyst

**v1.6 добавляет:**

```yaml
## 2. WORKING WITH SYSTEM ANALYST OUTPUTS

### 2.1 Reading Requirements
- project/sa_artifacts/requirements/SRS.md
- project/sa_artifacts/requirements/user_stories/
- project/sa_artifacts/api_specs/

### 2.2 Reading Architecture
- project/arch_artifacts/architecture/
- project/arch_artifacts/decisions/

### 2.3 Reading Data Models
- project/sa_artifacts/data_models/
```

#### Clarification Requests

**v1.6 добавляет:**

```markdown
# Clarification Request

**From:** Universal Coding Agent
**To:** System Analyst
...
```

### 3.5 Изменения в capabilities

| Capability | v1.5 | v1.6 |
|------------|------|------|
| pm_integration | Отсутствует | ✅ Добавлен |

### 3.6 Изменения в описании (description)

| Версия | Описание |
|--------|----------|
| v1.5 | ...development workflows - Updated v1.5, 21.02.2026 with 18 skills... |
| v1.6 | ...Integrated with Project Manager for coordination. - v1.6, 23.02.2026 with 18 skills and PM integration |

### 3.7 Изменения в whenToUse

**v1.5:**

```yaml
- Architecture design and API development
Skills activate automatically...
```

**v1.6:**

```yaml
- Architecture design and API development
- Receiving and executing tasks from Project Manager
Skills activate automatically...
```

### 3.8 Таблица изменений

| Категория | v1.5 | v1.6 |
|-----------|------|------|
| Интеграция с PM | Отсутствует | Полный протокол |
| Интеграция с SA | Отсутствует | Чтение requirements/architecture |
| Progress Reports | Отсутствуют | Детальные шаблоны |
| Metrics Reports | Отсутствуют | Шаблоны метрик |
| Deployment Artifacts | Не описаны | Полный набор |
| Clarification Requests | Отсутствуют | Шаблон запроса |
| Quality Gates | Не формализованы | Чеклисты |
| Troubleshooting | Отсутствует | Эскалация к PM/SA |

---

## 4. Общие тенденции изменений

### 4.1 Паттерны обновлений

| Паттерн | Описание |
|---------|----------|
| **Унификация структуры** | Все режимы теперь используют стандартизированные директории (`*_artifacts/`) |
| **Инструментальная координация** | Переход от описаний к конкретным примерам использования `new_task` и `switch_mode` |
| **Шаблоны документов** | Добавление шаблонов запросов, ответов, отчётов во все режимы |
| **Чеклисты** | Формализация процессов через чеклисты инициализации и завершения |
| **Troubleshooting** | Добавление секций troubleshooting во все режимы |

### 4.2 Интеграционная модель

```
┌─────────────────────────────────────────────────────────────┐
│                    PROJECT MANAGER                          │
│                         v2.0                                │
│  - Координирует все режимы                                  │
│  - Делегирует через new_task                                │
│  - Создаёт request files                                    │
└──────────────────────┬──────────────────────────────────────┘
                       │
           ┌───────────┼───────────┐
           │           │           │
           ▼           ▼           ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────────────────┐
│SYSTEM ANALYST│ │  ARCHITECT   │ │ UNIVERSAL CODING AGENT   │
│    v1.3      │ │  (built-in)  │ │         v1.6             │
├──────────────┤ ├──────────────┤ ├──────────────────────────┤
│sa_artifacts/ │ │arch_artifacts│ │dev_artifacts/            │
│- requirements│ │- architecture│ │- progress_reports        │
│- api_specs   │ │- decisions   │ │- metrics                 │
│- diagrams    │ │              │ │- deployment              │
│- data_models │ │              │ │- documentation           │
│- estimates   │ │              │ │                          │
└──────────────┘ └──────────────┘ └──────────────────────────┘
```

### 4.3 Стандартизированные директории проекта

```
project/
├── pm_artifacts/              # Project Manager
│   ├── plans/
│   ├── estimates/
│   ├── reports/
│   └── requests/
├── sa_artifacts/              # System Analyst
│   ├── requirements/
│   ├── api_specs/
│   ├── diagrams/
│   ├── data_models/
│   └── estimates/
├── arch_artifacts/            # Architect
│   ├── architecture/
│   └── decisions/
├── dev_artifacts/             # Universal Coding Agent
│   ├── progress_reports/
│   ├── metrics/
│   ├── deployment/
│   └── documentation/
└── src/                       # Source code
```

### 4.4 Общие шаблоны документов

| Шаблон | Используется в |
|--------|---------------|
| Request Template | PM → Specialists |
| Response Template | Specialists → PM |
| Progress Report | UCA → PM |
| Labor Estimate | SA → PM |
| Risk Assessment | SA → PM |
| Clarification Request | UCA → SA |
| Deployment Package | UCA → PM |

### 4.5 Рост размеров файлов

| Режим | Старая версия | Новая версия | Рост |
|-------|--------------|--------------|------|
| Project Manager | ~9,241 chars | ~14,715 chars | +59% |
| System Analyst | ~12,201 chars | ~17,080 chars | +40% |
| Universal Coding Agent | ~9,739 chars | ~21,960 chars | +126% |

### 4.6 Ключевые улучшения

1. **Интероперабельность:** Режимы теперь "говорят на одном языке" через стандартизированные артефакты
2. **Прослеживаемость:** Чёткие пути от requirements → design → implementation → deployment
3. **Отчётность:** Формализованные отчёты о прогрессе и метриках
4. **Эскалация:** Определены пути эскалации проблем между режимами
5. **Качество:** Чеклисты для инициализации и завершения задач

---

## Заключение

Обновления версий v2.0 (PM), v1.3 (SA) и v1.6 (UCA) представляют собой значительный шаг к созданию интегрированной экосистемы режимов для управления полным жизненным циклом проекта. Ключевые изменения:

1. **Проект Manager v2.0** стал "оркестратором" с инструментами делегирования
2. **System Analyst v1.3** получил протокол взаимодействия с PM
3. **Universal Coding Agent v1.6** научился получать задачи от PM и отчитываться о прогрессе

Все три режима теперь используют единую систему файлового обмена и шаблонов документов, что обеспечивает бесшовную координацию на всех фазах SDLC.

---

*Generated: 23-02-2026*
