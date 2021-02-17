_: pkgs:
let
  callPackage = pkgs.callPackage;
  python3CallPackage = pkgs.python3Packages.callPackage;
  buildPythonPackage = pkgs.python3Packages.buildPythonPackage;

  sqlint = callPackage ./sqlint/default.nix {};
  myNodePackages = import ./development/node-packages/node-packages.nix;
  myPerlPackages = callPackage ./perl-packages.nix {}; 
  java-buildpack-memory-calculator = callPackage ./java-buildpack-memory-calculator/default.nix {};
  jupyter_packaging = python3CallPackage ./development/python-modules/jupyter_packaging/default.nix {};
  simpervisor = python3CallPackage ./development/python-modules/simpervisor/default.nix {};
  json5 = python3CallPackage ./development/python-modules/json5/default.nix {};
  jupyter_server = python3CallPackage ./development/python-modules/jupyter_server/default.nix {};
  jupyterlab_server = python3CallPackage ./development/python-modules/jupyterlab_server/default.nix {
    inherit json5 jupyter_server;
  };
  nbclassic = python3CallPackage ./development/python-modules/nbclassic/default.nix {
    inherit jupyter_packaging jupyter_server;
  };
  jupyterlab = python3CallPackage ./development/python-modules/jupyterlab/default.nix {
    inherit nbclassic jupyter_packaging jupyter_server jupyterlab_server;
  };
  jupyter_lsp = python3CallPackage ./development/python-modules/jupyter_lsp/default.nix {
    inherit jupyter_server;
  };
  jupyter-resource-usage = python3CallPackage ./development/python-modules/jupyter-resource-usage/default.nix {
    inherit jupyterlab;
  };
  jupyterlab-topbar = python3CallPackage ./development/python-modules/jupyterlab-topbar/default.nix {
    inherit jupyterlab;
  };

  # TODO: The path is specified strangely below in order to make Nix accept the
  #       symbol "@" in the file path. Is there a better way to do this?
  base16-gruvbox-dark-labextension = callPackage (./. + "/development/node-packages/@arbennett/base16-gruvbox-dark/labextension.nix") {
    nodejs=pkgs.nodejs;
    jq=pkgs.jq;
    jupyter=pkgs.python3Packages.jupyter;
    jupyterlab=jupyterlab;
  };

  packageOverrides = selfPythonPackages: pythonPackages: {
    inherit jupyter-resource-usage jupyterlab-topbar json5 nbclassic jupyter_packaging jupyter_server jupyterlab_server jupyterlab jupyter_lsp simpervisor;
    jupyter-server-proxy = selfPythonPackages.callPackage ./development/python-modules/jupyter-server-proxy/default.nix {};
    jupyterlab-lsp = selfPythonPackages.callPackage ./development/python-modules/jupyterlab_lsp/default.nix {
      inherit jupyterlab jupyter_lsp;
    };
    jupyterlab_code_formatter = selfPythonPackages.callPackage ./development/python-modules/jupyterlab_code_formatter/default.nix {
      rpy2=selfPythonPackages.rpy2;
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
    ipython-sql = selfPythonPackages.callPackage ./development/python-modules/ipython-sql/default.nix {};
    ndex2 = selfPythonPackages.callPackage ./development/python-modules/ndex2/default.nix {};
    seaborn = selfPythonPackages.callPackage ./development/python-modules/seaborn/default.nix {};
    skosmos_client = selfPythonPackages.callPackage ./development/python-modules/skosmos_client/default.nix {};
    wikidata2df = selfPythonPackages.callPackage ./development/python-modules/wikidata2df/default.nix {};
    homoglyphs = selfPythonPackages.callPackage ./development/python-modules/homoglyphs/default.nix {};
    confusable-homoglyphs = selfPythonPackages.callPackage ./development/python-modules/confusable-homoglyphs/default.nix {};
    pyahocorasick = selfPythonPackages.callPackage ./development/python-modules/pyahocorasick/default.nix {};
    trotter = selfPythonPackages.callPackage ./development/python-modules/trotter/default.nix {};
  };

in

{
  inherit java-buildpack-memory-calculator sqlint;

  python3 = pkgs.python3.override (old: {
    packageOverrides =
      pkgs.lib.composeExtensions
        (old.packageOverrides or (_: _: {}))
        packageOverrides;
  });

  base16-gruvbox-dark-labextension=base16-gruvbox-dark-labextension;

  myNodePackages = myNodePackages;
  myPerlPackages = myPerlPackages;

  bash-it = callPackage ./bash-it/default.nix {}; 
  composer2nix = import (fetchTarball https://api.github.com/repos/svanderburg/composer2nix/tarball/8453940d79a45ab3e11f36720b878554fe31489f) {}; 
  jupyterlab-connect = callPackage ./jupyterlab-connect/default.nix {};
  mediawiki-codesniffer = callPackage ./mediawiki-codesniffer/default.nix {};
  pathvisio = callPackage ./pathvisio/default.nix { inherit java-buildpack-memory-calculator; };
  pgsanity = callPackage ./pgsanity/default.nix {};
  privoxy = callPackage ./privoxy/darwin-service.nix {}; 
  pywikibot = callPackage ./pywikibot/default.nix { inherit buildPythonPackage; };
  tosheets = callPackage ./tosheets/default.nix {};
  vim = callPackage ./vim/default.nix { inherit sqlint pkgs; pgFormatter = myPerlPackages.pgFormatter; };
}
