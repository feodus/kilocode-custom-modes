---
name: moex-bond-api-python
description: Работа с API Московской биржи (MOEX ISS API) на Python с фокусом на облигации. Получение данных по облигациям: список выпусков, параметры, котировки, доходность, дюрация, кредитные рейтинги, купоны, амортизации, оферты. Базовый функционал для акций: котировки и минимальная информация.
---

# MOEX Bond API Python Development

## Обзор

Этот навык предоставляет комплексные инструкции для работы с API Московской биржи (MOEX ISS API) на Python. **Основной фокус — работа с облигациями** (государственные, корпоративные, муниципальные). Функционал для акций ограничен базовыми операциями.

### Базовый URL

```
https://iss.moex.com/iss/
```

### Рекомендуемые параметры

- `iss.meta=off` — отключение метаданных (экономия трафика)
- `limit=unlimited` — снятие ограничения на количество записей

---

## Режимы торгов облигациями

| Board ID | Описание |
|----------|----------|
| `TQOB` | ОФЗ — государственные облигации |
| `TQCB` | Корпоративные облигации |
| `TQIR` | Муниципальные облигации |
| `TQOD` | Облигации с расчётами на следующий день |

---

## Эндпоинты API для облигаций

### Основные эндпоинты

| Эндпоинт | Назначение |
|----------|------------|
| `/engines/stock/markets/bonds/securities.json` | Список всех облигаций |
| `/engines/stock/markets/bonds/boards/TQOB/securities.json` | Список ОФЗ |
| `/engines/stock/markets/bonds/boards/TQCB/securities.json` | Список корпоративных облигаций |
| `/engines/stock/markets/bonds/boards/TQIR/securities.json` | Список муниципальных облигаций |
| `/securities/{SECID}.json` | Детальная информация по выпуску |
| `/securities/{SECID}/bondization.json` | Купоны, амортизации, оферты |

### Формат ответа

API возвращает JSON с несколькими секциями:

```json
{
  "securities": {
    "columns": ["SECID", "SECNAME", ...],
    "data": [["RU000A0JX0J2", "ОФЗ-26238-ПД", ...]]
  },
  "marketdata": {
    "columns": ["SECID", "LAST", "YIELD", ...],
    "data": [["RU000A0JX0J2", 98.5, 7.25, ...]]
  }
}
```

---

## Ключевые поля облигаций

### Идентификаторы

| Поле | Описание | Пример |
|------|----------|--------|
| `SECID` | Код облигации на Мосбирже | `RU000A0JX0J2` |
| `ISIN` | Международный идентификатор | `RU000A0JX0J2` |
| `SECNAME` | Полное наименование | `ОФЗ-26238-ПД` |
| `SHORTNAME` | Краткое наименование | `ОФЗ-26238` |
| `BOARDID` | Режим торгов | `TQOB`, `TQCB`, `TQIR` |

### Параметры выпуска

| Поле | Описание | Пример |
|------|----------|--------|
| `FACEVALUE` | Номинал | `1000` |
| `FACEUNIT` | Валюта номинала | `SUR` (рубли), `USD` |
| `INITIALFACEVALUE` | Начальный номинал | `1000` |
| `MATDATE` | Дата погашения | `2041-05-15` |
| `ISSUESIZE` | Объём выпуска (шт.) | `15000000` |

### Купонные параметры

| Поле | Описание | Примечание |
|------|----------|------------|
| `COUPONVALUE` | Сумма купона (руб.) | Фиксированная сумма |
| `COUPONPERCENT` | Ставка купона (%) | `null` = флоатер |
| `COUPONFREQUENCY` | Частота купонов в год | `2`, `4` |
| `NEXTCOUPON` | Дата следующего купона | `2026-03-15` |
| `ACCRUEDINT` | НКД (накопленный купонный доход) | `12.34` |

### Рыночные данные

