# Quick Start Guide - Enhanced Features

## Before vs After

### Before (v1.0)
```
Open Source Policy Options:
1. Severity (Critical, High, Medium, Low)
2. Exploit Maturity (Mature, Functional, PoC, Not Defined)
```

### After (v2.0) ✨
```
Open Source Policy Options:
1. Severity
2. Exploit Maturity
3. Fix Availability (NEW!)
   - Has Fix (Upgradable)
   - Has Patch
   - No Fix Available
4. CVSS Score (NEW!)
5. CVE-Specific (NEW!)
6. Ignored Vulnerabilities (NEW!)
```

## Real-World Examples

### Example 1: Enforce Security Fix Application
**Problem:** Team has many vulnerabilities with available fixes but they're not being applied.

**Solution:**
```bash
./rego-policy-generator
# Product: 1 (Open Source)
# Policy: 3 (Fix Availability)
# Option: 1 (Has Fix - Upgradable)
# Threshold: 5
```

**Result:** Build fails if more than 5 fixable vulnerabilities exist.

---

### Example 2: Block Log4Shell
**Problem:** Need to ensure Log4Shell CVEs never make it to production.

**Solution:**
```bash
./rego-policy-generator
# Product: 1 (Open Source)
# Policy: 5 (CVE)
# CVEs: CVE-2021-45046,CVE-2021-44832,CVE-2021-45105
# Threshold: 0
```

**Result:** Build fails on ANY occurrence of these CVEs.

---

### Example 3: CVSS-Based Gate
**Problem:** Want more nuanced control than just "high" severity.

**Solution:**
```bash
./rego-policy-generator
# Product: 1 (Open Source)
# Policy: 4 (CVSS Score)
# Score: 7.5
```

**Result:** Build fails if any vulnerability has CVSS >= 7.5.

---

### Example 4: Manage False Positives
**Problem:** Some vulnerabilities are false positives but they keep failing the build.

**Solution:**
```bash
./rego-policy-generator
# Product: 1 (Open Source)
# Policy: 6 (Ignored Vulnerabilities)
# IDs: SNYK-JS-AXIOS-1038255,SNYK-JAVA-ORGAPACHE-12345
```

**Result:** Helper functions created to exclude these from other checks.

---

## Testing Your New Policies

### Step 1: Generate a Policy
```bash
cd /Users/jenny/CascadeProjects/rego-policy-generator
./rego-policy-generator
```

### Step 2: Run Snyk Scan
```bash
# For Open Source
snyk test --json your-project > results.json

# For Container
snyk container test your-image --json > results.json

# For Code
snyk code test --sarif your-project > results.json
```

### Step 3: Test with Conftest
```bash
cat results.json | conftest test --policy your-policy.rego -
```

### Step 4: Integrate into CI/CD
```bash
# One-liner for CI/CD
snyk test --json | conftest test --policy your-policy.rego -
```

## Pre-Made Examples

Try the pre-generated examples:

```bash
# Test fix availability policy
snyk test --json your-project | conftest test --policy examples/fix-availability-policy.rego -

# Test CVSS score policy
snyk test --json your-project | conftest test --policy examples/cvss-score-policy.rego -

# Test CVE-specific policy
snyk test --json your-project | conftest test --policy examples/cve-specific-policy.rego -

# Test combined policy
snyk test --json your-project | conftest test --policy examples/combined-policy.rego -
```

## Common Patterns

### Pattern 1: Strict Security
```
✓ Critical severity: 0 allowed
✓ High severity: 5 allowed  
✓ CVSS >= 8.0: 0 allowed
✓ Has Fix: 10 allowed
```

### Pattern 2: Balanced Approach
```
✓ Critical severity: 0 allowed
✓ High severity: 20 allowed
✓ CVSS >= 9.0: 0 allowed
✓ Has Fix: 50 allowed
✓ Known false positives: Ignored
```

### Pattern 3: CVE Watchlist
```
✓ Specific CVEs: 0 allowed (compliance list)
✓ Critical severity: 5 allowed
✓ Mature exploits: 0 allowed
```

## Tips

1. **Start Conservative:** Begin with strict thresholds and relax as needed
2. **Combine Policies:** Use multiple policy types in one file for comprehensive checks
3. **Use Unlimited (u):** For reporting without breaking builds during initial setup
4. **Test First:** Use `--policy` flag with conftest to test policies before enforcing
5. **Document Exceptions:** When using ignored vulnerabilities, document why in comments

## Troubleshooting

### Issue: Policy not failing when it should
**Solution:** Check that you're using the correct Snyk output format:
- Open Source/Container: `--json` flag
- Code: `--sarif` flag (or `--json` for older format)

### Issue: Too many false failures
**Solution:** Use ignored vulnerabilities feature or adjust thresholds

### Issue: Need more complex logic
**Solution:** Edit the generated .rego file directly - it's just text!

## Next Steps

1. ✓ Generate your first policy with new features
2. ✓ Test it with your Snyk scan results
3. ✓ Integrate into your CI/CD pipeline
4. ✓ Share with your team
5. ✓ Iterate and improve based on results

## Resources

- **Main README:** Comprehensive documentation
- **FEATURES.md:** Technical details of all features
- **examples/:** Working policy examples
- **Conftest Docs:** https://www.conftest.dev/
- **Snyk CLI Docs:** https://docs.snyk.io/snyk-cli

Happy policy generation! 🚀

