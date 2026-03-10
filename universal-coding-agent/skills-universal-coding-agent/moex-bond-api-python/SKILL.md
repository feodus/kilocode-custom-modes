---
name: moex-bond-api-python
description: Working with MOEX ISS API (Moscow Exchange API) in Python with a focus on bonds. Retrieving bond data: issue list, parameters, quotes, yield, duration, credit ratings, coupons, amortizations, offers. Basic functionality for stocks: quotes and minimal information.
---

# MOEX Bond API Python Development

## Overview

This skill provides comprehensive instructions for working with the Moscow Exchange API (MOEX ISS API) in Python. **The main focus is on bonds** (government, corporate, municipal). Stock functionality is limited to basic operations.

### Base URL

```
https://iss.moex.com/iss/
```

### Recommended Parameters

- `iss.meta=off` — disable metadata (traffic savings)
- `limit=unlimited` — remove record limit

---

## Bond Trading Modes

| Board ID | Description |
|----------|-------------|
| `TQOB` | OFZ — government bonds |
| `TQCB` | Corporate bonds |
| `TQIR` | Municipal bonds |
| `TQOD` | Bonds with next-day settlement |

---

## Bond API Endpoints

### Main Endpoints

| Endpoint | Purpose |
|----------|---------|
| `/engines/stock/markets/bonds/securities.json` | List of all bonds |
| `/engines/stock/markets/bonds/boards/TQOB/securities.json` | OFZ list |
| `/engines/stock/markets/bonds/boards/TQCB/securities.json` | Corporate bonds list |
| `/engines/stock/markets/bonds/boards/TQIR/securities.json` | Municipal bonds list |
| `/securities/{SECID}.json` | Detailed issue information |
| `/securities/{SECID}/bondization.json` | Coupons, amortizations, offers |

### Response Format

API returns JSON with multiple sections:

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

## Key Bond Fields

### Identifiers

| Field | Description | Example |
|-------|-------------|---------|
| `SECID` | Bond code on MOEX | `RU000A0JX0J2` |
| `ISIN` | International identifier | `RU000A0JX0J2` |
| `SECNAME` | Full name | `ОФЗ-26238-ПД` |
| `SHORTNAME` | Short name | `ОФЗ-26238` |
| `BOARDID` | Trading mode | `TQOB`, `TQCB`, `TQIR` |

### Issue Parameters

| Field | Description | Example |
|-------|-------------|---------|
| `FACEVALUE` | Face value | `1000` |
| `FACEUNIT` | Face value currency | `SUR` (rubles), `USD` |
| `INITIALFACEVALUE` | Initial face value | `1000` |
| `MATDATE` | Maturity date | `2041-05-15` |
| `ISSUESIZE` | Issue size (pcs) | `15000000` |

### Coupon Parameters

| Field | Description | Note |
|-------|-------------|------|
| `COUPONVALUE` | Coupon amount (RUB) | Fixed amount |
| `COUPONPERCENT` | Coupon rate (%) | `null` = floater |
| `COUPONFREQUENCY` | Coupons per year | `2`, `4` |
| `NEXTCOUPON` | Next coupon date | `2026-03-15` |
| `ACCRUEDINT` | Accrued interest | `12.34` |

### Market Data

| Field | Description | Note |
|-------|-------------|------|
| `LAST` | Last trade price | `% of face value` |
| `WAPRICE` | Weighted average price | `% of face value` |
| `PREVPRICE` | Closing price | `% of face value` |
| `YIELD` | Yield to maturity | `% annual` |
| `DURATION` | Duration (years) | `5.42` |
| `DURATIONDAYS` | Duration in days | `1978` |
| `EFFECTIVEYIELD` | Effective yield | `% annual` |

### Offers and Risks

| Field | Description | Note |
|-------|-------------|------|
| `OFFERDATE` | Offer date | `null` = no offer |
| `HIGH_RISK` | High risk flag | `0` or `1` |
| `LISTLEVEL` | Listing level | `1`, `2`, `3` |
| `CREDITRATING` | Credit rating | `AAA` |

---

## Python Client for Bonds

### Installing Dependencies

```bash
pip install requests pandas
```

### Complete MOEXBondClient Class Example

