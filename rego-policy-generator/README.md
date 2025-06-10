# Snyk Rego Policy Generator for Conftest

This CLI tool generates custom Rego policies to validate Snyk scan outputs using `conftest`. It provides an interactive prompt to build policies based on Snyk product type and specific security criteria.

`conftest` is a utility that helps you write tests against structured configuration data. By using this generator, you can create custom policies to enforce security and compliance standards on your Snyk scan results directly in your CI/CD pipeline.

## Features

- **Interactive CLI**: Guides you through creating complex Rego policies.
- **Product-Specific Policies**: Offers different policy options tailored to each Snyk product.
- **Threshold Control**: Set specific failure thresholds for each rule, or use the "unlimited" option to report on all findings without failing the build.

### Supported Policies by Product

| Snyk Product      | Supported Policies         | Input Format |
| ----------------- | -------------------------- | ------------ |
| **Open Source**   | `Severity`, `Exploit Maturity` | JSON         |
| **Code**          | `Severity`, `CWE`              | JSON (SARIF) |
| **Container**     | `Severity`, `Exploit Maturity` | JSON         |
| **IaC**           | `Severity`                 | Text         |

## Usage

1.  **Generate a Policy**

    Run the script and follow the on-screen prompts:
    ```bash
    ./rego-policy-generator
    ```

2.  **Run a Snyk Scan**

    Run the appropriate Snyk scan and save the output. **Note the required output format for each product.**

    *   **For Open Source, Code, and Container (JSON):**
        ```bash
        # Snyk Open Source
        snyk test --json > snyk-os.json

        # Snyk Code
        snyk code test --sarif > snyk-code.json

        # Snyk Container
        snyk container test your-image --json > snyk-container.json
        ```

    *   **For Snyk IaC (Text):**
        ```bash
        snyk iac test > snyk-iac.txt
        ```

3.  **Run `conftest`**

    Use the generated policy to test the Snyk output file:
    ```bash
    conftest test --policy your_generated_policy.rego --input snyk-os.json
    ```

## Prerequisites

- Python 3
- [Conftest](https://www.conftest.dev/install/)
- [Snyk CLI](https://docs.snyk.io/snyk-cli/install-the-snyk-cli)
