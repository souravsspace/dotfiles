# Brocards: examples and edge cases

Read when a brocard call is ambiguous, or to justify a dismissal in detail.

Brocards: William Woodruff, ["Brocards for vulnerability triage"](https://vulnbrocards.com/)
(2026). Examples adapted from Trail of Bits `vulnerability-triage-brocards`
([trailofbits/skills](https://github.com/trailofbits/skills), CC-BY-SA-4.0).

## 1. No vulnerability without a threat model

Who is the attacker, what can they already do, how do they trigger it, what
harm results. Burden is on the claim.

| Scenario | Verdict | Why |
| --- | --- | --- |
| API throws an exception on an undocumented edge case | DISMISS | No path from attacker input to damage |
| Hang in a local developer tool | DISMISS | Developer kills the process; no remote attacker |
| Heap overflow in a network-facing parser | PASS | Remote input, overflow, code execution |
| Unhandled rejection crashes a Worker request | Depends | One request failing is a bug; a crash that takes down shared state or other tenants is DoS |

- A real defect is not automatically a vulnerability.
- Partial threat model: INFO naming the missing elements, not DISMISS.

## 2. No exploit from the heavens

Required capability must be less than resulting impact.

| Scenario | Verdict | Why |
| --- | --- | --- |
| Content manipulation, but only with active MITM | DISMISS | MITM can already inject anything |
| Code execution via ctypes poking CPython internals | DISMISS | ctypes use already is code execution |
| Org admin can delete their own org's data via an API | DISMISS | That is the admin's power |
| SSRF via a user-controlled URL | PASS | URL string in, internal network out |
| Org member reads another org's rows by changing an id | PASS | Member of A gains B's data |

- Privilege escalation passes: post-exploit capability exceeds pre-exploit.
- "Can do X" is not "can do X here": sandboxed execution differs from full
  privileges; a secret readable in CI differs from one readable in production.

## 3. No vulnerability outside of usage

Theoretically possible but never exercised is not a vulnerability.

| Scenario | Verdict | Why |
| --- | --- | --- |
| Private function overflows, only caller passes a fixed-size buffer | DISMISS | Never fed attacker data |
| Upstream library CVE in a function this codebase never calls | DISMISS | Not reachable through our usage |
| Vulnerable option (`allowPrototypes`, `shell: true`) never set here | DISMISS | Precondition absent, cite the call sites |
| Vulnerable package only in `devDependencies`, used by a build script on trusted input | DISMISS, usually | Not shipped; but check CI runs it on PR-controlled input |
| Library API with 200+ downstream callers, not all audited | PASS | Cannot show every caller is safe |

- For a library, "usage" means representative downstream callers, not only
  its own tests.
- Unreachable today may be reachable after a refactor; note it when the code is
  a public API under active change.

## 4. No vulnerability from standard behavior

Correct implementation of a spec is not an implementation bug.

| Scenario | Verdict | Why |
| --- | --- | --- |
| HTTP server follows the RFC robustness principle | DISMISS | Raise it with the standards body |
| "Uses broken MD5" about HMAC-MD5 | DISMISS | HMAC does not rely on collision resistance |
| Claims TLS 1.3-only but negotiates 1.2 CBC | PASS | Fails its own stricter promise |

- Voluntary strictness: when the project advertises behavior stricter than the
  spec, failing that promise is a vulnerability.

## 5. No vulnerability from documented behavior

Documented behavior with a stated caveat is not a vulnerability in the component
that documents it.

| Scenario | Verdict | Why |
| --- | --- | --- |
| Python `http.server`, documented "not for production" | DISMISS | Warned |
| Serializer documented "insecure for untrusted input" | DISMISS against serializer | Intentional |
| Our app feeds untrusted input to that serializer | PASS against our app | We broke the documented rule |
| CLI `--insecure` disables TLS verification | DISMISS | User opted in |

- A warning buried in a changelog footnote protects less than a prominent one.
- Documented is not acceptable: a dangerous default with no safe alternative can
  still merit a "safer default" request.
- Always state which component the finding is against.

## 6. No cure worse than the disease

Proportional response. Weigh practical severity against fix cost and blast
radius.

| Scenario | Verdict | Why |
| --- | --- | --- |
| ReDoS with negligible impact; fix breaks thousands of dependents | DISMISS or downgrade | Fix costs more |
| [CVE-2026-4539](https://nvd.nist.gov/vuln/detail/CVE-2026-4539) against pygments | DISMISS | Unfounded medium report forced churn across tens of thousands of dependents |
| Critical RCE in a widely used library | PASS | Severity justifies any disruption |
| Low-severity transitive dev dependency; fix needs a major framework upgrade | Downgrade | Pin or override, schedule the upgrade |

- Not an excuse to ignore: a low issue may still get a low-cost action (doc,
  override, input guard, deprecation).
- Staged cures count: a breaking fix in the next major beats an emergency
  migration.

## 7. The report is neither necessary nor sufficient

A CVE id does not prove a vulnerability; no CVE does not prove safety.

| Scenario | Verdict | Why |
| --- | --- | --- |
| CVSS 9.8, description "may cause unexpected behavior" | INFO | Demand concrete technical detail |
| Informal email with a concrete exploit chain, no CVE | Judge on merits | Channel does not reduce validity |
| Scanner assigns a CVE to a dependency | Verify | Check version range and reachability (brocards 3 and 5) |
| AI agent finding with confident severity, no trace | INFO or DISMISS | Run Step 3; confidence is not evidence |

- CVSS is a formula, not a verdict. Equal scores can carry very different real
  risk depending on deployment.
