{pkgs, overrides ? {}}:

# here it is for homebrew:
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/pgformatter.rb

let self = _self // overrides; _self = with self; {

  inherit (pkgs) buildPerlPackage fetchFromGitHub lib perl gnused glibcLocales;

  inherit (lib) maintainers;

  # Helper functions for packages that use Module::Build to build.
  pgFormatter = buildPerlPackage rec {
    #name = "pgFormatter-${version}";
    pname = "pgFormatter";
    version = "v3.0";

    src = fetchFromGitHub {
      owner  = "darold";
      repo   = "pgFormatter";
      rev    = "${version}";
      sha256 = "1cl43ka7wm75hcxkazn94lapnvm6yvmrksx7f0xgjkkkd5sx12j7";
    };

    # nativeBuildInputs shouldn't persist as run-time dependencies.
    #   From the manual:
    #   "Since these packages are able to be run at build time, that are added to
    #    the PATH, as described above. But since these packages only are
    #    guaranteed to be able to run then, they shouldn't persist as run-time
    #    dependencies. This isn't currently enforced, but could be in the future."
    nativeBuildInputs = [ ];

    # buildInputs may be used at run-time but are only on the PATH at build-time.
    #   From the manual:
    #   "These often are programs/libraries used by the new derivation at
    #    run-time, but that isn't always the case."
    # glibcLocales is needed to fix a locale issue. See this comment:
    # https://github.com/NixOS/nixpkgs/issues/8398#issuecomment-186832814
    buildInputs = [ glibcLocales ];

    outputs = [ "out" ];

    makeMakerFlags = [ "INSTALLDIRS=vendor" ];

    # Makefile.PL only accepts DESTDIR and INSTALLDIRS, but we need to set more to make this work for NixOS.
    patchPhase = ''
        sed -i "s#'DESTDIR'      => \$DESTDIR,#'DESTDIR'      => '$out/',#" Makefile.PL
        sed -i "s#'INSTALLDIRS'  => \$INSTALLDIRS,#'INSTALLDIRS'  => \$INSTALLDIRS, 'INSTALLVENDORLIB'  => 'bin/lib', 'INSTALLVENDORBIN'  => 'bin', 'INSTALLVENDORSCRIPT'  => 'bin', 'INSTALLVENDORMAN1DIR'  => 'share/man/man1', 'INSTALLVENDORMAN3DIR'  => 'share/man/man3',#" Makefile.PL
      '';

    doCheck = false;

    meta = {
      description = "A PostgreSQL SQL syntax beautifier that can work as a console program or as a CGI.";
      homepage = https://github.com/darold/pgFormatter;
      maintainers = with maintainers; [ "ariutta" ];
      license = with lib.licenses; [ postgresql artistic2 ];
    };
  };


}; in self