| Поле | Описание | Примечание |
|------|----------|------------|
| `LAST` | Цена последней сделки | `% от номинала` |
| `WAPRICE` | Средневзвешенная цена | `% от номинала` |
| `PREVPRICE` | Цена закрытия | `% от номинала` |
| `YIELD` | Доходность к погашению | `% годовых` |
| `DURATION` | Дюрация (в годах) | `5.42` |
| `DURATIONDAYS` | Дюрация в днях | `1978` |
| `EFFECTIVEYIELD` | Эффективная доходность | `% годовых` |

### Оферты и риски

| Поле | Описание | Примечание |
|------|----------|------------|
| `OFFERDATE` | Дата оферты | `null` = нет оферты |
| `HIGH_RISK` | Флаг высокого риска | `0` или `1` |
| `LISTLEVEL` | Уровень листинга | `1`, `2`, `3` |
| `CREDITRATING` | Кредитный рейтинг | `AAA` |

---

## Python-клиент для облигаций

### Установка зависимостей

```bash
pip install requests pandas
```

### Полный пример класса MOEXBondClient

```python
import requests
import pandas as pd
from datetime import datetime
from typing import Optional, Dict, List, Union
import time

class MOEXBondClient:
    """
    Клиент для работы с API Московской биржи.
    Основной фокус — облигации (ОФЗ, корпоративные, муниципальные).
    """
    
    BASE_URL = "https://iss.moex.com/iss"
    DEFAULT_PARAMS = {"iss.meta": "off", "limit": "unlimited"}
    RATE_LIMIT_DELAY = 1.0  # секунд между запросами
    
    def __init__(self):
        self._last_request_time = 0
    
    def _make_request(self, endpoint: str, params: Optional[Dict] = None) -> Dict:
        """Выполнение HTTP-запроса с rate limiting"""
        # Rate limiting
        elapsed = time.time() - self._last_request_time
        if elapsed < self.RATE_LIMIT_DELAY:
            time.sleep(self.RATE_LIMIT_DELAY - elapsed)
        
        url = f"{self.BASE_URL}{endpoint}"
        request_params = {**self.DEFAULT_PARAMS, **(params or {})}
        
        response = requests.get(url, params=request_params, timeout=30)
        response.raise_for_status()
        
        self._last_request_time = time.time()
        return response.json()
    
    def _parse_to_dataframe(self, data: Dict, section: str) -> pd.DataFrame:
        """Преобразование ответа API в DataFrame"""
        if section not in data:
            return pd.DataFrame()
        
        columns = data[section]["columns"]
        rows = data[section]["data"]
        return pd.DataFrame(rows, columns=columns)
    
    # ==================== МЕТОДЫ ДЛЯ ОБЛИГАЦИЙ ====================
    
    def get_bonds_list(self, board: str = 'TQOB') -> pd.DataFrame:
        """
        Получение списка облигаций по режиму торгов.
        
        Args:
            board: Режим торгов ('TQOB' - ОФЗ, 'TQCB' - корпоративные, 'TQIR' - муниципальные)
        
        Returns:
            DataFrame со списком облигаций
        """
        endpoint = f"/engines/stock/markets/bonds/boards/{board}/securities.json"
        data = self._make_request(endpoint)
        
        # Объединяем securities и marketdata
        securities = self._parse_to_dataframe(data, "securities")
        marketdata = self._parse_to_dataframe(data, "marketdata")
        
        if not securities.empty and not marketdata.empty:
            return securities.merge(marketdata, on="SECID", how="left")
        return securities
    
    def get_all_bonds(self) -> pd.DataFrame:
        """Получение списка всех облигаций (все режимы торгов)"""
        endpoint = "/engines/stock/markets/bonds/securities.json"
        data = self._make_request(endpoint)
        
        securities = self._parse_to_dataframe(data, "securities")
        marketdata = self._parse_to_dataframe(data, "marketdata")
        
        if not securities.empty and not marketdata.empty:
            return securities.merge(marketdata, on="SECID", how="left")
        return securities
    
    def get_bond_info(self, secid: str) -> Dict:
        """
        Детальная информация по облигации.
        
        Args:
            secid: Код облигации (например, 'RU000A0JX0J2')
        
        Returns:
            Словарь с информацией о выпуске
        """
        endpoint = f"/securities/{secid}.json"
        data = self._make_request(endpoint)
        
        info = {}
        
        # Парсим секцию securities
        if "securities" in data:
            securities = data["securities"]
            if securities["data"]:
                columns = securities["columns"]
                values = securities["data"][0]
                info = dict(zip(columns, values))
        
        # Добавляем рыночные данные
        if "marketdata" in data:
            marketdata = data["marketdata"]
            if marketdata["data"]:
                columns = marketdata["columns"]
                values = marketdata["data"][0]
                info.update(dict(zip(columns, values)))
        
        return info
    
    def get_bond_marketdata(self, secid: str) -> Dict:
        """
        Котировки и доходность облигации.
        
        Args:
            secid: Код облигации
        
        Returns:
            Словарь с рыночными данными
        """
        endpoint = f"/securities/{secid}.json"
        data = self._make_request(endpoint)
        
        if "marketdata" in data and data["marketdata"]["data"]:
            columns = data["marketdata"]["columns"]
            values = data["marketdata"]["data"][0]
            return dict(zip(columns, values))
        return {}
    
    def get_bondization(self, secid: str) -> Dict:
        """
        Полная информация о купонах, амортизациях и офертах.
        
        Args:
            secid: Код облигации
        
        Returns:
            Словарь с ключами 'coupons', 'amortizations', 'offers'
        """
        endpoint = f"/securities/{secid}/bondization.json"
        data = self._make_request(endpoint)
        
        result = {
            "coupons": self._parse_to_dataframe(data, "coupons"),
            "amortizations": self._parse_to_dataframe(data, "amortizations"),
            "offers": self._parse_to_dataframe(data, "offers")
        }
        
        return result
    
    def get_coupons(self, secid: str) -> pd.DataFrame:
        """
        График купонных выплат.
        
        Args:
            secid: Код облигации
        
        Returns:
            DataFrame с расписанием купонов
        """
        bondization = self.get_bondization(secid)
        return bondization["coupons"]
    
    def get_amortizations(self, secid: str) -> pd.DataFrame:
        """
        График амортизации номинала.
        
        Args:
            secid: Код облигации
        
        Returns:
            DataFrame с расписанием амортизаций
        """
        bondization = self.get_bondization(secid)
        return bondization["amortizations"]
    
    def get_offers(self, secid: str) -> pd.DataFrame:
        """
        Оферты (put/call).
        
        Args:
            secid: Код облигации
        
        Returns:
            DataFrame с информацией об офертах
        """
        bondization = self.get_bondization(secid)
        return bondization["offers"]
    
    def find_bond_by_isin(self, isin: str) -> Optional[str]:
        """
        Поиск SECID по ISIN.
        
        Args:
            isin: ISIN код облигации
        
        Returns:
            SECID или None если не найден
        """
        # ISIN обычно совпадает с SECID для облигаций
        endpoint = f"/securities/{isin}.json"
        try:
            data = self._make_request(endpoint)
            if "securities" in data and data["securities"]["data"]:
                return data["securities"]["data"][0][
                    data["securities"]["columns"].index("SECID")
                ]
        except requests.HTTPError:
            return None
        return None
    
    def is_floater(self, secid: str) -> bool:
        """
        Проверка на флоатер (облигация с плавающим купоном).
        
        Args:
            secid: Код облигации
        
        Returns:
            True если флоатер, False если фиксированный купон
        """
        info = self.get_bond_info(secid)
        return info.get("COUPONPERCENT") is None
    
    def get_bond_type(self, secid: str) -> str:
        """
        Определение типа облигации.
        
        Args:
            secid: Код облигации
        
        Returns:
            Тип: 'OFZ', 'CORPORATE', 'MUNICIPAL', 'UNKNOWN'
        """
        info = self.get_bond_info(secid)
        board_id = info.get("BOARDID", "")
        
        if board_id == "TQOB":
            return "OFZ"
        elif board_id == "TQCB":
            return "CORPORATE"
        elif board_id == "TQIR":
            return "MUNICIPAL"
        return "UNKNOWN"
    
    def calculate_yield(self, secid: str, price: float, face_value: float = 1000) -> float:
        """
        Расчёт доходности к погашению при заданной цене.
        
        Упрощённый расчёт без учёта купонов.
        Для точного расчёта использовать данные из bondization.
        
        Args:
            secid: Код облигации
            price: Цена покупки (% от номинала)
            face_value: Номинал облигации
        
        Returns:
            Ориентировочная доходность в % годовых
        """
        info = self.get_bond_info(secid)
        
        mat_date_str = info.get("MATDATE")
        coupon_percent = info.get("COUPONPERCENT")
        coupon_value = info.get("COUPONVALUE")
        
        if not mat_date_str:
            return 0.0
        
        mat_date = datetime.strptime(mat_date_str, "%Y-%m-%d")
        days_to_maturity = (mat_date - datetime.now()).days
        
        if days_to_maturity <= 0:
            return 0.0
        
        # Расчёт купонного дохода
        annual_coupon_income = (coupon_percent / 100 * face_value) if coupon_percent else 0
        
        # Расчёт доходности
        price_abs = price / 100 * face_value
        discount = face_value - price_abs
        
        # Упрощённая формула YTM
        total_return = annual_coupon_income + (discount / days_to_maturity * 365)
        yield_pct = (total_return / price_abs) * 100
        
        return round(yield_pct, 2)
    
    def get_best_price(self, secid: str) -> Optional[float]:
        """
        Получение лучшей доступной цены для облигации.
        
        Приоритет: LAST > WAPRICE > PREVPRICE
        
        Args:
            secid: Код облигации
        
        Returns:
            Цена в % от номинала или None
        """
        marketdata = self.get_bond_marketdata(secid)
        
        price = marketdata.get("LAST")
        if price is None or price == 0:
            price = marketdata.get("WAPRICE")
        if price is None or price == 0:
            price = marketdata.get("PREVPRICE")
        
        return price if price and price > 0 else None
    
    def get_accrued_interest(self, secid: str) -> float:
        """
        Получение НКД (накопленного купонного дохода).
        
        Args:
            secid: Код облигации
        
        Returns:
            НКД в рублях
        """
        info = self.get_bond_info(secid)
        return float(info.get("ACCRUEDINT", 0) or 0)
    
    def get_bonds_by_yield(self, board: str = 'TQOB', min_yield: float = 0, 
                           max_yield: float = 100, limit: int = 50) -> pd.DataFrame:
        """
        Получение облигаций отфильтрованных по доходности.
        
        Args:
            board: Режим торгов
            min_yield: Минимальная доходность (%)
            max_yield: Максимальная доходность (%)
            limit: Максимальное количество записей
        
        Returns:
            DataFrame с отфильтрованными облигациями
        """
        bonds = self.get_bonds_list(board)
        
        if bonds.empty:
            return bonds
        
        # Фильтрация по доходности
        filtered = bonds[
            (bonds["YIELD"] >= min_yield) & 
            (bonds["YIELD"] <= max_yield)
        ].copy()
        
        # Сортировка по доходности
        filtered = filtered.sort_values("YIELD", ascending=False)
        
        return filtered.head(limit)
    
    def get_bonds_by_maturity(self, board: str = 'TQOB', 
                              min_years: float = 0, max_years: float = 30) -> pd.DataFrame:
        """
        Получение облигаций отфильтрованных по сроку до погашения.
        
        Args:
            board: Режим торгов
            min_years: Минимальный срок (лет)
            max_years: Максимальный срок (лет)
        
        Returns:
            DataFrame с отфильтрованными облигациями
        """
        bonds = self.get_bonds_list(board)
        
        if bonds.empty:
            return bonds
        
        # Фильтрация по дате погашения
        now = datetime.now()
        
        def years_to_maturity(mat_date_str):
            if not mat_date_str:
                return None
            try:
                mat_date = datetime.strptime(mat_date_str, "%Y-%m-%d")
                return (mat_date - now).days / 365
            except:
                return None
        
        bonds["YEARS_TO_MATURITY"] = bonds["MATDATE"].apply(years_to_maturity)
        
        filtered = bonds[
            (bonds["YEARS_TO_MATURITY"] >= min_years) & 
            (bonds["YEARS_TO_MATURITY"] <= max_years)
        ].copy()
        
        return filtered.sort_values("YEARS_TO_MATURITY")


# ==================== БАЗОВЫЙ ФУНКЦИОНАЛ ДЛЯ АКЦИЙ ====================

class MOEXStockClient:
    """Минимальный клиент для работы с акциями"""
    
    BASE_URL = "https://iss.moex.com/iss"
    DEFAULT_PARAMS = {"iss.meta": "off"}
    
    def get_stock_quote(self, secid: str) -> Dict:
        """
        Получение текущей котировки акции.
        
        Args:
            secid: Тикер акции (например, 'SBER', 'GAZP')
        
        Returns:
            Словарь с котировками (LAST, PREVPRICE, HIGH, LOW, VOL)
        """
        endpoint = f"/engines/stock/markets/shares/securities/{secid}.json"
        response = requests.get(
            f"{self.BASE_URL}{endpoint}", 
            params=self.DEFAULT_PARAMS,
            timeout=30
        )
        response.raise_for_status()
        data = response.json()
        
        if "marketdata" in data and data["marketdata"]["data"]:
            columns = data["marketdata"]["columns"]
            values = data["marketdata"]["data"][0]
            return dict(zip(columns, values))
        return {}
    
    def get_stock_info(self, secid: str) -> Dict:
        """
        Минимальная информация по акции.
        
        Args:
            secid: Тикер акции
        
        Returns:
            Словарь с SECNAME, ISIN, LOTSIZE, FACEVALUE
        """
        endpoint = f"/securities/{secid}.json"
        response = requests.get(
            f"{self.BASE_URL}{endpoint}", 
            params=self.DEFAULT_PARAMS,
            timeout=30
        )
        response.raise_for_status()
        data = response.json()
        
        if "securities" in data and data["securities"]["data"]:
            columns = data["securities"]["columns"]
            values = data["securities"]["data"][0]
            return dict(zip(columns, values))
        return {}


# ==================== ОБЪЕДИНЁННЫЙ КЛИЕНТ ====================

class MOEXClient(MOEXBondClient, MOEXStockClient):
    """
    Полный клиент MOEX ISS API.
    Основной фокус — облигации. Базовый функционал — акции.
    """
    
    def __init__(self):
        MOEXBondClient.__init__(self)
```

