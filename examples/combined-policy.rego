package main

# Thresholds for severity
severity_thresholds = {
  "critical": 0,
  "high": 10,
}

# Thresholds for fix availability
fix_availability_thresholds = {
  "No Fix Available": 20,
}

# Critical severity check
deny contains msg if {
    current_value = "critical"
    vuln_count = count([v | v = input.vulnerabilities[_]; v.severity == current_value])
    vuln_count > severity_thresholds[current_value]
    msg = sprintf("Policy Violation - Severity '%s': %v found, exceeds threshold of %v", [current_value, vuln_count, severity_thresholds[current_value]])
}

# High severity check
deny contains msg if {
    current_value = "high"
    vuln_count = count([v | v = input.vulnerabilities[_]; v.severity == current_value])
    vuln_count > severity_thresholds[current_value]
    msg = sprintf("Policy Violation - Severity '%s': %v found, exceeds threshold of %v", [current_value, vuln_count, severity_thresholds[current_value]])
}

# No fix available check
deny contains msg if {
    vuln_count = count([v | v = input.vulnerabilities[_]; v.isUpgradable == false; v.isPatchable == false])
    vuln_count > fix_availability_thresholds["No Fix Available"]
    msg = sprintf("Policy Violation - Vulnerabilities with NO available fix: %v found, exceeds threshold of %v", [vuln_count, fix_availability_thresholds["No Fix Available"]])
}

# CVSS score check
deny contains msg if {
    min_cvss = 8.0
    high_cvss_vulns = [v | v = input.vulnerabilities[_]; v.cvssScore >= min_cvss]
    vuln_count = count(high_cvss_vulns)
    vuln_count > 0
    msg = sprintf("Policy Violation - Found %v vulnerabilities with CVSS score >= %v", [vuln_count, min_cvss])
}

