###################################################
# Dependencies for my customized Vim configuration.
#
# See my comments in ./default.nix regarding issue
# https://github.com/NixOS/nixpkgs/issues/26146
###################################################

{ pkgs, pgFormatter, sqlint }:

[
  pkgs.python3
  ####################
  # Deps for Neoformat
  ####################
  pkgs.black
  pkgs.html-tidy
  pgFormatter
  pkgs.nodePackages.prettier
  # TODO: take a look at javascript-typescript-langserver
  pkgs.nodePackages.typescript
  pkgs.python3Packages.jsbeautifier
  pkgs.php.packages.php-cs-fixer
  pkgs.jq

  # Python, Python Language Server & PYLS deps
  (pkgs.python3.withPackages (p: with p; [
    python-language-server
    rope
    flake8 # this is pyflakes + syntax checking
    mccabe
    pycodestyle
    pydocstyle
    pylint
    pyls-isort
    pyls-mypy
    pkgs.black
  ]))

  # sqlparse is on the command line as sqlformat.
  # It fails for some standard sql expressions (maybe CREATE TABLE?).
  pkgs.python3Packages.sqlparse

  pkgs.shfmt

  #####################################
  # Deps for ALE (Syntax Checker)
  #####################################
  #custom.mediawiki-codesniffer
  # TODO phpcs is installed by mediawiki-codesniffer. Should we still use the following line?
  #pkgs.php.packages.phpcs

  # TODO look into using phpstan:
  # I need to create a Nix expression for installing phpstan.
  # TODO Should phpstan be in addition to phpcs? Does phpstan conflict with the MW styleguide?

  pkgs.nodePackages.eslint

  pkgs.shellcheck
  # NOTE: sqlint won't work on NixOS 18.03, because that version doesn't
  # support passing gemConfig into bundlerApp:
  # https://github.com/NixOS/nixpkgs/blob/release-18.03/pkgs/development/ruby-modules/bundler-app/default.nix
  # it missed it by 5 days (Apr 4 vs. Apr 9):
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/ruby-modules/bundler-app/default.nix
  sqlint
]
