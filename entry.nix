/*
 * Core Nix Options Serializer.
 * Extracts, evaluates, and trivializes the options of a given Nix expression into a format suitable for JSON export.
 * This is injected by `default.nix` and invoked by the `dump_expr` CLI to introspect NixOS/Home Manager configuration schemas.
 */
{lib, pkgs, ...}:
{ config, options, ...}: 
let
  inherit (lib) optionAttrSetToDocList types isOption isDerivation tryEval;
  inherit (builtins) mapAttrs typeOf replaceStrings isFunction listToAttrs;
  optionList = optionAttrSetToDocList options;

  /*
   * Recursively normalizes a Nix value to strip it of unevaluable structures (like functions)
   * and resolve derivations to their paths (stripping `/nix/store/` to `nix://`).
   *
   * Nuance: We use `tryEval` specifically for derivations to prevent the entire tree
   * serialization from failing if a single derivation has a broken `drvPath` reference.
   * Empty/failing derivation evaluations are safely caught and reported as "failed eval".
   * Unhandled complex types emit a builtins.trace message and pass through, which might break strict JSON eval.
   */
  trivialize = v:
    if (types.attrsOf types.anything).check v then mapAttrs (k: v: trivialize v) v
    else if (types.listOf types.anything).check v then map (v: trivialize v) v
    else if isDerivation v then let
      tried = tryEval (replaceStrings ["/nix/store/"] ["nix://"] v.drvPath);
    in (if tried.success then tried.value else "failed eval ${v.name}")
    else if (types.nullOr (types.oneOf (with types; [int bool]))).check v then v
    else if isOption v then trivialize {_type = "option"; inherit (v) declarations description internal loc name readOnly type visible;}
    else if types.str.check v then v
    else if isFunction v then "<FUNCTION>"
    else builtins.trace "passed ${typeOf v}" v
  ;
in {
  inherit trivialize;
  trivialized = listToAttrs (map (v: {name = v.name; value = v;}) (trivialize optionList));
}
