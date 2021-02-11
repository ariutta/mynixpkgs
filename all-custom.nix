{ pkgs, buildPythonPackage }:

with pkgs.lib.trivial;
let
  callPackage = pkgs.callPackage;
  python3Packages = import ./development/python-modules/python-packages.nix { inherit buildPythonPackage; };
  nodePackages = import ./development/node-packages/node-packages.nix;
  perlPackages = callPackage ./perl-packages.nix {}; 
  sqlint = callPackage ./sqlint/default.nix {};
  java-buildpack-memory-calculator = callPackage ./java-buildpack-memory-calculator/default.nix {};
in
mergeAttrs nodePackages {
  inherit perlPackages java-buildpack-memory-calculator sqlint;
  bash-it = callPackage ./bash-it/default.nix {}; 
  composer2nix = import (fetchTarball https://api.github.com/repos/svanderburg/composer2nix/tarball/8453940d79a45ab3e11f36720b878554fe31489f) {}; 
  jupyterlab-connect = callPackage ./jupyterlab-connect/default.nix {};
  mediawiki-codesniffer = callPackage ./mediawiki-codesniffer/default.nix {};
  pathvisio = callPackage ./pathvisio/default.nix { inherit java-buildpack-memory-calculator; };
  pgsanity = callPackage ./pgsanity/default.nix {};
  privoxy = callPackage ./privoxy/darwin-service.nix {}; 
  pywikibot = callPackage ./pywikibot/default.nix { inherit buildPythonPackage; };
  tosheets = callPackage ./tosheets/default.nix {};
  vim = callPackage ./vim/default.nix { inherit sqlint pkgs; pgFormatter = perlPackages.pgFormatter; };
}
