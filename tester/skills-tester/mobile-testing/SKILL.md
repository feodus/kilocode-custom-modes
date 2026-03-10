---
name: mobile-testing
description: Mobile application testing strategies for iOS and Android. Use when testing mobile apps, designing mobile test strategies, validating mobile-specific functionality.
---

# Mobile Testing

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for performing mobile application testing including iOS and Android testing strategies, device fragmentation handling, mobile-specific functionality testing, and mobile automation with Appium. Designed for comprehensive mobile quality assurance.

## When to Use

Use this skill:
- When testing mobile applications (iOS/Android)
- For designing mobile test strategies
- When testing device-specific features
- For mobile automation with Appium
- When testing responsive designs
- During mobile app certification
- For performance testing on mobile devices

## Functions

### Mobile Testing Types

Different types of mobile testing:

```markdown
## Mobile Testing Categories

| Type | Description | Focus Areas |
|------|-------------|-------------|
| Functional Testing | Core features work correctly | User flows, navigation |
| UI/UX Testing | Visual consistency | Layout, typography, colors |
| Compatibility Testing | Works across devices | OS versions, screen sizes |
| Performance Testing | Speed and responsiveness | Load time, battery |
| Security Testing | Data protection | Storage, transmission |
| Accessibility Testing | Usability for all | Screen readers, contrast |
| Localization Testing | Language and region | i18n, L10n |
| Network Testing | Works on different networks | WiFi, 4G, offline |

### Mobile-Specific Considerations
- Touch gestures (tap, swipe, pinch)
- Device orientation
- Screen sizes (phones, tablets)
- Hardware buttons
- Camera, GPS, sensors
- Push notifications
- Background/foreground transitions
```

### Android Testing

Android-specific testing approaches:

```markdown
## Android Testing Checklist

### Device Coverage
| Category | Devices |
|----------|---------|
| Flagship | Samsung S23, Pixel 8 |
| Mid-range | Samsung A54, OnePlus |
| Budget | Xiaomi Redmi, Moto G |
| Tablet | Samsung Tab, Pixel Tab |

### OS Version Coverage
- Android 14 (API 34)
- Android 13 (API 33)
- Android 12 (API 31)
- Android 11 (API 30)

### Android-Specific Tests
| Feature | Test Cases |
|---------|------------|
| Navigation | Back button, gesture nav, 3-button nav |
| Notifications | Push notifications, toast messages |
| Permissions | Camera, location, storage |
| Background | App killed, app in background |
| Battery | Battery optimization, Doze mode |
| Play Store | Pre-launch crash reports |
```

### iOS Testing

iOS-specific testing approaches:

```markdown
## iOS Testing Checklist

### Device Coverage
| Category | Devices |
|----------|---------|
| Latest | iPhone 15 Pro, iPhone 15 |
| Recent | iPhone 14 Pro, iPhone 14 |
| Older | iPhone 13, iPhone 12 |
| Tablet | iPad Pro, iPad Air |

### iOS Version Coverage
- iOS 17
- iOS 16
- iOS 15

### iOS-Specific Tests
| Feature | Test Cases |
|---------|------------|
| Gestures | Swipe back, home gesture, control center |
| Notch/Dynamic Island | Content visibility |
| Face ID/Touch ID | Authentication |
| Dark Mode | UI consistency |
| App Library | App organization |
| Widgets | Home screen widgets |

### Xcode Tools
- **Instruments:** Performance profiling
- **Accessibility Inspector:** Accessibility testing
- **Console:** Debug logging
```

### Appium Setup

Mobile automation with Appium:

```markdown
## Appium Configuration

### Desired Capabilities (Android)
```python
desired_caps = {
    'platformName': 'Android',
    'platformVersion': '14',
    'deviceName': 'Pixel 8',
    'app': '/path/to/app.apk',
    'appPackage': 'com.example.app',
    'appActivity': '.MainActivity',
    'automationName': 'UiAutomator2',
    'noReset': True,
    'fullReset': False,
    'chromeDriverExecutable': '/path/to/chromedriver'
}
```

### Desired Capabilities (iOS)
```python
desired_caps = {
    'platformName': 'iOS',
    'platformVersion': '17',
    'deviceName': 'iPhone 15 Pro',
    'app': '/path/to/app.ipa',
    'bundleId': 'com.example.app',
    'automationName': 'XCUITest',
    'noReset': True,
    'xcodeOrgId': 'TEAM_ID',
    'xcodeSigningId': 'iPhone Developer'
}
```

### Appium Test Example

```python
from appium import webdriver
from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class MobileTest:
    def setup_method(self):
        desired_caps = {
            'platformName': 'Android',
            'platformVersion': '14',
            'deviceName': 'Pixel 8',
            'app': 'app.apk',
            'appPackage': 'com.example.app',
            'automationName': 'UiAutomator2'
        }
        self.driver = webdriver.Remote(
            'http://localhost:4723/wd/hub',
            desired_caps
        )
    
    def test_login(self):
        # Find and interact with elements
        username = self.driver.find_element(
            AppiumBy.ANDROID_UIAUTOMATOR,
            'new UiSelector().resourceId("com.example.app:id/username")'
        )
        username.send_keys("testuser")
        
        password = self.driver.find_element(
            AppiumBy.ID,
            "com.example.app:id/password"
        )
        password.send_keys("password123")
        
        login_btn = self.driver.find_element(
            AppiumBy.ID,
            "com.example.app:id/login_button"
        )
        login_btn.click()
        
        # Assert success
        WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located(
                (AppiumBy.ID, "com.example.app:id/dashboard")
            )
        )
    
    def teardown_method(self):
        self.driver.quit()
