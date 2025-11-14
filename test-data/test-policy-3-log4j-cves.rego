package main

# Test Policy 3: Block Log4Shell CVEs
# This policy fails on any occurrence of specific Log4j CVEs

# Thresholds for cve
cve_thresholds = {
  "CVE-2021-44832": 0,
  "CVE-2021-45046": 0,
}

deny contains msg if {
    cve_id = "CVE-2021-44832"
    vuln_count = count([v | v = input.vulnerabilities[_].identifiers.CVE[_]; v == cve_id])
    vuln_count > cve_thresholds[cve_id]
    msg = sprintf("Policy Violation - CVE '%s': %v found, exceeds threshold of %v", [cve_id, vuln_count, cve_thresholds[cve_id]])
}

deny contains msg if {
    cve_id = "CVE-2021-45046"
    vuln_count = count([v | v = input.vulnerabilities[_].identifiers.CVE[_]; v == cve_id])
    vuln_count > cve_thresholds[cve_id]
    msg = sprintf("Policy Violation - CVE '%s': %v found, exceeds threshold of %v", [cve_id, vuln_count, cve_thresholds[cve_id]])
}

