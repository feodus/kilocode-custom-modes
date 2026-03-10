---
name: security-testing
description: Security testing fundamentals, vulnerability assessment, penetration testing basics. Use when testing for security vulnerabilities, OWASP Top 10 compliance, and secure coding practices.
---

# Security Testing

> **Meta:** v1.0.0 | 09-03-2026

## Purpose

Skill for comprehensive security testing of applications. Covers vulnerability assessment, penetration testing fundamentals, OWASP Top 10 testing, and security best practices. Essential for identifying and mitigating security risks before deployment.

## When to Use

Use this skill:
- When performing security testing of web applications
- For vulnerability assessment and scanning
- When testing authentication and authorization mechanisms
- For OWASP Top 10 compliance verification
- During penetration testing activities
- When validating secure coding practices
- For security regression testing

## Security Testing Types

### Vulnerability Assessment

Systematic review of security weaknesses:

1. **Automated Scanning**
   - Use vulnerability scanners (OWASP ZAP, Nessus, Qualys)
   - Run SAST tools (SonarQube, Checkmarx)
   - Execute DAST tools during runtime
   - Scan dependencies for known vulnerabilities

2. **Manual Review**
   - Code review for security flaws
   - Configuration audit
   - Architecture security review
   - Access control verification

3. **Reporting**
   - Document discovered vulnerabilities
   - Classify by severity
   - Provide remediation recommendations
   - Track fix verification

### Penetration Testing

Authorized simulated attacks:

1. **Information Gathering**
   - Reconnaissance techniques
   - footprint
   - Social engineering
   - Open source intelligence

2. **Vulnerability Exploitation**
   - Exploiting known vulnerabilities
   - Testing for weak configurations
   - Attempting privilege escalation
   - Testing for injection flaws

3. **Post-Exploitation**
   - Maintaining access
   - Data exfiltration testing
   - Lateral movement
   - Documentation and reporting

## OWASP Top 10 Testing

### A01:2021 — Broken Access Control

Testing for unauthorized access:

```python
# Test for IDOR (Insecure Direct Object Reference)
def test_unauthorized_user_access():
    """Test that user cannot access other user's data"""
    # Login as user A
    response = client.get("/api/users/other_user_id")
    assert response.status_code == 403  # Forbidden

def test_privilege_escalation():
    """Test that regular user cannot access admin functions"""
    response = client.get("/api/admin/users")
    assert response.status_code == 403

def test_directory_traversal():
    """Test for path traversal vulnerabilities"""
    response = client.get("/api/files/../../../etc/passwd")
    assert response.status_code == 400
```

### A02:2021 — Cryptographic Failures

Testing encryption implementation:

```python
def test_sensitive_data_encryption():
    """Verify sensitive data is encrypted at rest"""
    # Check database storage
    response = client.get("/api/users/1")
    assert "password" not in response.json()
    assert "credit_card" not in response.json()

def test_transport_layer_security():
    """Verify HTTPS is enforced"""
    response = requests.get("http://example.com", allow_redirects=False)
    assert response.status_code in [301, 302]
    assert "https" in response.headers["Location"].lower()

def test_weak_encryption_algorithms():
    """Verify weak ciphers are not used"""
    # Test SSL/TLS configuration
    config = get_ssl_configuration()
    assert "TLSv1.0" not in config.versions
    assert "TLSv1.1" not in config.versions
```

### A03:2021 — Injection

Testing for injection vulnerabilities:

```python
def test_sql_injection_login():
    """Test for SQL injection in login form"""
    payloads = [
        "' OR '1'='1",
        "' OR '1'='1' --",
        "admin'--",
        "' UNION SELECT * FROM users--"
    ]
    for payload in payloads:
        response = client.post("/api/login", json={
            "username": payload,
            "password": "anything"
        })
        # Should not return 200 with valid session
        assert "session" not in response.cookies or response.status_code == 400

def test_xss_reflected():
    """Test for reflected XSS"""
    response = client.get("/api/search?q=<script>alert(1)</script>")
    assert "<script>" not in response.text

def test_xss_stored():
    """Test for stored XSS"""
    response = client.post("/api/comments", json={
        "content": "<img src=x onerror=alert(1)>"
    })
    # Retrieve comment
    comments = client.get("/api/comments").json()
    assert "<img" not in str(comments)

def test_command_injection():
    """Test for OS command injection"""
    response = client.get("/api/ping?host=;cat /etc/passwd")
    assert "root:" not in response.text
```

### A04:2021 — Insecure Design

Testing architectural security:

```python
def test_missing_rate_limiting():
    """Verify rate limiting is implemented"""
    for _ in range(110):
        response = client.post("/api/login", json={
            "username": "test", "password": "wrong"
        })
    # After 100 attempts, should be blocked
    assert response.status_code == 429

def test_missing_function_level_authorization():
    """Verify admin endpoints require admin role"""
    # Try admin endpoint with regular user token
    response = client.get("/api/admin/dashboard", headers=user_token)
    assert response.status_code == 403
```

### A05:2021 — Security Misconfiguration

Testing for misconfigurations:

```python
def test_debug_mode_disabled():
    """Verify debug mode is disabled in production"""
    response = client.get("/api/debug/info")
    assert response.status_code == 404

def test_default_credentials():
    """Test for default credentials"""
    default_creds = [
        ("admin", "admin"),
        ("admin", "password"),
        ("root", "root")
    ]
    for username, password in default_creds:
        response = client.post("/api/login", json={
            "username": username, "password": password
        })
        assert response.status_code in [400, 401, 403]

def test_verbose_error_messages():
    """Verify error messages don't leak sensitive info"""
    response = client.get("/api/user/99999")
    error_detail = response.json().get("detail", "")
    assert "traceback" not in error_detail.lower()
    assert "sql" not in error_detail.lower()
    assert "database" not in error_detail.lower()

def test_security_headers():
    """Verify security headers are present"""
    response = client.get("/")
    headers = response.headers
    assert "X-Content-Type-Options" in headers
    assert headers.get("X-Content-Type-Options") == "nosniff"
    assert "X-Frame-Options" in headers
    assert "Strict-Transport-Security" in headers
```

