# Changelog

All notable changes to the Snyk Rego Policy Generator will be documented in this file.

## [2.0.0] - 2024

### Added
- **Fix Availability Filtering**: New policy option to filter vulnerabilities based on fix availability
  - `Has Fix (Upgradable)`: Check for vulnerabilities with available upgrades
  - `Has Patch`: Check for vulnerabilities with available patches
  - `No Fix Available`: Check for vulnerabilities without any fix option
  
- **CVSS Score Thresholds**: Set policies based on CVSS scores (0.0-10.0) for more granular vulnerability severity control
  - Available for: Snyk Open Source, Snyk Code, Snyk Container

- **CVE-Specific Policies**: Target specific CVE IDs to ensure critical vulnerabilities are addressed
  - Support for comma-separated CVE lists
  - Available for: Snyk Open Source, Snyk Container

- **Ignored Vulnerabilities**: Define vulnerability IDs to exclude from policy checks
  - Useful for known false positives or accepted risks
  - Creates helper functions in generated Rego policies
  - Available for: Snyk Open Source, Snyk Container

- **Enhanced Documentation**: 
  - Updated README with detailed policy type explanations
  - Added usage examples for all new features
  - Created examples directory with sample policies

### Changed
- Updated policy menu to display new options based on selected Snyk product
- Enhanced `generate_rego_rules()` to support new policy types
- Improved `generate_rego_file()` to handle complex threshold maps

### Technical Details
- Fix availability checks use `isUpgradable` and `isPatchable` fields from Snyk JSON output
- CVSS score filtering uses `cvssScore` field from vulnerability data
- CVE checks query the `identifiers.CVE` array in Snyk output
- Maintained backward compatibility with existing policy types

## [1.0.0] - Initial Release

### Features
- Interactive CLI for policy generation
- Support for Snyk Open Source, Code, Container, and IaC
- Severity-based policies
- Exploit maturity policies
- CWE-based policies for Snyk Code
- Configurable thresholds with unlimited option

