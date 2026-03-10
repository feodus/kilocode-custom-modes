---
name: release-deployment-management
description: Управление релизом и развёртыванием. Используйте для планирования и координации релизов, управления развёртыванием, определения rollback-процедур и контроля версий.
---

# Release Deployment Management

> **Meta:** v2.0.0 | 09-03-2026
> **Объединено из:** deployment-planning + release-management

## Назначение

Комплексный навык для эффективного управления релизами и развёртыванием программного продукта. Включает планирование стратегии развёртывания, управление версиями, координацию rollback-процедур и обеспечение бесперебойного перехода от разработки к эксплуатации. Обеспечивает минимизацию рисков и времени простоя при развёртывании.

## Когда использовать

Используйте этот навык:
- При планировании стратегии развёртывания
- При координации релизного цикла
- При управлении процессом выкатки обновлений
- При определении rollback-процедур
- При контроле версий продукта
- При управлении релизным канбаном или бэклогом
- При координации нескольких команд разработки

## Стратегии развёртывания

### 1. Blue-Green Deployment

Параллельное развёртывание:
- Два идентичных окружения (blue — текущее, green — новое)
- Быстрое переключение между версиями
- Мгновенный rollback при проблемах
- Требует двойных ресурсов

### 2. Canary Release

Постепенное развёртывание:
- Начало с малого процента пользователей
- Постепенное увеличение доли
- Раннее обнаружение проблем
- Требует хорошего мониторинга

### 3. Rolling Deployment

Поэтапное развёртывание:
- Последовательное обновление компонентов
- Минимальное использование ресурсов
- Более длительный процесс
- Сложнее rollback

### 4. Feature Flags

Управление функциональностью:
- Включение/выключение без деплоя
- A/B тестирование в production
- Быстрое отключение проблемных фич
- Требует инфраструктуры

### 5. Immutable Infrastructure

Неизменяемая инфраструктура:
- Полная замена окружения при деплое
- Воспроизводимость
- Сложность первоначальной настройки
- Отлично для containers/K8s

## Функции

### 1. Планирование развёртывания

Разработка стратегии и плана:
- Выбор стратегии развёртывания
- Определение окружений для развёртывания
- Планирование последовательности развёртывания
- Оценка рисков и их митигация
- Определение временного окна для развёртывания
- Коммуникация с stakeholders

### 2. Управление версиями

Контроль версий продукта:
- Семантическое версионирование (semver)
- Version naming convention
- Changelog management
- Release branches strategy
- Tagging и versioning в CI/CD

### 3. Подготовка окружения

Подготовка к развёртыванию:
- Настройка production/s staging окружений
- Конфигурация окружения
- Подготовка данных
- Резервное копирование
- Проверка требований окружения

### 4. Координация развёртывания

Управление процессом выкатки:
- Координация между командами
- Scheduled maintenance windows
- Развёртывание в несколько этапов
- Мониторинг процесса
- Коммуникация статуса

### 5. Rollback Procedures

Планирование и выполнение отката:
- Чёткие критерии для rollback
- Пошаговые инструкции
- Автоматизированный rollback
- Время выполнения rollback (MTTR)
- Post-rollback анализ

### 6. Release Management

Управление релизным циклом:
- Release planning
- Release scheduling
- Release coordination
- Release communication
- Release sign-off
- Post-release monitoring

### 7. Post-Deployment Validation

Проверка после развёртывания:
- Smoke tests в production
- Мониторинг метрик
- Проверка интеграций
- User acceptance verification
- Rollback при необходимости

## Интеграция с другими навыками

- [`testing-quality-coordination`](testing-quality-coordination/SKILL.md) — валидация перед релизом
- [`project-metrics`](project-metrics/SKILL.md) — метрики релизов
- [`stakeholder-reporting`](stakeholder-reporting/SKILL.md) — отчётность о релизах

## Примеры использования

### Пример 1: Релиз веб-приложения с Blue-Green

План развёртывания:
1. **Подготовка:** Накатить изменения на green-окружение
2. **Pre-deployment:** Smoke tests, backup database
3. **Deployment:** Переключение traffic (load balancer)
4. **Validation:** Проверка основных user flows (5 минут)
5. **Success:** Оставить green как active, blue becomes standby
6. **Failure:** Переключить обратно на blue, investigate

Время выполнения: 15-30 минут
Rollback time: < 5 минут

### Пример 2: Canary Release для мобильного приложения

Стратегия:
- 1% пользователей: v1.1
- 10% пользователей: v1.1 (через 24ч)
- 50% пользователей: v1.1 (через 48ч)
- 100% пользователей: v1.1 (через 72ч)

Критерии для продвижения:
- Crash rate < 0.1%
- API error rate < 1%
- User reports < 5
- Performance metrics normal

Rollback: Отключить feature flag, push hotfix

### Пример 3: Kubernetes Deployment

Deployment strategy: RollingUpdate
- maxSurge: 1 (дополнительный pod)
- maxUnavailable: 0 (без unavailable pods)

Process:
1. Образ собран и помещён в registry
2. Deployment manifest обновлён
3. kubectl apply -f deployment.yaml
4. Kubernetes rolling update
5. Health checks на каждом pod
6. Post-deployment проверки

### Пример 4: Release Calendar Management

Релизный календарь:
- Minor releases: ежемесячно (второй вторник)
- Patch releases: по необходимости (critical bugs)
- Major releases: ежеквартально

Release criteria:
- All tests passing
- QA sign-off
- Security review passed
- Documentation updated
- Stakeholder approval

## Метрики релизов

### Deployment Metrics

| Метрика | Описание | Целевое значение |
|---------|----------|------------------|
| Deployment Frequency | Частота релизов | > 1/неделя |
| Lead Time for Changes | Время от commit до production | < 1 день |
| Mean Time to Recovery (MTTR) | Время восстановления | < 1 час |
| Change Failure Rate | % неудачных релизов | < 5% |

### Release Quality Metrics

- Post-deployment bugs
- Rollback frequency
- Hotfix frequency
- Production incidents
- User satisfaction

## Чеклист перед релизом

- [ ] Все тесты пройдены
- [ ] QA дал sign-off
- [ ] Security review пройден
- [ ] Документация обновлена
- [ ] Changelog подготовлен
- [ ] Rollback план готов
- [ ] Stakeholders уведомлены
- [ ] Monitoring настроен
- [ ] Support team подготовлен
- [ ] Communication plan готов

## Частые ошибки

1. **Недостаточное тестирование** — баги в production
2. **Плохое планирование rollback** — длительный простой
3. **Отсутствие мониторинга** — незамеченные проблемы
4. **Недостаточная коммуникация** — недовольные stakeholders
5. **Пропуск documentation** — проблемы с поддержкой

---

*Часть навыков Project Manager SDLC — Phase 6: Внедрение*
*Объединено: deployment-planning + release-management (v2.0, 09-03-2026)*
