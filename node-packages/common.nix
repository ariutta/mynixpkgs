with import <nixpkgs> { config.allowUnfree = true; };
let
  custom = import ./nixpkgs-custom/all-custom.nix;
  pvjs = callPackage ./default.nix { };
in [
  pkgs.coreutils
  pkgs.jq
  pkgs.nodejs
  pkgs.nodePackages.node2nix
] ++ (if stdenv.isDarwin then [] else [])
