{ pkgs, nodejs, stdenv }:

let
  nodePackages = import ./composition-v8.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages // {
}
