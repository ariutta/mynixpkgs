{ lib
, python3
, buildPythonPackage
, fetchPypi
, jsonschema
, jupyterlab
, psycopg2
, pytest
, sqlalchemy
, nodejs
, yarn }:

buildPythonPackage rec {
  pname = "jupyterlab_sql";
  version = "0.3.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ws0swc6kag52924zkgdd514asn53bpif3v327134bn1a56r24k8";
  };

  buildInputs = [
    nodejs
    yarn
  ];

  propagatedBuildInputs = [
    jupyterlab
    psycopg2
    sqlalchemy
    jsonschema
  ];

  checkInputs = [
    pytest
  ];

  meta = with lib; {
    description = "SQL GUI for JupyterLab.";
    homepage = "https://github.com/pbugnion/jupyterlab-sql";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
