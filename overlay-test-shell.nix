# For more info, see
# http://datakurre.pandala.org/2015/10/nix-for-python-developers.html
# https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html
# https://nixos.org/nix/manual/#sec-nix-shell

with builtins;
let
  # Importing overlays
  overlays = [
    # my custom overlays
    (import ./overlay.nix)
  ];
  #overlays = [];
  pkgs = import <nixpkgs> { inherit overlays; config.allowUnfree = true; };
  buildPythonPackage = pkgs.python3.pkgs.buildPythonPackage;
  mynixpkgs = import ./default.nix { inherit pkgs buildPythonPackage; };
in
  pkgs.stdenv.mkDerivation rec {
    name = "env";
    # Mandatory boilerplate for buildable env
    env = pkgs.buildEnv { name = name; paths = buildInputs; };
    builder = toFile "builder.sh" ''
      source $stdenv/setup; ln -s $env $out
    '';

    # Customizable development requirements
    buildInputs = with pkgs; [
      bash-it
      jupyterlab-connect

      # TODO: this gives a warning:
      # patchelf: cannot find section '.dynamic'. The input file is most likely statically linked
      java-buildpack-memory-calculator

      pathvisio
      pgsanity

      # TODO: this package description isn't quite done
      pywikibot

      sqlint
      tosheets

      # TODO: these pkgs cause errors
      #perlPackages.pgFormatter
      #privoxy
      #vim

      # With Python configuration requiring a special wrapper
      # find names here: https://github.com/NixOS/nixpkgs/blob/release-17.03/pkgs/top-level/python-packages.nix
      (python3.buildEnv.override {
        ignoreCollisions = true;
        extraLibs = with python3Packages; [
          confusable-homoglyphs
          homoglyphs
          jupyter-resource-usage
          jupyterlab-topbar
          json5
          nbclassic
          jupyter_packaging
          jupyter_server
          jupyterlab_server
          jupyterlab
          jupyter_lsp
          simpervisor
          jupyter-server-proxy
          jupyterlab-lsp
          jupyterlab_code_formatter
          jupyterlab_hide_code
          jupyterlab_vim
          jupyterlab-vimrc
          aquirdturtle_collapsible_headings
          jupyterlab-system-monitor
          jupyterlab-drawio
          nb_black
          seaborn
          skosmos_client
          wikidata2df
          homoglyphs
          confusable-homoglyphs
          pyahocorasick

          requests
        ];
      })

      # Other package descriptions in this repo

      # package descriptions from pypi2nix
      # daff: development/python-modules/daff/requirements.nix
      #
      # Only needed as a tool to define nix expressions
      # for PHP packages from composer,
      # mynixpkgs.composer2nix: mediawiki-codesniffer/composer-env.nix

      # package descriptions from composer2nix
      #
      # TODO: can't build. Give the following error:
      # [ErrorException]
      # Trying to access array offset on value of type null
      # 
      #mynixpkgs.mediawiki-codesniffer

      # package descriptions from node2nix
      # development/node-packages/node-env.nix

    ];

    # Customizable development shell setup with at last SSL certs set
    shellHook = ''
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
    '';
  }