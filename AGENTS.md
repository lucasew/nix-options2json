# Project Conventions

This file outlines the coding standards and project structure for the repository.

## Directory Structure

- **`bin/`**: Contains executable shell scripts.
    - Naming: Use `kebab-case` (e.g., `dump-options`).
    - Purpose: Scripts that provide CLI entry points.
- **`lib/`**: Contains Nix library code.
    - Naming: Use `camelCase.nix` (e.g., `lib.nix`) or `default.nix` if it's a package.
    - Purpose: Reusable Nix logic.
- **Root**: Contains project configuration and entry points (`default.nix`, `flake.nix`, `README.md`).

## Naming Conventions

- **Scripts**: `kebab-case` (e.g., `build-project`, `dump-options`).
- **Nix Files**: `camelCase` for libraries, or `default.nix` / `shell.nix` for standard files.
- **Nix Attributes**: `camelCase`.

## Tooling

This project uses [mise](https://mise.jdx.dev/) to manage development tools.
- Always pin tool versions in `mise.toml`.
- Do not use `latest` or `lts`.

## Code Quality

- **Shell Scripts**:
    - Must pass `shellcheck`.
    - Must be formatted with `shfmt`.
    - Use strict mode (`set -euo pipefail`) where appropriate.
    - Find project root dynamically (e.g., using `BASH_SOURCE`).
- **Nix Code**:
    - Must be formatted with `alejandra`.
    - Avoid `builtins.trace` in production code; use proper error handling or assertions.
    - Comments should explain *why*, not just *what*.

## Verification

Before submitting changes, ensure the following checks pass:
1.  **Shellcheck**: `shellcheck bin/*`
2.  **Formatting**: `alejandra .` (if installed)
