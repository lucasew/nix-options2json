# Project Conventions

## Naming
-   **Nix Libraries:** Use `.nix` extension. Libraries should be named descriptively (e.g., `lib.nix` for core logic).
-   **Scripts:** Place executable scripts in `bin/`. Use descriptive names (e.g., `dump-options`).
-   **Magic Strings:** Avoid magic strings in code. Define constants.

## Structure
-   **Colocation:** Keep related files together.
-   **Clean Root:** Avoid cluttering the root directory. Move scripts to `bin/`.

## Code Style
-   **Nix:** Follow standard Nix formatting (e.g., `alejandra` if available).
-   **Bash:** Follow `shellcheck` recommendations and `shfmt`.
-   **Complexity:** Break down large functions into smaller helpers.
