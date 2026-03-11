/*
  Default package entrypoint for nix-options2json.

  Why: Loads `entry.nix` with the required system packages (allowing broken ones
  for edge case evaluations) via `callPackage`.

  This provides a clean interface for external consumers importing this repository
  directly without worrying about passing dependencies.
*/
{pkgs ? import <nixpkgs> {config.allowBroken = true;}}:
pkgs.callPackage ./entry.nix {}
