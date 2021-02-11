{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "trotter";
  version = "0.9.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0c1l4vavr61fja8750lf3w1n0gs8y7z8nyrwidj1by80w9w3mgk6";
  };

  # Tests try to make network requests, so we can't run them
  doCheck = false;

  meta = with lib; {
    description = "Provides methods to access the NDEx REST Server API";
    homepage = "https://github.com/ndexbio/ndex2-client";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ ariutta ];
  };
}