### A06:2021 — Vulnerable Components

Testing for vulnerable dependencies:

```bash
# Check for vulnerable dependencies
npm audit
pip-audit
safety check
owasp-dependency-check
```

### A07:2021 — Authentication Failures

Testing authentication mechanisms:

```python
def test_password_complexity():
    """Verify password complexity requirements"""
    weak_passwords = ["123456", "password", "admin", "qwerty"]
    for password in weak_passwords:
        response = client.post("/api/register", json={
            "username": "testuser",
            "password": password
        })
        assert response.status_code == 400

def test_session_timeout():
    """Verify sessions expire after inactivity"""
    # Login and wait for timeout
    response = client.post("/api/login", json=credentials)
    session_token = response.cookies["session"]
    
    # Wait for session to expire
    time.sleep(3601)  # More than 1 hour
    
    response = client.get("/api/profile", cookies={"session": session_token})
    assert response.status_code == 401

def test_concurrent_session_limit():
    """Verify user cannot have multiple sessions"""
    # Login from two devices
    session1 = client.post("/api/login", json=credentials).cookies
    session2 = client.post("/api/login", json=credentials).cookies
    
    # First session should be invalidated
    response = client.get("/api/profile", cookies=session1)
    assert response.status_code == 401
```

### A08:2021 — Software and Data Integrity Failures

Testing for integrity issues:

```python
def test_subresource_integrity():
    """Verify CDN resources have integrity hashes"""
    response = client.get("/")
    # Check that scripts have integrity attributes
    assert 'integrity="sha256-' in response.text

def test_update_signature_verification():
    """Verify software updates are signed"""
    update = get_latest_update()
    assert verify_signature(update)
```

### A09:2021 — Security Logging Failures

Testing security logging:

```python
def test_failed_login_logged():
    """Verify failed login attempts are logged"""
    response = client.post("/api/login", json={
        "username": "admin",
        "password": "wrong"
    })
    # Check logs were created
    logs = get_security_logs()
    assert any("failed" in log.message.lower() for log in logs)

def test_sensitive_data_not_in_logs():
    """Verify sensitive data isn't logged"""
    response = client.post("/api/login", json={
        "username": "user",
        "password": "secret123"
    })
    logs = get_security_logs()
    for log in logs:
        assert "secret123" not in log.message
```

### A10:2021 — SSRF

Testing for Server-Side Request Forgery:

```python
def test_ssrf_internal_services():
    """Test for SSRF vulnerabilities"""
    ssrf_payloads = [
        "http://localhost/admin",
        "http://127.0.0.1:8080",
        "http://metadata.google.internal/computeMetadata"
    ]
    for payload in ssrf_payloads:
        response = client.get(f"/api/fetch?url={payload}")
        assert response.status_code in [400, 403]
        assert "localhost" not in response.text.lower()
        assert "127.0.0.1" not in response.text.lower()
```

## Security Testing Tools

### Static Application Security Testing (SAST)

| Tool | Language | Description |
|------|----------|-------------|
| SonarQube | Multi | Code quality and security |
| Checkmarx | Multi | Static analysis |
| Bandit | Python | Security issues in Python |
| ESLint security | JavaScript | Security rules for ESLint |

### Dynamic Application Security Testing (DAST)

| Tool | Description |
|------|-------------|
| OWASP ZAP | Web application scanner |
| Burp Suite | Web security testing |
| Nikto | Web server scanner |

### Dependency Scanning

| Tool | Language | Description |
|------|----------|-------------|
| npm audit | JavaScript | Check npm dependencies |
| pip-audit | Python | Check Python packages |
| OWASP Dependency-Check | Multi | Scan dependencies |

### Password Testing

| Tool | Description |
|------|-------------|
| Hashcat | Password cracking |
| John the Ripper | Password recovery |
| Hydra | Login brute-force |

## Security Testing Checklist

### Pre-Testing
- [ ] Scope defined
- [ ] Authorization obtained
- [ ] Rules of engagement established
- [ ] Tools configured
- [ ] Test data prepared

### Authentication Testing
- [ ] Credential stuffing protection
- [ ] Password policy enforcement
- [ ] Session management
- [ ] Multi-factor authentication
- [ ] Password reset functionality

### Authorization Testing
- [ ] Access control enforcement
- [ ] Privilege escalation prevention
- [ ] IDOR protection
- [ ] Horizontal/vertical access control

### Input Validation Testing
- [ ] SQL injection prevention
- [ ] XSS protection
- [ ] Command injection prevention
- [ ] Path traversal prevention
- [ ] CSV injection prevention

### Configuration Testing
- [ ] Security headers present
- [ ] Debug mode disabled
- [ ] Default credentials changed
- [ ] Error handling secure
- [ ] TLS/SSL configuration

### Data Protection
- [ ] Sensitive data encrypted
- [ ] Data at rest protected
- [ ] Data in transit encrypted
- [ ] No sensitive data in logs
- [ ] PII properly handled

## Related Skills

- api-testing — API security testing
- test-automation-frameworks — integrating security tests
- performance-testing — security under load
- accessibility-testing — accessibility security
- defect-management — reporting security defects

---
*Security Testing — identifying and mitigating security vulnerabilities*