---

## Поля секции bondization

### Секция coupons (купоны)

| Поле | Описание |
|------|----------|
| `coupondate` | Дата выплаты купона |
| `value` | Сумма купона (руб.) |
| `valueprc` | Ставка купона (%) |
| `initial_face_value` | Номинал на дату выплаты |
| `accumulated_coupon` | НКД на дату |

### Секция amortizations (амортизации)

| Поле | Описание |
|------|----------|
| `amortdate` | Дата амортизации |
| `value` | Сумма амортизации (руб.) |
| `valueprc` | % от номинала |
| `face_value` | Номинал после амортизации |

### Секция offers (оферты)

| Поле | Описание |
|------|----------|
| `offerdate` | Дата оферты |
| `offertype` | Тип оферты (put/call) |
| `value` | Цена выкупа |
| `valueprc` | % от номинала |

---

## Обработка null-значений

### Интерпретация null в ключевых полях

| Поле | Значение null | Интерпретация |
|------|---------------|---------------|
| `COUPONPERCENT` | `null` | Флоатер (плавающая ставка) |
| `OFFERDATE` | `null` | Нет оферты |
| `MATDATE` | `null` | Бессрочная облигация (редко) |
| `YIELD` | `null` | Нет торгов / нерассчитана |
| `DURATION` | `null` | Для флоатеров может не рассчитываться |

