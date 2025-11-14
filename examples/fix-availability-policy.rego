package main

# Thresholds for fix availability
fix_availability_thresholds = {
  "Has Fix (Upgradable)": 5,
}

deny contains msg if {
    vuln_count = count([v | v = input.vulnerabilities[_]; v.isUpgradable == true])
    vuln_count > fix_availability_thresholds["Has Fix (Upgradable)"]
    msg = sprintf("Policy Violation - Vulnerabilities with available fixes (upgradable): %v found, exceeds threshold of %v", [vuln_count, fix_availability_thresholds["Has Fix (Upgradable)"]])
}

