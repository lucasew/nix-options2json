{lib, pkgs, ...}:
{ config, options, ...}: 
let
  inherit (lib) optionAttrSetToDocList types isOption isDerivation tryEval;
  inherit (builtins) mapAttrs typeOf replaceStrings isFunction listToAttrs;

  # Extracts and flattens NixOS/Home-Manager style options into a list of documented options.
  optionList = optionAttrSetToDocList options;

  /*
    Recursively normalizes a Nix value `v` into a "trivial" format suitable for JSON serialization.

    Why: Nix evaluation can produce complex structures (like functions, deeply nested derivations,
    and lazy errors) that `builtins.toJSON` cannot serialize. This function defensively
    sanitizes the data, discarding un-serializable components while preserving configuration options.

    Side effects:
    - Calls `builtins.trace` on unhandled types to alert the user during evaluation.
    - Suppresses evaluation errors in derivations using `tryEval` to prevent silent failures
      from terminating the entire export process.
  */
  trivialize = v:
    if (types.attrsOf types.anything).check v then mapAttrs (k: v: trivialize v) v
    else if (types.listOf types.anything).check v then map (v: trivialize v) v
    else if isDerivation v then let
      # We transform Nix store paths to a pseudo-protocol to avoid pulling derivations
      # and we wrap in tryEval because evaluating the `drvPath` of broken derivations can throw.
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

  # The finalized attribute set mapping option names to their sanitized (JSON-ready) definitions.
  trivialized = listToAttrs (map (v: {name = v.name; value = v;}) (trivialize optionList));
}