### Проверка на null в Python

```python
def safe_float(value, default=0.0):
    """Безопасное преобразование в float"""
    if value is None:
        return default
    try:
        return float(value)
    except (ValueError, TypeError):
        return default

# Пример использования
info = client.get_bond_info("RU000A0JX0J2")
coupon_percent = safe_float(info.get("COUPONPERCENT"))
is_floater = info.get("COUPONPERCENT") is None
```

---

## Практические примеры

### Пример 1: Получение списка всех ОФЗ

```python
from moex_client import MOEXClient

client = MOEXClient()

# Получение списка ОФЗ
ofz_bonds = client.get_bonds_list("TQOB")

# Вывод топ-5 по доходности
top_yield = ofz_bonds.nlargest(5, "YIELD")[["SECID", "SECNAME", "YIELD", "DURATION"]]
print(top_yield)
```

### Пример 2: Поиск корпоративной облигации по ISIN

```python
client = MOEXClient()

# Поиск по ISIN
isin = "RU000A0ZYJY7"
secid = client.find_bond_by_isin(isin)

if secid:
    info = client.get_bond_info(secid)
    print(f"Наименование: {info.get('SECNAME')}")
    print(f"Доходность: {info.get('YIELD')}%")
    print(f"Тип: {client.get_bond_type(secid)}")
else:
    print("Облигация не найдена")
```

