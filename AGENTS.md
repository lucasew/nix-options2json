# Project Conventions (AGENTS.md)

Welcome. This file outlines the conventions, structures, and non-negotiable standards for contributing to `nix-options2json`.

## Core Philosophy
- **Value-Driven Docs**: Avoid obvious comments. Explain the *why*, *how*, non-obvious edge cases, and side-effects. Keep docs matched to current implementation.
- **Robust Error Handling**: Silent failures are strictly prohibited. The codebase enforces centralized error reporting (e.g., if using JS/TS, do not use `console.error` directly; wire to a Sentry/reporting wrapper. In Nix, suppress evaluation failures gracefully via `tryEval` without silent collapse).
- **Test Beyond Automation**: Always do a sanity check. Tests must exercise your actual edge cases and logic, rather than external library behavior.

## PR & Commit Standards
Every PR must include these exact, concise sections in the PR body:
- `Assumptions`
- `Alternatives Not Chosen`
- `How To Pivot`
- `Next Knobs`

PR Titles should use appropriate prefixes (e.g. `📝 Docs: [Description]`, `🛠️ Refactor: [Description]`, `🛡️ Sentinel: [Severity] [Description]`).

## Execution & Workflow Guards
- **Scope Discipline**: Execute only the explicitly requested outcome. Deliver small, reversible changes. Do not bundle "nice to have" adjustments.
- **Tooling Requirements**: Use `mise` for tasks (install and configure if necessary). Tool versions must be pinned.
- **Staging Limits**: Never `git add .` or `git add -A`. Stage files explicitly, verifying scope before committing.
- **Review Negative Memory**: Read `.jules/CONSISTENTLY_IGNORED.md` and `.jules/sentinel.md` before planning work to avoid rejected patterns.

## Operational Memory (Where to Find Things)
A high-level map of responsibilities:
- `default.nix` -> Primary Nix entrypoint for external consumers.
- `entry.nix` -> Core options-to-JSON serialization logic (`trivialize`).
- `dump_expr` -> CLI tool to evaluate and dump a Nix expression.
- `bin/` -> Execution scripts (e.g., `dump-options` - dynamically resolves project root).
- `.github/workflows/` -> CI / Release workflows.

*(Note: Keep this section compact. Add to it if structural components shift.)*
