{
  lib,
  pkgs,
  ...
}: {
  config,
  options,
  ...
}: let
  inherit (lib) optionAttrSetToDocList types isOption isDerivation tryEval;
  inherit (builtins) mapAttrs typeOf replaceStrings isFunction listToAttrs;

  optionList = optionAttrSetToDocList options;

  trivialize = v:
  # Recursively trivialize attributes
    if (types.attrsOf types.anything).check v then mapAttrs (k: v: trivialize v) v
    # Recursively trivialize lists
    else if (types.listOf types.anything).check v then map (v: trivialize v) v
    # Handle Derivations: extract drvPath and replace store path prefix
    else if isDerivation v then let
      tried = tryEval (replaceStrings ["/nix/store/"] ["nix://"] v.drvPath);
    in (if tried.success then tried.value else "failed eval ${v.name}")
    # Handle Primitives (null, int, bool, float)
    else if (types.nullOr (types.oneOf (with types; [int bool float]))).check v then v
    # Handle Options: extract relevant metadata recursively
    else if isOption v then
      trivialize {
        _type = "option";
        inherit (v) declarations description internal loc name readOnly type visible;
      }
    # Handle Strings
    else if types.str.check v then v
    # Handle Paths (serialize as absolute path string)
    else if types.path.check v then v
    # Handle Functions: return placeholder
    else if isFunction v then "<FUNCTION>"
    # Fallback for unknown types (e.g. paths, or other complex types not handled)
    # Original code used builtins.trace here. We replace it with a string placeholder
    # to ensure JSON serialization succeeds and output is clean.
    else "<UNKNOWN: ${typeOf v}>";
in {
  inherit trivialize;
  # Convert the list of options to an attribute set indexed by option name
  trivialized = listToAttrs (map (v: {
    name = v.name;
    value = v;
  }) (trivialize optionList));
}
