# Snyk Rego Policy Generator for Conftest

> **Version 2.0** - Enhanced with advanced filtering capabilities

This CLI tool generates custom Rego policies to validate Snyk scan outputs using `conftest`. It provides an interactive prompt to build policies based on Snyk product type and specific security criteria.

`conftest` is a utility that helps you write tests against structured configuration data. By using this generator, you can create custom policies to enforce security and compliance standards on your Snyk scan results directly in your CI/CD pipeline.

## Features

- **Interactive CLI**: Guides you through creating complex Rego policies
- **Product-Specific Policies**: Offers different policy options tailored to each Snyk product
- **Threshold Control**: Set specific failure thresholds for each rule, or use the "unlimited" option to report on all findings without failing the build
- **Advanced Filtering**: Fix availability, CVSS scores, CVE-specific checks, and more

### Supported Policies by Product

| Snyk Product      | Supported Policies         | Input Format |
| ----------------- | -------------------------- | ------------ |
| **Open Source**   | `Severity`, `Exploit Maturity`, `Fix Availability`, `CVSS Score`, `CVE`, `Ignored Vulnerabilities` | JSON         |
| **Code**          | `Severity`, `CWE`, `CVSS Score`              | JSON (SARIF) |
| **Container**     | `Severity`, `Exploit Maturity`, `Fix Availability`, `CVSS Score`, `CVE`, `Ignored Vulnerabilities` | JSON         |
| **IaC**           | `Severity`                 | Text         |

## Usage

1.  **Generate a Policy**

    Run the script and follow the on-screen prompts:
    ```bash
    ./rego-policy-generator
    ```

2.  **Run Snyk and `conftest`**

    Pipe the Snyk scan output directly into `conftest` for immediate validation. Use the `-` argument to tell `conftest` to read from stdin.

    *   **For Open Source, Code, and Container (JSON):**
        ```bash
        # Snyk Open Source
        snyk test --json | conftest test --policy your_policy.rego -

        # Snyk Code
        snyk code test --sarif | conftest test --policy your_policy.rego -

        # Snyk Container
        snyk container test your-image --json | conftest test --policy your_policy.rego -
        ```

    *   **For Snyk IaC (Text):**
        ```bash
        snyk iac test | conftest test --policy your_policy.rego -
        ```

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

## Prerequisites

- Python 3
- [Conftest](https://www.conftest.dev/install/)
- [Snyk CLI](https://docs.snyk.io/snyk-cli/install-the-snyk-cli)

## Documentation

- **[QUICK_START.md](QUICK_START.md)** - Quick reference and common scenarios
- **[FEATURES.md](FEATURES.md)** - Detailed feature documentation
- **[examples/](examples/)** - Working policy examples

## Version History

**Current Version: 2.0** - See git tags for version tracking
- Added Fix Availability filtering
- Added CVSS Score thresholds
- Added CVE-Specific policies
- Added Ignored Vulnerabilities support

## Contributing

Issues and pull requests are welcome! Please see existing examples and documentation for guidance.

## License

This project is provided as-is for use with Snyk security scanning.
