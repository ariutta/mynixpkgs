_: pkgs:
let
  sqlint = pkgs.callPackage ./sqlint/default.nix {};
  #nodePackages = import ./development/node-packages/node-packages.nix;
  perlPackages = pkgs.callPackage ./perl-packages.nix {}; 
  pgFormatter = perlPackages.pgFormatter;
  java-buildpack-memory-calculator = pkgs.callPackage ./java-buildpack-memory-calculator/default.nix {};

  callPackage = pkgs.python3Packages.callPackage;
  buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
  jupyter_packaging = callPackage ./development/python-modules/jupyter_packaging/default.nix {};
  simpervisor = callPackage ./development/python-modules/simpervisor/default.nix {};
  json5 = callPackage ./development/python-modules/json5/default.nix {};
  jupyter_server = callPackage ./development/python-modules/jupyter_server/default.nix {};
  jupyterlab_server = callPackage ./development/python-modules/jupyterlab_server/default.nix {
    inherit json5 jupyter_server;
  };
  nbclassic = callPackage ./development/python-modules/nbclassic/default.nix {
    inherit jupyter_packaging jupyter_server;
  };
  jupyterlab = callPackage ./development/python-modules/jupyterlab/default.nix {
    inherit nbclassic jupyter_packaging jupyter_server jupyterlab_server;
  };
  jupyter_lsp = callPackage ./development/python-modules/jupyter_lsp/default.nix {
    inherit jupyter_server;
  };
  jupyter-resource-usage = callPackage ./development/python-modules/jupyter-resource-usage/default.nix {
    inherit jupyterlab;
  };
  jupyterlab-topbar = callPackage ./development/python-modules/jupyterlab-topbar/default.nix {
    inherit jupyterlab;
  };
  packageOverrides = selfPythonPackages: pythonPackages: {
    inherit jupyter-resource-usage jupyterlab-topbar json5 nbclassic jupyter_packaging jupyter_server jupyterlab_server jupyterlab jupyter_lsp simpervisor;
    jupyter-server-proxy = selfPythonPackages.callPackage ./development/python-modules/jupyter-server-proxy/default.nix {};
    jupyterlab-lsp = selfPythonPackages.callPackage ./development/python-modules/jupyterlab_lsp/default.nix {
      inherit jupyterlab jupyter_lsp;
    };
    jupyterlab_code_formatter = selfPythonPackages.callPackage ./development/python-modules/jupyterlab_code_formatter/default.nix {
      inherit jupyterlab;
    };
    jupyterlab_hide_code = selfPythonPackages.callPackage ./development/python-modules/jupyterlab_hide_code/default.nix {
      inherit jupyterlab;
    };
    jupyterlab_vim = selfPythonPackages.callPackage ./development/python-modules/jupyterlab_vim/default.nix {
      inherit jupyterlab jupyter_packaging;
    };
    jupyterlab-vimrc = selfPythonPackages.callPackage ./development/python-modules/jupyterlab-vimrc/default.nix {
      inherit jupyterlab;
    };
    aquirdturtle_collapsible_headings = selfPythonPackages.callPackage ./development/python-modules/aquirdturtle_collapsible_headings/default.nix {
      inherit jupyterlab;
    };
    jupyterlab-system-monitor = selfPythonPackages.callPackage ./development/python-modules/jupyterlab-system-monitor/default.nix {
      inherit jupyterlab jupyter-resource-usage jupyterlab-topbar;
    };
    jupyterlab-drawio = selfPythonPackages.callPackage ./development/python-modules/jupyterlab-drawio/default.nix {
      inherit jupyterlab;
    };
    nb_black = selfPythonPackages.callPackage ./development/python-modules/nb_black/default.nix {};
    ndex2 = selfPythonPackages.callPackage ./development/python-modules/ndex2/default.nix {};
    seaborn = selfPythonPackages.callPackage ./development/python-modules/seaborn/default.nix {};
    skosmos_client = selfPythonPackages.callPackage ./development/python-modules/skosmos_client/default.nix {};
    wikidata2df = selfPythonPackages.callPackage ./development/python-modules/wikidata2df/default.nix {};
    homoglyphs = selfPythonPackages.callPackage ./development/python-modules/homoglyphs/default.nix {};
    confusable-homoglyphs = selfPythonPackages.callPackage ./development/python-modules/confusable-homoglyphs/default.nix {};
    pyahocorasick = selfPythonPackages.callPackage ./development/python-modules/pyahocorasick/default.nix {};
  };

in

{
  inherit java-buildpack-memory-calculator sqlint;
  #inherit perlPackages java-buildpack-memory-calculator sqlint;

  python3 = pkgs.python3.override (old: {
    packageOverrides =
      pkgs.lib.composeExtensions
        (old.packageOverrides or (_: _: {}))
        packageOverrides;
  });

  bash-it = callPackage ./bash-it/default.nix {}; 
  composer2nix = import (fetchTarball https://api.github.com/repos/svanderburg/composer2nix/tarball/8453940d79a45ab3e11f36720b878554fe31489f) {}; 
  jupyterlab-connect = callPackage ./jupyterlab-connect/default.nix {};
  mediawiki-codesniffer = callPackage ./mediawiki-codesniffer/default.nix {};
  pathvisio = callPackage ./pathvisio/default.nix { inherit java-buildpack-memory-calculator; };
  pgsanity = callPackage ./pgsanity/default.nix {};
  privoxy = callPackage ./privoxy/darwin-service.nix {}; 
  pywikibot = callPackage ./pywikibot/default.nix { inherit buildPythonPackage; };
  tosheets = callPackage ./tosheets/default.nix {};
  vim = callPackage ./vim/default.nix { inherit sqlint pkgs pgFormatter; };
}
