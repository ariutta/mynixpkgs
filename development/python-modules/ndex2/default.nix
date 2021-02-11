{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, nose
, six
, ijson
, requests
, requests-toolbelt
, networkx
, urllib3
, pandas
, enum34
, pysolr
, numpy
}:

buildPythonPackage rec {
  pname = "ndex2";
  version = "3.3.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1lpvrzyafi2li4xi49vhsr7f4fm6mk1pdm6fzj1gdv7m50177nfc";
  };

  # The source requiremets.txt appears to want:
  #   if python < 3, use enum
  #   if python 3 but < 3.4, use enum34
  # But the way it's specified doesn't work for python >= 3.4.
  # I'm just telling it to use enum34 whenever python < 3.4
  prePatch = ''
    substituteInPlace setup.py \
        --replace "'enum34'," "'enum34; python_version < \"3.4\"',"
  '';

  # TODO: can we de-dupe any deps between checkInputs and propagatedBuildInputs?
  checkInputs = [
    nose six ijson requests requests-toolbelt networkx urllib3 pandas pysolr numpy
  ];

  propagatedBuildInputs = [
    six ijson requests requests-toolbelt networkx urllib3 pandas pysolr numpy
  ] ++ lib.optionals (pythonOlder "3.4") [ enum34 ];

  checkPhase = ''
    nosetests -v
  '';

  # The tests try to make network requests, so we can't run them
  # for a Nix installation.
  doCheck = false;

  meta = {
    description = "Provides methods to access the NDEx REST Server API";
    homepage = "https://github.com/ndexbio/ndex2-client";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ ariutta ];
  };
}
