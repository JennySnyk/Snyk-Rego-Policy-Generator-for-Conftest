package main

# Test Policy 2: CVSS Score Threshold
# This policy fails if any vulnerability has CVSS >= 7.5

deny contains msg if {
    min_cvss = 7.5
    high_cvss_vulns = [v | v = input.vulnerabilities[_]; v.cvssScore >= min_cvss]
    vuln_count = count(high_cvss_vulns)
    vuln_count > 0
    msg = sprintf("Policy Violation - Found %v vulnerabilities with CVSS score >= %v", [vuln_count, min_cvss])
}

