/*
 * Default package entrypoint for nix-options2json.
 * Bootstraps the dependency injection (pkgs, lib) by evaluating `entry.nix`.
 * The `allowBroken = true` config permits evaluating Nix expressions that might
 * include broken derivations, deferring handling to the `tryEval` checks in `entry.nix`.
 */
{pkgs ? import <nixpkgs> {config.allowBroken = true;}}:
pkgs.callPackage ./entry.nix {}