### Пример 3: Получение графика купонов

```python
client = MOEXClient()

secid = "RU000A0JX0J2"  # ОФЗ-26238-ПД
coupons = client.get_coupons(secid)

# Фильтрация будущих купонов
from datetime import datetime
future_coupons = coupons[
    coupons["coupondate"] > datetime.now().strftime("%Y-%m-%d")
]

print(f"Количество будущих купонов: {len(future_coupons)}")
print(future_coupons[["coupondate", "value", "valueprc"]].head())
```

### Пример 4: Проверка на флоатер

```python
client = MOEXClient()

secid = "RU000A1038V6"  # Пример флоатера
is_floater = client.is_floater(secid)

if is_floater:
    print("Это облигация с плавающим купоном (флоатер)")
    # Для флоатеров купонная ставка рассчитывается по формуле
else:
    info = client.get_bond_info(secid)
    print(f"Фиксированный купон: {info.get('COUPONPERCENT')}%")
```

### Пример 5: Получение данных по оферте

```python
client = MOEXClient()

secid = "RU000A0JX0J2"
offers = client.get_offers(secid)

if not offers.empty:
    print("Доступные оферты:")
    print(offers[["offerdate", "offertype", "valueprc"]])
else:
    print("Оферт нет (обычная облигация к погашению)")
```

