{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "simpervisor";
  version = "0.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1icksf4hxvx115lj4sf00vki75xxskw1z369ll2dnvmxrl9rxiyf";
  };

  doCheck = true;
  buildInputs = [ setuptools ];
  #propagatedBuildInputs = [ jupyterlab ];

  meta = with lib; {
    description = "Simple async process supervisor.";
    homepage = "https://github.com/yuvipanda/simpervisor";
    license = licenses.bsd3;
    maintainers = [];
  };
}
