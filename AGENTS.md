# AGENTS.md

This file acts as the source of truth for operational memory, formatting rules, PR structures, and code constraints for the project.

## Operational Memory

Where key concerns live in this repository:

* `entry.nix` -> core Nix evaluation serialization and logic. Contains the `trivialize` function which recursively normalizes a Nix value into a format suitable for JSON serialization, handling complex structures like derivations and lazy errors using `tryEval`.
* `dump_expr` -> CLI entrypoint for evaluating a target Nix expression and dumping its options to JSON; it wraps the target expression using `./default.nix`.
* `default.nix` -> default package entrypoint.

## Formatting Rules

* **Nix Docstrings:** When adding docstrings in Nix files, use the `/* ... */` block comment format to align with JSDoc/TSDoc style expectations.

## Code Constraints

* **Centralized Error Reporting:** The codebase enforces centralized error reporting; silent failures (such as empty catch blocks or silently swallowed `tryEval` errors) are strictly prohibited.
* **Security:** When evaluating untrusted Nix expressions via `nix-instantiate` in bash scripts, always use the `--restrict-eval` flag to sandbox evaluation and prevent arbitrary file access or execution.
* **Security Fixes:** Must be logged in `.jules/sentinel.md` using the format `- YYYY-MM-DD: [issue pattern]`, and PR titles must use the format `🛡️ Sentinel: [Severity] [Description]`.
* **Docs Fixes:** PR titles must use the exact format `📝 Docs: [Description]` and focus on explaining the 'why', non-obvious nuances, and execution flow without changing any executable logic.

## PR Structures

All PR bodies must include the following mandatory sections:
* `Assumptions`
* `Alternatives Not Chosen`
* `How To Pivot`
* `Next Knobs`