### Пример 6: Расчёт доходности к погашению

```python
client = MOEXClient()

secid = "RU000A0JX0J2"
current_price = client.get_best_price(secid)

if current_price:
    print(f"Текущая цена: {current_price}%")
    
    # Расчёт доходности при покупке по текущей цене
    ytm = client.calculate_yield(secid, current_price)
    print(f"Ориентировочная YTM: {ytm}%")
    
    # Сравнение с рыночной доходностью
    info = client.get_bond_info(secid)
    market_yield = info.get("YIELD")
    print(f"Рыночная доходность: {market_yield}%")
```

### Пример 7: Фильтрация облигаций по параметрам

```python
client = MOEXClient()

# Поиск ОФЗ с доходностью 7-8% и сроком до погашения 5-10 лет
bonds = client.get_bonds_list("TQOB")

filtered = bonds[
    (bonds["YIELD"] >= 7) & 
    (bonds["YIELD"] <= 8)
].copy()

# Добавляем срок до погашения
from datetime import datetime
now = datetime.now()
filtered["YEARS"] = filtered["MATDATE"].apply(
    lambda x: (datetime.strptime(x, "%Y-%m-%d") - now).days / 365 if x else None
)

filtered = filtered[
    (filtered["YEARS"] >= 5) & 
    (filtered["YEARS"] <= 10)
]

print(filtered[["SECID", "SECNAME", "YIELD", "YEARS", "DURATION"]])
```

