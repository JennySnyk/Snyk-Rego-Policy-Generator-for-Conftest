package main

# Test Policy 4: Track Vulnerabilities Without Fixes
# This policy warns about vulnerabilities that have no available fix

# Thresholds for fix availability
fix_availability_thresholds = {
  "No Fix Available": 1,
}

deny contains msg if {
    vuln_count = count([v | v = input.vulnerabilities[_]; v.isUpgradable == false; v.isPatchable == false])
    vuln_count > fix_availability_thresholds["No Fix Available"]
    msg = sprintf("Policy Violation - Vulnerabilities with NO available fix: %v found, exceeds threshold of %v", [vuln_count, fix_availability_thresholds["No Fix Available"]])
}

