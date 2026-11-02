# False-positive checklist

Apply every item to every claim that reaches Step 3. Adapted from Trail of Bits
`fp-check` ([trailofbits/skills](https://github.com/trailofbits/skills),
CC-BY-SA-4.0), extended with web and dependency patterns.

## Checklist

1. **Full validation chain.** Trace backwards from the sink to every check that
   precedes it: request schema (zod, valibot, pydantic), middleware, guards,
   earlier bounds checks. An isolated snippet proves nothing.
2. **Conditional reachability.** List the conditions needed to reach the sink.
   Do they rule out the bad input? (`buf[len-4]` is safe if the branch only runs
   when `len > 12`.)
3. **Defensive code is not the bug.** An assertion or check followed by
   guarded use is protection, not a vulnerability.
4. **Confirmed data path.** Report only paths traced hop by hop. Never assume
   network data reaches a function.
5. **Data source trust.** Constants, build-time env, operator-set secrets and
   rows written only by trusted code are not attacker input. Rows a user can
   write are.
6. **Bounds math.** If `size >= MIN` is checked and `MIN >= HEADER`, then
   `size - HEADER` cannot underflow. Do the arithmetic.
7. **TOCTOU.** Prove the value can change between check and use. Same-function
   check-then-use on a local value is not TOCTOU; check-then-write on shared
   storage (DB, KV, cache) without a transaction or conditional write can be.
8. **API contracts.** Read what the API guarantees before claiming the sink is
   unsafe: query builders and prepared statements parameterize, JSX and most
   templating escape by default, `URL` normalizes, `JSON.parse` does not execute.
   The opposite is also true: raw-SQL helpers, `dangerouslySetInnerHTML`,
   `innerHTML`, `eval`, `new Function`, `child_process` with `shell: true` do not
   protect.
9. **Pattern is not proof.** "Looks dangerous" ends nothing; context and
   contracts decide.
10. **Concurrency is real?** Single-threaded init, a single-writer design, or a
    serialized queue cannot race. Async request handlers sharing storage can.
11. **Real impact.** Ask: code execution, privilege escalation, auth bypass,
    cross-tenant read/write, secret or PII disclosure, money movement, or
    sustained DoS? A failed write of non-critical data is an operational bug.
12. **Defense in depth vs primary control.** A secondary control failing is not
    critical when the primary holds (single-use tokens enforced server-side make
    a missed client cleanup harmless).
13. **Apply all items.** A checklist skimmed is a checklist skipped.

## Web and service specifics

- **Authorization.** For IDOR/tenant claims, find where the query is scoped
  (org id, owner id) and where membership is checked. An id in the URL is fine
  if every query filters by the caller's tenant.
- **Auth bypass.** Check the middleware order and route registration: is the
  route actually behind the guard, including method variants and trailing
  slashes?
- **SSRF.** Who controls the URL, is there an allowlist or private-range block,
  and are redirects followed?
- **Secrets.** "Secret in code" needs the value to be real and live, not a
  placeholder, test key or public key (publishable keys, site keys are public by
  design).
- **CORS/CSRF.** Credentials mode, origin reflection, SameSite cookies and
  token-based auth change the answer completely.
- **Rate limits / DoS.** Platform limits (request size, CPU time, edge rate
  limiting) may cap the claimed amplification.

## Dependency specifics

- Installed version vs affected range, per lockfile, not per `package.json`
  range.
- Transitive path: who requires it, and is the vulnerable entry point one that
  parent ever calls?
- Runtime vs build vs dev: shipped bundle, server runtime, or only tooling?
- Vulnerable feature behind an option: is that option ever set?
- Fixed version available? Override/resolution possible without a major bump?

## Red flags for a false positive

- Finding sits inside validation or bounds-checking code itself.
- Claimed TOCTOU or race with no proof of concurrent change.
- Preceding validation ignored, or "network data reaches here" assumed.
- Debug-only, test-only, migration-only or one-time setup code reported as
  production.
- Framework or language guarantee missed (escaping, parameterization, memory
  safety, type checks).
- Severity stated with confidence but no traced path.
- Same claim copied from another project with different usage.