### Пример 8: Полный анализ облигации

```python
def analyze_bond(client, secid):
    """Полный анализ облигации"""
    
    # Базовая информация
    info = client.get_bond_info(secid)
    
    print("=" * 60)
    print(f"АНАЛИЗ ОБЛИГАЦИИ: {info.get('SECNAME')}")
    print("=" * 60)
    
    # Идентификация
    print(f"\n[ИДЕНТИФИКАЦИЯ]")
    print(f"  SECID: {secid}")
    print(f"  ISIN: {info.get('ISIN')}")
    print(f"  Тип: {client.get_bond_type(secid)}")
    print(f"  Флоатер: {'Да' if client.is_floater(secid) else 'Нет'}")
    
    # Параметры выпуска
    print(f"\n[ПАРАМЕТРЫ ВЫПУСКА]")
    print(f"  Номинал: {info.get('FACEVALUE')} {info.get('FACEUNIT')}")
    print(f"  Дата погашения: {info.get('MATDATE')}")
    print(f"  Объём выпуска: {info.get('ISSUESIZE'):,} шт.")
    
    # Купоны
    print(f"\n[КУПОН]")
    if client.is_floater(secid):
        print(f"  Тип: Плавающий (флоатер)")
    else:
        print(f"  Ставка: {info.get('COUPONPERCENT')}%")
        print(f"  Сумма: {info.get('COUPONVALUE')} руб.")
    print(f"  Частота: {info.get('COUPONFREQUENCY')} раз/год")
    print(f"  Следующий купон: {info.get('NEXTCOUPON')}")
    
    # Рыночные данные
    print(f"\n[РЫНОЧНЫЕ ДАННЫЕ]")
    print(f"  Цена: {client.get_best_price(secid)}%")
    print(f"  НКД: {info.get('ACCRUEDINT')} руб.")
    print(f"  Доходность: {info.get('YIELD')}%")
    print(f"  Дюрация: {info.get('DURATION')} лет ({info.get('DURATIONDAYS')} дней)")
    
    # Оферты
    offers = client.get_offers(secid)
    print(f"\n[ОФЕРТЫ]")
    if not offers.empty:
        print(f"  Количество оферт: {len(offers)}")
        for _, offer in offers.iterrows():
            print(f"  - {offer['offerdate']}: {offer.get('offertype', 'N/A')}")
    else:
        print("  Нет оферт")
    
    # Риски
    print(f"\n[РИСКИ]")
    print(f"  Высокий риск: {'Да' if info.get('HIGH_RISK') else 'Нет'}")
    print(f"  Уровень листинга: {info.get('LISTLEVEL')}")
    
    print("=" * 60)

# Использование
client = MOEXClient()
analyze_bond(client, "RU000A0JX0J2")
```

---

## Базовый функционал для акций

### Получение котировки акции

```python
from moex_client import MOEXClient

client = MOEXClient()

# Получение котировки Сбербанка
quote = client.get_stock_quote("SBER")

print(f"Последняя цена: {quote.get('LAST')} руб.")
print(f"Цена закрытия: {quote.get('PREVPRICE')} руб.")
print(f"Максимум дня: {quote.get('HIGH')} руб.")
print(f"Минимум дня: {quote.get('LOW')} руб.")
print(f"Объём: {quote.get('VOL')} шт.")
```

### Получение информации об акции

```python
client = MOEXClient()

info = client.get_stock_info("GAZP")

print(f"Наименование: {info.get('SECNAME')}")
print(f"ISIN: {info.get('ISIN')}")
print(f"Размер лота: {info.get('LOTSIZE')} шт.")
```

