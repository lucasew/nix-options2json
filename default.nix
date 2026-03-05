{pkgs ? import <nixpkgs> {config.allowBroken = true;}}:
pkgs.callPackage ./lib/lib.nix {}
