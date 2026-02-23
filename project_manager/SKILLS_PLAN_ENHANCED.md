# Enhanced Skills Plan for Project Manager Mode Based on SDLC Phases

> **Meta:** v1.2.0 | 23-02-2026 | Author: Universal Coding Agent

## Обзор

Данный документ содержит расширенный план разработки skills (навыков) для режима Project Manager с учетом фаз SDLC (Software Development Life Cycle). Skills предназначены для улучшения работы с методологиями управления проектами, финансовым планированием, управлением рисками и отчётностью на каждом этапе жизненного цикла разработки ПО.

> **Важно:** Навыки `requirements-analysis` и `srs-specification` перенесены в режим System Analyst. Вместо них в Project Manager добавлен навык `requirements-management` для управления жизненным циклом требований.

---

## SDLC-ориентированная структура навыков

### Фаза 1: Планирование и анализ требований

#### 1.1 project-initiation
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Инициация проекта, определение целей и задач |
| **Функции** | Project Charter, Business Case, Stakeholder Identification, Vision & Scope |
| **Интеграция** | Работает с данными от System Analyst о бизнес-требованиях |

#### 1.2 requirements-management
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Управление жизненным циклом требований |
| **Функции** | Requirements Traceability, Change Control, Scope Management, Validation |
| **Интеграция** | Запрашивает SRS и данные о требованиях от System Analyst |

> **Примечание:** Навыки `requirements-analysis` и `srs-specification` перенесены в режим System Analyst. PM управляет требованиями, SA анализирует и документирует.

#### 1.3 feasibility-study
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Средний |
| **Описание** | Технико-экономическое обоснование проекта |
| **Функции** | Technical Feasibility, Financial Analysis, Risk Assessment, Resource Requirements |
| **Интеграция** | Использует технические спецификации от System Analyst |

#### 1.4 project-budget-planning
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Детальное бюджетирование проекта |
| **Функции** | Cost Estimation, Budget Allocation, CAPEX/OPEX Forecasting, Financial Tracking |
| **Интеграция** | Требует данные о затратах от System Analyst |

---

### Фаза 2: Определение требований

> **Примечание:** Навык `srs-specification` перенесён в режим System Analyst. PM запрашивает SRS у SA.

#### 2.1 risk-assessment
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Идентификация и оценка рисков проекта |
| **Функции** | Risk Identification, Probability & Impact Matrix, Mitigation Strategies, Contingency Planning |
| **Интеграция** | Работает с данными о рисках от System Analyst |

#### 2.2 resource-planning
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Планирование ресурсов проекта |
| **Функции** | Team Composition, Capacity Planning, Skills Matrix, Vendor Management |
| **Интеграция** | Использует данные о составе команды от System Analyst |

#### 2.3 methodology-selection
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Средний |
| **Описание** | Выбор методологии разработки |
| **Функции** | Waterfall, Agile, Iterative, Hybrid Selection, Process Definition |
| **Интеграция** | На основе характеристик проекта от System Analyst |

---

### Фаза 3: Проектирование

#### 3.1 project-architecture-overview
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Средний |
| **Описание** | Обзор архитектуры проекта с точки зрения управления |
| **Функции** | High-level Architecture, Component Dependencies, Integration Points, Technology Stack Overview |
| **Интеграция** | Работает с архитектурными решениями от System Analyst |

#### 3.2 development-planning
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Планирование фазы разработки |
| **Функции** | Development Schedule, Milestones, Deliverables, Phase Transitions |
| **Интеграция** | Использует технические спецификации от System Analyst |

#### 3.3 quality-planning
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Средний |
| **Описание** | Планирование качества на этапе разработки |
| **Функции** | Quality Gates, Testing Strategy, Code Review Process, Compliance Requirements |
| **Интеграция** | Работает с требованиями к качеству от System Analyst |

---

### Фаза 4: Разработка

#### 4.1 agile-scrum-management
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Управление спринтами, бэклогом, планирование итераций |
| **Функции** | Sprint Planning, Daily Standup, Sprint Review, Sprint Retrospective, Backlog Grooming |
| **Интеграция** | Работает с данными от System Analyst о пользовательских историях |

#### 4.2 kanban-flow
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Средний |
| **Описание** | Канбан-доски, WIP-лимиты, управление потоком задач |
| **Функции** | Flow Visualization, WIP Limits, Bottleneck Management, Lead Time/Cycle Time Tracking |
| **Интеграция** | Использует данные о статусах задач от System Analyst |

#### 4.3 development-tracking
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Отслеживание прогресса разработки |
| **Функции** | Progress Monitoring, Burndown Charts, Velocity Tracking, Delivery Predictions |
| **Интеграция** | Использует данные о задачах от System Analyst |

#### 4.4 resource-costing
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Расчёт стоимости ресурсов в процессе разработки |
| **Функции** | FTE Costing, Contractor Rates, Overtime Calculations, Market Benchmarks |
| **Интеграция** | Использует данные о команде и ставках от System Analyst |

---

### Фаза 5: Тестирование

#### 5.1 testing-coordination
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Координация процесса тестирования |
| **Функции** | Test Planning, Test Environment Setup, Defect Tracking, Release Criteria |
| **Интеграция** | Работает с тестовыми планами от System Analyst |

#### 5.2 quality-metrics
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Средний |
| **Описание** | Метрики качества: defect density, code coverage, DORA |
| **Функции** | Defect Density, Code Coverage, DORA Metrics (Lead Time, Deployment Frequency, MTTR, Change Failure Rate) |
| **Интеграция** | Требует данные о качестве от System Analyst/Code mode |

