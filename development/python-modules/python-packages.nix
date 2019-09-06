with import <nixpkgs> { config.allowUnfree = true; };

{
  arviz = callPackage ./arviz/default.nix {};
  daff = (callPackage ./daff/requirements.nix {}).packages.daff;
  flask-mwoauth = callPackage ./flask-mwoauth/default.nix {};
#  flask-mwoauth = (
#    callPackage ./flask-mwoauth/requirements.nix {}
#  ).packages.flask-mwoauth;
}