```python
import requests
import pandas as pd
from datetime import datetime
from typing import Optional, Dict, List, Union
import time

class MOEXBondClient:
    """
    Client for MOEX API.
    Main focus — bonds (OFZ, corporate, municipal).
    """
    
    BASE_URL = "https://iss.moex.com/iss"
    DEFAULT_PARAMS = {"iss.meta": "off", "limit": "unlimited"}
    RATE_LIMIT_DELAY = 1.0  # seconds between requests
    
    def __init__(self):
        self._last_request_time = 0
    
    def _make_request(self, endpoint: str, params: Optional[Dict] = None) -> Dict:
        """Execute HTTP request with rate limiting"""
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
        """Convert API response to DataFrame"""
        if section not in data:
            return pd.DataFrame()
        
        columns = data[section]["columns"]
        rows = data[section]["data"]
        return pd.DataFrame(rows, columns=columns)
    
    # ==================== BOND METHODS ====================
    
    def get_bonds_list(self, board: str = 'TQOB') -> pd.DataFrame:
        """
        Get bond list by trading mode.
        
        Args:
            board: Trading mode ('TQOB' - OFZ, 'TQCB' - corporate, 'TQIR' - municipal)
        
        Returns:
            DataFrame with bond list
        """
        endpoint = f"/engines/stock/markets/bonds/boards/{board}/securities.json"
        data = self._make_request(endpoint)
        
        # Merge securities and marketdata
        securities = self._parse_to_dataframe(data, "securities")
        marketdata = self._parse_to_dataframe(data, "marketdata")
        
        if not securities.empty and not marketdata.empty:
            return securities.merge(marketdata, on="SECID", how="left")
        return securities
    
    def get_all_bonds(self) -> pd.DataFrame:
        """Get list of all bonds (all trading modes)"""
        endpoint = "/engines/stock/markets/bonds/securities.json"
        data = self._make_request(endpoint)
        
        securities = self._parse_to_dataframe(data, "securities")
        marketdata = self._parse_to_dataframe(data, "marketdata")
        
        if not securities.empty and not marketdata.empty:
            return securities.merge(marketdata, on="SECID", how="left")
        return securities
    
    def get_bond_info(self, secid: str) -> Dict:
        """
        Detailed bond information.
        
        Args:
            secid: Bond code (e.g., 'RU000A0JX0J2')
        
        Returns:
            Dictionary with issue information
        """
        endpoint = f"/securities/{secid}.json"
        data = self._make_request(endpoint)
        
        info = {}
        
        # Parse securities section
        if "securities" in data:
            securities = data["securities"]
            if securities["data"]:
                columns = securities["columns"]
                values = securities["data"][0]
                info = dict(zip(columns, values))
        
        # Add market data
        if "marketdata" in data:
            marketdata = data["marketdata"]
            if marketdata["data"]:
                columns = marketdata["columns"]
                values = marketdata["data"][0]
                info.update(dict(zip(columns, values)))
        
        return info
    
    def get_bond_marketdata(self, secid: str) -> Dict:
        """
        Bond quotes and yield.
        
        Args:
            secid: Bond code
        
        Returns:
            Dictionary with market data
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
        Complete information about coupons, amortizations, and offers.
        
        Args:
            secid: Bond code
        
        Returns:
            Dictionary with keys 'coupons', 'amortizations', 'offers'
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
        Coupon payment schedule.
        
        Args:
            secid: Bond code
        
        Returns:
            DataFrame with coupon schedule
        """
        bondization = self.get_bondization(secid)
        return bondization["coupons"]
    
    def get_amortizations(self, secid: str) -> pd.DataFrame:
        """
        Amortization schedule.
        
        Args:
            secid: Bond code
        
        Returns:
            DataFrame with amortization schedule
        """
        bondization = self.get_bondization(secid)
        return bondization["amortizations"]
    
    def get_offers(self, secid: str) -> pd.DataFrame:
        """
        Offers (put/call).
        
        Args:
            secid: Bond code
        
        Returns:
            DataFrame with offer information
        """
        bondization = self.get_bondization(secid)
        return bondization["offers"]
    
    def find_bond_by_isin(self, isin: str) -> Optional[str]:
        """
        Find SECID by ISIN.
        
        Args:
            isin: ISIN code of bond
        
        Returns:
            SECID or None if not found
        """
        # ISIN usually matches SECID for bonds
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
        Check for floater (bond with floating coupon).
        
        Args:
            secid: Bond code
        
        Returns:
            True if floater, False if fixed coupon
        """
        info = self.get_bond_info(secid)
        return info.get("COUPONPERCENT") is None
    
    def get_bond_type(self, secid: str) -> str:
        """
        Determine bond type.
        
        Args:
            secid: Bond code
        
        Returns:
            Type: 'OFZ', 'CORPORATE', 'MUNICIPAL', 'UNKNOWN'
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
        Calculate yield to maturity at given price.
        
        Simplified calculation without coupons.
        For accurate calculation, use bondization data.
        
        Args:
            secid: Bond code
            price: Purchase price (% of face value)
            face_value: Bond face value
        
        Returns:
            Approximate yield in % annual
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
        
        # Calculate coupon income
        annual_coupon_income = (coupon_percent / 100 * face_value) if coupon_percent else 0
        
        # Calculate yield
        price_abs = price / 100 * face_value
        discount = face_value - price_abs
        
        # Simplified YTM formula
        total_return = annual_coupon_income + (discount / days_to_maturity * 365)
        yield_pct = (total_return / price_abs) * 100
        
        return round(yield_pct, 2)
    
    def get_best_price(self, secid: str) -> Optional[float]:
        """
        Get best available price for bond.
        
        Priority: LAST > WAPRICE > PREVPRICE
        
        Args:
            secid: Bond code
        
        Returns:
            Price in % of face value or None
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
        Get accrued interest (НКД).
        
        Args:
            secid: Bond code
        
        Returns:
            Accrued interest in rubles
        """
        info = self.get_bond_info(secid)
        return float(info.get("ACCRUEDINT", 0) or 0)
    
    def get_bonds_by_yield(self, board: str = 'TQOB', min_yield: float = 0, 
                           max_yield: float = 100, limit: int = 50) -> pd.DataFrame:
        """
        Get bonds filtered by yield.
        
        Args:
            board: Trading mode
            min_yield: Minimum yield (%)
            max_yield: Maximum yield (%)
            limit: Maximum number of records
        
        Returns:
            DataFrame with filtered bonds
        """
        bonds = self.get_bonds_list(board)
        
        if bonds.empty:
            return bonds
        
        # Filter by yield
        filtered = bonds[
            (bonds["YIELD"] >= min_yield) & 
            (bonds["YIELD"] <= max_yield)
        ].copy()
        
        # Sort by yield
        filtered = filtered.sort_values("YIELD", ascending=False)
        
        return filtered.head(limit)
    
    def get_bonds_by_maturity(self, board: str = 'TQOB', 
                              min_years: float = 0, max_years: float = 30) -> pd.DataFrame:
        """
        Get bonds filtered by time to maturity.
        
        Args:
            board: Trading mode
            min_years: Minimum term (years)
            max_years: Maximum term (years)
        
        Returns:
            DataFrame with filtered bonds
        """
        bonds = self.get_bonds_list(board)
        
        if bonds.empty:
            return bonds
        
        # Filter by maturity date
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


# ==================== BASIC STOCK FUNCTIONALITY ====================

class MOEXStockClient:
    """Minimal client for working with stocks"""
    
    BASE_URL = "https://iss.moex.com/iss"
    DEFAULT_PARAMS = {"iss.meta": "off"}
    
    def get_stock_quote(self, secid: str) -> Dict:
        """
        Get current stock quote.
        
        Args:
            secid: Stock ticker (e.g., 'SBER', 'GAZP')
        
        Returns:
            Dictionary with quotes (LAST, PREVPRICE, HIGH, LOW, VOL)
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
        Minimal stock information.
        
        Args:
            secid: Stock ticker
        
        Returns:
            Dictionary with SECNAME, ISIN, LOTSIZE, FACEVALUE
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


# ==================== UNIFIED CLIENT ====================

class MOEXClient(MOEXBondClient, MOEXStockClient):
    """
    Full MOEX ISS API client.
    Main focus — bonds. Basic functionality — stocks.
    """
    
    def __init__(self):
        MOEXBondClient.__init__(self)
```

