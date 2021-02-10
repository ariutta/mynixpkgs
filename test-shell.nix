# For more info, see
# http://datakurre.pandala.org/2015/10/nix-for-python-developers.html
# https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html
# https://nixos.org/nix/manual/#sec-nix-shell

with builtins;
let
  pkgs = import <nixpkgs> { inherit overlays; config.allowUnfree = true; };
  buildPythonPackage = pkgs.python3.pkgs.buildPythonPackage;
  mynixpkgs = import ./default.nix { inherit pkgs buildPythonPackage; };
  overlays = [];
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
      mynixpkgs.bash-it
      mynixpkgs.jupyterlab-connect

      # TODO: this gives a warning:
      # patchelf: cannot find section '.dynamic'. The input file is most likely statically linked
      mynixpkgs.java-buildpack-memory-calculator

#      # can't find jre
      #mynixpkgs.pathvisio

      mynixpkgs.perlPackages.pgFormatter
      mynixpkgs.pgsanity
      mynixpkgs.privoxy

      # TODO: this package description isn't quite done
      mynixpkgs.pywikibot

      mynixpkgs.sqlint
      mynixpkgs.tosheets
      mynixpkgs.vim

      # With Python configuration requiring a special wrapper
      # find names here: https://github.com/NixOS/nixpkgs/blob/release-17.03/pkgs/top-level/python-packages.nix
      (python3.buildEnv.override {
        ignoreCollisions = true;
        extraLibs = [
          python3Packages.requests

#          #packages."homoglyphs"
#          #packages."confusable-homoglyphs"
#          #packages."homoglyphs"
#          #packages."bs4"
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
