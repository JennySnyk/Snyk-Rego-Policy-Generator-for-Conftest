# Snyk Rego Policy Generator for Conftest

> **Version 3.0** - Now with Blocked Packages Policy! 🆕

This CLI tool generates custom Rego policies to validate Snyk scan outputs using `conftest`. It provides an interactive prompt to build policies based on Snyk product type and specific security criteria.

`conftest` is a utility that helps you write tests against structured configuration data. By using this generator, you can create custom policies to enforce security and compliance standards on your Snyk scan results directly in your CI/CD pipeline.

## 🆕 What's New in Version 3.0

**Blocked Packages Policy** - Create a deny-list of packages that should ALWAYS fail policy checks:

| Use Case | Example |
|----------|---------|
| 🚫 **Supply chain attacks** | `event-stream`, `ua-parser-js`, `coa` |
| ⚖️ **License compliance** | Block GPL/AGPL in proprietary projects |
| 🏢 **Organizational policies** | Enforce approved dependency lists |
| 📦 **Deprecated libraries** | `request`, `moment`, `left-pad` |
| 🔒 **Security incidents** | Quickly block compromised packages |

### Quick Start v3

```bash
./rego-policy-generator-v3
```

### Example: Block Malicious Packages

```
Which policy type do you want to apply?
1. Severity
2. Exploit Maturity
3. Blocked Packages 🆕
Enter the number of your choice: 3

📦 BLOCKED PACKAGES CONFIGURATION
Enter package name to block (or 'done' to finish): event-stream
  Reason for blocking 'event-stream': supply chain attack
  ✅ Added 'event-stream' to blocklist
```

**Generated Policy:**
```rego
blocked_packages = {
  "event-stream": "supply chain attack",
}

deny contains msg if {
    pkg_name := blocked_packages[_]
    v := all_vulnerabilities[_]
    v.packageName == pkg_name
    msg := sprintf("🚫 BLOCKED PACKAGE DETECTED: '%s' - Reason: %s", 
                   [pkg_name, blocked_packages[pkg_name]])
}
```

---

## 🎯 Version History

| Version | File | Key Features |
|---------|------|--------------|
| v1 | `rego-policy-generator.original` | Basic severity & exploit maturity |
| v2 | `rego-policy-generator` | + Advanced filtering, CVSS, CVE, Fix Availability |
| **v3** | `rego-policy-generator-v3` | + **Blocked Packages Policy** 🆕 |

---

## Features

- **Interactive CLI**: Guides you through creating complex Rego policies
- **Product-Specific Policies**: Offers different policy options tailored to each Snyk product
- **Threshold Control**: Set specific failure thresholds for each rule, or use the "unlimited" option to report on all findings without failing the build
- **Advanced Filtering**: Fix availability, CVSS scores, CVE-specific checks, and more
- **Nested Structure Support**: Handles vulnerabilities in both `input.vulnerabilities[]` and `input.applications[].vulnerabilities[]`
- **Blocked Packages**: Create deny-lists for specific packages (v3)

### Supported Policies by Product

| Snyk Product | Supported Policies | Input Format |
|--------------|-------------------|--------------|
| **Open Source** | Severity, Exploit Maturity, Fix Availability, CVSS Score, CVE, Ignored Vulnerabilities, **Blocked Packages** 🆕 | JSON |
| **Code** | Severity, CWE, CVSS Score | JSON (SARIF) |
| **Container** | Severity, Exploit Maturity, Fix Availability, CVSS Score, CVE, Ignored Vulnerabilities, **Blocked Packages** 🆕 | JSON |
| **IaC** | Severity | Text |

---

## Usage

### 1. Generate a Policy

```bash
# Version 3 (recommended - includes blocked packages)
./rego-policy-generator-v3

# Version 2 (advanced filtering)
./rego-policy-generator
```

### 2. Run Snyk and Conftest

Pipe the Snyk scan output directly into `conftest` for immediate validation:

**For Open Source, Code, and Container (JSON):**
```bash
# Snyk Open Source
snyk test --json | conftest test --policy your_policy.rego -

# Snyk Code
snyk code test --sarif | conftest test --policy your_policy.rego -

# Snyk Container
snyk container test your-image --json | conftest test --policy your_policy.rego -
```

**For Snyk IaC (Text):**
```bash
snyk iac test | conftest test --policy your_policy.rego -
```

### 3. CI/CD Pipeline Example

```bash
# Generate policy once
./rego-policy-generator-v3

# In your CI pipeline:
snyk test --json > snyk-results.json
conftest test --policy security-policy.rego snyk-results.json
# Exit code 0 = pass, non-zero = policy violation
```

---

## Examples

Check the `examples/` directory for working policy samples, or see the [QUICK_START.md](QUICK_START.md) guide for detailed scenarios.

### Quick Example: Enforce Fix Application
```bash
./rego-policy-generator
# Select: 1 (Snyk Open Source)
# Choose: 3 (Fix Availability)  
# Select: 1 (Has Fix - Upgradable)
# Threshold: 5
```

This creates a policy that fails if more than 5 vulnerabilities with available fixes are found.

## Sample Policies

Check out the `Sample of rego/` directory for working examples:

| File | Description |
|------|-------------|
| `iceman-oss.rego` | Open Source with severity + exploit thresholds |
| `iceman-container.rego` | Container with CWE exclusions |
| `log4j-core-test.rego` | CVE-specific blocking |
| `owasp-top10.rego` | OWASP Top 10 checks |

---

## Prerequisites

- Python 3
- [Conftest](https://www.conftest.dev/install/)
- [Snyk CLI](https://docs.snyk.io/snyk-cli/install-the-snyk-cli)

## Installation

```bash
git clone https://github.com/JennySnyk/Snyk-Rego-Policy-Generator-for-Conftest.git
cd Snyk-Rego-Policy-Generator-for-Conftest

# Make executable
chmod +x rego-policy-generator-v3

# Run
./rego-policy-generator-v3
```

---

## Documentation

- **[QUICK_START.md](QUICK_START.md)** - Quick reference and common scenarios
- **[FEATURES.md](FEATURES.md)** - Detailed feature documentation
- **[examples/](examples/)** - Working policy examples

## Contributing

Issues and pull requests are welcome! Future enhancements could include:
- Version-specific package blocking (e.g., `lodash@<4.17.21`)
- License-based policies
- SBOM integration
- Auto-detection of JSON structure

## License

This project is provided as-is for use with Snyk security scanning.
