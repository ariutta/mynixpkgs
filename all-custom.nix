with import <nixpkgs> { config.allowUnfree = true; };

let
  nodePackages = import ./node-packages/default.nix {};
in
{
  bash-it = callPackage ./bash-it/default.nix {}; 
  black = callPackage ./black/default.nix {}; 
  composer2nix = import (fetchTarball https://api.github.com/repos/svanderburg/composer2nix/tarball/8453940d79a45ab3e11f36720b878554fe31489f) {}; 
  java-buildpack-memory-calculator = callPackage ./java-buildpack-memory-calculator/default.nix {};
  mediawiki-codesniffer = callPackage ./mediawiki-codesniffer/default.nix {};
  pathvisio = callPackage ./pathvisio/default.nix {};
  bridgedb = nodePackages."bridgedb-6.0.2";
  gpml2pvjson = nodePackages."gpml2pvjson-4.1.1";
  pvjs = nodePackages."@wikipathways/pvjs-4.0.4";
  perlPackages = callPackage ./perl-packages.nix {}; 
  pgsanity = callPackage ./pgsanity/default.nix {};
  privoxy = callPackage ./privoxy/darwin-service.nix {}; 
  sqlint = callPackage ./sqlint/default.nix {};
  tosheets = callPackage ./tosheets/default.nix {};
  vim = callPackage ./vim/default.nix {};

}
