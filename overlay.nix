_: pkgs:
let
  callPackage = pkgs.callPackage;
  python3CallPackage = pkgs.python3Packages.callPackage;
  myNodePackages = import ./development/node-packages/node-packages.nix;
  myPerlPackages = callPackage ./perl-packages.nix {}; 
  java-buildpack-memory-calculator = callPackage ./java-buildpack-memory-calculator/default.nix {};

  packageOverrides = selfPythonPackages: pythonPackages: {
    seaborn = selfPythonPackages.callPackage ./development/python-modules/seaborn/default.nix {};
    nb_black = selfPythonPackages.callPackage ./development/python-modules/nb_black/default.nix {};
    ipython-sql = selfPythonPackages.callPackage ./development/python-modules/ipython-sql/default.nix {};
    ndex2 = selfPythonPackages.callPackage ./development/python-modules/ndex2/default.nix {};
    skosmos_client = selfPythonPackages.callPackage ./development/python-modules/skosmos_client/default.nix {};
    wikidata2df = selfPythonPackages.callPackage ./development/python-modules/wikidata2df/default.nix {};
    homoglyphs = selfPythonPackages.callPackage ./development/python-modules/homoglyphs/default.nix {};
    confusable-homoglyphs = selfPythonPackages.callPackage ./development/python-modules/confusable-homoglyphs/default.nix {};
    pyahocorasick = selfPythonPackages.callPackage ./development/python-modules/pyahocorasick/default.nix {};
    trotter = selfPythonPackages.callPackage ./development/python-modules/trotter/default.nix {};
  };

in

{
  inherit java-buildpack-memory-calculator;

  python3 = pkgs.python3.override (old: {
    packageOverrides =
      pkgs.lib.composeExtensions
        (old.packageOverrides or (_: _: {}))
        packageOverrides;
  });

  myNodePackages = myNodePackages;
  myPerlPackages = myPerlPackages;

  allene = callPackage ./allene/default.nix {};
  bash-it = callPackage ./bash-it/default.nix {}; 
  composer2nix = import (fetchTarball https://api.github.com/repos/svanderburg/composer2nix/tarball/8453940d79a45ab3e11f36720b878554fe31489f) {}; 
  jupyterlab-connect = callPackage ./jupyterlab-connect/default.nix {};
  mediawiki-codesniffer = callPackage ./mediawiki-codesniffer/default.nix {};
  pathvisio = callPackage ./pathvisio/default.nix { inherit java-buildpack-memory-calculator; };
  pgsanity = callPackage ./pgsanity/default.nix {};
  privoxy = callPackage ./privoxy/darwin-service.nix {}; 
  pywikibot = python3CallPackage ./pywikibot/default.nix {};
  tosheets = callPackage ./tosheets/default.nix {};
  vim = callPackage ./vim/default.nix { inherit pkgs; };
}
