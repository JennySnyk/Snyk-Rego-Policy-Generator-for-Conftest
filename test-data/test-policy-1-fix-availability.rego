package main

# Test Policy 1: Enforce Fix Application
# This policy fails if there are too many vulnerabilities with available fixes

# Thresholds for fix availability
fix_availability_thresholds = {
  "Has Fix (Upgradable)": 3,
}

deny contains msg if {
    vuln_count = count([v | v = input.vulnerabilities[_]; v.isUpgradable == true])
    vuln_count > fix_availability_thresholds["Has Fix (Upgradable)"]
    msg = sprintf("Policy Violation - Vulnerabilities with available fixes (upgradable): %v found, exceeds threshold of %v", [vuln_count, fix_availability_thresholds["Has Fix (Upgradable)"]])
}

