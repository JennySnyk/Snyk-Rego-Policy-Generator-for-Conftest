package main

# Thresholds for severity
severity_thresholds = {
  "critical": 5,
}

# Thresholds for exploit maturity
exploit_maturity_thresholds = {
  "Mature": 5,
}


deny contains msg if {
    current_value = "critical"
    vuln_count = count([v | v = input.vulnerabilities[_]; v.severity == current_value])
    vuln_count > severity_thresholds[current_value]
    msg = sprintf("Policy Violation - Severity '%s': %v found, exceeds threshold of %v", [current_value, vuln_count, severity_thresholds[current_value]])
}


deny contains msg if {
    current_value = "Mature"
    vuln_count = count([v | v = input.vulnerabilities[_]; v.exploit == current_value])
    vuln_count > exploit_maturity_thresholds[current_value]
    msg = sprintf("Policy Violation - Exploit Maturity '%s': %v found, exceeds threshold of %v", [current_value, vuln_count, exploit_maturity_thresholds[current_value]])
}
