{pkgs ? import <nixpkgs> {config.allowBroken = true;}}:
pkgs.callPackage ./entry.nix {}
