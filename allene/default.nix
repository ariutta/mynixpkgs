{ stdenv
, lib
, fetchFromGitHub
, nodejs-16_x
, python2
, gnumake
, gcc
, binutils-unwrapped
, gnused # this is sed
, findutils # for xargs
, parallel
, jq }:

with builtins;

let
  baseName = "allene";
  version = "4deb0cb";
in
stdenv.mkDerivation rec {
  name = (concatStringsSep "-" [baseName version]);

  propagatedBuildInputs = [
    nodejs-16_x

    # node-gyp dependencies (node-gyp compiles C/C++ Addons)
    #   see https://github.com/nodejs/node-gyp#on-unix
    python2

  ] ++ (if stdenv.isDarwin then [

    # more node-gyp dependencies
    # XCode Command Line Tools
    # TODO: do we need cctools?
    #pkgs.darwin.cctools

  ] else [

    # more node-gyp dependencies
    gnumake

    # gcc and binutils disagree on the version of a
    # dependency, so we need to binutils-unwrapped.
    gcc # also provides cc
    binutils-unwrapped # provides ar

  ]) ++ [
    # the deps above were just for Node.js

    # the one(s) below are specifically for allene
    parallel
    jq
    gnused
    findutils # for xargs

    # should we specify bash as a dependency?
  ];

  src = fetchFromGitHub {
    owner = "ariutta";
    repo = "allene";
    rev = "4deb0cb88612b27d01dbe0af917b9dc97c2a9b2e";
    sha256 = "10bw7j51lvnxpwz5ayvb18hkl5yp6068pl0gs0ld4qml24dwa1cs";
  };

  buildPhase = ''
    mkdir ./bin
    cp ./allene ./bin
    for f in $(ls -1 ./bin); do
      full_f=./bin/"$f"

      patchShebangs "$full_f"

      substituteInPlace "$full_f" \
        --replace '/src/' '/../lib/'
    done

    mkdir ./lib
    cp ./src/* ./lib
    for f in $(ls -1 ./lib); do
      full_f=./lib/"$f"
      patchShebangs "$full_f"
    done
  '';

  doCheck = true;

  checkPhase = ''
    if [ ! -e "./bin/allene" ]; then
      echo "test failed: allene does not exist"
      exit 1;
    fi

    ./bin/allene -h >/dev/null

    for cmd in depcheck each hoist init link-bins update; do
      ./bin/allene $cmd -h >/dev/null
    done
  '';

  installPhase = ''
    mkdir -p "$out"/bin
    cp ./bin/* "$out"/bin

    mkdir -p "$out"/lib
    cp ./lib/* "$out"/lib
  '';

  meta = with lib;
    { description = "Keep interdependent JS packages in sync";
      homepage = https://github.com/ariutta/allene;
      license = licenses.mit;
      maintainers = with maintainers; [ ariutta ];
      platforms = platforms.all;
    };
}