#### 5.3 uat-coordination
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Средний |
| **Описание** | Координация приемочного тестирования |
| **Функции** | UAT Planning, User Training, Feedback Collection, Sign-off Management |
| **Интеграция** | Работает с тестовыми сценариями от System Analyst |

---

### Фаза 6: Внедрение

#### 6.1 deployment-planning
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Планирование процесса внедрения |
| **Функции** | Deployment Strategy, Rollback Plan, Environment Preparation, Go-live Coordination |
| **Интеграция** | Работает с архитектурными решениями от System Analyst |

#### 6.2 change-management
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Средний |
| **Описание** | Управление изменениями при внедрении |
| **Функции** | Change Communication, User Adoption, Training Programs, Resistance Management |
| **Интеграция** | Использует данные о заинтересованных сторонах от System Analyst |

#### 6.3 release-management
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Управление релизом продукта |
| **Функции** | Release Planning, Version Control, Deployment Tracking, Post-release Activities |
| **Интеграция** | Работает с артефактами от System Analyst |

---

### Фаза 7: Поддержка и сопровождение

#### 7.1 maintenance-planning
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Средний |
| **Описание** | Планирование сопровождения продукта |
| **Функции** | Maintenance Schedule, Support Levels, SLA Management, Feature Requests |
| **Интеграция** | Работает с данными об инцидентах от System Analyst |

#### 7.2 project-metrics
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | KPI проекта: CPI, SPI, burndown, velocity |
| **Функции** | CPI (Cost Performance Index), SPI (Schedule Performance Index), Burndown Charts, Velocity tracking, Earned Value Management |
| **Интеграция** | Использует данные о прогрессе от System Analyst |

---

### Фаза 8: Завершение проекта

#### 8.1 project-closure
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Завершение проекта и передача результатов |
| **Функции** | Closure Activities, Handover Process, Lessons Learned, Final Reporting |
| **Интеграция** | Использует все данные проекта от System Analyst |

---

### Категория 9: Универсальные навыки управления

#### 9.1 stakeholder-reporting
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Высокий |
| **Описание** | Генерация отчётов для стейкхолдеров на всех фазах |
| **Функции** | Status Reports, Executive Summaries, Dashboards, KPI Reporting, Traffic Light Reports |
| **Интеграция** | Использует все данные проекта от System Analyst |

#### 9.2 escalation-management
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Средний |
| **Описание** | Процедуры эскалации на всех фазах проекта |
| **Функции** | Escalation Matrix, SLA for Escalations, Escalation Documentation, Tracking |
| **Интеграция** | Работает с данными о структуре команды от System Analyst |

#### 9.3 change-request
| Параметр | Значение |
|----------|----------|
| **Приоритет** | Средний |
| **Описание** | Управление изменениями на всех фазах |
| **Функции** | Change Request Forms, Impact Assessment, Approval Workflows, Change Log |
| **Интеграция** | Работает с данными о текущем scope от System Analyst |

---

## Приоритизация по фазам SDLC

### Фаза 1 (Планирование и анализ): 4 навыка
1. **project-initiation** — начальный этап проекта
2. **requirements-management** — управление жизненным циклом требований
3. **project-budget-planning** — критично для оценок
4. **feasibility-study** — обоснование проекта

### Фаза 2 (Определение требований): 3 навыка
> **Примечание:** `srs-specification` перенесён в System Analyst
1. **risk-assessment** — критично для планирования
2. **resource-planning** — необходимо для планирования
3. **methodology-selection** — выбор подхода

### Фаза 3 (Проектирование): 3 навыка
1. **development-planning** — планирование фазы разработки
2. **project-architecture-overview** — понимание архитектуры
3. **quality-planning** — планирование качества

### Фаза 4 (Разработка): 4 навыка
1. **agile-scrum-management** — основная методология
2. **development-tracking** — отслеживание прогресса
3. **resource-costing** — контроль затрат
4. **kanban-flow** — альтернативная методология

### Фаза 5 (Тестирование): 3 навыка
1. **testing-coordination** — координация тестирования
2. **quality-metrics** — метрики качества
3. **uat-coordination** — приемочное тестирование

### Фаза 6 (Внедрение): 3 навыка
1. **deployment-planning** — планирование внедрения
2. **release-management** — управление релизом
3. **change-management** — управление изменениями

### Фаза 7 (Поддержка): 2 навыка
1. **project-metrics** — отслеживание метрик
2. **maintenance-planning** — планирование сопровождения

### Фаза 8 (Завершение): 1 навык
1. **project-closure** — завершение проекта

### Универсальные навыки: 3 навыка
1. **stakeholder-reporting** — отчетность на всех фазах
2. **escalation-management** — эскалация вопросов
3. **change-request** — управление изменениями

---

## Шаблон SKILL.md

```markdown
---
name: skill-name
description: Краткое описание того, что делает skill и когда его использовать
---

# Skill Name

> **Meta:** vX.X.X | DD-MM-YYYY

## Назначение

Подробное описание назначения skill.

## Когда использовать

Условия активации skill.

## Функции

### Функция 1
Описание функции.

### Функция 2
Описание функции.

## Интеграция с System Analyst

Какие данные требуются от System Analyst.

## Примеры использования

### Пример 1
Описание примера.

## Связанные skills

- related-skill-1
- related-skill-2

---
```

---

## Следующие шаги

1. Создать директорию `skills-project-manager/`
2. Реализовать навыки Фазы 1 (Планирование и анализ) - 4 навыка
3. Протестировать интеграцию с режимом
4. Реализовать навыки Фазы 2 (Определение требований) - 4 навыка
5. Продолжить поочередно по всем фазам
6. Обновить документацию в AGENTS.md

---
