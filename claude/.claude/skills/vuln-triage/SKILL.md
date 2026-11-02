---
name: vuln-triage
description: >-
  Triage and verify a vulnerability claim against the codebase and return
  ACCEPT, DISMISS or NEEDS-MORE-INFO with file:line evidence. Input can be a
  CVE id, GHSA/OSV advisory, Dependabot or npm/bun audit alert, scanner output,
  bug bounty report, or findings from another agent or a code review. Runs
  only in the read-only vuln-triage subagent and reports back to the caller.
when_to_use: >-
  "is this vulnerability real", "triage this CVE", "does this advisory affect
  us", "is this a false positive", "verify this security finding", "should we
  fix this Dependabot alert", "filter these scanner findings", "assess this bug
  bounty report". Not for hunting new bugs or writing a fix.
argument-hint: "[CVE id | advisory URL | finding text | path to findings file] [full]"
context: fork
agent: vuln-triage
---

# Vulnerability triage

Triage these claims: $ARGUMENTS

Working directory is the codebase under triage unless the claims name another
path. If no claim was given, return `NEEDS-MORE-INFO: no claim supplied.` and
stop.

Goal: decide whether each claim is a real, reachable vulnerability **in this
codebase**, with evidence. Two lenses, both required:

- **Brocards** judge the claim: is this a vulnerability at all? Adapted from
  William Woodruff, ["Brocards for vulnerability triage"](https://vulnbrocards.com/) (2026).
- **Code verification** judges the code: does the claimed path exist, can an
  attacker drive it, does any check stop it? Adapted from Trail of Bits
  `fp-check`.

LLMs over-report bugs and over-rate severity. Burden of proof is on the claim.
Equally, never dismiss without evidence.

## Step 0: restate each claim

Before any analysis, write one line per claim:

`An attacker with <capability> can <action> on <component@version / path> to achieve <impact>.`

Fill what the claim gives. Missing pieces are recorded, not invented. Half of
false positives collapse here because the claim does not survive a precise
restatement. With several claims, restate them all before analysing any; merge
duplicates.

## Step 1: locate

- **Dependency claim** (CVE/GHSA in a package): Glob for manifests and
  lockfiles (`package.json`, `bun.lock`, `package-lock.json`, `pnpm-lock.yaml`,
  `yarn.lock`, `requirements*.txt`, `poetry.lock`, `uv.lock`, `go.sum`,
  `Cargo.lock`, `Gemfile.lock`, …). Find the installed version, direct or
  transitive, and who pulls it in. Fetch the advisory (GHSA:
  `https://github.com/advisories/<id>`, OSV: `https://osv.dev/vulnerability/<id>`,
  NVD) for affected ranges and the vulnerable function/option. Installed version
  outside the affected range: DISMISS (not affected), cite lockfile line.
  Package absent: DISMISS, cite the search.
- **Code claim**: find the named file/function. If it does not exist, or does
  not match the description, DISMISS (claim does not match code), cite what is
  actually there.

## Step 2: brocards

Run in order. Default: stop at the first DISMISS and report it. If the
arguments contain `full`, run all seven anyway. Verdict per brocard: PASS,
DISMISS, or INFO (needs more information; say exactly what).

1. **Threat model.** Attacker, capability, action, impact all present and
   coherent? Behavior with no attacker-reachable harm is a bug, not a
   vulnerability. Partial model: INFO naming the missing parts.
2. **Exploit from the heavens.** Does triggering it require capability that
   already includes the impact (admin abusing admin powers, code execution to
   get code execution, active MITM to inject content)? Then DISMISS. Limited
   access gaining elevated access passes.
3. **Outside of usage.** Is the vulnerable function, option or code path
   actually reached by this codebase with attacker-influenced data? Grep every
   call site of the vulnerable API. Dev-only, build-only, test-only or
   dead-code use is not production reach, but check how the deployed build and
   config really run first (debug flags shipped on, scripts run in CI with
   secrets).
4. **Standard behavior.** Is it correct implementation of a spec (RFC, protocol,
   language semantics)? Then the issue is in the standard. Exception: the
   project claims stricter behavior than the spec and fails it.
5. **Documented behavior.** Is it explicitly documented with its caveat (an
   `--insecure` flag, "not for production", "never pass untrusted input")? Then
   DISMISS against that component. If **this codebase** uses it against the
   documentation, the vulnerability is here: PASS.
6. **Cure worse than disease.** Would the fix (major upgrade, breaking change,
   removed feature) cost more than the practical risk? Then downgrade or DISMISS
   and propose the proportional action (pin, config change, input guard, doc).
   Never applies to a confirmed critical.
7. **Report neither necessary nor sufficient.** Strip CVE id, CVSS, scanner
   label and reporter reputation. Does the technical content alone justify
   action? High CVSS with a vague description is INFO, not ACCEPT. An informal
   report with a concrete chain gets full weight.

Expanded examples and edge cases: [references/brocards.md](references/brocards.md).

## Step 3: code verification

Required for every claim that survives Step 2. Trace, do not pattern-match.

1. **Source.** Where does the input come from? Network request, user upload,
   webhook, queue message, env/config, DB row written by whom, constant? Is it
   attacker-controlled, and by which attacker (anonymous, signed-in user, org
   member, admin, operator)?
2. **Path.** Follow it hop by hop from entry point (route, handler, job, CLI) to
   the sink, citing `path:line` at each hop. Note auth and permission checks
   on the way.
3. **Validation chain.** Every schema, type guard, bounds check, allowlist,
   escaping, parameterization or framework guarantee between source and sink.
   Does it actually stop the claimed input, mathematically or by contract?
4. **Sink.** Does the sink behave as the claim says with input that passes all
   checks? Check the API contract (ORMs parameterize, templating escapes,
   `URL` parsing normalizes) before claiming injection or overflow.
5. **Conditions.** Concurrency claims need proof of concurrent access. TOCTOU
   needs proof the value can change between check and use.

Checklist and red flags: [references/false-positive-patterns.md](references/false-positive-patterns.md).

## Step 4: devil's advocate, both ways

Before the verdict, argue against it once.

Wrongly dismissing:

- "Only in debug mode": is debug truly off in production config?
- "Needs local access": containers, CI runners and shared hosts make local real.
- "Nobody calls that": Grep proves it, an assumption does not.
- "The spec allows it": does the project promise stricter?
- "Behind auth": which role, and can a low-privilege or self-signed-up user hold it?

Wrongly accepting:

- "It has a CVE" / "CVSS is 9.8": brocard 7.
- "Looks dangerous": pattern recognition is not a traced path.
- "Better safe than sorry": brocard 6 requires weighing the fix.
- "Can't prove it's not exploitable": burden is on the claim (brocard 1).
- "Others patched it": their usage is not ours (brocard 3).

After all claims: check whether two individually weak findings chain into one
real attack.

## Step 5: verdict

- **ACCEPT**: passes all brocards and a traced, attacker-reachable path exists.
- **DISMISS**: fails a brocard or the trace proves it unreachable/blocked.
- **NEEDS-MORE-INFO**: a decisive fact is missing; name it and where to get it.

Severity is contextual, never copied from CVSS: `critical` (unauthenticated
remote code execution, auth bypass, cross-tenant data exposure), `high`,
`medium`, `low`, `none`. Confidence: `high` (full trace), `medium` (trace with
one assumption, named), `low`.

## Report format

Return exactly this, one block per claim, then the totals line. Caveman ultra.

```
## <claim id or short title>
Verdict: ACCEPT|DISMISS|NEEDS-MORE-INFO | Severity: <level> | Confidence: <level>
Claim: <Step 0 restatement>
Brocards: 1 PASS | 2 PASS | 3 DISMISS | 4 - | 5 - | 6 - | 7 -
Decisive: <brocard # or trace step that decided it, one line>
Evidence:
- <path:line | lockfile entry | advisory URL> <what it shows>
Path: <entry path:line> > <hop path:line> > <sink path:line>   (ACCEPT only)
Missing: <exact fact needed, where to get it>                 (NEEDS-MORE-INFO only)
Next: <close | proportional fix in one line | escalate to PoC | ask reporter for X>
```

`-` marks a brocard skipped after an earlier DISMISS. Last line:

`Totals: <n> ACCEPT, <n> DISMISS, <n> NEEDS-MORE-INFO.` plus `Chain:` line if
Step 4 found one, plus `Side note:` lines for anything unverified seen on the
way.
