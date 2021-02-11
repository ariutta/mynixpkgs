{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, aiohttp
, notebook
, simpervisor
}:

buildPythonPackage rec {
  pname = "jupyter-server-proxy";
  version = "1.6.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sdiywnymdqsmdddj1gszb8fj1z3p1njy419q0i921ib4rmdc22y";
  };

  doCheck = true;
  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ aiohttp notebook simpervisor ];

  meta = with lib; {
    description = "Jupyter server extension to supervise and proxy web services.";
    homepage = "https://pypi.org/project/jupyter-server-proxy/";
    license = licenses.bsd3;
    maintainers = [];
  };
}
