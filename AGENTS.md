# Project Conventions & Guidelines

## Core Principles
- **No Silent Failures**: The codebase enforces centralized error reporting. Silent failures, such as empty catch blocks or silently swallowed `tryEval` errors, are strictly prohibited.
- **Centralized Error Reporting**: All errors must be routed through a centralized error reporter. In Nix code, this often means using a centralized `reportError` or equivalent mechanism when handling expected failures.
- **Security**: Security fixes must be logged in `.jules/sentinel.md` using the format `- YYYY-MM-DD: [issue pattern]`.
- **Formatting**: Docstrings in Nix files should use the `/* ... */` block comment format.
- **Pull Requests**:
  - Security PRs must use the format `🛡️ Sentinel: [Severity] [Description]`.
  - Documentation PRs must use the exact format `📝 Docs: [Description]`.
  - All PR bodies must include the following mandatory sections: `Assumptions`, `Alternatives Not Chosen`, `How To Pivot`, and `Next Knobs`.

## Project Structure
- `default.nix` -> Default package entrypoint, wraps `entry.nix`.
- `entry.nix` -> Main logic module, exports options to JSON. Contains `trivialize` and the central error reporter logic.
- `dump_expr` -> Bash CLI tool for evaluating a target Nix expression and dumping its options to JSON.
- `.github/workflows/autorelease.yml` -> CI workflow, sets up Nix/Mise and runs tests.