---

## Bondization Section Fields

### Coupons Section

| Field | Description |
|-------|-------------|
| `coupondate` | Coupon payment date |
| `value` | Coupon amount (RUB) |
| `valueprc` | Coupon rate (%) |
| `initial_face_value` | Face value on payment date |
| `accumulated_coupon` | Accrued interest on date |

### Amortizations Section

| Field | Description |
|-------|-------------|
| `amortdate` | Amortization date |
| `value` | Amortization amount (RUB) |
| `valueprc` | % of face value |
| `face_value` | Face value after amortization |

### Offers Section

| Field | Description |
|-------|-------------|
| `offerdate` | Offer date |
| `offertype` | Offer type (put/call) |
| `value` | Redemption price |
| `valueprc` | % of face value |

---

## Handling Null Values

### Interpreting Null in Key Fields

| Field | Null Value | Interpretation |
|-------|------------|----------------|
| `COUPONPERCENT` | `null` | Floater (floating rate) |
| `OFFERDATE` | `null` | No offer |
| `MATDATE` | `null` | Perpetual bond (rare) |
| `YIELD` | `null` | No trading / not calculated |
| `DURATION` | `null` | May not be calculated for floaters |

### Null Checking in Python

```python
def safe_float(value, default=0.0):
    """Safe conversion to float"""
    if value is None:
        return default
    try:
        return float(value)
    except (ValueError, TypeError):
        return default

# Example usage
info = client.get_bond_info("RU000A0JX0J2")
coupon_percent = safe_float(info.get("COUPONPERCENT"))
is_floater = info.get("COUPONPERCENT") is None
```

