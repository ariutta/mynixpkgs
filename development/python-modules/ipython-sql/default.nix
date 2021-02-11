{ lib
, python3
, buildPythonPackage
, fetchPypi
, prettytable
, ipython
, sqlalchemy
, sqlparse
, six
, ipython_genutils }:

buildPythonPackage rec {
  pname = "ipython-sql";
  version = "0.3.9";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vf3dhvdynd3wiwsw3a67fshy06r6d17qb1wns7rvf1q3wvzd1vi";
  };

  propagatedBuildInputs = [
    prettytable
    ipython
    sqlalchemy
    sqlparse
    six
    ipython_genutils
  ];

  meta = with lib; {
    description = "Introduces a %sql (or %%sql) magic.";
    longDescription = ''
      Introduces a %sql (or %%sql) magic.
      Connect to a database, using SQLAlchemy connect strings, then issue SQL
      commands within IPython or IPython Notebook.
      '';
    homepage = "https://pypi.org/project/ipython-sql/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
