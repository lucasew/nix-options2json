# nix-options2json

Exports the options of a Nix expression to a JSON format for easier viewing.

## Usage

Use the provided script to export options:

```bash
./bin/dump-options '{ options = { ... }; config = { ... }; }'
```

## Structure

*   `bin/dump-options`: The main script.
*   `lib.nix`: Core logic for trivializing Nix options (refactored from `entry.nix`).
*   `default.nix`: Entry point.