---

## Practical Examples

### Example 1: Get All OFZ List

```python
from moex_client import MOEXClient

client = MOEXClient()

# Get OFZ list
ofz_bonds = client.get_bonds_list("TQOB")

# Print top 5 by yield
top_yield = ofz_bonds.nlargest(5, "YIELD")[["SECID", "SECNAME", "YIELD", "DURATION"]]
print(top_yield)
```

### Example 2: Find Corporate Bond by ISIN

```python
client = MOEXClient()

# Search by ISIN
isin = "RU000A0ZYJY7"
secid = client.find_bond_by_isin(isin)

if secid:
    info = client.get_bond_info(secid)
    print(f"Name: {info.get('SECNAME')}")
    print(f"Yield: {info.get('YIELD')}%")
    print(f"Type: {client.get_bond_type(secid)}")
else:
    print("Bond not found")
```

### Example 3: Get Coupon Schedule

```python
client = MOEXClient()

secid = "RU000A0JX0J2"  # OFZ-26238-ПД
coupons = client.get_coupons(secid)

# Filter future coupons
from datetime import datetime
future_coupons = coupons[
    coupons["coupondate"] > datetime.now().strftime("%Y-%m-%d")
]

print(f"Number of future coupons: {len(future_coupons)}")
print(future_coupons[["coupondate", "value", "valueprc"]].head())
```

### Example 4: Check for Floater

```python
client = MOEXClient()

secid = "RU000A1038V6"  # Example floater
is_floater = client.is_floater(secid)

if is_floater:
    print("This is a floating rate bond (floater)")
    # For floaters, coupon rate is calculated by formula
else:
    info = client.get_bond_info(secid)
    print(f"Fixed coupon: {info.get('COUPONPERCENT')}%")
```

### Example 5: Get Offer Data

```python
client = MOEXClient()

secid = "RU000A0JX0J2"
offers = client.get_offers(secid)

if not offers.empty:
    print("Available offers:")
    print(offers[["offerdate", "offertype", "valueprc"]])
else:
    print("No offers (regular maturity bond)")
```

### Example 6: Calculate Yield to Maturity

```python
client = MOEXClient()

secid = "RU000A0JX0J2"
current_price = client.get_best_price(secid)

if current_price:
    print(f"Current price: {current_price}%")
    
    # Calculate yield at current price
    ytm = client.calculate_yield(secid, current_price)
    print(f"Approximate YTM: {ytm}%")
    
    # Compare with market yield
    info = client.get_bond_info(secid)
    market_yield = info.get("YIELD")
    print(f"Market yield: {market_yield}%")
```

### Example 7: Filter Bonds by Parameters

```python
client = MOEXClient()

# Find OFZ with yield 7-8% and maturity 5-10 years
bonds = client.get_bonds_list("TQOB")

filtered = bonds[
    (bonds["YIELD"] >= 7) & 
    (bonds["YIELD"] <= 8)
].copy()

# Add years to maturity
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

### Example 8: Complete Bond Analysis

```python
def analyze_bond(client, secid):
    """Complete bond analysis"""
    
    # Basic information
    info = client.get_bond_info(secid)
    
    print("=" * 60)
    print(f"BOND ANALYSIS: {info.get('SECNAME')}")
    print("=" * 60)
    
    # Identification
    print(f"\n[IDENTIFICATION]")
    print(f"  SECID: {secid}")
    print(f"  ISIN: {info.get('ISIN')}")
    print(f"  Type: {client.get_bond_type(secid)}")
    print(f"  Floater: {'Yes' if client.is_floater(secid) else 'No'}")
    
    # Issue parameters
    print(f"\n[ISSUE PARAMETERS]")
    print(f"  Face Value: {info.get('FACEVALUE')} {info.get('FACEUNIT')}")
    print(f"  Maturity Date: {info.get('MATDATE')}")
    print(f"  Issue Size: {info.get('ISSUESIZE'):,} pcs")
    
    # Coupons
    print(f"\n[COUPON]")
    if client.is_floater(secid):
        print(f"  Type: Floating (floater)")
    else:
        print(f"  Rate: {info.get('COUPONPERCENT')}%")
        print(f"  Amount: {info.get('COUPONVALUE')} RUB")
    print(f"  Frequency: {info.get('COUPONFREQUENCY')} times/year")
    print(f"  Next Coupon: {info.get('NEXTCOUPON')}")
    
    # Market data
    print(f"\n[MARKET DATA]")
    print(f"  Price: {client.get_best_price(secid)}%")
    print(f"  Accrued Interest: {info.get('ACCRUEDINT')} RUB")
    print(f"  Yield: {info.get('YIELD')}%")
    print(f"  Duration: {info.get('DURATION')} years ({info.get('DURATIONDAYS')} days)")
    
    # Offers
    offers = client.get_offers(secid)
    print(f"\n[OFFERS]")
    if not offers.empty:
        print(f"  Number of offers: {len(offers)}")
        for _, offer in offers.iterrows():
            print(f"  - {offer['offerdate']}: {offer.get('offertype', 'N/A')}")
    else:
        print(f"  No offers")
    
    # Risks
    print(f"\n[RISKS]")
    print(f"  High Risk: {'Yes' if info.get('HIGH_RISK') else 'No'}")
    print(f"  Listing Level: {info.get('LISTLEVEL')}")
    
    print("=" * 60)

