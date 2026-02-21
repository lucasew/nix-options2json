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

  # Constants
  TYPE_OPTION = "option";
  FUNCTION_PLACEHOLDER = "<FUNCTION>";

  # Helper: Try to evaluate derivation path
  tryEvalDerivation = v: let
    tried = tryEval (replaceStrings ["/nix/store/"] ["nix://"] v.drvPath);
  in
    if tried.success
    then tried.value
    else "failed eval ${v.name}";

  # Helper: Trivialize attributes
  trivializeAttrs = v: mapAttrs (k: v: trivialize v) v;

  # Helper: Trivialize list
  trivializeList = v: map (v: trivialize v) v;

  # Helper: Trivialize option
  trivializeOption = v:
    trivialize {
      _type = TYPE_OPTION;
      inherit (v) declarations description internal loc name readOnly type visible;
    };

  # Main trivialize function
  trivialize = v:
    if (types.attrsOf types.anything).check v
    then trivializeAttrs v
    else if (types.listOf types.anything).check v
    then trivializeList v
    else if isDerivation v
    then tryEvalDerivation v
    else if (types.nullOr (types.oneOf (with types; [int bool]))).check v
    then v
    else if isOption v
    then trivializeOption v
    else if types.str.check v
    then v
    else if isFunction v
    then FUNCTION_PLACEHOLDER
    else builtins.trace "passed ${typeOf v}" v;

  optionList = optionAttrSetToDocList options;
in {
  inherit trivialize;
  trivialized = listToAttrs (map (v: {
      name = v.name;
      value = v;
    })
    (trivialize optionList));
}