---

## Обработка ошибок

### Типичные ошибки

| Код HTTP | Описание | Решение |
|----------|----------|---------|
| 404 | Облигация не найдена | Проверить SECID/ISIN |
| 429 | Too Many Requests | Увеличить RATE_LIMIT_DELAY |
| 500 | Server Error | Повторить запрос |
| 503 | Service Unavailable | Подождать и повторить |

### Retry-механизм

```python
import time
from functools import wraps

def retry_on_error(max_retries=3, delay=1):
    """Декоратор для повторных попыток"""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            last_exception = None
            for attempt in range(max_retries):
                try:
                    return func(*args, **kwargs)
                except requests.HTTPError as e:
                    last_exception = e
                    if e.response.status_code == 404:
                        raise  # Не повторяем для 404
                    time.sleep(delay * (attempt + 1))
                except requests.RequestException as e:
                    last_exception = e
                    time.sleep(delay * (attempt + 1))
            raise last_exception
        return wrapper
    return decorator

# Использование
class MOEXBondClient:
    @retry_on_error(max_retries=3, delay=2)
    def _make_request(self, endpoint: str, params: Optional[Dict] = None) -> Dict:
        # ... реализация
        pass
```

---

## Рекомендации по использованию

### Rate Limiting

MOEX ISS API имеет ограничения на частоту запросов. Рекомендуется:

- Минимальный интервал между запросами: **1 секунда**
- Использовать пакетную загрузку при необходимости множества запросов
- Кэшировать результаты для часто используемых данных

### Оптимизация запросов

```python
# Плохо: отдельный запрос для каждой облигации
for secid in secids:
    info = client.get_bond_info(secid)  # N запросов

# Хорошо: получить список один раз
bonds = client.get_bonds_list("TQOB")  # 1 запрос
# Затем фильтровать локально
```

### Кэширование

```python
from functools import lru_cache
import pickle
from datetime import datetime, timedelta

class CachedMOEXClient(MOEXClient):
    def __init__(self, cache_ttl_minutes=5):
        super().__init__()
        self._cache = {}
        self._cache_ttl = timedelta(minutes=cache_ttl_minutes)
    
    def _get_cached(self, key):
        if key in self._cache:
            data, timestamp = self._cache[key]
            if datetime.now() - timestamp < self._cache_ttl:
                return data
        return None
    
    def _set_cached(self, key, data):
        self._cache[key] = (data, datetime.now())
    
    def get_bonds_list(self, board='TQOB'):
        cache_key = f"bonds_list_{board}"
        cached = self._get_cached(cache_key)
        if cached is not None:
            return cached
        result = super().get_bonds_list(board)
        self._set_cached(cache_key, result)
        return result
```

---

## Зависимости

```txt
# requirements.txt
requests>=2.28.0
pandas>=1.5.0
```

### Опциональные зависимости

```txt
# Для асинхронных запросов
aiohttp>=3.8.0

# Для кэширования
cachetools>=5.0.0

# Для работы с датами
python-dateutil>=2.8.0
```

---

## Ссылки

- [MOEX ISS API Documentation](https://iss.moex.com/iss/reference/)
- [MOEX ISS API Reference (English)](https://www.moex.com/a2193)
- [Примеры использования MOEX API](https://github.com/moex-online/moex-api-examples)

---

## Резюме

Этот навык предоставляет полный набор инструментов для работы с облигациями на Московской бирже:

1. **Получение списков** — ОФЗ, корпоративные, муниципальные
2. **Детальная информация** — параметры выпуска, купоны, рыночные данные
3. **Bondization** — полное расписание купонов, амортизаций, оферт
4. **Аналитика** — расчёт доходности, дюрации, определение типа облигации
5. **Фильтрация** — по доходности, сроку, типу

Для акций доступен только базовый функционал: получение котировок и минимальной информации.
