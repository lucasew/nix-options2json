{lib, pkgs, ...}:
{ config, options, ...}: 
let
  inherit (lib) optionAttrSetToDocList types isOption isDerivation tryEval;
  inherit (builtins) mapAttrs typeOf replaceStrings isFunction;
  optionList = optionAttrSetToDocList options;
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
  trivialized = trivialize optionList;
}
