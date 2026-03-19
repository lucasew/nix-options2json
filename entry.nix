{lib, pkgs, ...}:
{ config, options, ...}: 
let
  inherit (lib) optionAttrSetToDocList types isOption isDerivation tryEval;
  inherit (builtins) mapAttrs typeOf replaceStrings isFunction listToAttrs;
  optionList = optionAttrSetToDocList options;
  reportError = msg: val: builtins.trace "ERROR: ${msg}" val;
  trivialize = v:
    if (types.attrsOf types.anything).check v then mapAttrs (k: v: trivialize v) v
    else if (types.listOf types.anything).check v then map (v: trivialize v) v
    else if isDerivation v then let
      tried = tryEval (replaceStrings ["/nix/store/"] ["nix://"] v.drvPath);
    in (if tried.success then tried.value else reportError "Failed to evaluate derivation ${v.name}" "failed eval ${v.name}")
    else if (types.nullOr (types.oneOf (with types; [int bool]))).check v then v
    else if isOption v then trivialize {_type = "option"; inherit (v) declarations description internal loc name readOnly type visible;}
    else if types.str.check v then v
    else if isFunction v then "<FUNCTION>"
    else reportError "passed ${typeOf v}" v
  ;
in {
  inherit trivialize;
  trivialized = listToAttrs (map (v: {name = v.name; value = v;}) (trivialize optionList));
}