# Usage
client = MOEXClient()
analyze_bond(client, "RU000A0JX0J2")
```

---

## Basic Stock Functionality

### Get Stock Quote

```python
from moex_client import MOEXClient

client = MOEXClient()

# Get Sberbank quote
quote = client.get_stock_quote("SBER")

print(f"Last Price: {quote.get('LAST')} RUB")
print(f"Close Price: {quote.get('PREVPRICE')} RUB")
print(f"Day High: {quote.get('HIGH')} RUB")
print(f"Day Low: {quote.get('LOW')} RUB")
print(f"Volume: {quote.get('VOL')} pcs")
```

### Get Stock Information

```python
client = MOEXClient()

info = client.get_stock_info("GAZP")

print(f"Name: {info.get('SECNAME')}")
print(f"ISIN: {info.get('ISIN')}")
print(f"Lot Size: {info.get('LOTSIZE')} pcs")
```

---

## Error Handling

### Common Errors

| HTTP Code | Description | Solution |
|-----------|-------------|----------|
| 404 | Bond not found | Check SECID/ISIN |
| 429 | Too Many Requests | Increase RATE_LIMIT_DELAY |
| 500 | Server Error | Retry request |
| 503 | Service Unavailable | Wait and retry |

### Retry Mechanism

```python
import time
from functools import wraps

def retry_on_error(max_retries=3, delay=1):
    """Decorator for retry attempts"""
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
                        raise  # Don't retry for 404
                    time.sleep(delay * (attempt + 1))
                except requests.RequestException as e:
                    last_exception = e
                    time.sleep(delay * (attempt + 1))
            raise last_exception
        return wrapper
    return decorator

# Usage
class MOEXBondClient:
    @retry_on_error(max_retries=3, delay=2)
    def _make_request(self, endpoint: str, params: Optional[Dict] = None) -> Dict:
        # ... implementation
        pass
```

---

## Usage Recommendations

### Rate Limiting

MOEX ISS API has rate limits. Recommended:

- Minimum interval between requests: **1 second**
- Use batch loading when many requests are needed
- Cache results for frequently used data

### Request Optimization

```python
# Bad: separate request for each bond
for secid in secids:
    info = client.get_bond_info(secid)  # N requests

# Good: get list once
bonds = client.get_bonds_list("TQOB")  # 1 request
# Then filter locally
```

### Caching

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

## Dependencies

```txt
# requirements.txt
requests>=2.28.0
pandas>=1.5.0
```

### Optional Dependencies

```txt
# For async requests
aiohttp>=3.8.0

# For caching
cachetools>=5.0.0

# For date handling
python-dateutil>=2.8.0
```

---

## References

- [MOEX ISS API Documentation](https://iss.moex.com/iss/reference/)
- [MOEX ISS API Reference (English)](https://www.moex.com/a2193)
- [MOEX API Usage Examples](https://github.com/moex-online/moex-api-examples)

---

## Summary

This skill provides a complete toolkit for working with bonds on the Moscow Exchange:

1. **Getting Lists** — OFZ, corporate, municipal
2. **Detailed Information** — issue parameters, coupons, market data
3. **Bondization** — complete schedule of coupons, amortizations, offers
4. **Analytics** — yield calculation, duration, bond type determination
5. **Filtering** — by yield, term, type

For stocks, only basic functionality is available: getting quotes and minimal information.