```

### Mobile Test Strategies

```markdown
## Mobile Test Strategy

### Device Selection Matrix
| Priority | Android | iOS |
|----------|---------|-----|
| P0 | Samsung S23, Pixel 8 | iPhone 15 Pro |
| P1 | OnePlus, Samsung A-series | iPhone 14, iPhone 13 |
| P2 | Xiaomi, Moto | iPhone 12, iPad |

### Test Pyramid for Mobile
```
        /\
       /E2E\       ← Few E2E tests
      /------\
     /Integration\  ← More integration
    /------------\
   /Unit Tests-----← Most unit tests
```

### Network Conditions Testing
| Network | Latency | Bandwidth |
|---------|---------|-----------|
| 5G | 20ms | 100+ Mbps |
| 4G/LTE | 50ms | 20 Mbps |
| 3G | 100ms | 5 Mbps |
| 2G | 300ms | 250 Kbps |
| Offline | N/A | 0 |
```

## Usage Examples

### Example 1: Mobile Test Plan

```markdown
## Mobile Test Plan: Shopping App

**Application:** ShopApp v2.1
**Platforms:** Android 12+, iOS 15+

### Test Scope

#### Functional Tests
- User registration and login
- Product search and filters
- Add to cart functionality
- Checkout process
- Payment integration
- Order history

#### Device Coverage
| Device | OS | Priority |
|--------|-----|----------|
| Samsung S23 | Android 14 | P0 |
| Pixel 8 | Android 14 | P0 |
| iPhone 15 Pro | iOS 17 | P0 |
| Samsung A54 | Android 13 | P1 |
| iPhone 13 | iOS 16 | P1 |

### Test Results
- Total Test Cases: 120
- Passed: 115
- Failed: 5
- Blocked: 0

### Defects Found
| ID | Device | Issue | Severity |
|----|--------|-------|----------|
| MOB-001 | Samsung A54 | Cart crashes | High |
| MOB-002 | iPhone 13 | Payment timeout | Medium |
```

### Example 2: Appium Mobile Test

```python
# Mobile E2E test with Appium
def test_product_search_android(self):
    """Test product search on Android"""
    # Wait for app to load
    WebDriverWait(self.driver, 30).until(
        EC.presence_of_element_located(
            (AppiumBy.ID, "com.shopapp:id/search_icon")
        )
    )
    
    # Click search
    search_icon = self.driver.find_element(
        AppiumBy.ID, "com.shopapp:id/search_icon"
    )
    search_icon.click()
    
    # Enter search query
    search_input = self.driver.find_element(
        AppiumBy.ID, "com.shopapp:id/search_input"
    )
    search_input.send_keys("headphones")
    
    # Submit search
    self.driver.press_keycode(66)  # Enter key
    
    # Verify results
    results = self.driver.find_elements(
        AppiumBy.CLASS_NAME, "android.widget.TextView"
    )
    assert len(results) > 0
    assert "headphones" in results[0].text.lower()
```

## Document Templates

### Mobile Test Report

```markdown
## Mobile Test Report

**Application:** {App Name vX.X}
**Platforms:** {Android, iOS}
**Date:** {Date}

### Test Summary
| Platform | Devices Tested | Test Cases | Passed | Failed |
|----------|----------------|------------|--------|--------|
| Android | 5 | 100 | 95 | 5 |
| iOS | 4 | 100 | 98 | 2 |

### Device Results
| Device | OS | Status | Defects |
|--------|-----|--------|---------|
| Samsung S23 | Android 14 | Pass | 0 |
| iPhone 15 Pro | iOS 17 | Pass | 0 |

### Platform-Specific Issues
- {Issue 1}
- {Issue 2}

### Recommendations
1. {Recommendation 1}
2. {Recommendation 2}
```

### Mobile Device Matrix

```markdown
## Mobile Device Matrix

### Android
| Device | Model | OS Version | Screen | Status |
|--------|-------|------------|--------|--------|
| Samsung S23 | SM-S918 | Android 14 | 6.1" | Required |
| Pixel 8 | GVU6C | Android 14 | 6.2" | Required |
| Samsung A54 | SM-A546 | Android 13 | 6.4" | Recommended |

### iOS
| Device | Model | OS Version | Screen | Status |
|--------|-------|------------|--------|--------|
| iPhone 15 Pro | iPhone15Pro | iOS 17 | 6.1" | Required |
| iPhone 14 | iPhone14 | iOS 16 | 6.1" | Required |
| iPhone 13 | iPhone13 | iOS 15 | 6.1" | Recommended |
```

## Best Practices

### Mobile Testing

1. **Device fragmentation** — test on real devices
2. **Real conditions** — test on actual networks
3. **Gesture** — cover all touch interactions
4. ** testingOrientation changes** — test portrait and landscape
5. **Background apps** — test app switching

### Mobile Automation

1. **Use Appium** — industry standard
2. **Page object pattern** — maintainable tests
3. **Explicit waits** — avoid hard-coded sleeps
4. **Screenshots on failure** — debugging evidence
5. **Parallel execution** — faster test runs

### Device Selection

1. **Cover market share** — use analytics data
2. **Prioritize OS versions** — latest and previous
3. **Screen sizes** — phones and tablets
4. **Hardware variations** — cameras, sensors
5. **Real vs emulator** — both have uses

## Related Skills

- test-automation-frameworks — mobile automation
- test-case-design — mobile test cases
- performance-testing — mobile performance
- manual-testing — mobile exploratory testing
- test-data-management — mobile test data

---
*Mobile Testing — ensuring quality across the fragmented device ecosystem
